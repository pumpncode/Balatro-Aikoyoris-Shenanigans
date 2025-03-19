AKYRS.LetterJoker = SMODS.Joker:extend{
    in_pool = function (self, args)
        return G.GAME.letters_enabled or false
    end
}

-- repeater
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 0,
        y = 0
    },
    key = "redstone_repeater",
    rarity = 2,
    cost = 5,
    config = {
        extra = {
            mult_stored = 1,
            mult = 2,
            starting_mult = 1
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult_stored, card.ability.extra.mult, card.ability.extra.starting_mult }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main and card then
            stored = mult
            mult = mod_mult(card.ability.extra.mult_stored)
            card.ability.extra.mult_stored = stored
            update_hand_text({ immediate = true, nopulse = true, delay = 0 }, { mult_stored = stored })
            return {
                message = "Swapped!",
                xmult = card.ability.extra.mult,
            }
        end
    end,
    blueprint_compat = true
}


local NON_STONE_UPGRADES = {}
for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
    if v.key ~= 'm_stone' then
        NON_STONE_UPGRADES[#NON_STONE_UPGRADES + 1] = v
    end
end
-- observer
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 1,
        y = 0
    },
    key = "observer",
    rarity = 2,
    cost = 5,
    config = {
        extra = {
            mult_stored = 2,
            mult = 4,
            times = 2,
            total_times = 2,
            times_increment = 1,
            mult_change = 0,
            chip_change = 0
        },
        name = "Observer"
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult, card.ability.extra.mult_stored, card.ability.extra.times,
                card.ability.extra.total_times, card.ability.extra.times_increment }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult_stored,
            }
        end
    end,
    blueprint_compat = true
}
-- quasi connectivity
SMODS.Joker {

    atlas = 'AikoyoriJokers',
    pos = {
        x = 2,
        y = 0
    },
    key = "quasi_connectivity",
    rarity = 3,
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult }
        }
    end,
    config = {
        name = "Quasi Connectivity",
        extra = {
            mult = 6,
            first_hand = true
        }
    },
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local quasiCount = 0
            local jokers = {}
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.name == "Quasi Connectivity" then
                    quasiCount = quasiCount + 1
                end
                if (G.jokers.cards[i] ~= card or #G.jokers.cards < 2) then
                    jokers[#jokers + 1] = G.jokers.cards[i]
                end

                G.jokers.cards[i]:set_debuff(false)
            end
            -- remove the current card from the list
            if not G.GAME.aiko_has_quasi then
                jokers[card] = nil
                G.GAME.aiko_has_quasi = true
            end
            for i = 1, quasiCount do
                if (#jokers > 0) then
                    local _card = pseudorandom_element(jokers, pseudoseed('akyrj:quasi_connectivity'))
                    if _card then
                        _card:set_debuff(true)
                        _card:juice_up(1, 1)
                    end
                    jokers[_card] = nil
                end
            end
            G.GAME.aiko_has_quasi = false
            card.ability.extra.first_hand = false
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.mult,
            }
        end
        if context.selling_card then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].debuff then
                    G.jokers.cards[i]:set_debuff(false)
                end
            end
        end
    end,
    blueprint_compat = true
}
-- diamond pick
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 3,
        y = 0
    },
    key = "diamond_pickaxe",
    rarity = 2,
    cost = 3,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.chip_add, card.ability.extra.chip_add_stack }
        }
    end,
    config = {
        name = "Diamond Pickaxe",
        extra = {
            chip_add = 64,
            chip_add_stack = 2,
        }
    },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.ability.name == "Stone Card" then
                for i = 1, card.ability.extra.chip_add_stack do
                    context.other_card:juice_up(0.5, 2)
                    SMODS.calculate_effect({
                        chips = card.ability.extra.chip_add,
                        juice_card = context.other_card,
                    },card)
                end
                return {
                    juice_card = context.other_card,
                    func = function ()
                        context.other_card:set_ability(
                            pseudorandom_element(NON_STONE_UPGRADES, pseudoseed('akyrj:pickaxe')), nil, true)
                                
                    end
                }
            end
        end
    end,
    blueprint_compat = false
}
-- netherite pick
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 4,
        y = 0
    },
    key = "netherite_pickaxe",
    rarity = 2,
    cost = 4,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["m_stone"]
        return {
            vars = { card.ability.extra.chip_add, card.ability.extra.chip_add_stack }
        }
    end,
    config = {
        name = "Netherite Pickaxe",
        extra = {
            chip_add = 64,
            chip_add_stack = 5,
        }
    },
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local cards = {}
        for i = 1,5 do
            local carder = AKYRS.create_random_card("netheritepick")
            carder:set_ability(G.P_CENTERS["m_stone"])
            table.insert(cards, carder)
        end
        SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        AKYRS.card_area_preview(G.akyrsCardsPrev, desc_nodes, {
            cards = cards,
            override = true,
            w = 2.2,
            h = 0.6,
            ml = 0,
            scale = 0.5,
            func_delay = 1.0,
            func_after = function(ca) 
                if ca and ca.cards then
                    for i,k in ipairs(ca.cards) do
                        if not k.removed then
                            k:start_dissolve({G.C.CHIPS}, true)
                        end
                    end
                end
             end,
        })
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.ability.name == "Stone Card" then
                context.other_card.ability.aiko_about_to_be_destroyed = true
                for i = 1, card.ability.extra.chip_add_stack do
                    SMODS.calculate_effect({
                        chips = card.ability.extra.chip_add,
                        juice_card = context.other_card,
                    },card)
                end
                
            end
        end

        if context.destroy_card and context.cardarea == G.play and not context.blueprint and not context.destroy_card.ability.eternal then
            
            if context.destroy_card.ability.aiko_about_to_be_destroyed then
                return { remove = true }
            end
        end
    end,
    blueprint_compat = false
}
-- utage charts
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 5,
        y = 0
    },
    key = "utage_charts",
    rarity = 3,
    cost = 4,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.play_mod }
        }
    end,
    config = {
        name = "Playable Cards",
        play_mod = 1,
    },
    add_to_deck = function(self, card, from_debuff)
        G.GAME.aiko_cards_playable = G.GAME.aiko_cards_playable + card.ability.play_mod
        G.hand:aiko_change_playable(card.ability.play_mod)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.aiko_cards_playable = G.GAME.aiko_cards_playable - card.ability.play_mod
        G.hand:aiko_change_playable(-card.ability.play_mod)
    end,
    blueprint_compat = false,
}

