
assert(SMODS.load_file("./func/words/puzzle_words.lua"))()

SMODS.Blind{
    key = "the_thought",
    dollars = 5,
    mult = 2,
    boss_colour =HEX('95df3e'),
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 1, max = 10},
    pos = { x = 0, y = 0 },
    debuff = {
        special_blind = true,
        infinite_discards = true,
    },
    vars = {},
    set_blind = function(self)
        G.GAME.aiko_puzzle_win = false
        G.GAME.current_round.advanced_blind = true
        G.GAME.word_todo = AKYRS.aiko_pickRandomInTable(puzzle_words)
        
        G.hand:change_size(3)
        G.FUNCS.draw_from_deck_to_hand(3)
        
        G.GAME.current_round.discards_sub = G.GAME.current_round.discards_left + 1
        self.discards_sub = G.GAME.current_round.discards_left + 1 -- math.max(G.GAME.current_round.discards_left, 0)
        ease_discard(-self.discards_sub)
        
        G.GAME.current_round.hand_sub = G.GAME.round_resets.hands-math.max(G.GAME.round_resets.hands,6)
        self.hands_sub = G.GAME.round_resets.hands-math.max(G.GAME.round_resets.hands,6)
        ease_hands_played(-self.hands_sub)
        
        --print ("Word is "..G.GAME.word_todo)
        G.E_MANAGER:add_event(
            Event({
                delay = 10,
                func = function()
                    ease_background_colour{new_colour = HEX('95df3e'), special_colour = HEX('ffd856'), tertiary_colour = G.C.BLACK, contrast = 3}
                    
                    return true
                end
            })
        )
        G.E_MANAGER:add_event(
            Event({
                delay = 10,
                func = function()
                    recalculateHUDUI()
                    recalculateBlindUI()
                    return true
                end
            })
        )
    end,
    drawn_to_hand = function(self)
        G.FUNCS.draw_from_discard_to_deck()
        G.deck:shuffle('akyrthought')
    end,
    in_pool = function(self)
        return G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled or false
    end,
    disable = function(self)
        G.GAME.current_round.advanced_blind = false
        G.hand:change_size(-3)
        
        ease_hands_played(self.hands_sub or G.GAME.current_round.hand_sub)
        ease_discard(self.discards_sub or G.GAME.current_round.discards_sub)
        
        recalculateHUDUI()
        recalculateBlindUI()
        
    end,
    defeat = function(self)
        G.GAME.current_round.advanced_blind = false
        G.hand:change_size(-3)
        
        recalculateHUDUI()
        recalculateBlindUI()
    end,
    press_play = function(self)

    end

}

local function talismanCheck(v,big,omega,jen)
    if Talisman then
        if Talisman.config_file.break_infinity == "omeganum" then
            if Jen then
                return jen
            end
            return omega
        end
        return big
    end
    return v
end

