

assert(SMODS.load_file("./modules/misc.lua"))() 
assert(SMODS.load_file("./modules/atlasses.lua"))() 
assert(SMODS.load_file("./func/word_utils.lua"))() 

function CardArea:aiko_change_playable(delta)
    self.config.highlighted_limit = self.config.highlight_limit or G.GAME.aiko_cards_playable or 5
    if delta ~= 0 then
        G.E_MANAGER:add_event(Event({
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
    end
    
end

local function replenishLetters()
    if(G.GAME and G.GAME.letters_to_give)then
        for _,k in ipairs(aiko_alphabets_no_wilds) do
            table.insert(G.GAME.letters_to_give,k)
        end
    end
end

function Card:set_letters_random()
    if(G.GAME and G.GAME.letters_to_give)then
        if (#G.GAME.letters_to_give == 0) then
            replenishLetters()
        end
        local index = pseudorandom(pseudoseed('aiko:letters'),1,#G.GAME.letters_to_give)
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
    if not self.aikoyori_letters_stickers then
        self.aikoyori_letters_stickers = {}
    end
    for i, v in ipairs(aiko_alphabets) do
        --print("PREPPING STICKERS "..v, " THE LETTER IS NUMBER "..i.. "should be index x y ",(i - 1) % 10 , math.floor((i-1) / 10))
        self.aikoyori_letters_stickers[v] = Sprite(0, 0, self.CARD_W, self.CARD_H, G.ASSET_ATLAS["akyrs_lettersStickers"], {x =(i - 1) % 10 ,y =  math.floor((i-1) / 10)})
    end
    self.aikoyori_letters_stickers["correct"] = Sprite(0, 0, self.CARD_W, self.CARD_H, G.ASSET_ATLAS["akyrs_lettersStickers"], {x =7 ,y = 2})
    self.aikoyori_letters_stickers["misalign"] = Sprite(0, 0, self.CARD_W, self.CARD_H, G.ASSET_ATLAS["akyrs_lettersStickers"], {x =8 ,y =  2})
    self.aikoyori_letters_stickers["incorrect"] = Sprite(0, 0, self.CARD_W, self.CARD_H, G.ASSET_ATLAS["akyrs_lettersStickers"], {x =9,y =  2})
end

local cardBaseHooker = Card.set_base
function Card:set_base(card, initial)
    local ret = cardBaseHooker(self,card, initial)
    self.aiko_draw_delay = math.random() * 1.75 + 0.25
    if self.base.name and not self.ability.aikoyori_letters_stickers then
        self:set_letters_random()
    end
    return ret
end
local cardSave = Card.save
function Card:save()
    local c = cardSave(self)
    c.is_null = self.is_null
    return c
end


local cardLoad = Card.load
function Card:load(cardTable, other_card)
    local c = cardLoad(self, cardTable, other_card)
    self.is_null = cardTable.is_null
    return c
end

local igo = Game.init_game_object
function Game:init_game_object()
    local ret = igo(self)
    ret.aiko_cards_playable = 5
    ret.starting_params.special_hook = false
    ret.letters_enabled = false
    ret.letters_mult_enabled = false
    ret.aiko_last_mult = 0
    ret.aiko_last_chips = 0
    ret.aiko_has_quasi = false
    ret.aiko_current_word = nil
    ret.aiko_words_played = {}
    ret.letters_to_give = {}
    replenishLetters()
    ret.current_round.aiko_round_played_words = {}
    ret.current_round.aiko_round_correct_letter = {}
    ret.current_round.aiko_round_misaligned_letter = {}
    ret.current_round.aiko_round_incorrect_letter = {}
    ret.current_round.discards_sub = 0
    ret.current_round.hands_sub = 0
    ret.current_round.aiko_infinite_hack = "8"
    ret.current_round.advanced_blind = false
    return ret
end

function SMODS.current_mod.reset_game_globals(run_start)
    G.GAME.current_round.discards_sub = 0
    G.GAME.current_round.hands_sub = 0
end


SMODS.Shader{
    key = "tint",
    path = "tint.fs",
}

local getNominalHook = Card.get_nominal
function Card:get_nominal(mod)
    if self.is_null then
        
        return -10-aiko_alphabets_to_num[self.ability.aikoyori_letters_stickers]
    end
    local ret = getNominalHook(self, mod)
    return ret
end


local drag_mod = {x = 0, y = 0, r = 0}
function aikoyori_draw_extras(card, layer)
    --print("DRAWING EXTRAS")
    
    
    if G.aikoyori_letters_stickers and G.GAME.letters_enabled then
        if card.ability.aikoyori_letters_stickers then
            local movement_mod = 0.05*math.sin(1.1*(G.TIMERS.REAL + card.aiko_draw_delay)) - 0.07
            local rot_mod = 0.02*math.sin(0.72*(G.TIMERS.REAL + card.aiko_draw_delay)) + 0.03
            
            if not card then return color end
            if G.GAME.current_round.aiko_round_correct_letter and G.GAME.current_round.aiko_round_correct_letter[card.ability.aikoyori_letters_stickers] then
                G.aikoyori_letters_stickers["correct"].role.draw_major = card
                G.aikoyori_letters_stickers["correct"]:draw_shader('dissolve', 0, nil, nil, card.children.center, 0.1, rot_mod - drag_mod.r, drag_mod.x * -3, movement_mod - drag_mod.y * -3)
                G.aikoyori_letters_stickers["correct"]:draw_shader('dissolve', nil, nil, nil, card.children.center, nil, rot_mod - drag_mod.r, drag_mod.x * -3, -0.02 + movement_mod*0.9 - drag_mod.y * -3, nil)
            elseif G.GAME.current_round.aiko_round_misaligned_letter and G.GAME.current_round.aiko_round_misaligned_letter[card.ability.aikoyori_letters_stickers] then
                G.aikoyori_letters_stickers["misalign"].role.draw_major = card
                G.aikoyori_letters_stickers["misalign"]:draw_shader('dissolve', 0, nil, nil, card.children.center, 0.1, rot_mod - drag_mod.r, drag_mod.x * -3, movement_mod - drag_mod.y * -3)
                G.aikoyori_letters_stickers["misalign"]:draw_shader('dissolve', nil, nil, nil, card.children.center, nil, rot_mod - drag_mod.r, drag_mod.x * -3, -0.02 + movement_mod*0.9 - drag_mod.y * -3, nil)
            elseif G.GAME.current_round.aiko_round_incorrect_letter and G.GAME.current_round.aiko_round_incorrect_letter[card.ability.aikoyori_letters_stickers] then
                G.aikoyori_letters_stickers["incorrect"].role.draw_major = card
                G.aikoyori_letters_stickers["incorrect"]:draw_shader('dissolve', 0, nil, nil, card.children.center, 0.1, rot_mod - drag_mod.r, drag_mod.x * -3, movement_mod - drag_mod.y * -3)
                G.aikoyori_letters_stickers["incorrect"]:draw_shader('dissolve', nil, nil, nil, card.children.center, nil, rot_mod - drag_mod.r, drag_mod.x * -3, -0.02 + movement_mod*0.9 - drag_mod.y * -3, nil)
            end
            local send = card.ARGS.send_to_shader
            
            G.aikoyori_letters_stickers[card.ability.aikoyori_letters_stickers].role.draw_major = card
            G.aikoyori_letters_stickers[card.ability.aikoyori_letters_stickers]:draw_shader('dissolve', 0, nil, nil, card.children.center, 0.1, rot_mod - drag_mod.r, drag_mod.x * -3, movement_mod - drag_mod.y * -3)
            G.aikoyori_letters_stickers[card.ability.aikoyori_letters_stickers]:draw_shader('dissolve', nil, nil, nil, card.children.center, nil, rot_mod - drag_mod.r, drag_mod.x * -3, -0.02 + movement_mod*0.9 - drag_mod.y * -3, nil)

        end
        
    end
end

local gameUpdate = EventManager.update

function EventManager:update(dt, forced)
    local s = gameUpdate(self, dt, forced)
    if G.STATE == G.STATES.HAND_PLAYED then
        if G.GAME.aiko_last_chips ~= G.GAME.current_round.current_hand.chips or G.GAME.aiko_last_mult ~=
            G.GAME.current_round.current_hand.mult then
            G.GAME.aiko_last_mult = G.GAME.current_round.current_hand.mult
            G.GAME.aiko_last_chips = G.GAME.current_round.current_hand.chips
            for i = 1, #G.jokers.cards do
                if true then
                    if (G.jokers.cards[i].aiko_trigger_external) and not G.jokers.cards[i].debuff then
                        G.jokers.cards[i]:aiko_trigger_external(G.jokers.cards[i])
                        --G.E_MANAGER:add_event(Event({trigger = "immediate",func = (function()return true end)}), 'base')
                    end
                end
            end
        end
    end
    return s
end

local mod_mult_ref = mod_mult
local mod_chips_ref = mod_chips

function mod_mult(_mult)
    local m = mod_mult_ref(_mult)
    return m
end

function mod_chips(_chips)
    local c = mod_chips_ref(_chips)
    return c
end


function Card:aiko_trigger_external(card)
    if (card.ability.name == "Observer") then
        card.ability.extra.times = card.ability.extra.times - 1

        card_eval_status_text(card, 'jokers', nil, 0.5, nil, {
            instant = true,
            card_align = "m",
            message = localize {
                type = 'variable',
                key = 'a_remaining',
                vars = { card.ability.extra.times }
            },
        })
        update_hand_text({ immediate = true, nopulse = true, delay = 0 }, { mult_stored = stored })

        if card.ability.extra.times == 0 then
            card_eval_status_text(card, 'jokers', nil, 0.5, nil, {
                instant = true,
                card_align = "m",
                message = localize {
                    type = 'variable',
                    key = 'a_remaining',
                    vars = { card.ability.extra.times }
                },
            })
            card.ability.extra.total_times = card.ability.extra.total_times + card.ability.extra.times_increment
            card.ability.extra.times = card.ability.extra.total_times
            card.ability.extra.mult_stored = card.ability.extra.mult_stored + card.ability.extra.mult
        end
        card.ability.extra.mult_change = mult
        card.ability.extra.chip_change = chips
    end
end



local cardReleaseRecalcHook = Card.stop_drag
function Card:stop_drag()
    local c = cardReleaseRecalcHook(self)
    --print("CARD RELEASED!!!!")
    if G.hand and self.area and self.area == G.hand and G.STATE == G.STATES.SELECTING_HAND then
        self.area:parse_highlighted()
    end
    return c
end



local debugKeysNShit = Controller.key_press_update
function Controller:key_press_update(key, dt)
    local c = debugKeysNShit(self,key, dt)
    local _card = self.hovering.target
    if not _RELEASE_MODE and _card then
        
        if key == ',' then
            if _card.playing_card then
                _card:set_letters(alphabet_delta(_card.ability.aikoyori_letters_stickers, - 1))
            end
        end
        if key == '.' then
            if _card.playing_card then
                _card:set_letters(alphabet_delta(_card.ability.aikoyori_letters_stickers, 1))
            end
        end
        if key == ";" then
            if(_card and _card.ability) then
                _card.ability.akyrs_self_destructs = not not not _card.ability.akyrs_self_destructs
            end
        end
    end
    return c
end

local applyToRunBackHook = Back.apply_to_run
local suits = {"S","H","D","C"}

function Back:apply_to_run()
    local c = applyToRunBackHook(self)
    
    if self.effect.config.all_nulls then
        G.E_MANAGER:add_event(Event({
            func = function()
                G.playing_cards = {}
                for i, letter in pairs(scrabble_letters) do
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    local front = pseudorandom_element(G.P_CARDS, pseudoseed('aikoyori:all_nulls'))
                    local car = Card(G.deck.T.x, G.deck.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS['c_base'], {playing_card = G.playing_card})
                    car.is_null = true
                    car:set_letters(letter)
                    G.deck:emplace(car)
                    table.insert(G.playing_cards, car)
                    G.GAME.starting_deck_size = #G.playing_cards
                end
                return true
            end
        }))
        G.GAME.starting_params.all_nulls = true
    end
    if self.effect.config.selection then
        G.GAME.aiko_cards_playable = G.GAME.aiko_cards_playable + self.effect.config.selection
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
    return c
end

function customDeckHooks(self,card_protos)
    if self.GAME.starting_params.special_hook then
        return {}
    end
    return card_protos
end

local getChipBonusHook = Card.get_chip_bonus
function Card:get_chip_bonus()
    if self.is_null then self.base.nominal = 0 end
    local c = getChipBonusHook(self)
    
    return c
end
local getMultBonusHook = Card.get_chip_mult
function Card:get_chip_mult()
    local c = getMultBonusHook(self)
    
    if self.ability.aikoyori_letters_stickers and G.GAME.letters_mult_enabled then c = c + scrabble_scores[self.ability.aikoyori_letters_stickers] end
    return c
end


local copyCardHook = copy_card
function copy_card(other, new_card, card_scale, playing_card, strip_edition)
    local c = copyCardHook(other, new_card, card_scale, playing_card, strip_edition)
    c.is_null = other.is_null
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
            return -10-aiko_alphabets_to_num[self.ability.aikoyori_letters_stickers]
        else
            return -math.random(100,1000000) 
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
    for k,v in pairs(t) do
      t2[k] = v
    end
    return t2
  end
  

local cardGetUIBoxRef = Card.generate_UIBox_ability_table

function Card:generate_UIBox_ability_table()
    local ret = cardGetUIBoxRef(self)
    local letter = self.ability.aikoyori_letters_stickers
    if letter and letter == "#" then
        letter = "Wild"
    else 
        if letter then
        letter = string.upper(letter)
        end
    end
    if self.is_null then  
        --print(table_to_string(ret))
        local newRetTable = table.aiko_shallow_copy(ret)
        newRetTable.name = {}
        localize({type = 'name_text', key = 'aiko_x_akyrs_null', set = 'AikoyoriExtraBases', vars={colours={G.C.BLUE}}, nodes = newRetTable.name})
        newRetTable.name = newRetTable.name[1]
        newRetTable.main = {}
        newRetTable.info = {}
        newRetTable.type = {}

        for i, v in ipairs(ret.info) do
            if i > 0 then
                table.insert(newRetTable.info, v)
            end
        end

        
        if(G.GAME.letters_enabled and letter) then
            generate_card_ui({key = 'letters'..letter, set = 'AikoyoriExtraBases'}, newRetTable)
        else
            
            generate_card_ui({key = 'aiko_x_akyrs_null', set = 'AikoyoriExtraBases'}, newRetTable)
        end
        if self.ability.set ~= 'Default' then
            for i, v in ipairs(ret.main) do            
                if i > 0 then
                    table.insert(newRetTable.main, v)
                end
            end
            for i, v in ipairs(ret.type) do
                if i > 0 then
                    table.insert(newRetTable.type, v)
                end
            end
        else
            
        end
        
        
        ret = newRetTable
    else
        if(G.GAME.letters_enabled and letter) then
            generate_card_ui({key = 'letters'..letter, set = 'AikoyoriExtraBases'}, ret)
        end
    end
    return ret
end

local eval_hook = G.FUNCS.evaluate_play
G.FUNCS.evaluate_play = function()
    local ret = eval_hook()
    G.GAME.aiko_current_word = nil
    return ret
end


function recalculateBlindUI()
    if G.HUD_blind then
        G.HUD_blind.definition = nil
        G.HUD_blind.definition = create_UIBox_HUD_blind()
        G.HUD_blind:set_parent_child(G.HUD_blind.definition, nil)
        G.HUD_blind:recalculate()
    end
end


function recalculateHUDUI()
    if G.HUD then
        ease_discard(0,true, true)
        G.HUD:recalculate()
    end
end
local easeDiscardHook = ease_discard
function ease_discard(mod, instant, silent)
    
    local discard_UI = G.HUD:get_UIE_by_ID('discard_UI_count')
    if G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind and G.GAME.blind.config.blind.debuff and G.GAME.blind.config.blind.debuff.infinite_discards and not G.GAME.blind.disabled and not G.GAME.blind.disabled and not G.GAME.aiko_puzzle_win then
        
        G.GAME.current_round.aiko_infinite_hack = "8"
        discard_UI.config.object.config.string[1].ref_value = "aiko_infinite_hack"
        discard_UI.config.object.T.r = 1.57
        discard_UI.config.object:update()
    else
        discard_UI.config.object.config.string[1].ref_value = "discards_left"
        discard_UI.config.object.T.r = 0
        local ret = easeDiscardHook(mod, instant, silent)
        return ret

    end
end


local cashOutHook = G.FUNCS.cash_out
G.FUNCS.cash_out = function (e)
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

local startRunHook = Game.start_run
function Game:start_run(args)
    local ret = startRunHook(self,args)
    recalculateHUDUI()
    recalculateBlindUI()
    return ret 
end

local cardSetCostHook = Card.set_cost
function Card:set_cost()
    local ret = cardSetCostHook(self)
    if self.ability.akyrs_self_destructs then
        self.sell_cost = -1
    end
    return ret
end

local discardAbilityHook = G.FUNCS.can_discard
G.FUNCS.can_discard = function(e)
    local ret = discardAbilityHook(e)
    if #G.hand.highlighted > 0 and G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind and G.GAME.blind.config.blind.debuff and G.GAME.blind.config.blind.debuff.infinite_discards then
        e.config.colour = G.C.RED
        e.config.button = 'discard_cards_from_highlighted'
    end
  end
  


local endRoundHook = end_round
function end_round()
    if (G.GAME.current_round.advanced_blind and not G.GAME.aiko_puzzle_win) and (G.GAME.current_round.hands_left > 0)
    then
        
        G.STATE_COMPLETE = true
        G.STATE = G.STATES.SELECTING_HAND
    else
        local ret = endRoundHook()
        for i,card in ipairs(G.consumeables.cards) do
            if card.ability.akyrs_self_destructs then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:start_dissolve({G.C.RED}, nil, 1.6)
                        return true
                    end,
                    delay = 0.5,
                }), 'base')
            end
        end
        for i,card in ipairs(G.deck.cards) do
            if card.ability.akyrs_self_destructs then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:start_dissolve({G.C.RED}, nil, 1.6)
                        return true
                    end,
                    delay = 0.5,
                }), 'base')
            end
        end
        return ret
    end

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

