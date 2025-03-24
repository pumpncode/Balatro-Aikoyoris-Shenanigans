
local alphabet_digital_hallucinations_compat = {
	colour = HEX("3e63c2"),
	loc_key = "k_akyrs_plus_alphabet",
	create = function()
		local ccard = create_card("Alphabet", G.consumeables, nil, nil, nil, nil, nil, "diha")
		ccard:set_edition({ negative = true }, true)
		ccard:add_to_deck()
		G.consumeables:emplace(ccard)
	end,
}

SMODS.Booster{
    key = "letter_pack_1",
    set = "Booster",
    loc_txt = { 
        name = "Letter Pack",
        group_name = "Alphabet Card",
        text={
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:attention} Alphabets{} cards to",
            "keep for later use",
        },
    },
    config = { extra = 3, choose = 1 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 0, y = 0 },
    group_key = "k_alphabets",
    cost = 4,
    select_card = 'consumeables',
    weight = 1,
    kind = "letter_pack",
    create_card = function (self, card, i) 
        return create_card("Alphabet", G.pack_cards, nil, nil, true, true, nil, "_letter")
    end,
    in_pool = function(self, args)
        return G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled
    end,
    cry_digital_hallucinations = alphabet_digital_hallucinations_compat,
}
SMODS.Booster{
    key = "letter_pack_2",
    set = "Booster",
    loc_txt = { 
        name = "Letter Pack",
        group_name = "Alphabet Card",
        text={
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:attention} Alphabets{} cards to",
            "keep for later use",
        },
    },
    config = { extra = 3, choose = 1 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 1, y = 0 },
    group_key = "k_alphabets",
    cost = 4,
    select_card = 'consumeables',
    weight = 1,
    kind = "letter_pack",
    create_card = function (self, card, i) 
        return create_card("Alphabet", G.pack_cards, nil, nil, true, true, nil, "_letter")
    end,
    in_pool = function(self, args)
        return G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled
    end,
    cry_digital_hallucinations = alphabet_digital_hallucinations_compat,
}
SMODS.Booster{
    key = "letter_pack_3",
    set = "Booster",
    loc_txt = { 
        name = "Letter Pack",
        group_name = "Alphabet Card",
        text={
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:attention} Alphabets{} cards to",
            "keep for later use",
        },
    },
    config = { extra = 3, choose = 1 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 2, y = 0 },
    group_key = "k_alphabets",
    cost = 4,
    select_card = 'consumeables',
    weight = 1,
    kind = "letter_pack",
    create_card = function (self, card, i) 
        return create_card("Alphabet", G.pack_cards, nil, nil, true, true, nil, "_letter")
    end,
    in_pool = function(self, args)
        return G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled
    end,
    cry_digital_hallucinations = alphabet_digital_hallucinations_compat,
}
SMODS.Booster{
    key = "letter_pack_4",
    set = "Booster",
    loc_txt = { 
        name = "Letter Pack",
        group_name = "Alphabet Card",
        text={
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:attention} Alphabets{} cards to",
            "keep for later use",
        },
    },
    config = { extra = 3, choose = 1 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 3, y = 0 },
    group_key = "k_alphabets",
    cost = 4,
    select_card = 'consumeables',
    weight = 1,
    kind = "letter_pack",
    create_card = function (self, card, i) 
        return create_card("Alphabet", G.pack_cards, nil, nil, true, true, nil, "_letter")
    end,
    in_pool = function(self, args)
        return G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled
    end,
    cry_digital_hallucinations = alphabet_digital_hallucinations_compat,
}
SMODS.Booster{
    key = "letter_pack_jumbo_1",
    set = "Booster",
    loc_txt = { 
        name = "Jumbo Letter Pack",
        group_name = "Alphabet Card",
        text={
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:attention} Alphabets{} cards to",
            "keep for later use",
        },
    },
    config = { extra = 5, choose = 1 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 4, y = 0 },
    group_key = "k_alphabets",
    cost = 6,
    select_card = 'consumeables',
    weight = 1,
    kind = "letter_pack",
    create_card = function (self, card, i) 
        return create_card("Alphabet", G.pack_cards, nil, nil, true, true, nil, "_letter")
    end,
    in_pool = function(self, args)
        return G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled
    end,
    cry_digital_hallucinations = alphabet_digital_hallucinations_compat,
}
SMODS.Booster{
    key = "letter_pack_jumbo_2",
    set = "Booster",
    loc_txt = { 
        name = "Jumbo Letter Pack",
        group_name = "Alphabet Card",
        text={
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:attention} Alphabets{} cards to",
            "keep for later use",
        },
    },
    config = { extra = 5, choose = 1 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 5, y = 0 },
    group_key = "k_alphabets",
    cost = 6,
    select_card = 'consumeables',
    weight = 1,
    kind = "letter_pack",
    create_card = function (self, card, i) 
        return create_card("Alphabet", G.pack_cards, nil, nil, true, true, nil, "_letter")
    end,
    in_pool = function(self, args)
        return G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled
    end,
    cry_digital_hallucinations = alphabet_digital_hallucinations_compat,
}
SMODS.Booster{
    key = "letter_pack_mega_1",
    set = "Booster",
    loc_txt = { 
        name = "Mega Letter Pack",
        group_name = "Alphabet Card",
        text={
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:attention} Alphabets{} cards to",
            "keep for later use",
        },
    },
    config = { extra = 5, choose = 2 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 6, y = 0 },
    group_key = "k_alphabets",
    cost = 8,
    select_card = 'consumeables',
    weight = 0.25,
    kind = "letter_pack",
    create_card = function (self, card, i) 
        return create_card("Alphabet", G.pack_cards, nil, nil, true, true, nil, "_letter")
    end,
    in_pool = function(self, args)
        return G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled
    end,
    cry_digital_hallucinations = alphabet_digital_hallucinations_compat,
}
SMODS.Booster{
    key = "letter_pack_mega_2",
    set = "Booster",
    loc_txt = { 
        name = "Mega Letter Pack",
        group_name = "Alphabet Card",
        text={
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:attention} Alphabets{} cards to",
            "keep for later use",
        },
    },
    config = { extra = 5, choose = 2 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
        }
    end,
    atlas = 'aikoyoriBoosterPack', pos = { x = 7, y = 0 },
    group_key = "k_alphabets",
    cost = 8,
    select_card = 'consumeables',
    weight = 0.25,
    kind = "letter_pack",
    create_card = function (self, card, i) 
        return create_card("Alphabet", G.pack_cards, nil, nil, true, true, nil, "_letter")
    end,
    in_pool = function(self, args)
        return G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled
    end,
    cry_digital_hallucinations = alphabet_digital_hallucinations_compat,
}