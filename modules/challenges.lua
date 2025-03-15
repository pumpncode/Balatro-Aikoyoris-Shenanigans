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
    }
}