local to_big = not to_big and function(x) return x end or to_big
SMODS.Blind{
    key = "the_libre",
    dollars = 5,
    mult = 2,
    boss_colour = HEX('a74ce8'),
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 3, max = 10},
    pos = { x = 0, y = 5 },
    debuff = {
        disable_chip_x = talismanCheck(3,3333,333,1e300)
    },
    loc_vars = function(self)
        local orig_chips = to_big(get_blind_amount(G.GAME.round_resets.ante)*self.mult*G.GAME.starting_params.ante_scaling)
        
        if Talisman then
            if Talisman.config_file.break_infinity == "omeganum" then
                local val = 1
                if Jen then
                    val = to_big(33333):arrow(orig_chips:log10():ceil(),33333)
                else
                    val = to_big(self.debuff.disable_chip_x):tetrate(orig_chips)
                end
                
                return { vars = {val}, key = self.key }
            else
                
                return { vars = {self.debuff.disable_chip_x ^ orig_chips}, key = self.key }
            end
        else
            return { vars = {orig_chips ^ self.debuff.disable_chip_x}, key = self.key }
        end
    end,
    collection_loc_vars = function(self)
        local s = talismanCheck(
        localize("k_akyrs_current_req").."^3",
        "33^"..localize("k_akyrs_current_req"),
        "33^^"..localize("k_akyrs_current_req"),
        "33333{log("..localize("k_akyrs_current_req")..")}".."33333")
        return { vars = {""..s}, key = self.key }
    end,
    set_blind = function(self)
    end,
    drawn_to_hand = function(self)
        
    end,
    in_pool = function(self)
        return true
    end,
    disable = function(self)
        local to_big = not to_big and function(x) return x end or to_big
        if Talisman then
            if Talisman.config_file.break_infinity == "omeganum" then 
                local val = to_big(get_blind_amount(G.GAME.round_resets.ante)*self.mult*G.GAME.starting_params.ante_scaling):tetrate(to_big(self.debuff.disable_chip_x))
                if Jen and G.GAME.blind.chips then
                    val = to_big(33333):arrow(to_big(G.GAME.blind.chips):log10():ceil(),33333)
                end
                G.GAME.blind.chips = val
            else
                G.GAME.blind.chips = to_big(get_blind_amount(G.GAME.round_resets.ante)*self.mult*G.GAME.starting_params.ante_scaling) ^ to_big(self.debuff.disable_chip_x)

            end
        else
            G.GAME.blind.chips = get_blind_amount(G.GAME.round_resets.ante)*self.mult*G.GAME.starting_params.ante_scaling ^ self.debuff.disable_chip_x
        end
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            
    end,
    defeat = function(self)
        
    end,
    press_play = function(self)
    end

}
AKYRS.picker_primed_action = function ()
    
    G.E_MANAGER:add_event(Event({
        trigger = "after",
        func = function ()
            G.GAME.blind.chips = G.GAME.blind.chips * G.GAME.blind.debuff.score_change
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            G.HUD_blind:get_UIE_by_ID("HUD_blind_count"):juice_up()
            play_sound('timpani')
            return true
        end
    }))
end
AKYRS.picker_initial_action = function() 
    G.E_MANAGER:add_event(Event({
        trigger = "before",
        func = function ()
            G.hand:unhighlight_all()
            
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.2,
                func = function ()
                    local i=1
                    while i <= G.hand.config.highlighted_limit do
                        if i > #G.hand.cards then
                            break
                        end
                        local card = pseudorandom_element(G.hand.cards,pseudoseed("akyrpickerseed"))
                        if card and not card.highlighted then
                            card:highlight(true)
                            G.hand:add_to_highlighted(card)
                            i = i + 1
                        end
                    end
                    
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        func = function ()
                            G.GAME.blind.debuff.primed = true
                            return true
                        end
                    }))
                    return true
                end
            }))
            return true
        end
    },"base",true))
end
SMODS.Blind{
    key = "the_picker",
    dollars = 5,
    mult = 1.5,
    boss_colour = HEX('67e38b'),
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 2, max = 10},
    pos = { x = 0, y = 6 },
    debuff = {
        primed = false,
        acted = false,
        initial_action_acted = false,
        initial_action_act_set = false,
        hand_per_hand = 3,
        lock = false,
        score_change = 1.25,
        akyrs_pick_cards = true,
    },
    loc_vars = function(self)
        return { vars = {G.hand.config.highlighted_limit, self.debuff.score_change}, key = self.key }
    end,
    collection_loc_vars = function(self)
        return { vars = { "Up to selection limit amount of", 1.2 }, key = self.key }
    end,
    set_blind = function(self)
        G.GAME.blind.debuff.orig_chips = G.GAME.blind.chips
    end,
    drawn_to_hand = function(self)
    end,
    in_pool = function(self)
        return true
    end,
    disable = function(self)
        G.GAME.blind.chips = G.GAME.blind.debuff.orig_chips * 2
    end,
    defeat = function(self)
    end,
    press_play = function(self)
        G.GAME.blind.debuff.primed = false
        G.GAME.blind.debuff.acted = false
        G.E_MANAGER:add_event(Event{
            trigger = "after",
            func = function ()
                G.GAME.blind.debuff.initial_action_act_set = false
                return true
            end
        })
    end
}

SMODS.Blind {
    key = "the_height",
    dollars = 7,
    mult = 0.5,
    boss_colour = HEX('36adff'),
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 3, max = 10},
    pos = { x = 0, y = 7 },
    debuff = {
        requirement_scale = 2
    },
    loc_vars = function(self)
        return { vars = {self.debuff.requirement_scale}, key = self.key }
    end,
    collection_loc_vars = function(self)
        return { vars = { "2"}, key = self.key }
    end,
}
SMODS.Blind {
    key = "the_expiry",
    dollars = 5,
    mult = 2,
    boss_colour = HEX('ca60ff'),
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 2, max = 10},
    pos = { x = 0, y = 8 },
    set_blind = function (self)
        for i,k in ipairs(G.consumeables.cards) do
            k.ability.akyrs_perma_debuff = true
        end
    end,
    
    disable = function (self)
        for i,k in ipairs(G.consumeables.cards) do
            k.ability.akyrs_perma_debuff = false
            k.debuff = false
        end
    end
}

