assert(SMODS.load_file("./modules/atlasses.lua"))() 
assert(SMODS.load_file("./modules/misc.lua"))() 
SMODS.ConsumableType{
    atlas = "consumablesAlphabetPacks",
    key = "Alphabet",
    primary_colour = HEX("ffaf19"),
    secondary_colour = HEX("5cecff"),
    collection_rows = {6,6,6},
    shop_rate = 1,
    loc_txt = {
        collection = "Alphabet Cards",
        name = "Alphabet",

        undiscovered = { -- description for undiscovered cards in the collection
            name = 'Unknown Alphabet',
            text = { 'Find this card when', 'letters are enabled' },
        },
    },
}

local word_letter = {
    "Apple", "Bee", "Cat", "Dog", "Earth", "Fire", "Goat", "Heart", "Ice Cream", "Jam", 
    "Kite", "Lemon", "Magic", "Night", "Orange", "Pineapple", "Quit", "Rat", "Spoon", "Tea", 
    "Umbrella", "Vine", "Water", "Xylophone", "Yarn", "Zebra"
}


for k, v in ipairs(aiko_alphabets_no_wilds) do
    local upper = string.upper(v)
    
    SMODS.Consumable{
        key = v,
        set = "Alphabet",
        atlas = 'consumablesAlphabetPacks',
        pos = { x = math.fmod(k-1,20), y = math.floor((k-1)/20) } ,
        loc_txt = {
            name = upper.." for "..word_letter[k],
            text = { "Convert all selected cards'","letter to {C:red}#1#{}" },
        },
        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.letter,
                    card.ability.max_selected,
                },
            }
        end,
        config = {extra = {letter = v, max_selected = 9999999}},
        
        can_use = function(self, card)
            return #G.hand.highlighted <= card.ability.extra.max_selected and #G.hand.highlighted > 0
        end,
        use = function(self, card, area, copier)
            for i=1, #G.hand.highlighted do
                local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            
            delay(0.5)
            
            for i=1, #G.hand.highlighted do
                local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function()
                    G.hand.highlighted[i].ability.aikoyori_letters_stickers = card.ability.extra.letter G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
        end,
        in_pool = function(self, args)
            return G.GAME.letters_enabled
        end,
    }

end