local function is_valid_pool(name)
    return G.P_CENTER_POOLS[name] and true or false
end

function string.split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

local function is_valid_edition(name)
    for _, v in pairs(G.P_CENTER_POOLS.Edition) do
        if v.name == name then
            return true
        end
    end
    return false
end


local function is_valid_enhancement(name)
    for _, v in pairs(G.P_CENTER_POOLS.Enhanced) do
        local first_part = string.split(v.name," ")[1]
        if first_part == name then
            return true
        end
    end
    return false
end
-- it is forbidden to dog
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 7,
        y = 0
    },
    key = "it_is_forbidden_to_dog",
    rarity = 3,
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { 
                card.ability.extra.mult
             }
        }
    end,
    config = {
        extra = {
            mult = 1.5,
        }
    },
    calculate = function(self, card, context)
        if context.individual and context.other_card.debuff and not context.end_of_round and 
        (   context.cardarea == G.play or 
            context.cardarea == G.hand ) then
            return {
                xmult = card.ability.extra.mult
            }
        end
    end,
    blueprint_compat = true,
}

-- eat pant
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 8,
        y = 0
    },
    key = "eat_pant",
    rarity = 3,
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { 
                math.floor(card.ability.extra.card_target),
                card.ability.extra.extra,
                card.ability.extra.Xmult,
             }
        }
    end,
    config = {
        extra = {
            extra = 0.4,
            card_target = 4,
            Xmult = 1,
        }
    },
    calculate = function(self, card, context)
        if context.joker_main then	
            return {
                xmult = card.ability.extra.Xmult
            }
        end
        if context.individual and context.cardarea == G.play and #context.full_hand == math.floor(card.ability.extra.card_target) then
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.extra
            return {
				message = localize('k_upgrade_ex'),
				colour = G.C.MULT,
				card = card
			}
        end		
        if context.destroy_card and (context.cardarea == G.play or context.cardarea == 'unscored') and not context.blueprint and not context.destroy_card.ability.eternal then
            if #context.full_hand == math.floor(card.ability.extra.card_target) then
                return { remove = true }
            end
        end
    end,
    blueprint_compat = true,
}


