-- this file focuses on PURE scoring/joker calculation hooks

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

        if card.ability.extra.times <= 0 then
            card_eval_status_text(card, 'jokers', nil, 0.5, nil, {
                instant = true,
                card_align = "m",
                message = localize {
                    type = 'variable',
                    key = 'a_remaining',
                    vars = { card.ability.extra.times }
                },
            })
            card.ability.extra.total_times = card.ability.extra.total_times + card.ability.extra.times_increment
            card.ability.extra.times = card.ability.extra.total_times
            card.ability.extra.mult_stored = card.ability.extra.mult_stored + card.ability.extra.mult
        end
        card.ability.extra.mult_change = mult
        card.ability.extra.chip_change = chips
    end
end


local hookCalFx = SMODS.calculate_effect
SMODS.calculate_effect = function(effect, scored_card, from_edition, pre_jokers)
    local r = hookCalFx(effect, scored_card, from_edition, pre_jokers)
    if G.GAME.blind and G.GAME.blind.debuff.akyrs_score_face_with_my_dec_mult and G.GAME.blind.debuff.dec_mult then
        if scored_card:is_face(true) then
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function () scored_card:juice_up(0.1); return true end}))
            r = SMODS.calculate_individual_effect(effect, scored_card, "xmult", G.GAME.blind.debuff.dec_mult, false, false)
            percent = (percent or 0) + (percent_delta or 0.08)
        end
    end
    return r
end