SMODS.Blind {
    key = "the_nature",
    dollars = 5,
    mult = 2,
    boss_colour = HEX('3d8a55'),
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 4, max = 10},
    debuff = {
        dec_mult = 0.5,
    },
    
    loc_vars = function (self)
        return {
            vars = { self.debuff.dec_mult }
        }
    end,
    collection_loc_vars = function (self)
        return {
            vars = { 0.5 }
        }
    end,
    calculate = function (self, blind, context)
        if context.individual and (context.cardarea == G.hand or context.cardarea == G.play or context.cardarea == "unscored") then
            if context.other_card:is_face(true) then
                return { Xmult = blind.debuff.dec_mult }
            end
        end
    end,
    pos = { x = 0, y = 9 },
}

SMODS.Blind {
    key = "the_key",
    dollars = 5,
    mult = 2,
    boss_colour = HEX('8c7d36'),
    debuff = {
        akyrs_perma_selection = true
    },
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 3, max = 10},
    pos = { x = 0, y = 12 },
    calculate = function (self, card, context)
        
    end,
    press_play = function (self)
    end
}



-- Showdown Bosses
SMODS.Blind {
    key = "final_periwinkle_pinecone",
    dollars = 8,
    mult = 2,
    boss_colour = HEX('7da8f0'),
    atlas = 'aikoyoriBlindsChips', 
    debuff = {
        akyrs_all_seals_perma_debuff = true
    },
    boss = {min = 1, max = 10, showdown = true},
    pos = { x = 0, y = 10 },
    disable = function (self)
        if AKYRS.all_card_areas then 
            for _,area in ipairs(AKYRS.all_card_areas) do
                if (area and area.cards) then
                    for j,c in ipairs(area.cards) do
                        if c.seal then
                            c.ability.akyrs_perma_debuff = false
                        end
                    end
                end
    
            end
                
        end
    end
}
SMODS.Blind {
    key = "final_razzle_raindrop",
    dollars = 8,
    mult = 2,
    boss_colour = HEX('ff40ac'),
    debuff = {
        akyrs_suit_debuff_hand = true
    },
    
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 1, max = 10, showdown = true},
    pos = { x = 0, y = 11 },
    
    disable = function (self)
        if AKYRS.all_card_areas then 
            for _,area in ipairs(AKYRS.all_card_areas) do
                if (area and area.cards) then
                    for j,c in ipairs(area.cards) do
                        if c.seal then
                            c.ability.akyrs_perma_debuff = false
                            c.debuff = false
                        end
                    end
                end
    
            end
                
        end
    end
}
SMODS.Blind {
    key = "final_lilac_lasso",
    dollars = 8,
    mult = 2,
    boss_colour = HEX('973fd5'),
    debuff = {
        jokers_not_debuffed = 4,
    },
    
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 1, max = 10, showdown = true},
    pos = { x = 0, y = 13 },
    
    loc_vars = function (self)
        return {
            vars = { self.debuff.jokers_not_debuffed }
        }
    end,
    collection_loc_vars = function (self)
        return {
            vars = { 4 }
        }
    end,
    set_blind =function (self)
        self.prepped = true
    end,
    drawn_to_hand = function (self)
        if self.prepped and G.jokers.cards[1] then
            local jokers = {}
            local undebuffed = {}
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:set_debuff(false)
                jokers[#jokers+1] = G.jokers.cards[i] 
            end 
            for i = 1, (self.debuff.jokers_not_debuffed or 4) do
                if #jokers == 0 then break end
                local _card = pseudorandom_element(jokers, pseudoseed('lilac_lasso'))
                for l,j in ipairs(jokers) do
                    if j == _card then
                        table.insert(undebuffed, j)
                        table.remove(jokers, l)
                        break
                    end
                end
            end 
            
            for i, jkr in ipairs(jokers) do
                jkr:set_debuff(true)
            end
            local r_und = {}
            for i = #undebuffed, 1, -1 do
                table.insert(r_und, undebuffed[i])
            end
            for i, carder in ipairs(r_und) do
                G.E_MANAGER:add_event(
                    Event{
                        trigger = "after",
                        delay = AKYRS.get_speed_mult(carder)*0.05,
                        func = function ()
                            carder:juice_up(0.5,1)
                            return true
                        end
                    }
                )
            end
        end
        self.prepped = nil
        
    end,
    press_play =function (self)
        if G.jokers.cards[1] then
            self.triggered = true
            self.prepped = true
        end
    end,
    disable = function (self)
        
        for i = 1, #G.jokers.cards do
            G.jokers.cards[i]:set_debuff(true)
        end 
    end
}

