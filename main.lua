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
                vars = {card.ability.extra.times}
            },
            
        })
        update_hand_text({immediate = true, nopulse = true, delay = 0}, {mult_stored = stored})

        if card.ability.extra.times == 0 then
            SMODS.eval_this(card, {
                instant = true,
                message = localize {
                    type = 'variable',
                    key = 'a_mult',
                    vars = {(card.ability.extra.mult_stored+card.ability.extra.mult)}
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
            vars = {card.ability.extra.mult_stored, card.ability.extra.mult, card.ability.extra.starting_mult}
        }
    end,
    loc_txt = {
        name = "Redstone Repeater",
        text = {"Swaps the current {C:white,X:mult} Mult {}", "with the stored {C:mult}Mult",
                "then {C:white,X:mult} X#2# {} Mult", "Start with X {C:white,X:mult}   #3#   {} {C:mult}Mult{}",
                "{C:inactive}(Currently X {C:white,X:mult}   #1#   {} {C:mult}Mult{}{C:inactive}){}"}
    },
    calculate = function(self, card, context)
        if context.joker_main and card then

            stored = mult
            mult = mod_mult(card.ability.extra.mult_stored)
            SMODS.eval_this(card, {
                message = "Swapped!"

            })
            card.ability.extra.mult_stored = stored
            update_hand_text({immediate = true, nopulse = true, delay = 0}, {mult_stored = stored})
            return {
                Xmult_mod = card.ability.extra.mult,
                message = localize {
                    type = 'variable',
                    key = 'a_xmult',
                    vars = {card.ability.extra.mult}
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
            vars = {card.ability.extra.mult, card.ability.extra.mult_stored, card.ability.extra.times,
                    card.ability.extra.total_times, card.ability.extra.times_increment}
        }
    end,
    loc_txt = {
        name = "Observer",
        text = {"This Joker gains {C:mult}#1#{} Mult", "for every{C:attention} #4# {}times {C:inactive}(#3#)",
                "{C:chips}Chips{} or {C:mult}Mult{} value changes",
                "{s:0.8}Times needed increases by {C:attention}#5#{}",
                "{s:0.8}every time this Joker gains {C:mult}Mult{}",
                "{C:inactive}(Currently {C:mult}+#2#{} Mult{C:inactive}){}"}
    },
    calculate = function(self, card, context)

        if context.joker_main then

            return {
                mult_mod = card.ability.extra.mult_stored,
                message = localize {
                    type = 'variable',
                    key = 'a_mult',
                    vars = {card.ability.extra.mult_stored}
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
            vars = {card.ability.extra.mult}
        }
    end,
    loc_txt = {
        name = "Quasi Connectivity",
        text = {"{C:white,X:mult} X#1# {} Mult", "Disables one {C:attention}random Joker{}",
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
                if(#jokers > 0) then
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
                    vars = {card.ability.extra.mult}
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

