SMODS.Shader{
    key = "texelated",
    path = "texelated.fs"
}
SMODS.Shader{
    key = "noire",
    path = "noire.fs"
}
SMODS.Shader{
    key = "sliced",
    path = "sliced.fs",
    
}

SMODS.Edition{
    key = "texelated",
    shader = "akyrs_texelated",
    config = {
        extra = {
            mult = 20,
            x_mult = 0.9;
        }
    },
    
    calculate =  function (self, card, context)
        if context.main_scoring and context.cardarea == G.play then
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
        if context.main_scoring and context.cardarea == G.play then
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
                ["cry_prob"] = true
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