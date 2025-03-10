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
            AKYRS.replenishLetters()
        end
        local index = pseudorandom(pseudoseed('aiko:letters'), 1, #G.GAME.letters_to_give)
        self.ability.aikoyori_letters_stickers = table.remove(G.GAME.letters_to_give, index)
    else
        self.ability.aikoyori_letters_stickers = pseudorandom_element(scrabble_letters, pseudoseed('aiko:letters'))
    end
end

function Card:set_letters(letter)
    self.ability.aikoyori_letters_stickers = letter
end

function Card:remove_letters()
    self.ability.aikoyori_letters_stickers = nil
end

function aiko_mod_startup(self)
    if not AKYRS.aikoyori_letters_stickers then
        AKYRS.aikoyori_letters_stickers = {}
    end
    for i, v in ipairs(aiko_alphabets) do
        --print("PREPPING STICKERS "..v, " THE LETTER IS NUMBER "..i.. "should be index x y ",(i - 1) % 10 , math.floor((i-1) / 10))
        AKYRS.aikoyori_letters_stickers[v] = Sprite(0, 0, self.CARD_W, self.CARD_H, G.ASSET_ATLAS
            ["akyrs_lettersStickers"], { x = (i - 1) % 10, y = math.floor((i - 1) / 10) })
    end
    AKYRS.aikoyori_letters_stickers["correct"] = Sprite(0, 0, self.CARD_W, self.CARD_H,
        G.ASSET_ATLAS["akyrs_lettersStickers"], { x = 7, y = 2 })
    AKYRS.aikoyori_letters_stickers["misalign"] = Sprite(0, 0, self.CARD_W, self.CARD_H,
        G.ASSET_ATLAS["akyrs_lettersStickers"], { x = 8, y = 2 })
    AKYRS.aikoyori_letters_stickers["incorrect"] = Sprite(0, 0, self.CARD_W, self.CARD_H,
        G.ASSET_ATLAS["akyrs_lettersStickers"], { x = 9, y = 2 })
end

-- Rendering Letters
function AKYRS.aikoyori_draw_extras(card, layer)
    if card and AKYRS.aikoyori_letters_stickers and (G.GAME.letters_enabled or card.ability.forced_letter_render) then
        if card.ability.aikoyori_letters_stickers and AKYRS.aikoyori_letters_stickers[card.ability.aikoyori_letters_stickers] then
            local movement_mod = 0.05 * math.sin(1.1 * (G.TIMERS.REAL + card.aiko_draw_delay)) - 0.07
            local rot_mod = 0.02 * math.sin(0.72 * (G.TIMERS.REAL + card.aiko_draw_delay)) + 0.03
            if G.GAME.current_round.aiko_round_correct_letter and G.GAME.current_round.aiko_round_correct_letter[card.ability.aikoyori_letters_stickers] then
                AKYRS.aikoyori_letters_stickers["correct"].role.draw_major = card
                AKYRS.aikoyori_letters_stickers["correct"].VT.w = card.VT.w
                AKYRS.aikoyori_letters_stickers["correct"].VT.h = card.VT.h
                AKYRS.aikoyori_letters_stickers["correct"].VT.scale = card.VT.w / G.CARD_W
                AKYRS.aikoyori_letters_stickers["correct"]:draw_shader('dissolve', 0, nil, nil, card.children.center, 0.1,
                    nil, nil, nil)
                AKYRS.aikoyori_letters_stickers["correct"]:draw_shader('dissolve', nil, nil, nil, card.children.center, nil,
                    nil, nil, -0.02 + movement_mod * 0.9, nil)
            elseif G.GAME.current_round.aiko_round_misaligned_letter and G.GAME.current_round.aiko_round_misaligned_letter[card.ability.aikoyori_letters_stickers] then
                AKYRS.aikoyori_letters_stickers["misalign"].role.draw_major = card
                AKYRS.aikoyori_letters_stickers["misalign"].VT.w = card.VT.w
                AKYRS.aikoyori_letters_stickers["misalign"].VT.h = card.VT.h
                AKYRS.aikoyori_letters_stickers["misalign"].VT.scale = card.VT.w / G.CARD_W
                AKYRS.aikoyori_letters_stickers["misalign"]:draw_shader('dissolve', 0, nil, nil, card.children.center, 0.1,
                    nil, nil, nil)
                AKYRS.aikoyori_letters_stickers["misalign"]:draw_shader('dissolve', nil, nil, nil, card.children.center, nil,
                    nil, nil, -0.02 + movement_mod * 0.9, nil)
            elseif G.GAME.current_round.aiko_round_incorrect_letter and G.GAME.current_round.aiko_round_incorrect_letter[card.ability.aikoyori_letters_stickers] then
                AKYRS.aikoyori_letters_stickers["incorrect"].role.draw_major = card
                AKYRS.aikoyori_letters_stickers["incorrect"].VT.w = card.VT.w
                AKYRS.aikoyori_letters_stickers["incorrect"].VT.h = card.VT.h
                AKYRS.aikoyori_letters_stickers["incorrect"].VT.scale = card.VT.w / G.CARD_W
                AKYRS.aikoyori_letters_stickers["incorrect"]:draw_shader('dissolve', 0, nil, nil, card.children.center, 0.1,
                    nil, nil, nil)
                AKYRS.aikoyori_letters_stickers["incorrect"]:draw_shader('dissolve', nil, nil, nil, card.children.center, nil,
                    nil, nil, -0.02 + movement_mod * 0.9, nil)
            end
            AKYRS.aikoyori_letters_stickers[card.ability.aikoyori_letters_stickers].role.draw_major = card
            AKYRS.aikoyori_letters_stickers[card.ability.aikoyori_letters_stickers].VT.w = card.VT.w
            AKYRS.aikoyori_letters_stickers[card.ability.aikoyori_letters_stickers].VT.h = card.VT.h
            AKYRS.aikoyori_letters_stickers[card.ability.aikoyori_letters_stickers].VT.scale = card.VT.w / G.CARD_W
            AKYRS.aikoyori_letters_stickers[card.ability.aikoyori_letters_stickers]:draw_shader('dissolve', 0, nil, nil,
                card.children.center, 0.1, nil, nil, nil)
            AKYRS.aikoyori_letters_stickers[card.ability.aikoyori_letters_stickers]:draw_shader('dissolve', nil, nil, nil,
                card.children.center, nil, nil, nil, -0.02 + movement_mod * 0.9, nil)
        end
    end
end

-- parse hand on cards rearrangement

local cardReleaseRecalcHook = Card.stop_drag
function Card:stop_drag()
    local c = cardReleaseRecalcHook(self)
    --print("CARD RELEASED!!!!")
    if G.hand and self.area and self.area == G.hand and G.STATE == G.STATES.SELECTING_HAND then
        self.area:parse_highlighted()
    end
    return c
end

local applyToRunBackHook = Back.apply_to_run

function Back:apply_to_run()
    if self.effect.config.all_nulls then
        G.E_MANAGER:add_event(Event({
            func = function()
                G.playing_cards = {}
                local deckloop = G.GAME.starting_params.deck_size_letter or 1
                for loops = 1, deckloop do
                    for i, letter in pairs(scrabble_letters) do
                        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                        local front = pseudorandom_element(G.P_CARDS, pseudoseed('aikoyori:all_nulls'))
                        local car = Card(G.deck.T.x, G.deck.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS['c_base'],
                            { playing_card = G.playing_card })
                        car.is_null = true

                        -- misprintize
                        if G.GAME.modifiers and G.GAME.modifiers.cry_misprint_min and G.GAME.modifiers.cry_misprint_max then
                            for k, v in pairs(G.playing_cards) do
                                Cryptid.misprintize(car)
                            end
                        end

                        car:set_letters(letter)
                        G.deck:emplace(car)

                        table.insert(G.playing_cards, car)
                        -- for cryptid
                        if G.GAME.modifiers and G.GAME.modifiers.cry_ccd then
                            for k, v in pairs(G.playing_cards) do
                                v:set_ability(get_random_consumable('cry_ccd', { "no_doe", "no_grc" }, nil, nil, true),
                                    true, nil)
                            end
                        end
                    end
                end
                G.GAME.starting_deck_size = #G.playing_cards


                G.deck:shuffle('akyrsletterdeck')
                return true
            end
        }))
        G.GAME.starting_params.all_nulls = true
    end
    local c = applyToRunBackHook(self)

    if self.effect.config.selection then
        G.GAME.aiko_cards_playable = math.max(G.GAME.aiko_cards_playable, self.effect.config.selection)
        if Cryptid and G.GAME.modifiers.cry_highlight_limit then
            G.GAME.modifiers.cry_highlight_limit = math.max(G.GAME.modifiers.cry_highlight_limit, self.effect.config.selection)
        end
    end
    if self.effect.config.special_hook then
        G.GAME.starting_params.special_hook = true
    end
    if self.effect.config.letters_enabled then
        G.GAME.letters_enabled = true
    end
    if self.effect.config.letters_mult_enabled then
        G.GAME.letters_mult_enabled = true
    end
    if self.effect.config.letters_xmult_enabled then
        G.GAME.letters_xmult_enabled = true
    end
    return c
end

local getChipBonusHook = Card.get_chip_bonus
function Card:get_chip_bonus()
    if self.is_null then self.base.nominal = 0 end
    local c = getChipBonusHook(self)
    if SMODS.has_enhancement(self, "m_akyrs_scoreless") then
        c = c - self.base.nominal
    end
    return c
end

local getMultBonusHook = Card.get_chip_mult
function Card:get_chip_mult()
    local c = getMultBonusHook(self)

    if self.ability.aikoyori_letters_stickers and G.GAME.letters_mult_enabled then
        c = c +
            scrabble_scores[self.ability.aikoyori_letters_stickers]
    end
    return c
end

local getXMultBonusHook = Card.get_chip_x_mult
function Card:get_chip_x_mult()
    local c = getXMultBonusHook(self)

    if self.ability.aikoyori_letters_stickers and G.GAME.letters_xmult_enabled then
        c = c +
            (1 + (scrabble_scores[self.ability.aikoyori_letters_stickers] / 10))
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
function Card:is_suit(suit, bypass_debuff, flush_calc)
    if self.is_null then return false end
    local c = isSuitHook(self, suit, bypass_debuff, flush_calc)
    return c
end

local getIDHook = Card.get_id
function Card:get_id()
    if self.is_null then
        if self.ability.aikoyori_letters_stickers and G.GAME.letters_mult_enabled then
            --print(self.ability.aikoyori_letters_stickers)
            return -10 - aiko_alphabets_to_num[self.ability.aikoyori_letters_stickers]
        else
            return -math.random(100, 1000000)
        end
    end
    local c = getIDHook(self)
    return c
end

local isFaceHook = Card.is_face
function Card:is_face(from_boss)
    if self.is_null and not next(find_joker("Pareidolia")) then return false end
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
    if card.is_null then return false end
    local ret = noRankHook(card)
    return ret
end

local noSuitHook = SMODS.has_no_suit
function SMODS.has_no_suit(card)
    if card.is_null then return false end
    local ret = noSuitHook(card)
    return ret
end

local playCardEval = G.FUNCS.play_cards_from_highlighted

G.FUNCS.play_cards_from_highlighted = function(e)
    local ret = playCardEval(e)
    return ret
end

local cashOutHook = G.FUNCS.cash_out
G.FUNCS.cash_out = function(e)
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
