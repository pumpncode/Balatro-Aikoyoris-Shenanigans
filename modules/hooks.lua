
function CardArea:aiko_change_playable(delta)
    self.config.highlighted_limit = self.config.highlight_limit or G.GAME.aiko_cards_playable or 5
    if delta ~= 0 then
        G.E_MANAGER:add_event(Event({
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
    end
end


local igo = Game.init_game_object
function Game:init_game_object()
    local ret = igo(self)
    ret.aiko_last_mult = 0
    ret.aiko_last_chips = 0
    ret.aiko_has_quasi = false
    ret.aiko_cards_playable = 5
    return ret
end

local gameUpdate = EventManager.update

function EventManager:update(dt, forced)
    local s = gameUpdate(self, dt, forced)
    if G.STATE == G.STATES.HAND_PLAYED then
        if G.GAME.aiko_last_chips ~= G.GAME.current_round.current_hand.chips or G.GAME.aiko_last_mult ~=
            G.GAME.current_round.current_hand.mult then
            G.GAME.aiko_last_mult = G.GAME.current_round.current_hand.mult
            G.GAME.aiko_last_chips = G.GAME.current_round.current_hand.chips
            for i = 1, #G.jokers.cards do
                if true then
                    if (G.jokers.cards[i].aiko_trigger_external) and not G.jokers.cards[i].debuff then
                        G.jokers.cards[i]:aiko_trigger_external(G.jokers.cards[i])
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



function Card:aiko_trigger_external(card)
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