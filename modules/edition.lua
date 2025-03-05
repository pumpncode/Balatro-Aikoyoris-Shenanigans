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
        mult = 20,
        x_mult = 0.9;
    },
    badge_colour = G.C.PLAYABLE,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                self.config.mult,
                self.config.x_mult,
            }
        }
    end,
    in_shop = true,
    weight = 2,
}

SMODS.Edition{
    key = "noire",
    shader = "akyrs_noire",
    config = {
        x_mult = 0.3;
        card_limit = 2
    },
    badge_colour = G.C.PLAYABLE,
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                self.config.card_limit,
                self.config.x_mult,
            }
        }
    end,
    in_shop = true,
    weight = 14,
}