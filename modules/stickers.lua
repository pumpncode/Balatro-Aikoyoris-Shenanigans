local all_sets = {}
for i,k in pairs(G.P_CENTER_POOLS) do
    all_sets[i] = true
end

SMODS.Sticker{
    key = "self_destructs",
    default_compat = true,
    atlas = "aikoyoriStickers",
    pos = {x = 0, y = 0},
    rate = 0,
    badge_colour = G.C.RED,
    sets =  all_sets,
    calculate = function(self, card, context)
    end,
    apply = function(self, card, val)
        card.ability[self.key] = val
        card:set_cost()
    end

}

SMODS.Seal{
    key = "debuff",
    atlas = 'aikoyoriStickers',
    pos = {x = 1, y = 0},
    badge_colour = HEX('91777c'),
    sound = { sound = 'generic1', per = 1.2, vol = 0.4 },

    calculate = function(self, card, context)
        card.debuff = true
    end,

}