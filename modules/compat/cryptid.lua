if Cryptid then -- TODO: Ask Cryptid Discord so I can hook this up properly
    sendInfoMessage("Cryptid Detected... vro ;P","Aikoyori's Shenanigans")
    local original_cluster_fuck = SMODS.PokerHandParts.cry_cfpart.func
    SMODS.PokerHandPart:take_ownership("cry_cfpart",{
        func = function (hand)
            local notnullcnt = 0
            for i,k in ipairs(hand) do
                if not k.is_null then
                    notnullcnt = notnullcnt + 1
                end
            end
            if notnullcnt > 7 then
                return original_cluster_fuck(hand)
            end
            return {}
        end
    })
    SMODS.Back{
        key = "cry_misprint_ultima",
        atlas = "deckBacks",
        pos = { x = 6, y = 0},
        config = { cry_misprint_min = 1e-4, cry_misprint_max = 1e4 },
        set_badges = function (self, card, badges)
            SMODS.create_mod_badges({ mod = Cryptid }, badges)
        end,
        loc_vars = function (self, info_queue, card)
            return {
                vars = {
                    self.config.cry_misprint_min,
                    self.config.cry_misprint_max
                }
            }
        end,
        apply = function(self)
            G.GAME.modifiers.cry_misprint_min = (G.GAME.modifiers.cry_misprint_min or to_big(1)) * self.config.cry_misprint_min
            G.GAME.modifiers.cry_misprint_max = (G.GAME.modifiers.cry_misprint_max or to_big(1)) * self.config.cry_misprint_max
        end,

    }
    AKYRS.HardcoreChallenge{
        key = "detroit_4",
    
        rules = {
            custom = {
                {id = 'no_shop_jokers'},
                {id = 'akyrs_no_tarot_except_twof'},
                {id = 'akyrs_allow_duplicates'},
                {id = 'akyrs_idea_by_missingnumber'},
            },
            modifiers = {
                {id = 'joker_slots', value = -1e300},
                {id = 'consumable_slots', value = -1e300},
            }
        },
        stake = 'stake_cry_ascendant',
        jokers = {
        },
        consumeables = {
        },
        vouchers = {
        },
        restrictions = {
            banned_cards = {
                {id = 'c_wraith'},
                {id = 'c_soul'},
                {id = 'v_blank'},
                {id = 'v_antimatter'},
                {id = 'p_buffoon_normal_1', ids = {
                    'p_buffoon_normal_1','p_buffoon_normal_2','p_buffoon_jumbo_1','p_buffoon_mega_1',
                }},
            },
            banned_tags = {
                {id = 'tag_rare'},
                {id = 'tag_uncommon'},
                {id = 'tag_holo'},
                {id = 'tag_polychrome'},
                {id = 'tag_negative'},
                {id = 'tag_foil'},
                {id = 'tag_buffoon'},
                {id = 'tag_top_up'},
    
            },
            banned_other = {
                {id = 'bl_final_acorn', type = 'blind'},
                {id = 'bl_final_heart', type = 'blind'},
                {id = 'bl_final_leaf', type = 'blind'}
            }
        },
        difficulty = 12,
    }
    AKYRS.HardcoreChallenge{
        key = "detroit_5",
    
        rules = {
            custom = {
                {id = 'no_shop_jokers'},
                {id = 'akyrs_no_tarot_except_twof'},
                {id = 'akyrs_allow_duplicates'},
                {id = 'discard_cost', value = 2e20},
                {id = 'no_reward_specific', value = 'Small'},
                {id = 'no_reward_specific', value = 'Big'},
                {id = 'no_reward_specific', value = 'Boss'},
                {id = 'no_extra_hand_money'},
                {id = 'no_interest'},
                {id = 'chips_dollar_cap'},
            },
            modifiers = {
                {id = 'hands', value = 1},
                {id = 'discards', value = 1},
                {id = 'joker_slots', value = -1e300},
                {id = 'consumable_slots', value = -1e300},
            }
        },
        stake = 'stake_cry_ascendant',
        jokers = {
        },
        consumeables = {
        },
        vouchers = {
        },
        deck = {
            type = "Hardcore Challenge Deck",
            cards = {}
        },
        restrictions = {
            banned_cards = {
                {id = 'c_wraith'},
                {id = 'c_soul'},
                {id = 'v_blank'},
                {id = 'v_antimatter'},
                {id = 'p_buffoon_normal_1', ids = {
                    'p_buffoon_normal_1','p_buffoon_normal_2','p_buffoon_jumbo_1','p_buffoon_mega_1',
                }},
            },
            banned_tags = {
                {id = 'tag_rare'},
                {id = 'tag_uncommon'},
                {id = 'tag_holo'},
                {id = 'tag_polychrome'},
                {id = 'tag_negative'},
                {id = 'tag_foil'},
                {id = 'tag_buffoon'},
                {id = 'tag_top_up'},
    
            },
            banned_other = {
                {id = 'bl_final_acorn', type = 'blind'},
                {id = 'bl_final_heart', type = 'blind'},
                {id = 'bl_final_leaf', type = 'blind'}
            }
        },
        difficulty = 20,
    }
end
ret = {}