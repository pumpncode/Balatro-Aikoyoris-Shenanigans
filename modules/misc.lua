
G.C.PLAYABLE = HEX("ee36ff")

function table_contains(tbl, x)
    found = false
    for _, v in pairs(tbl) do
        if v == x then
            found = true
        end
    end
    return found
end

local NON_STONE_UPGRADES = {}
for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
    if v.key ~= 'm_stone' then
        NON_STONE_UPGRADES[#NON_STONE_UPGRADES + 1] = v
    end
end