-- tsunagite
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 9,
        y = 0
    },
    soul_pos = {
        x = 9,
        y = 1
    },
    key = "tsunagite",
    rarity = 4,
    cost = 12,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "akyrs_chip_mult_xchip_xmult", set = 'Other', vars = { 
            card.ability.extra.chips,
            card.ability.extra.mult,
            card.ability.extra.Xchips,
            card.ability.extra.Xmult, } }
        info_queue[#info_queue+1] = {key = "akyrs_gain_chip_mult_xchip_xmult", set = 'Other', vars = { 
            card.ability.extra.gain_chips,
            card.ability.extra.gain_mult,
            card.ability.extra.gain_Xchips,
            card.ability.extra.gain_Xmult } }
        info_queue[#info_queue+1] = {key = "akyrs_tsunagite_scores", set = 'Other', }
        return {
            vars = { 
                card.ability.extra.total,
            }
        }
    end,
    config = {
        extra = {
            total = 15,
            chips = 15,
            Xchips = 1.15,
            mult = 15,
            Xmult = 1.15,
            base_chips = 15,
            base_Xchips = 1.15,
            base_mult = 15,
            base_Xmult = 1.15,
            gain_chips = 15,
            gain_Xchips = 1.5,
            gain_mult = 5,
            gain_Xmult = 0.1,
        }
    },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local total = 0
            for i,k in ipairs(G.play.cards) do

                total = total + k.base.nominal
                if k.base.value == 'Ace' then
                    total = total - 10
                end
            end
            if total <= 15 then
                return {
                    chips = card.ability.extra.chips,
                    xchips = card.ability.extra.Xchips,
                    mult = card.ability.extra.mult,
                    xmult = card.ability.extra.Xmult
                }
            end

        end		
        if context.using_consumeable then
            if context.consumeable.ability.set == 'Planet' then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.gain_chips 
                card.ability.extra.Xchips = card.ability.extra.Xchips + card.ability.extra.gain_Xchips 
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain_mult 
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.gain_Xmult
                SMODS.calculate_effect({
                    message= localize('k_upgrade_ex')
                }, card)
            end
        end
        --[[
        if context.end_of_round then
            if G.GAME.blind.boss and (
                card.ability.extra.chips ~= card.ability.extra.base_chips or
                card.ability.extra.Xchips ~= card.ability.extra.base_Xchips or
                card.ability.extra.mult ~= card.ability.extra.base_mult or
                card.ability.extra.Xmult ~= card.ability.extra.base_Xmult  
            ) then
                card.ability.extra.chips = card.ability.extra.base_chips
                card.ability.extra.Xchips = card.ability.extra.base_Xchips 
                card.ability.extra.mult = card.ability.extra.base_mult 
                card.ability.extra.Xmult = card.ability.extra.base_Xmult 
                SMODS.calculate_effect({
                    message= localize('k_reset')
                }, card)
            end
        end]]
    end,
    blueprint_compat = true,
}


-- yona yona dance
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 0,
        y = 1
    },
    key = "yona_yona_dance",
    rarity = 2,
    cost = 6,
    loc_vars = function(self, info_queue, card)
        
        info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_yona_yona_ex"]
        return {
            vars = { 
                card.ability.extra.times,
             }
        }
    end,
    config = {
        extra = {
            times = 2
        },
    },

    calculate = function(self, card, context)
        if context.repetition and (context.other_card:get_id() == 4 or context.other_card:get_id() == 7) then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.times,
            }
        end
    end,
    blueprint_compat = true,
}

