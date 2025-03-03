if Cryptid and false then -- TODO: Ask Cryptid Discord so I can hook this up properly
    local original_cluster_fuck = SMODS.PokerHands.cry_Clusterfuck.evaluate
    SMODS.PokerHand:take_ownership("cry_Clusterfuck",{
        evaluate = function (parts, hand)
            local notnullcnt = 0
            for i,k in ipairs(hand) do
                if not k.is_null then
                    notnullcnt = notnullcnt + 1
                end
            end
            if notnullcnt > 7 then
                return original_cluster_fuck(parts, hand)
            end
            return {}
        end
    })
end