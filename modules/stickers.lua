
assert(SMODS.load_file("./modules/misc.lua"))() 

local all_sets = {}
for i,k in pairs(G.P_CENTER_POOLS) do
    all_sets[i] = true
end

SMODS.Sticker{
    key = "self_destructs",
    default_compat = true,
    atlas = "lettersStickers",
    pos = {x = 0, y = 3},
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