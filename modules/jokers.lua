
assert(SMODS.load_file("./modules/misc.lua"))() 
-- repeater
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 0,
        y = 0
    },
    key = "redstone_repeater",
    rarity = 2,
    cost = 5,
    config = {
        extra = {
            mult_stored = 1,
            mult = 2,
            starting_mult = 1
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult_stored, card.ability.extra.mult, card.ability.extra.starting_mult }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main and card then
            stored = mult
            mult = mod_mult(card.ability.extra.mult_stored)
            card.ability.extra.mult_stored = stored
            update_hand_text({ immediate = true, nopulse = true, delay = 0 }, { mult_stored = stored })
            return {
                message = "Swapped!",
                xmult = card.ability.extra.mult,
            }
        end
    end,
    blueprint_compat = true
}


local NON_STONE_UPGRADES = {}
for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
    if v.key ~= 'm_stone' then
        NON_STONE_UPGRADES[#NON_STONE_UPGRADES + 1] = v
    end
end
-- observer
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 1,
        y = 0
    },
    key = "observer",
    rarity = 2,
    cost = 5,
    config = {
        extra = {
            mult_stored = 2,
            mult = 2,
            times = 2,
            total_times = 2,
            times_increment = 1,
            mult_change = 0,
            chip_change = 0
        },
        name = "Observer"
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult, card.ability.extra.mult_stored, card.ability.extra.times,
                card.ability.extra.total_times, card.ability.extra.times_increment }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult_stored,
            }
        end
    end,
    blueprint_compat = true
}
-- quasi connectivity
SMODS.Joker {

    atlas = 'AikoyoriJokers',
    pos = {
        x = 2,
        y = 0
    },
    key = "quasi_connectivity",
    rarity = 3,
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.mult }
        }
    end,
    config = {
        name = "Quasi Connectivity",
        extra = {
            mult = 6,
            first_hand = true
        }
    },
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local quasiCount = 0
            local jokers = {}
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.name == "Quasi Connectivity" then
                    quasiCount = quasiCount + 1
                end
                if (G.jokers.cards[i] ~= card or #G.jokers.cards < 2) then
                    jokers[#jokers + 1] = G.jokers.cards[i]
                end

                G.jokers.cards[i]:set_debuff(false)
            end
            -- remove the current card from the list
            if not G.GAME.aiko_has_quasi then
                jokers[card] = nil
                G.GAME.aiko_has_quasi = true
            end
            for i = 1, quasiCount do
                if (#jokers > 0) then
                    local _card = pseudorandom_element(jokers, pseudoseed('akyrj:quasi_connectivity'))
                    if _card then
                        _card:set_debuff(true)
                        _card:juice_up(1, 1)
                    end
                    jokers[_card] = nil
                end
            end
            G.GAME.aiko_has_quasi = false
            card.ability.extra.first_hand = false
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.mult,
            }
        end
        if context.selling_card then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].debuff then
                    G.jokers.cards[i]:set_debuff(false)
                end
            end
        end
    end,
    blueprint_compat = true
}
-- diamond pick
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 3,
        y = 0
    },
    key = "diamond_pickaxe",
    rarity = 2,
    cost = 3,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.chip_add, card.ability.extra.chip_add_stack }
        }
    end,
    config = {
        name = "Diamond Pickaxe",
        extra = {
            chip_add = 64,
            chip_add_stack = 2,
        }
    },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.ability.name == "Stone Card" then
                for i = 1, card.ability.extra.chip_add_stack do
                    context.other_card:juice_up(0.5, 2)
                    SMODS.calculate_effect({
                        chips = card.ability.extra.chip_add,
                        juice_card = context.other_card,
                    },card)
                end
                return {
                    juice_card = context.other_card,
                    func = function ()
                        context.other_card:set_ability(
                            pseudorandom_element(NON_STONE_UPGRADES, pseudoseed('akyrj:pickaxe')), nil, true)
                                
                    end
                }
            end
        end
    end,
    blueprint_compat = false
}
-- netherite pick
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 4,
        y = 0
    },
    key = "netherite_pickaxe",
    rarity = 2,
    cost = 4,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.chip_add, card.ability.extra.chip_add_stack }
        }
    end,
    config = {
        name = "Netherite Pickaxe",
        extra = {
            chip_add = 64,
            chip_add_stack = 5,
        }
    },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.ability.name == "Stone Card" then
                context.other_card.ability.aiko_about_to_be_destroyed = true
                for i = 1, card.ability.extra.chip_add_stack do
                    SMODS.calculate_effect({
                        chips = card.ability.extra.chip_add,
                        juice_card = context.other_card,
                    },card)
                end
                
            end
        end

        if context.after and context.cardarea == G.play then
            
            for i,k in ipairs(G.play.cards)do
                if k.ability.aiko_about_to_be_destroyed then
                    k:start_dissolve({ G.C.BLACK }, nil, 4, false); 
                    k:juice_up(0.1) 
                    
                end
            end

        end

        if context.destroying_card and context.cardarea == G.play and not context.blueprint and not context.destroying_card.ability.eternal then
            
            if context.destroy_card.ability.aiko_about_to_be_destroyed then
                return { remove = true }
            end
        end
    end,
    blueprint_compat = false
}
-- utage charts
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 5,
        y = 0
    },
    key = "utage_charts",
    rarity = 3,
    cost = 4,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.play_mod }
        }
    end,
    config = {
        name = "Playable Cards",
        play_mod = 1,
    },
    add_to_deck = function(self, card, from_debuff)
        G.GAME.aiko_cards_playable = G.GAME.aiko_cards_playable + card.ability.play_mod
        G.hand:aiko_change_playable(card.ability.play_mod)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.aiko_cards_playable = G.GAME.aiko_cards_playable - card.ability.play_mod
        G.hand:aiko_change_playable(-card.ability.play_mod)
    end,
    blueprint_compat = false,
}

