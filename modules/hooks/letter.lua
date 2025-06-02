-- This file contains hooks mainly focusing on letters & null cards

AKYRS.replenishLetters = function()
    if (G.GAME and G.GAME.letters_to_give) then
        for _, k in ipairs(aiko_alphabets_no_wilds) do
            table.insert(G.GAME.letters_to_give, k)
        end
    end
end

function Card:set_letters_random()
    if (G.GAME and G.GAME.letters_to_give) then
        if (#G.GAME.letters_to_give == 0) then
            G.GAME.used_up_uppercase = true
            AKYRS.replenishLetters()
        end
        local index = pseudorandom(pseudoseed('aiko:letters'), 1, #G.GAME.letters_to_give)
        local l = table.remove(G.GAME.letters_to_give, index)
        if not G.GAME.used_up_uppercase then l = l:upper() end
        if G.GAME.akyrs_mathematics_enabled then 
            self.is_null = true
        end
        self.ability.aikoyori_letters_stickers = l
    else
        self.ability.aikoyori_letters_stickers = pseudorandom_element(AKYRS.scrabble_letters, pseudoseed('aiko:letters'))
    end
end

function Card:set_letters(letter)
    self.ability.aikoyori_letters_stickers = letter
end

function Card:set_pretend_letters(letter)
    if self.ability.aikoyori_letters_stickers == "#" then
        self.ability.aikoyori_pretend_letter = letter
    end
end

function Card:remove_letters()
    self.ability.aikoyori_letters_stickers = nil
end

-- parse hand on cards rearrangement

local cardReleaseRecalcHook = Card.stop_drag
function Card:stop_drag()
    local area = self.area
    self.akyrs_oldarea = self.area or self.akyrs_oldarea
    for i, k in ipairs(G.CONTROLLER.collision_list) do
        if (k:is(CardArea)) then
            if (k.config.akyrs_emplace_func and k.config.akyrs_emplace_func(k, self)) or AKYRS.card_any_drag() then
                area = k
                break
            end
        end
        
        if (k:is(Card)) and false then
            if (k.area and k.area.config.akyrs_emplace_func and k.area.config.akyrs_emplace_func(k.area, self)) or AKYRS.card_any_drag() then
                area = k.area
                break
            end
        end
    end
    if area and area ~= self.area then
        if G.GAME.akyrs_ultimate_freedom or (area.config.card_limit + AKYRS.edition_extend_card_limit(self) >= #area.cards + 1 or area == G.hand or area == G.deck) then
            if self.akyrs_oldarea == G.hand or self.akyrs_oldarea == G.deck then
                AKYRS.remove_value_from_table(G.playing_cards,self)
            end
            for i, cardarea in ipairs(G.I.CARDAREA) do
                if cardarea and cardarea.cards then
                    cardarea:remove_card(self)
                end
            end
            if area == G.hand or area == G.deck then
                table.insert(G.playing_cards,self)
            end
            AKYRS.draw_card(self.area, area, 1, 'up', nil, self ,0)
            AKYRS.simple_event_add(
                function ()
                    
                    self.akyrs_oldarea = nil
                    return true
                end, 0
            )
            area:align_cards()
        end
        --print("TARGET SUSPECT")

    end
    local c = cardReleaseRecalcHook(self)

    if G.hand and self.area and self.area == G.hand and G.STATE == G.STATES.SELECTING_HAND and G.GAME.akyrs_character_stickers_enabled then
        self.area:parse_highlighted()
    end
    if G.deck and self.area and self.area == G.jokers and self.config.center_key == "j_akyrs_hibana" then
        G.deck:shuffle()
    end
    return c
end 

function Card:get_letter_with_pretend()
    local letter = self.ability.aikoyori_letters_stickers
    if letter == "#" and self.ability.aikoyori_pretend_letter and self.ability.aikoyori_pretend_letter ~= '' then
        letter = self.ability.aikoyori_pretend_letter
    end
    return letter
end

local getChipBonusHook = Card.get_chip_bonus
function Card:get_chip_bonus()
    if self.is_null then self.base.nominal = 0 end
    local c = getChipBonusHook(self)
    if self.ability.set == 'Enhanced' and self.config.center_key == "m_akyrs_scoreless" then
        c = c - self.base.nominal
    end
    return c
end

local getMultBonusHook = Card.get_chip_mult
function Card:get_chip_mult()
    local c = getMultBonusHook(self)

    if self.ability.aikoyori_letters_stickers and G.GAME.akyrs_letters_mult_enabled then
        c = c +
        AKYRS.get_scrabble_score(self.ability.aikoyori_letters_stickers)
    end
    return c
end

local getXMultBonusHook = Card.get_chip_x_mult
function Card:get_chip_x_mult()
    local c = getXMultBonusHook(self)

    if self.ability.aikoyori_letters_stickers and G.GAME.akyrs_letters_xmult_enabled then
        c = c +
            (1 + (AKYRS.get_scrabble_score(self.ability.aikoyori_letters_stickers) / 10))
    end
    return c
end

local copyCardHook = copy_card
function copy_card(other, new_card, card_scale, playing_card, strip_edition)
    local c = copyCardHook(other, new_card, card_scale, playing_card, strip_edition)
    c.is_null = other.is_null
    c.akyrs_old_ability = other.ability
    return c
end

local isSuitHook = Card.is_suit
function Card:is_suit(...)
    if self and self.is_null then return false end
    if not self then print("AKYRS > HOW IS IT NIL???") return false end
    return isSuitHook(self, ...)
end

local getIDHook = Card.get_id
function Card:get_id()
    if self.is_null then
        if self.ability.aikoyori_letters_stickers and G.GAME.akyrs_letters_mult_enabled then
            --print(self.ability.aikoyori_letters_stickers)
            return -10 - string.byte(self.ability.aikoyori_letters_stickers)
        else
            return -math.random(100, 1000000)
        end
    end
    if #SMODS.find_card("j_akyrs_henohenomoheji") > 0 and AKYRS.bal("absurd") then
        if self and self.get_letter_with_pretend and self.ability and self.ability.aikoyori_letters_stickers and G.GAME.akyrs_character_stickers_enabled then
            if self:get_letter_with_pretend():lower() == "j" then return 11 end
            if self:get_letter_with_pretend():lower() == "q" then return 12 end
            if self:get_letter_with_pretend():lower() == "k" then return 13 end
        end
    end
    local c = getIDHook(self)
    return c
end

local isFaceHook = Card.is_face
function Card:is_face(from_boss)
    if next(SMODS.find_card("j_akyrs_henohenomoheji")) then
        if self and self.get_letter_with_pretend and self.ability and self.ability.aikoyori_letters_stickers and G.GAME.akyrs_character_stickers_enabled and
        (self:get_letter_with_pretend():lower() == "j" or 
        self:get_letter_with_pretend():lower() == "q" or 
        self:get_letter_with_pretend():lower() == "k") then
            return true
        end
    elseif self.is_null and not next(SMODS.find_card("j_pareidolia")) then return false end
    local c = isFaceHook(self, from_boss)
    return c
end

function table.aiko_shallow_copy(t)
    local t2 = {}
    for k, v in pairs(t) do
        t2[k] = v
    end
    return t2
end

local noRankHook = SMODS.has_no_rank
function SMODS.has_no_rank(card)
    if card.is_null then return true end
    --if card.base.value and card.base.value == "akyrs_non_playing" then return true end
    local ret = noRankHook(card)
    return ret
end

local noSuitHook = SMODS.has_no_suit
function SMODS.has_no_suit(card)
    if card.is_null then return true end
    --if card.base.value and card.base.value == "akyrs_non_playing" then return true end
    local ret = noSuitHook(card)
    return ret
end


local cashOutHook = G.FUNCS.cash_out
G.FUNCS.cash_out = function(e)
    SMODS.calculate_context({akyrs_round_eval = true, dollars = G.GAME.current_round.dollars})
    if not G.GAME.current_round.advanced_blind or G.GAME.aiko_puzzle_win then
        local ret = cashOutHook(e)
        G.GAME.aiko_puzzle_win = nil
        G.GAME.current_round.advanced_blind = false
        G.GAME.current_round.aiko_round_played_words = {}
        G.GAME.current_round.aiko_round_correct_letter = {}
        G.GAME.current_round.aiko_round_misaligned_letter = {}
        G.GAME.current_round.aiko_round_incorrect_letter = {}
        G.GAME.current_round.advanced_blind = false
        return ret
    else
        return nil
    end
end
