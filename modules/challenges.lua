SMODS.Challenge{
    key = "space_oddity",
    jokers = {
        {
            id = "j_space",
            edition = "akyrs_sliced",
            eternal = true,
        },
        {
            id = "j_oops",
            edition = "akyrs_noire",
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
            akyrs_card_ability = {
                akyrs_cycler = 1,
                akyrs_priority_draw_rank = "Ace"
            }
        },
    }
}