local function is_valid_pool(name)
    return G.P_CENTER_POOLS[name] and true or false
end

function string.split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

local function is_valid_edition(name)
    for _, v in pairs(G.P_CENTER_POOLS.Edition) do
        if v.name == name then
            return true
        end
    end
    return false
end


local function is_valid_enhancement(name)
    for _, v in pairs(G.P_CENTER_POOLS.Enhanced) do
        local first_part = string.split(v.name," ")[1]
        if first_part == name then
            return true
        end
    end
    return false
end
-- maxwell's notebook
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 6,
        y = 0
    },
    key = "maxwells_notebook",
    rarity = 3,
    cost = 4,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {  }
        }
    end,
    config = {
        
    },
    calculate = function(self, card, context)
        if G.GAME.letters_enabled and G.GAME.aiko_current_word then
            local word = G.GAME.aiko_current_word
            
            if not word then return {} end
            word = string.lower(word)
            local lowerword = string.lower(word)
            word = string.gsub(" " .. word, "%W%l", string.upper):sub(2)
            if word == "Default" then word = nil end
            if word == "Card" then word = "Default" end
            if word == "Consumable" then word = "Consumeables" end
            if word == "Holo" then word = "Holographic" end
            --print(word)
            if context.cardarea == G.play and context.individual then
                if (is_valid_edition(word)) then
                    context.other_card:set_edition({[lowerword] = true}, false, false)
                end

                if (is_valid_enhancement(word)) then
                    
                    local enhancement_from_name = {}
                    for i,k in pairs(G.P_CENTERS) do
                        if(k.set == "Enhanced") then
                            enhancement_from_name[string.split(k.name," ")[1]] = k
                        end
                    end
                    context.other_card:set_ability(enhancement_from_name[word],nil,true)
                end
            end

            if context.joker_main then     
                if (word == "Joker") then
                    local carder = create_card(word,G.jokers, nil, nil, nil, nil, nil, 'akyrs:maxwell')
                    G.jokers:emplace(carder)
                elseif word == "Default" then
                    local front = pseudorandom_element(G.P_CARDS, pseudoseed('akyrs:maxwell'))
                    local carder = Card(G.deck.T.x, G.deck.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS['c_base'], {playing_card = G.playing_card})
                    G.deck:emplace(carder)
                    table.insert(G.playing_cards, carder)
                else
                    --print(word)
                    pcall(function(word)
                        
                        local carder = create_card(word,G.consumeables, nil, nil, nil, nil, nil, 'akyrs:maxwell')
                        if carder then
                            G.consumeables:emplace(carder)
                        end
                    end, word)
                end

                G.GAME.consumeable_buffer = 0
                return {
                    message = localize {
                        key = 'k_created',
                        vars = { word }
                    }
                }
            end
        end
    end,
    blueprint_compat = true,
}