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
    
    self.config.highlighted_limit = self.config.highlighted_limit + delta
    G.GAME.aiko_cards_playable = self.config.highlighted_limit
    if Cryptid then
        G.GAME.modifiers.cry_highlight_limit = self.config.highlighted_limit
        
    end

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
    if G.GAME.blind and G.GAME.blind.debuff.requirement_scale and not G.GAME.blind.disabled then
        if G.GAME.current_round.hands_left >= 1 and G.GAME.current_round.hands_played > 0 then
            G.GAME.blind.chips = G.GAME.chips * G.GAME.blind.debuff.requirement_scale
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        end
    end
    if G.STATE == G.STATES.HAND_PLAYED then
        G.GAME.current_round.akyrs_executed_debuff = false
        for suitkey, suit in pairs(SMODS.Suits) do
            for _, card in ipairs(G.play.cards) do
                if(suitkey ~= nil and card:is_suit(suitkey) and G.GAME.current_round.aiko_played_suits) then
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
        if not G.GAME.blind.debuff.initial_action_act_set and not G.GAME.blind.disabled then
            G.GAME.blind.debuff.initial_action_acted = false
            G.GAME.blind.debuff.initial_action_act_set = true
        end
        if not G.GAME.current_round.akyrs_executed_debuff and AKYRS.all_card_areas and G.GAME.blind and not G.GAME.blind.disabled  then
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
            if G.GAME.blind.debuff.akyrs_all_seals_perma_debuff and not G.GAME.blind.disabled then
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

        if  G.GAME.blind.debuff.akyrs_pick_cards and not G.GAME.blind.disabled then
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
    return ret
end



local endRoundHook = end_round
function end_round()
    if (G.GAME.current_round.advanced_blind and not G.GAME.aiko_puzzle_win) and (G.GAME.current_round.hands_left > 0)
    then
        G.STATE_COMPLETE = true
        G.STATE = G.STATES.SELECTING_HAND
    else
        local ret = endRoundHook()
        for _, cardarea in ipairs(AKYRS.all_card_areas) do
            if cardarea and cardarea.cards then
                for i, card in ipairs(cardarea.cards) do

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

local cardAreaRemoveHook = CardArea.remove
function CardArea:remove()
    local r = cardAreaRemoveHook(self)
    if not AKYRS.all_card_areas then return end
    for k, v in pairs(AKYRS.all_card_areas) do
        if v == self then
            table.remove(AKYRS.all_card_areas, k)
        end
    end
    return r
end

local setCardAbilityHook = Card.set_ability

function Card:set_ability(c,i,d)
    local r = setCardAbilityHook(self,c,i,d)
    
    if(i) then
        self.akyrs_old_ability = AKYRS.deep_copy(self.ability)
    end
    return r
end


local cardBaseHooker = Card.set_base
function Card:set_base(card, initial)
    local ret = cardBaseHooker(self, card, initial)
    self.aiko_draw_delay = math.random() * 1.75 + 0.25
    self.akyrs_impostor_card = false
    if self.base.name and not self.ability.aikoyori_letters_stickers then
        self:set_letters_random()
        self.ability.forced_letter_render = false
    end
    return ret
end
local cardInitHook = Card.init
function Card:init(X, Y, W, H, card, center, params)
    local ret = cardInitHook(self, X, Y, W, H, card, center, params)
    self.akyrs_upgrade_sliced = false
    
    return ret
end

local cardSave = Card.save
function Card:save()
    local c = cardSave(self)
    c.is_null = self.is_null
    c.highlighted = self.highlighted
    c.akyrs_old_ability = self.akyrs_old_ability
    c.akyrs_upgrade_sliced = self.akyrs_upgrade_sliced
    c.akyrs_impostor_card = self.akyrs_impostor_card
    return c
end

local cardLoad = Card.load
function Card:load(cardTable, other_card)
    local c = cardLoad(self, cardTable, other_card)
    self.is_null = cardTable.is_null
    self.highlighted = cardTable.highlighted
    self.akyrs_old_ability = cardTable.akyrs_old_ability
    self.akyrs_upgrade_sliced = cardTable.akyrs_upgrade_sliced
    self.akyrs_impostor_card = cardTable.akyrs_impostor_card
    return c
end

local getNominalHook = Card.get_nominal
function Card:get_nominal(mod)
    if self.is_null and self.ability.aikoyori_letters_stickers then
        return -10 - string.byte(self.ability.aikoyori_letters_stickers)
    end
    local ret = getNominalHook(self, mod)
    return ret
end


