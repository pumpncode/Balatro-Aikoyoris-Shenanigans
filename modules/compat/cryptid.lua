if Cryptid then -- TODO: Ask Cryptid Discord so I can hook this up properly
    sendInfoMessage("Cryptid Detected... vro ;P","Aikoyori's Shenanigans")
    local original_cluster_fuck = SMODS.PokerHandParts.cry_cfpart.func
    SMODS.PokerHandPart:take_ownership("cry_cfpart",{
        func = function (hand)
            local notnullcnt = 0
            for i,k in ipairs(hand) do
                if not k.is_null then
                    notnullcnt = notnullcnt + 1
                end
            end
            if notnullcnt > 7 then
                return original_cluster_fuck(hand)
            end
            return {}
        end
    })
end
ret = {}