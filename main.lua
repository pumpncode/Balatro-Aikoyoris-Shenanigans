-- Creates an atlas for cards to use
SMODS.Atlas {
    -- Key for code to find it with
    key = "AikoyoriJokers",
    -- The name of the file, for the code to pull the atlas from
    path = "AikoyoriJokers.png",
    -- Width of each sprite in 1x size
    px = 71,
    -- Height of each sprite in 1x size
    py = 95
}

function Card:trigger_external(card)
    if (card.ability.name == "Observer") then
        card.ability.extra.times = card.ability.extra.times - 1

        card_eval_status_text(card, 'jokers', nil, 0.5, nil, {
            instant = true,
            card_align = "m",
            message = localize {
                type = 'variable',
                key = 'a_remaining',
                vars = { card.ability.extra.times }
            },

        })
        update_hand_text({ immediate = true, nopulse = true, delay = 0 }, { mult_stored = stored })

        if card.ability.extra.times == 0 then
            SMODS.eval_this(card, {
                instant = true,
                message = localize {
                    type = 'variable',
                    key = 'a_mult',
                    vars = { (card.ability.extra.mult_stored + card.ability.extra.mult) }
                }
            })
            card.ability.extra.total_times = card.ability.extra.total_times + card.ability.extra.times_increment
            card.ability.extra.times = card.ability.extra.total_times
            card.ability.extra.mult_stored = card.ability.extra.mult_stored + card.ability.extra.mult
        end
        card.ability.extra.mult_change = mult
        card.ability.extra.chip_change = chips
    end
end

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
    loc_txt = {
        name = "Redstone Repeater",
        text = { "Swaps the current {C:white,X:mult} Mult {}", "with the stored {C:mult}Mult",
            "then {C:white,X:mult} X#2# {} Mult", "Start with X {C:white,X:mult}   #3#   {} {C:mult}Mult{}",
            "{C:inactive}(Currently X {C:white,X:mult}   #1#   {} {C:mult}Mult{}{C:inactive}){}" }
    },
    calculate = function(self, card, context)
        if context.joker_main and card then
            stored = mult
            mult = mod_mult(card.ability.extra.mult_stored)
            SMODS.eval_this(card, {
                message = "Swapped!"

            })
            card.ability.extra.mult_stored = stored
            update_hand_text({ immediate = true, nopulse = true, delay = 0 }, { mult_stored = stored })
            return {
                Xmult_mod = card.ability.extra.mult,
                message = localize {
                    type = 'variable',
                    key = 'a_xmult',
                    vars = { card.ability.extra.mult }
                }
            }
        end
    end,
    blueprint_compat = true
}

local igo = Game.init_game_object
function Game:init_game_object()
    local ret = igo(self)
    ret.last_mult = 0
    ret.last_chips = 0
    ret.has_quasi = false
    return ret
end

local gameUpdate = EventManager.update

function EventManager:update(dt, forced)
    local s = gameUpdate(self, dt, forced)
    if G.STATE == G.STATES.HAND_PLAYED then
        if G.GAME.last_chips ~= G.GAME.current_round.current_hand.chips or G.GAME.last_mult ~=
            G.GAME.current_round.current_hand.mult then
            G.GAME.last_mult = G.GAME.current_round.current_hand.mult
            G.GAME.last_chips = G.GAME.current_round.current_hand.chips
            for i = 1, #G.jokers.cards do
                if true then
                    if (G.jokers.cards[i].trigger_external) and not G.jokers.cards[i].debuff then
                        G.jokers.cards[i]:trigger_external(G.jokers.cards[i])
                        --G.E_MANAGER:add_event(Event({trigger = "immediate",func = (function()return true end)}), 'base')
                    end
                end
            end
        end
    end
    return s
end

local mod_mult_ref = mod_mult
local mod_chips_ref = mod_chips

function mod_mult(_mult)
    local m = mod_mult_ref(_mult)
    return m
end

function mod_chips(_chips)
    local c = mod_chips_ref(_chips)
    return c