SMODS.Joker {
    key = "tldr_joker",
    atlas = 'AikoyoriJokers',
    pos = {
        x = 6,
        y = 1
    },
    soul_pos = {
        x = 7,
        y = 1
    },
    rarity = 1,
    cost = 2,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["m_stone"]
        return {
            vars = { 
                card.ability.extra.mult,
             }
        }
    end,
    config = {
        extra = {
            mult = 1
        },
    },
    calculate = function(self, card, context)
        if context.joker_main or context.individual and not context.end_of_round then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    blueprint_compat = true,
}

SMODS.Joker {
    atlas = 'AikoyoriJokers',
    key = "reciprocal_joker",
    pos = {
        x = 1,
        y = 1
    },
    rarity = 1,
    cost = 2,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { }
        }
    end,
    config = {
        extra = {
        },
    },
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = localize('k_akyrs_reciprocaled'),
                func = function()
                    mult = mod_mult(hand_chips / mult)
                    
                    update_hand_text({ delay = 0, immediate = false }, { mult = mult, chips = hand_chips })
                end
            }
        end
    end,
    blueprint_compat = true,
}

SMODS.Joker {
    atlas = 'AikoyoriJokers',
    key = "kyoufuu_all_back",
    pos = {
        x = 2,
        y = 1
    },
    rarity = 1,
    cost = 3,
    loc_vars = function(self, info_queue, card)
        return {
        }
    end,
    config = {
        extra = {
        },
    },
    calculate = function(self, card, context)
        if context.pre_discard and G.GAME.current_round.discards_left == 1 then
            return {
                message = localize('k_akyrs_drawn_discard'),
                func = function()
                    G.FUNCS.draw_from_discard_to_deck()
                end
            }
        end
    end,
    blueprint_compat = false,
}

