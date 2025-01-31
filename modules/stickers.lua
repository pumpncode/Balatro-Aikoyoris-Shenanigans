
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
        if context.end_of_round and card.ability.akyrs_self_destructs then
            G.E_MANAGER:add_event(Event({
                func = function()
                    card:start_dissolve({G.C.RED}, nil, 1.6)
                    return true
                end,
                delay = 0.5,
            }), 'base')
            if context.destroying_card then
                return true
            end
        end
    end,
    apply = function(self, card, val)
        card.ability.akyrs_self_destructs = val
        card:set_cost()
    end

}