SMODS.Challenge{
    key = "space_oddity",
    jokers = {
        {
            id = "j_space",
            edition = "akyrs_sliced",
            akyrs_sell_cost = 0,
            eternal = true,
        },
        {
            id = "j_oops",
            edition = "akyrs_noire",
            akyrs_sell_cost = 0,
            eternal = true,
        },
    }
}

SMODS.Challenge{
    key = "4_hibanas",
    jokers = {
        {
            id = "j_akyrs_hibana",
            edition = "negative",
            eternal = true,
            pinned = true,
            akyrs_sell_cost = 0,
            akyrs_card_ability = {
                akyrs_cycler = 4,
                akyrs_priority_draw_rank = "5"

            }
        },
        {
            id = "j_akyrs_hibana",
            edition = "negative",
            eternal = true,
            pinned = true,
            akyrs_sell_cost = 0,
            akyrs_card_ability = {
                akyrs_cycler = 3,
                akyrs_priority_draw_suit = "Hearts"
            }
        },
        {
            id = "j_akyrs_hibana",
            edition = "negative",
            eternal = true,
            pinned = true,
            akyrs_sell_cost = 0,
            akyrs_card_ability = {
                akyrs_cycler = 2,
                akyrs_priority_draw_conditions = "Face Cards"
            }
        },
        {
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
        {
            id = "j_akyrs_hibana",
            eternal = true,
            pinned = true,
            akyrs_sell_cost = 0,
            
        }
    },
    rules = {
        modifiers = {
            { id = "discards", value = 1 },
            { id = "dollars", value = 10 },
        }
    }
}
AKYRS.HardcoreChallenge{
    key = "secured_two_factor",
    jokers = {
        {
            id = "j_akyrs_2fa",
            eternal = true,
            akyrs_sell_cost = 0,
        }
    },
    rules = {
        modifiers = {
        }
    },
    stake = 8
}
AKYRS.HardcoreChallenge{
    key = "detroit",

    rules = {
        custom = {
            {id = 'no_shop_jokers'},
        },
        modifiers = {
            {id = 'joker_slots', value = -20},
            {id = 'consumable_slots', value = -20},
        }
    },
    stake = 2,
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
}