-- UI HOOKS

local updateSelectHandHook = Game.update_selecting_hand
function Game:update_selecting_hand(dt)
    local ret = updateSelectHandHook(self, dt)
    if not self.aiko_wordle and isBlindKeyAThing() == "bl_akyrs_the_thought" then
        self.aiko_wordle = UIBox{
            definition = create_UIBOX_Aikoyori_WordPuzzleBox(),
            config = {align="b", offset = {x=0,y=0.4},major = G.jokers, bond = 'Weak'}
        }
    end
        
    return ret
end
local updateHandPlayedHook = Game.update_hand_played
function Game:update_hand_played(dt)
    local ret = updateHandPlayedHook(self, dt)
    if self.aiko_wordle then self.aiko_wordle:remove(); self.aiko_wordle = nil end
    if not self.aiko_wordle then
        self.aiko_wordle = UIBox{
            definition = create_UIBOX_Aikoyori_WordPuzzleBox(),
            config = {align="b", offset = {x=0,y=0.4},major = G.jokers, bond = 'Weak'}
        }
    end
    return ret
end

local updateNewRoundHook = Game.update_new_round
function Game:update_new_round(dt)
    local ret = updateNewRoundHook(self,dt)
    if self.aiko_wordle then self.aiko_wordle:remove(); self.aiko_wordle = nil end
    
    return ret
end

local deleteRunHook = Game.delete_run
function Game:delete_run()
    local ret = deleteRunHook(self)
    
    if self.aiko_wordle then self.aiko_wordle:remove(); self.aiko_wordle = nil end
    return ret
end