SMODS.Consumable{
    key = "Wild",
    set = "Alphabet",
    atlas = 'consumablesAlphabetPacks',
    pos = { x = 6, y = 1 } ,
    cost = 6,
    loc_txt = {
        name = "? for ????",
        text = { "Convert up to #2# selected card's","letter to {C:red}Wild (#1#){}" },
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.letter,
                card.ability.max_selected,
            },
        }
    end,
    config = {extra = {letter = "#", max_selected = 1}},
    
    can_use = function(self, card)
        return #G.hand.highlighted <= card.ability.extra.max_selected and #G.hand.highlighted > 0
    end,
    use = function(self, card, area, copier)
        for i=1, #G.hand.highlighted do
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
        end
        
        delay(0.5)
        
        for i=1, #G.hand.highlighted do
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function()
                G.hand.highlighted[i].ability.aikoyori_letters_stickers = card.ability.extra.letter
                G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
        end
    end,
    in_pool = function(self, args)
        return G.GAME.letters_enabled
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
            "be used immediately",
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
    group_key = "alphabets",
    cost = 4,
    draw_hand = true,
    weight = 1,
    kind = "letter_pack",
    create_card = function (self, card, i) 
        return create_card("Alphabet", G.pack_cards, nil, nil, true, true, nil, "_letter")
    end,
    in_pool = function(self, args)
        return G.GAME.letters_enabled
    end,
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
            "be used immediately",
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
    group_key = "alphabets",
    cost = 4,
    draw_hand = true,
    weight = 1,
    kind = "letter_pack",
    create_card = function (self, card, i) 
        return create_card("Alphabet", G.pack_cards, nil, nil, true, true, nil, "_letter")
    end,
    in_pool = function(self, args)
        return G.GAME.letters_enabled
    end,
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
            "be used immediately",
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
    group_key = "alphabets",
    cost = 4,
    draw_hand = true,
    weight = 1,
    kind = "letter_pack",
    create_card = function (self, card, i) 
        return create_card("Alphabet", G.pack_cards, nil, nil, true, true, nil, "_letter")
    end,
    in_pool = function(self, args)
        return G.GAME.letters_enabled
    end,
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
            "be used immediately",
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
    group_key = "alphabets",
    cost = 4,
    draw_hand = true,
    weight = 1,
    kind = "letter_pack",
    create_card = function (self, card, i) 
        return create_card("Alphabet", G.pack_cards, nil, nil, true, true, nil, "_letter")
    end,
    in_pool = function(self, args)
        return G.GAME.letters_enabled
    end,
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
            "be used immediately",
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
    group_key = "alphabets",
    cost = 4,
    draw_hand = true,
    weight = 1,
    kind = "letter_pack",
    create_card = function (self, card, i) 
        return create_card("Alphabet", G.pack_cards, nil, nil, true, true, nil, "_letter")
    end,
    in_pool = function(self, args)
        return G.GAME.letters_enabled
    end,
}
SMODS.Booster{
    key = "letter_pack_jumbo_1",
    set = "Booster",
    loc_txt = { 
        name = "Letter Pack",
        group_name = "Jumbo Alphabet Card",
        text={
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:attention} Alphabets{} cards to",
            "be used immediately",
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
    atlas = 'aikoyoriBoosterPack', pos = { x = 1, y = 0 },
    group_key = "alphabets",
    cost = 6,
    draw_hand = true,
    weight = 1,
    kind = "letter_pack",
    create_card = function (self, card, i) 
        return create_card("Alphabet", G.pack_cards, nil, nil, true, true, nil, "_letter")
    end,
    in_pool = function(self, args)
        return G.GAME.letters_enabled
    end,
}
SMODS.Booster{
    key = "letter_pack_jumbo_2",
    set = "Booster",
    loc_txt = { 
        name = "Letter Pack",
        group_name = "Jumbo Alphabet Card",
        text={
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:attention} Alphabets{} cards to",
            "be used immediately",
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
    atlas = 'aikoyoriBoosterPack', pos = { x = 1, y = 0 },
    group_key = "alphabets",
    cost = 6,
    draw_hand = true,
    weight = 1,
    kind = "letter_pack",
    create_card = function (self, card, i) 
        return create_card("Alphabet", G.pack_cards, nil, nil, true, true, nil, "_letter")
    end,
    in_pool = function(self, args)
        return G.GAME.letters_enabled
    end,
}
SMODS.Booster{
    key = "letter_pack_mega_1",
    set = "Booster",
    loc_txt = { 
        name = "Letter Pack",
        group_name = "Mega Alphabet Card",
        text={
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:attention} Alphabets{} cards to",
            "be used immediately",
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
    atlas = 'aikoyoriBoosterPack', pos = { x = 2, y = 0 },
    group_key = "alphabets",
    cost = 8,
    draw_hand = true,
    weight = 0.25,
    kind = "letter_pack",
    create_card = function (self, card, i) 
        return create_card("Alphabet", G.pack_cards, nil, nil, true, true, nil, "_letter")
    end,
    in_pool = function(self, args)
        return G.GAME.letters_enabled
    end,
}
SMODS.Booster{
    key = "letter_pack_mega_2",
    set = "Booster",
    loc_txt = { 
        name = "Letter Pack",
        group_name = "Mega Alphabet Card",
        text={
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:attention} Alphabets{} cards to",
            "be used immediately",
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
    atlas = 'aikoyoriBoosterPack', pos = { x = 2, y = 0 },
    group_key = "alphabets",
    cost = 8,
    draw_hand = true,
    weight = 0.25,
    kind = "letter_pack",
    create_card = function (self, card, i) 
        return create_card("Alphabet", G.pack_cards, nil, nil, true, true, nil, "_letter")
    end,
    in_pool = function(self, args)
        return G.GAME.letters_enabled
    end,
}