local cardAreaAlignHook = CardArea.align_cards
function CardArea:align_cards()
    local r = cardAreaAlignHook(self)
    if self.config.type == 'akyrs_credits' then

        for k, card in ipairs(self.cards) do
            if not card.states.drag.is then 
                --card.T.r = 0.2*(-#self.cards/2 - 0.5 + k)/(#self.cards)+ (G.SETTINGS.reduced_motion and 0 or 1)*0.02*math.sin(2*G.TIMERS.REAL+card.T.x)
                local max_cards = math.max(#self.cards, self.config.temp_limit)
                card.T.x = self.T.x + (self.T.w-self.card_w)*((k-1)/math.max(max_cards-1, 1) - 0.5*(#self.cards-max_cards)/math.max(max_cards-1, 1)) + 0.5*(self.card_w - card.T.w)

                local highlight_height = G.HIGHLIGHT_H
                if not card.highlighted then highlight_height = 0 end
                card.T.y = self.T.y - highlight_height + (G.SETTINGS.reduced_motion and 0 or 1)*0.04*math.sin(2.*G.TIMERS.REAL + card.T.y*1.471 + card.T.x*1.471) -- + math.abs(1.3*(-#self.cards/2 + k-0.5)/(#self.cards))^2
                card.T.x = card.T.x + card.shadow_parrallax.x/30
            end
        end
        table.sort(self.cards, function (a, b) return a.T.x + a.T.w/2 < b.T.x + b.T.w/2 end)
    end  
    return r
end
local cardAreaDrawHook = CardArea.draw
function CardArea:draw()
    local r = cardAreaDrawHook(self)

    self.ARGS.draw_layers = self.ARGS.draw_layers or self.config.draw_layers or {'shadow', 'card'}
    for k, v in ipairs(self.ARGS.draw_layers) do
        if self.config.type == 'akyrs_credits' then 
            for i = 1, #self.cards do 
                if self.cards[i] ~= G.CONTROLLER.focused.target or self == G.hand then
                    if G.CONTROLLER.dragging.target ~= self.cards[i] then self.cards[i]:draw(v) end
                end
            end
        end
    end
    return r
end


local applyToRunBackHook = Back.apply_to_run

function Back:apply_to_run()
    if self.effect.config.all_nulls then
        G.E_MANAGER:add_event(Event({
            func = function()
                G.playing_cards = {}
                
                local deckloop = G.GAME.starting_params.deck_size_letter or 1
                local usedLetter = {}
                for loops = 1, deckloop do
                    for i, letter in pairs(AKYRS.scrabble_letters) do
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
                        if not usedLetter[letter:lower()] then letter = letter:upper() usedLetter[letter:lower()]=true else letter = letter:lower() end
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

local function compareFirstElement(a,b)
    return a[1] < b[1]
end

local shufflingEverydayHook = CardArea.shuffle
function CardArea:shuffle(_seed)
    local r = shufflingEverydayHook(self, _seed)
    if self == G.deck then
        --print("everyday shuffling")
        local priorityqueue = {}
        local cardsPrioritised = {}
        local cardsOther = {}
        for d, joker in ipairs(G.jokers.cards) do
            if (not joker.debuff) then
                if (joker.ability.akyrs_priority_draw_suit) then
                    priorityqueue[#priorityqueue+1] = {#G.jokers.cards - d + 1, "suit",joker.ability.akyrs_priority_draw_suit}
                    --print(joker.ability.akyrs_priority_draw_suit)
                end
                if joker.ability.akyrs_priority_draw_rank then
                    priorityqueue[#priorityqueue+1] = {#G.jokers.cards - d + 1, "rank",joker.ability.akyrs_priority_draw_rank}
                    --print(joker.ability.akyrs_priority_draw_rank)
                end
                if joker.ability.akyrs_priority_draw_conditions == "Face Cards" then
                    priorityqueue[#priorityqueue+1] = {#G.jokers.cards - d + 1, "face",true}
                    --print(joker.ability.akyrs_priority_draw_conditions)
                end
            end
        end
        table.sort(priorityqueue,compareFirstElement)
        local cards = self.cards
        for i, k in ipairs(cards) do
            local priority = 0
            
            for j, l in ipairs(priorityqueue) do
                if 
                (l[2] == "suit" and k.base.suit == l[3]) or
                (l[2] == "rank" and k.base.value == l[3]) or
                (l[2] == "face" and k:is_face() == l[3])
                 then
                    --print(k.base.name, l[1], l[2], l[3])
                    priority = priority + l[1]
                end
            end

            if priority > 0 then
                cardsPrioritised[#cardsPrioritised+1] = {priority,k}
            else
                cardsOther[#cardsOther+1] = k
            end
        end
        table.sort(cardsPrioritised,compareFirstElement)
        for _, card in ipairs(cardsPrioritised) do
            table.insert(cardsOther, card[2])
        end
        self.cards = cardsOther
        self:set_ranks()
    end
    return r
end


local evalRnd = G.FUNCS.evaluate_round
G.FUNCS.evaluate_round = function()
    if G.GAME.modifiers.akyrs_half_debuff then
        local undbf = {}
        for i,k in ipairs(G.deck.cards) do
            if not k.debuff then
                table.insert(undbf, k)
            end
            if pseudorandom("akyrsdbfhcchal") < 0.5 then
                k.ability.akyrs_perma_debuff = true
            end
        end
    end
    local ret = evalRnd()
    return ret
end


G.FUNCS.akyrs_difficult_blind_alert = function(e)
    if not e.children.alert then
        e.children.alert = UIBox{
          definition = create_UIBox_card_alert({no_bg = true,text = localize('k_akyrs_difficult'), scale = 0.3}),
          config = {
            instance_type = 'ALERT',
            align="tri",
            offset = {x = 0.3, y = -0.18},
            major = e, parent = e}
        }
        e.children.alert.states.collide.can = false
    end
end

G.FUNCS.akyrs_do_nothing = function(e)
end