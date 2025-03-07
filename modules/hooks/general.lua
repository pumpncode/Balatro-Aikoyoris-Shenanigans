-- This file contains general hooks that has a bunch of things in them

local igo = Game.init_game_object
function Game:init_game_object()
    local ret = igo(self)
    ret.aiko_cards_playable = 5
    ret.starting_params.special_hook = false
    ret.starting_params.deck_size_letter = 1
    ret.letters_enabled = false
    ret.letters_mult_enabled = false
    ret.letters_xmult_enabled = false
    ret.aiko_last_mult = 0
    ret.aiko_last_chips = 0
    ret.aiko_has_quasi = false
    ret.aiko_current_word = nil
    ret.aiko_words_played = {}
    ret.letters_to_give = {}
    ret.aiko_letters_consumable_rate = 0
    AKYRS.replenishLetters()
    ret.current_round.aiko_round_played_words = {}
    ret.current_round.aiko_round_correct_letter = {}
    ret.current_round.aiko_round_misaligned_letter = {}
    ret.current_round.aiko_round_incorrect_letter = {}
    ret.current_round.aiko_played_suits = {}
    ret.current_round.discards_sub = 0
    ret.current_round.hands_sub = 0
    ret.current_round.aiko_infinite_hack = "8"
    ret.current_round.advanced_blind = false
    return ret
end

function SMODS.current_mod.reset_game_globals(run_start)
    G.GAME.current_round.discards_sub = 0
    G.GAME.current_round.hands_sub = 0
    G.GAME.current_round.aiko_played_suits = {}
end

