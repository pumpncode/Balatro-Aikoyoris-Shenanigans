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
        hand_size = -1,
        selection = 2,
        special_hook = true
    },
    loc_txt =  	{
        name = 'Letter Deck',
        text = { 'Play with {C:red}No Ranks and Suits{}', 'Hands only come from Letter', "{C:blue}-1{} Hand Size", "{C:playable}+2{} Card Selections" },
    },
}