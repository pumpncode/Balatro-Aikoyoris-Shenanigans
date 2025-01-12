SMODS.Enhancement{
    key = "null",
    atlas = 'cardUpgrades',
    pos = {x = 0, y = 0},
    loc_txt =  	{
        name = 'Null',
        text = { 'No Base Chips' },
    },
    replace_base_card = true,
    no_rank = true,
    no_suit = true,
    always_scores = true,
    weight = 0,
    config = {
        bonus = 0,
        bonus_chips = 0,
        mult = 0,
    }
}

SMODS.Back{
    key = "Letter Deck",
    atlas = 'deckBacks',
    pos = {x = 0, y = 0},
    config = {
        all_nulls = true,
        selection = 2000000000,
        special_hook = true,
        letters_enabled = true,
        letters_mult_enabled = true
    },
    loc_txt =  	{
        name = 'Letter Deck',
        text = { 'Play with {C:red}No Ranks and Suits{}', 'Letters enabled by default', "Play {C:playable}as many{} card as you want per hand" },
    },
}