function CardArea:aiko_change_playable(delta)
    self.config.highlighted_limit = self.config.highlight_limit or G.GAME.aiko_cards_playable or 5
    G.GAME.modifiers.cry_highlight_limit = G.GAME.aiko_cards_playable
    if delta ~= 0 then
        G.E_MANAGER:add_event(Event({
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
    end
end

local gameUpdate = EventManager.update

function EventManager:update(dt, forced)
    local s = gameUpdate(self, dt, forced)
    if G.GAME.letters_enabled and G.GAME.alphabet_rate == 0 then
        G.GAME.alphabet_rate = 1
    end
    if not G.GAME.letters_enabled and G.GAME.alphabet_rate > 0 then
        G.GAME.alphabet_rate = 0
    end
    if G.GAME.blind and G.GAME.blind.debuff.requirement_scale then
        if G.GAME.current_round.hands_left >= 1 and G.GAME.current_round.hands_played > 0 then
            G.GAME.blind.chips = G.GAME.chips * G.GAME.blind.debuff.requirement_scale
        end
    end
    if G.STATE == G.STATES.HAND_PLAYED then
        G.GAME.current_round.akyrs_executed_debuff = false
        for suitkey, suit in pairs(SMODS.Suits) do
            for _, card in ipairs(G.play.cards) do
                if(card:is_suit(suitkey) and G.GAME.current_round.aiko_played_suits) then
                    G.GAME.current_round.aiko_played_suits[suitkey] = true
                    goto akyrs_suit_check_continue
                end
            end
            ::akyrs_suit_check_continue::
        end

        if G.GAME.aiko_last_chips ~= G.GAME.current_round.current_hand.chips or G.GAME.aiko_last_mult ~=
            G.GAME.current_round.current_hand.mult then
            G.GAME.aiko_last_mult = G.GAME.current_round.current_hand.mult
            G.GAME.aiko_last_chips = G.GAME.current_round.current_hand.chips
            for i = 1, #G.jokers.cards do
                if true then
                    if (G.jokers.cards[i].aiko_trigger_external) and not G.jokers.cards[i].debuff then
                        G.E_MANAGER:add_event(
                            Event{
                                trigger = "before",
                                delay = 0,
                                function ()
                                    G.jokers.cards[i]:aiko_trigger_external(G.jokers.cards[i])
                                    return true;
                                end
                            }
                        ,'base',true)
                        --G.E_MANAGER:add_event(Event({trigger = "immediate",func = (function()return true end)}), 'base')
                    end
                end
            end
        end
    end
    if G.STATE == G.STATES.SELECTING_HAND then
        if not G.GAME.blind.debuff.initial_action_act_set then
            G.GAME.blind.debuff.initial_action_acted = false
            G.GAME.blind.debuff.initial_action_act_set = true
        end
        if not G.GAME.current_round.akyrs_executed_debuff and AKYRS.all_card_areas and G.GAME.blind then
            if G.GAME.blind.debuff.akyrs_suit_debuff_hand then
                if AKYRS.all_card_areas then 
                    for suit, _ in pairs(G.GAME.current_round.aiko_played_suits) do
                        for _,area in ipairs(AKYRS.all_card_areas) do
                            if (area and area.cards) then
                                for j,c in ipairs(area.cards) do
                                    if c:is_suit(suit) then
                                        c:set_debuff(true)
                                    end
                                end
                            end
                
                        end
                        
                    end
                end
            end
            if G.GAME.blind.debuff.akyrs_all_seals_perma_debuff then
                if AKYRS.all_card_areas then 
                    for _,area in ipairs(AKYRS.all_card_areas) do
                        if (area and area.cards) then
                            for j,c in ipairs(area.cards) do
                                if c.seal and not c.ability.akyrs_undebuffable then
                                    c.ability.akyrs_perma_debuff = true
                                end
                            end
                        end
            
                    end
                        
                end
            end
            G.GAME.current_round.akyrs_executed_debuff = true
        end

        if AKYRS.checkBlindKey("bl_akyrs_the_picker") and not G.GAME.blind.disabled then
            if AKYRS.picker_initial_action and not G.GAME.blind.debuff.initial_action_acted then
                AKYRS.picker_initial_action()
                G.GAME.blind.debuff.initial_action_acted = true
            end
        end
    end
    
    -- permanent debuff shenanigans
    if AKYRS.all_card_areas then 
        for i,k in ipairs(AKYRS.all_card_areas) do
            if (k and k.cards) then
                for j,l in ipairs(k.cards) do
                    if l.ability.akyrs_undebuffable then
                        l.ability.akyrs_perma_debuff = false
                        l.ability.perma_debuff = false
                        l:set_debuff(false)
                    end
                    if l.ability.akyrs_perma_debuff and not l.ability.akyrs_undebuffable then
                        l:set_debuff(true)
                    end
                end
            end

        end
    end


    return s
end

function customDeckHooks(self, card_protos)
    if self.GAME.starting_params.special_hook then
        return {}
    end
    return card_protos
end

local startRunHook = Game.start_run
function Game:start_run(args)
    local ret = startRunHook(self, args)
    if not self.aiko_wordle and AKYRS.checkBlindKey("bl_akyrs_the_thought") then
        --print("CHECK SUCCESS")
        self.aiko_wordle = UIBox {
            definition = create_UIBOX_Aikoyori_WordPuzzleBox(),
            config = { align = "b", offset = { x = 0, y = 0.4 }, major = G.jokers, bond = 'Weak' }
        }
    end
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
        for i, card in ipairs(G.consumeables.cards) do
            if card.ability.akyrs_self_destructs then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:start_dissolve({ G.C.RED }, nil, 1.6)
                        return true
                    end,
                    delay = 0.5,
                }), 'base')
            end
        end
        for i, card in ipairs(G.deck.cards) do
            if card.ability.akyrs_self_destructs then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:start_dissolve({ G.C.RED }, nil, 1.6)
                        return true
                    end,
                    delay = 0.5,
                }), 'base')
            end
        end
        for i, card in ipairs(G.discard.cards) do
            if card.ability.akyrs_self_destructs then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:start_dissolve({ G.C.RED }, nil, 1.6)
                        return true
                    end,
                    delay = 0.5,
                }), 'base')
            end
        end
        for i, card in ipairs(G.play.cards) do
            if card.ability.akyrs_self_destructs then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:start_dissolve({ G.C.RED }, nil, 1.6)
                        return true
                    end,
                    delay = 0.5,
                }), 'base')
            end
        end
        for i, card in ipairs(G.hand.cards) do
            if card.ability.akyrs_self_destructs then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:start_dissolve({ G.C.RED }, nil, 1.6)
                        return true
                    end,
                    delay = 0.5,
                }), 'base')
            end
        end
        return ret
    end
end


local updateSelectHandHook = Game.update_selecting_hand
function Game:update_selecting_hand(dt)
    local ret = updateSelectHandHook(self, dt)
    if not self.aiko_wordle and AKYRS.isBlindKeyAThing() == "bl_akyrs_the_thought" then
        self.aiko_wordle = UIBox {
            definition = create_UIBOX_Aikoyori_WordPuzzleBox(),
            config = { align = "b", offset = { x = 0, y = 0.4 }, major = G.jokers, bond = 'Weak' }
        }
    end

    return ret
end

local updateHandPlayedHook = Game.update_hand_played
function Game:update_hand_played(dt)
    local ret = updateHandPlayedHook(self, dt)
    if self.aiko_wordle then
        self.aiko_wordle:remove(); self.aiko_wordle = nil
    end
    if not self.aiko_wordle then
        self.aiko_wordle = UIBox {
            definition = create_UIBOX_Aikoyori_WordPuzzleBox(),
            config = { align = "b", offset = { x = 0, y = 0.4 }, major = G.jokers, bond = 'Weak' }
        }
    end
    return ret