SMODS.Blind {
    key = "forgotten_weights_of_the_past",
    dollars = 8,
    mult = 2,
    boss_colour = HEX('60203f'),
    debuff = {
        ante_scaler = 2,
        current_ante = nil,
    },
    
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = -999999999999, max = 10},
    pos = { x = 0, y = 14 },
    
    loc_vars = function (self)
        return {
            vars = { self.debuff.ante_scaler }
        }
    end,
    collection_loc_vars = function (self)
        return {
            vars = { 2 }
        }
    end,
    in_pool = function (self)
        return G.GAME.round_resets.ante < 0  -- :3
    end,
    set_blind = function (self)
        G.GAME.blind.debuff.current_ante = G.GAME.round_resets.ante
    end,
    calculate = function (self, blind, context)
        if context.individual and context.cardarea == G.play and not context.repetition and not blind.disabled then
            local old_ante = blind.debuff.current_ante
            blind.debuff.current_ante = blind.debuff.current_ante*blind.debuff.ante_scaler
            ease_ante(-old_ante + blind.debuff.current_ante)
        end
    end
}
SMODS.Blind {
    key = "forgotten_prospects_of_the_future",
    dollars = 8,
    mult = 2,
    boss_colour = HEX('2b664f'),
    debuff = {
        ante_scaler = 1,
    },
    
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = -999999999999, max = 10},
    pos = { x = 0, y = 15 },
    
    loc_vars = function (self)
        return {
            vars = { self.debuff.ante_scaler }
        }
    end,
    collection_loc_vars = function (self)
        return {
            vars = { 1 }
        }
    end,
    in_pool = function (self)
        return G.GAME.round_resets.ante < 1  -- :3
    end,
    set_blind = function (self)
        G.GAME.blind.debuff.current_ante = G.GAME.round_resets.ante
    end,
    calculate = function (self, blind, context)
        if context.after and not blind.disabled then
            ease_ante(blind.debuff.ante_scaler * #G.hand.cards)
        end
    end
}
SMODS.Blind {
    key = "forgotten_uncertainties_of_life",
    dollars = 8,
    mult = 2,
    boss_colour = HEX('2c5c6c'),
    debuff = {
        hand_shrinker = 1,
    },
    
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = -999999999999, max = 10},
    pos = { x = 0, y = 16 },
    
    loc_vars = function (self)
        return {
            vars = { self.debuff.hand_shrinker }
        }
    end,
    collection_loc_vars = function (self)
        return {
            vars = { 1 }
        }
    end,
    in_pool = function (self)
        return G.GAME.round_resets.ante < 1  -- :3
    end,
    calculate = function (self, blind, context)
        if context.after and not context.end_of_round and not blind.disabled then
            G.hand:change_size(-blind.debuff.hand_shrinker)
        end
    end
}

SMODS.Blind {
    key = "forgotten_inevitability_of_death",
    dollars = 8,
    mult = 2,
    boss_colour = HEX('4d494b'),
    debuff = {
        discard_dealer = 1,
    },
    
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = -999999999999, max = 10},
    pos = { x = 0, y = 17 },
    
    loc_vars = function (self)
        return {
            vars = { self.debuff.discard_dealer }
        }
    end,
    collection_loc_vars = function (self)
        return {
            vars = { 1 }
        }
    end,
    in_pool = function (self)
        return G.GAME.round_resets.ante < 1  -- :3
    end,
    calculate = function (self, blind, context)
        if context.blind_defeated and not blind.disabled then
            ease_dollars(-G.GAME.chips / G.GAME.blind.chips)
        end
    end
}