end

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
    loc_txt = {
        name = "Observer",
        text = { "This Joker gains {C:mult}#1#{} Mult", "for every{C:attention} #4# {}times {C:inactive}(#3#)",
            "{C:chips}Chips{} or {C:mult}Mult{} value changes",
            "{s:0.8}Times needed increases by {C:attention}#5#{}",
            "{s:0.8}every time this Joker gains {C:mult}Mult{}",
            "{C:inactive}(Currently {C:mult}+#2#{} Mult{C:inactive}){}" }
    },
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult_stored,
                message = localize {
                    type = 'variable',
                    key = 'a_mult',
                    vars = { card.ability.extra.mult_stored }
                },
                colour = G.C.MULT
            }
        end
    end,
    blueprint_compat = true
}
function table_contains(tbl, x)
    found = false
    for _, v in pairs(tbl) do
        if v == x then
            found = true
        end
    end
    return found
end

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
    loc_txt = {
        name = "Quasi Connectivity",
        text = { "{C:white,X:mult} X#1# {} Mult", "Disables one {C:attention}random Joker{}",
            "after a hand is played",
            "{s:0.8}Debuffs itself if it's",
            "{s:0.8}the sole card"
        }
    },
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
            if not G.GAME.has_quasi then
                jokers[card] = nil
                G.GAME.has_quasi = true
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
            G.GAME.has_quasi = false
            card.ability.extra.first_hand = false
        end
        if context.joker_main then
            return {
                Xmult_mod = card.ability.extra.mult,
                message = localize {
                    type = 'variable',
                    key = 'a_xmult',
                    vars = { card.ability.extra.mult }
                }
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

local NON_STONE_UPGRADES = {}

for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
    if v.key ~= 'm_stone' then
        NON_STONE_UPGRADES[#NON_STONE_UPGRADES + 1] = v
    end
end


SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 3,
        y = 0
    },
    key = "DiamondPickaxe",
    rarity = 1,
    cost = 3,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.chip_add, card.ability.extra.chip_add_stack }
        }
    end,
    loc_txt = {
        name = "Diamond Pickaxe",
        text = { 
            "Gives {C:attention}#2#{} stacks of {C:chips}+#1#{} Chips",
            "for every {C:attention}Stone{} Cards scored",
            "Randomly change that card's upgrades"
        }
    },
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
                    
                    SMODS.eval_this(card, {
                        chip_mod = card.ability.extra.chip_add,
                        colour = G.C.CHIPS,
                        message = localize {
                            type = 'variable',
                            key = 'a_chips',
                            vars = { card.ability.extra.chip_add }
                        },
                    })
                end

                G.E_MANAGER:add_event(Event({
                    func = function()
                        context.other_card:juice_up()
                        context.other_card:set_ability(pseudorandom_element(NON_STONE_UPGRADES, pseudoseed('akyrj:pickaxe')), nil)
                        
                        return true
                    end,
                    delay = 0.5,
                }), 'base')
            end
        end
    end,
    blueprint_compat = false
}
SMODS.Joker {
    atlas = 'AikoyoriJokers',
    pos = {
        x = 4,
        y = 0
    },
    key = "Netherite Pickaxe",
    rarity = 1,
    cost = 3,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.chip_add, card.ability.extra.chip_add_stack }
        }
    end,
    loc_txt = {
        name = "Netherite Pickaxe",
        text = { 
            "Gives {C:attention}#2#{} stacks of {C:chips}+#1#{} Chips",
            "for every {C:attention}Stone{} Cards scored",
            "{C:red,E:1}Destroys that card"
        }
    },
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
                for i = 1, card.ability.extra.chip_add_stack do
                    
                    SMODS.eval_this(card, {
                        chip_mod = card.ability.extra.chip_add,
                        colour = G.C.CHIPS,
                        message = localize {
                            type = 'variable',
                            key = 'a_chips',
                            vars = { card.ability.extra.chip_add }
                        },
                    })
                end

                G.E_MANAGER:add_event(Event({
                    func = function()
                        context.other_card:start_dissolve({ G.C.BLUE }, nil, 1.6, false)
                        return true
                    end,
                    delay = 0.5,
                }), 'base')
            end
        end
        if context.destroying_card and not context.blueprint and not context.destroying_card.ability.eternal then
            return true
        end
    end,
    blueprint_compat = false
}