end

local updateNewRoundHook = Game.update_new_round
function Game:update_new_round(dt)
    local ret = updateNewRoundHook(self, dt)
    if self.aiko_wordle then
        self.aiko_wordle:remove(); self.aiko_wordle = nil
    end

    return ret
end

local deleteRunHook = Game.delete_run
function Game:delete_run()
    local ret = deleteRunHook(self)

    if self.aiko_wordle then
        self.aiko_wordle:remove(); self.aiko_wordle = nil
    end
    return ret
end


function Card:a_cool_fucking_spin(time, radian)
    Moveable.a_cool_fucking_spin(self, time, radian)
end

function Moveable:a_cool_fucking_spin(time, radian)
    if G.SETTINGS.reduced_motion then return end
    local radian = radian or math.pi * 2

    G.E_MANAGER:add_event(Event({
        trigger = 'ease',
        blockable = false,
        type = 'lerp',
        ref_table = self.VT,
        ref_value = 'r',
        ease_to = radian,
        delay = time,
        func = (function(t)
            self.VT.r = t
            self.T.r = t
            return t
        end)
    }))
end

local add2highlightHook = CardArea.add_to_highlighted
function CardArea:add_to_highlighted(card, silent)
    local ret = add2highlightHook(self,card,silent)
    if AKYRS.checkBlindKey("bl_akyrs_the_picker") and not G.GAME.blind.disabled and self == G.hand then
        if G.GAME.blind.debuff.primed and not G.GAME.blind.debuff.lock and AKYRS.picker_primed_action and not G.GAME.blind.debuff.acted and G.STATE == G.STATES.SELECTING_HAND then
            AKYRS.picker_primed_action()
            G.GAME.blind.debuff.acted = true
        end
    end
    return ret
end

local removeFhighlightHook = CardArea.remove_from_highlighted
function CardArea:remove_from_highlighted(card, force)
    local ret = removeFhighlightHook(self,card, force)
    if AKYRS.checkBlindKey("bl_akyrs_the_picker") and not G.GAME.blind.disabled and self == G.hand then
        if G.GAME.blind.debuff.primed and not G.GAME.blind.debuff.lock and AKYRS.picker_primed_action and not G.GAME.blind.debuff.acted and G.STATE == G.STATES.SELECTING_HAND then
            AKYRS.picker_primed_action()
            G.GAME.blind.debuff.acted = true
        end
    end
    return ret
end
local unhighlightallHook = CardArea.unhighlight_all
function CardArea:unhighlight_all()
    local ret = unhighlightallHook(self)
    if AKYRS.checkBlindKey("bl_akyrs_the_picker") and not G.GAME.blind.disabled and self == G.hand then
        if G.GAME.blind.debuff.primed and not G.GAME.blind.debuff.lock and AKYRS.picker_primed_action and not G.GAME.blind.debuff.acted and G.STATE == G.STATES.SELECTING_HAND then
            AKYRS.picker_primed_action()
            G.GAME.blind.debuff.acted = true
        end
    end
    return ret
end

local dcfhHook = G.FUNCS.discard_cards_from_highlighted 
G.FUNCS.discard_cards_from_highlighted = function (e,hook)
    if AKYRS.checkBlindKey("bl_akyrs_the_picker") and not G.GAME.blind.disabled then
        G.GAME.blind.debuff.primed = false
    end
    local r = dcfhHook(e,hook)
    return r
end

local loadBlind = Blind.load
function Blind:load(blindTable)
    local r = loadBlind(self,blindTable)
    if AKYRS.checkBlindKey("bl_akyrs_the_picker") and not G.GAME.blind.disabled then
        self.debuff.lock = true
        G.E_MANAGER:add_event(Event{
            trigger = "before",
            delay = 0,
            func = function ()
                self.debuff.initial_action_act_set = false
                
                G.E_MANAGER:add_event(Event{
                    func = function ()
                        self.debuff.primed = true
                        self.debuff.acted = false
                        G.E_MANAGER:add_event(Event{
                            trigger = "before",
                            func = function ()
                                self.debuff.lock = false
                                return true
                            end
                })
                        return true
                    end
                })
                return true
            end
        })
    end
    return r
end


local eval_hook = G.FUNCS.evaluate_play
G.FUNCS.evaluate_play = function()
    local ret = eval_hook()
    G.GAME.aiko_current_word = nil
    return ret
end


local cardAreaInitHook = CardArea.init
function CardArea:init(X, Y, W, H, config)
    local r = cardAreaInitHook(self,X,Y,W,H,config)
    if not config.temporary then
        if not AKYRS.all_card_areas then
            AKYRS.all_card_areas = {}
        end
        table.insert(AKYRS.all_card_areas,self)
    end
    return r
end