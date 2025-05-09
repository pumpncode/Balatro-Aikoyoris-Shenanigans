
SMODS.Challenge{
    key = "space_oddity",
    jokers = {
        AKYRS.crypternity{
            id = "j_space",
            edition = "akyrs_sliced",
            akyrs_sell_cost = 0,
        },
        AKYRS.crypternity{
            id = "j_oops",
            edition = "akyrs_noire",
            akyrs_sell_cost = 0,
        },
    }
}

SMODS.Challenge{
    key = "4_hibanas",
    jokers = {
        AKYRS.crypternity{
            id = "j_akyrs_hibana",
            edition = "negative",
            pinned = true,
            akyrs_sell_cost = 0,
            akyrs_card_ability = {
                akyrs_cycler = 4,
                akyrs_priority_draw_rank = "5"

            }
        },
        AKYRS.crypternity{
            id = "j_akyrs_hibana",
            edition = "negative",
            pinned = true,
            akyrs_sell_cost = 0,
            akyrs_card_ability = {
                akyrs_cycler = 3,
                akyrs_priority_draw_suit = "Hearts"
            }
        },
        AKYRS.crypternity{
            id = "j_akyrs_hibana",
            edition = "negative",
            pinned = true,
            akyrs_sell_cost = 0,
            akyrs_card_ability = {
                akyrs_cycler = 2,
                akyrs_priority_draw_conditions = "Face Cards"
            }
        },
        AKYRS.crypternity{
            id = "j_akyrs_hibana",
            edition = "negative",
            eternal = true,
            pinned = true,
            akyrs_sell_cost = 0,
            akyrs_card_ability = {
                akyrs_cycler = 1,
                akyrs_priority_draw_rank = "Ace"
            }
        },
    },
    rules = {
        modifiers = {
            { id = "discards", value = 1 },
            { id = "dollars", value = 10 },
        }
    }
}

AKYRS.HardcoreChallenge{
    key = "spark",
    jokers = {
        AKYRS.crypternity{
            id = "j_akyrs_hibana",
            pinned = true,
            akyrs_sell_cost = 0,
            
        }
    },
    rules = {
        modifiers = {
            { id = "discards", value = 1 },
            { id = "dollars", value = 10 },
        }
    },
    deck = {
        deck = "Hardcore Challenge Deck",
        no_ranks = {
            ['A'] = true,
            ['5'] = true,
            ['J'] = true,
            ['Q'] = true,
            ['K'] = true,
        },
        no_suits = {
            ['H'] = true,
        }
    },
    difficulty = 2,
}
AKYRS.HardcoreChallenge{
    key = "secured_two_factor",
    jokers = {
        AKYRS.crypternity{
            id = "j_akyrs_2fa",
            akyrs_sell_cost = 0,
        }
    },
    rules = {
        modifiers = {
        }
    },
    difficulty = 4,
    stake = "stake_gold",
}
AKYRS.HardcoreChallenge{
    key = "detroit",

    rules = {
        custom = {
            {id = 'no_shop_jokers'},
        },
        modifiers = {
            {id = 'joker_slots', value = -1e200},
            {id = 'consumable_slots', value = -1e200},
        }
    },
    stake = "stake_gold",
    jokers = {
        
        AKYRS.crypternity{
            id = "j_credit_card",
            akyrs_sell_cost = 0,
        },
        AKYRS.crypternity{
            id = "j_vagabond",
            akyrs_sell_cost = 0,
        },
        AKYRS.crypternity{
            id = "j_raised_fist",
            akyrs_sell_cost = 0,
        },
        AKYRS.crypternity{
            id = "j_sixth_sense",
            akyrs_sell_cost = 0,
        },
    },
    consumeables = {
    },
    vouchers = {
    },
    restrictions = {
        banned_cards = {
            {id = 'c_judgement'},
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
    difficulty = 5,
}

AKYRS.HardcoreChallenge{
    key = "detroit_2",

    rules = {
        custom = {
            {id = 'no_shop_jokers'},
        },
        modifiers = {
            {id = 'joker_slots', value = -1e200},
            {id = 'consumable_slots', value = -1e200},
        }
    },
    stake = "stake_gold",
    jokers = {
    },
    consumeables = {
    },
    vouchers = {
    },
    restrictions = {
        banned_cards = {
            {id = 'c_judgement'},
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
    difficulty = 7,
}
AKYRS.HardcoreChallenge{
    key = "detroit_3",

    rules = {
        custom = {
            {id = 'no_shop_jokers'},
            {id = 'akyrs_no_tarot_except_twof'},
            {id = 'akyrs_allow_duplicates'},
            {id = 'akyrs_idea_by_astrapboy'},
        },
        modifiers = {
            {id = 'joker_slots', value = -1e200},
            {id = 'consumable_slots', value = -1e200},
        }
    },
    stake = "stake_gold",
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
    difficulty = 10,
}


AKYRS.HardcoreChallenge{
    key = "half_life",
    jokers = {
    },
    rules = {
        modifiers = {
        },
        custom = {
            {id = 'akyrs_half_debuff'},
        }
    },
    difficulty = 6,
}

AKYRS.HardcoreChallenge{
    key = "half_life_2",
    jokers = {
    },
    vouchers = {
        {id = 'v_magic_trick'},
        {id = 'v_illusion'},
        {id = 'v_overstock_norm'},
        {id = 'v_overstock_plus'},
    },
    rules = {
        modifiers = {
            {id = 'dollars', value = 500},
        },
        custom = {
            {id = 'akyrs_half_self_destruct'},
        }
    },
    difficulty = 8,
}

local fullDeckTenTimesBig = {}
local fullDeckTwentyTimesBig = {}
for a = 1, 10 do
    for i, k in pairs(G.P_CARDS) do
        local card_id_parts = {}
        for part in string.gmatch(i, "([^_]+)") do
            table.insert(card_id_parts, part)
        end
        table.insert(fullDeckTenTimesBig,{ s = card_id_parts[1],r = card_id_parts[2] })
    end
end

for a = 1, 20 do
    for i, k in pairs(G.P_CARDS) do
        local card_id_parts = {}
        for part in string.gmatch(i, "([^_]+)") do
            table.insert(card_id_parts, part)
        end
        table.insert(fullDeckTwentyTimesBig,{ s = card_id_parts[1],r = card_id_parts[2] })
    end
end


AKYRS.HardcoreChallenge{
    key = "thin_yo_deck",
    jokers = {
    },
    vouchers = {
    },
    deck = {
        type = "Hardcore Challenge Deck",
        cards = fullDeckTenTimesBig
    },
    rules = {
    },
    difficulty = 2,
}
AKYRS.HardcoreChallenge{
    key = "thin_yo_deck_2",
    jokers = {
    },
    vouchers = {
    },
    deck = {
        type = "Hardcore Challenge Deck",
        cards = fullDeckTwentyTimesBig
    },
    rules = {
    },
    difficulty = 3,
}
AKYRS.HardcoreChallenge{
    key = "national_debt",
    jokers = {
    },
    vouchers = {
    },
    deck = {
        type = "Hardcore Challenge Deck",
    },
    rules = {
        modifiers = {
            { id = "dollars", value = -36560000000000 },
        }
    },
    difficulty = 6,
    stake = "stake_gold",
}