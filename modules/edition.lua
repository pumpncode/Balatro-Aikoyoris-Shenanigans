SMODS.Shader{
    key = "texelated",
    path = "texelated.fs"
}
SMODS.Shader{
    key = "noire",
    path = "noire.fs"
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
    badge_colour = G.C.PLAYABLE,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                self.config.extra.mult,
                self.config.extra.x_mult,
            }
        }
    end,
    sound = { sound = "akyrs_texelated_sfx", per = 1.2, vol = 0.4 },
    in_shop = true,
    weight = 2,
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
    badge_colour = G.C.PLAYABLE,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                self.config.extra.card_limit,
                self.config.extra.x_mult,
            }
        }
    end,
    sound = { sound = "akyrs_noire_sfx", per = 0.8, vol = 0.3 },
    in_shop = true,
    weight = 14,
}