SMODS.Joker {
    atlas = 'AikoyoriJokers',
    key = "2fa",
    pos = {
        x = 3,
        y = 1
    },
    rarity = 1,
    cost = 3,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_2fa_example"]
        return {
            vars = {
                card.ability.extra.extra,
                card.ability.extra.chips
            }
        }
    end,
    config = {
        extra = {
            chips = 0,
            extra = 8,
        },
    },
    calculate = function(self, card, context)
        if context.before then
            
            for i, _card in ipairs(G.play.cards) do
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.extra
            end
            return {
                message = localize("k_akyrs_2fa_generate")
            }
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
        if context.end_of_round and context.cardarea == G.jokers  then
            return {
                message = localize("k_akyrs_2fa_reset"),
                func = function ()
                    card.ability.extra.chips = 0
                end
            }
        end
        if context.after and not context.blueprint then
            
            for i, _card in ipairs(G.play.cards) do
                local percent = math.abs(1.15 - (i-0.999)/(#G.hand.cards-0.998)*0.3)
                G.E_MANAGER:add_event(Event{
                    trigger = 'after',
                    blocking = false,
                    delay = 0.2*i,
                    func = function ()
                        if G.play and G.play.cards then
                            local percent = math.abs(1.15 - (i-0.999)/(#G.play.cards-0.998)*0.3)
                            if G.play.cards[i] then
                                G.play.cards[i]:flip()
                            end
                            --G.play.cards[i]:a_cool_fucking_spin(1,math.pi * 100)
                            play_sound('card1', percent);
                        end
                        return true
                    end
                })
                G.E_MANAGER:add_event(Event{
                    trigger = 'after',
                    delay = 2+0.2*i,
                    blocking = false,
                    func = function ()
                            
                        if G.play and G.play.cards then
                            local _rank = nil
                            local _suit = nil
                            while _rank == nil or _suit == nil do
                                _rank = pseudorandom_element(SMODS.Ranks, pseudoseed('akyrs2far'))
                                _suit = pseudorandom_element(SMODS.Suits, pseudoseed('akyrs2fas'))
                            end
                            
                            
                            --G.play.cards[i]:a_cool_fucking_spin(1,10)
                            
                            if G.play.cards[i] then
                                SMODS.change_base(G.play.cards[i],_suit.key,_rank.key)
                                G.play.cards[i]:flip()
                            end
                            
                        end

                        return true
                    end
                })
            end
            delay(4+0.2*#G.play.cards)
            return {
                message = localize("k_akyrs_2fa_regen"),
                
            }
        end
    end,
    blueprint_compat = false,
}

-- gaslighting 
SMODS.Joker{
    
    atlas = 'AikoyoriJokers',
    key = "gaslighting",
    pos = {
        x = 4,
        y = 1
    },
    rarity = 3,
    cost = 3,
    config = {
        extra = {
            xmult = 1,
            extra = 0.5,
        },
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.extra,
                card.ability.extra.xmult,
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
        if context.final_scoring_step and G.GAME.blind then
            
                local comp = false
                if Talisman then
                    comp = G.GAME.blind.chips:lt(G.GAME.current_round.current_hand.chips * G.GAME.current_round.current_hand.mult)
                else
                    
                    comp = G.GAME.current_round.current_hand.chips * G.GAME.current_round.current_hand.mult >= G.GAME.blind.chips
                end
                G.E_MANAGER:add_event(
                    Event{
                        func = function ()
                            local comp = false
                            if Talisman then
                                comp = G.GAME.blind.chips:lt(G.GAME.current_round.current_hand.chips * G.GAME.current_round.current_hand.mult)
                            else
                                
                                comp = G.GAME.current_round.current_hand.chips * G.GAME.current_round.current_hand.mult >= G.GAME.blind.chips
                            end
                            if comp then
                                card.ability.extra.xmult = 1
                            else 
                                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.extra
                            end
                            return true
                        end
                    }
                )
                if comp then
                    return {
                        message = localize("k_akyrs_extinguish")
                    }
                else 
                    return {
                        message = localize("k_akyrs_burn"),
                    }
                end
        end
    end
}

-- hibana 
SMODS.Joker{
    atlas = 'AikoyoriJokers',
    key = "hibana",
    pos = {
        x = 5,
        y = 1
    },
    soul_pos = {
        x = 8,
        y = 1
    },
    rarity = 3,
    cost = 7,
    config = {
        extra = {
            possible_table = {
                {"Ace", "Rank", {"k_aces", "dictionary"}},
                {"Face Cards", "Condition", {"k_face_cards","dictionary"}},
                {"Hearts", "Suit", {"Hearts", 'suits_plural'}},
                {"5", "Rank", {"5", "ranks"}}
            },
        },
        akyrs_cycler = 1,
        akyrs_priority_draw_rank = "Ace",
        akyrs_priority_draw_suit = nil,
        akyrs_priority_draw_conditions = nil,
    },
    loc_vars = function(self, info_queue, card)
        local table = card.ability.extra.possible_table[math.fmod(card.ability.akyrs_cycler,#(card.ability.extra.possible_table))]
        info_queue[#info_queue+1] = { key = "dd_akyrs_hibana_conditions", set = "DescriptionDummy"}
        return {
            vars = {
                localize(table[3][1],table[3][2]),
                card.ability.akyrs_cycler,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.end_of_round and context.cardarea == G.jokers then
            card.ability.akyrs_cycler = math.floor(card.ability.akyrs_cycler)
            card.ability.akyrs_priority_draw_rank = nil
            card.ability.akyrs_priority_draw_suit = nil
            card.ability.akyrs_priority_draw_conditions = nil
            card.ability.akyrs_cycler = math.fmod(card.ability.akyrs_cycler,#(card.ability.extra.possible_table)) + 1
            local curr = card.ability.extra.possible_table[card.ability.akyrs_cycler]
            if curr[2] == "Rank" then
                card.ability.akyrs_priority_draw_rank = curr[1]
            end
            if curr[2] == "Suit" then
                card.ability.akyrs_priority_draw_suit = curr[1]
            end
            if curr[2] == "Condition" then
                card.ability.akyrs_priority_draw_conditions = curr[1]
            end
            return {
                message = localize('k_akyrs_hibana_change')
            }
        end
    end,
    add_to_deck = function (self, card, from_debuff)        
        card.ability.akyrs_cycler = math.floor(card.ability.akyrs_cycler)
        card.ability.akyrs_priority_draw_rank = nil
        card.ability.akyrs_priority_draw_suit = nil
        card.ability.akyrs_priority_draw_conditions = nil
        local curr = card.ability.extra.possible_table[card.ability.akyrs_cycler]
        if curr[2] == "Rank" then
            card.ability.akyrs_priority_draw_rank = curr[1]
        end
        if curr[2] == "Suit" then
            card.ability.akyrs_priority_draw_suit = curr[1]
        end
        if curr[2] == "Condition" then
            card.ability.akyrs_priority_draw_conditions = curr[1]
        end
        if G.deck then
            G.deck:shuffle()
        end
    end,
    remove_from_deck = function (self, card, from_debuff)
        if G.deck then
            G.deck:shuffle()
        end
    end
}


-- HOLY SHIT NEW PAGE this one is dedicated to the letters
-- update nevermind i add whatever the fuck i wanna

-- maxwell's notebook
AKYRS.LetterJoker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 6,
        y = 0
    },
    key = "maxwells_notebook",
    rarity = 3,
    cost = 4,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_maxwell_example"]
        info_queue[#info_queue+1] = AKYRS.DescriptionDummies["dd_akyrs_credit_larantula"]
        return {
            vars = {  }
        }
    end,
    config = {
        
    },
    
    calculate = function(self, card, context)
        if G.GAME.letters_enabled and G.GAME.aiko_current_word then
            local word = G.GAME.aiko_current_word
            
            if not word then return {} end
            word = string.lower(word)
            local lowerword = string.lower(word)
            word = string.gsub(" " .. word, "%W%l", string.upper):sub(2)
            if word == "Default" then word = nil end
            if word == "Card" then word = "Default" end
            if word == "Consumable" then word = "Consumeables" end
            if word == "Holo" then word = "Holographic" end
            --print(word)
            if context.cardarea == G.play and context.individual then
                if (is_valid_edition(word)) then
                    context.other_card:set_edition({[lowerword] = true}, false, false)
                end

                if (is_valid_enhancement(word)) then
                    
                    local enhancement_from_name = {}
                    for i,k in pairs(G.P_CENTERS) do
                        if(k.set == "Enhanced") then
                            enhancement_from_name[string.split(k.name," ")[1]] = k
                        end
                    end
                    context.other_card:set_ability(enhancement_from_name[word],nil,true)
                end
            end

            if context.joker_main then     
                if (word == "Joker") then
                    local carder = create_card(word,G.jokers, nil, nil, nil, nil, nil, 'akyrs:maxwell')
                    G.jokers:emplace(carder)
                elseif word == "Default" then
                    local front = pseudorandom_element(G.P_CARDS, pseudoseed('akyrs:maxwell'))
                    local carder = Card(G.deck.T.x, G.deck.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS['c_base'], {playing_card = G.playing_card})
                    G.deck:emplace(carder)
                    table.insert(G.playing_cards, carder)
                else
                    --print(word)
                    pcall(function(word)
                        
                        local carder = create_card(word,G.consumeables, nil, nil, nil, nil, nil, 'akyrs:maxwell')
                        if carder then
                            G.consumeables:emplace(carder)
                        end
                    end, word)
                end

                G.GAME.consumeable_buffer = 0
                return {
                    message = localize {
                        key = 'k_created',
                        vars = { word }
                    }
                }
            end
        end
    end,
    blueprint_compat = true,
}
