--SMODS.Enhancement{
--    key = "null",
--    atlas = 'cardUpgrades',
--    pos = {x = 0, y = 0},
--    loc_txt =  	{
--        name = 'Null',
--        text = { 'No Base Chips' },
--    },
--    replace_base_card = true,
--    no_rank = true,
--    no_suit = true,
--    always_scores = true,
--    weight = 0,
--    config = {
--        bonus = 0,
--        bonus_chips = 0,
--        mult = 0,
--    }
--}

SMODS.Back{
    key = "letter_deck",
    atlas = 'deckBacks',
    pos = {x = 0, y = 0},
    loc_vars = function (self, info_queue, card)
        return { vars = {
            self.config.ante_scaling
        } }
    end,
    config = {
        all_nulls = true,
        starting_deck_size = 100,
        selection = 1e100,
        special_hook = true,
        letters_enabled = true,
        letters_mult_enabled = true,
        letters_xmult_enabled = true,
        ante_scaling = 2,
        vouchers = {'v_akyrs_alphabet_soup','v_akyrs_crossing_field'}
    },
}


SMODS.Enhancement{
    key = "brick_card",
    atlas = 'cardUpgrades',
    pos = {x = 1, y = 0},
    loc_vars = function (self, info_queue, card)
        return { vars = {
            card.ability.extra.mult
        } }
    end,
    config = {
        extra = {
            mult = 10
        }
    },
    calculate = function (self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    no_rank = true,
    no_suit = true,
    always_scores = true,
    replace_base_card = true,
}


SMODS.Enhancement{
    key = "scoreless",
    atlas = 'cardUpgrades',
    pos = {x = 0, y = 0},
    loc_vars = function (self, info_queue, card)
        return { vars = {
        } }
    end,
    never_scores = true,
    replace_base_card = false,
    overrides_base_rank = true
}

