SMODS.Edition{
    key = "texelated",
    shader = "akyrs_texelated",
    config = {
        extra = {
            mult = -50,
            x_mult = 2;
        }
    },
    
    calculate =  function (self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                mult = card.edition.extra.mult,
                Xmult = card.edition.extra.x_mult
            }
        end
        if context.pre_joker and (context.cardarea == G.jokers)  then
            return {
                mult = card.edition.extra.mult,
                Xmult = card.edition.extra.x_mult
            }
        end
    end,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.edition.extra.mult,
                card.edition.extra.x_mult,
            }
        }
    end,
    sound = { sound = "akyrs_texelated_sfx", per = 1.2, vol = 0.4 },
    in_shop = true,
    weight = 7,
}

SMODS.Edition{
    key = "noire",
    shader = "akyrs_noire",
    config = {
        extra ={
            x_mult = 0.75,
        },
        card_limit = 2
    },
    calculate =  function (self, card, context)
        if context.main_scoring and (context.cardarea == G.hand or context.cardarea == G.play)  then
            return {
                Xmult = card.edition.extra.x_mult
            }
        end
        if context.pre_joker and (context.cardarea == G.jokers)  then
            return {
                Xmult = card.edition.extra.x_mult
            }
        end
    end,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.edition.card_limit,
                card.edition.extra.x_mult,
            }
        }
    end,
    sound = { sound = "akyrs_noire_sfx", per = 0.8, vol = 0.3 },
    in_shop = true,
    weight = 3,
}

SMODS.Edition{
    key = "sliced",
    shader = "akyrs_sliced",
    config = {
        extra = {
            mod_mult = 0.5,
        },
        akyrs_card_extra_triggers = 1
    },
    disable_base_shader = true,
    sound = { sound = "akyrs_noire_sfx", per = 0.8, vol = 0.3 },
    in_shop = true,
    on_apply = function (card)
        if not card.akyrs_upgrade_sliced then
            AKYRS.mod_card_values(card.ability,{multiply = 0.5, reference = card.akyrs_old_ability, unkeywords = {
                ["cry_prob"] = true,
                ["akyrs_cycler"] = true,
            }})
            card.akyrs_upgrade_sliced = true
        end
    end,
    on_remove = function (card)
        card.ability = card.akyrs_old_ability
        card.akyrs_upgrade_sliced = false
    end,
    weight = 5,
}

SMODS.Edition{
    key = "burnt",
    shader = "akyrs_burnt",
    config = {
        extra = {
            odds = 7,
        },
        name = "akyrs_burnt"
    },
    disable_base_shader = true,
    sound = { sound = "akyrs_noire_sfx", per = 0.8, vol = 0.3 },
    in_shop = false,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                G.GAME.probabilities.normal or 1,
                card.edition.extra.odds,
            }
        }
    end,
    calculate = function (self, card, context)
        if context.end_of_round then
            local odder = pseudorandom("burnt") < G.GAME.probabilities.normal / card.edition.extra.odds
            card.edition.akyrs_burned_to_ash = odder
        end
        
    end,
    weight = 0,
}