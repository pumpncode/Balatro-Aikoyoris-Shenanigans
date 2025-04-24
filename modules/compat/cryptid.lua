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
    SMODS.Back{
        key = "cry_misprint_ultima",
        atlas = "deckBacks",
        pos = { x = 6, y = 0},
        config = { cry_misprint_min = 1e-4, cry_misprint_max = 1e4 },
        set_badges = function (self, card, badges)
            SMODS.create_mod_badges({ mod = Cryptid }, badges)
        end,
        loc_vars = function (self, info_queue, card)
            return {
                vars = {
                    self.config.cry_misprint_min,
                    self.config.cry_misprint_max
                }
            }
        end,
        apply = function(self)
            G.GAME.modifiers.cry_misprint_min = (G.GAME.modifiers.cry_misprint_min or to_big(1)) * self.config.cry_misprint_min
            G.GAME.modifiers.cry_misprint_max = (G.GAME.modifiers.cry_misprint_max or to_big(1)) * self.config.cry_misprint_max
        end,

    }
end
ret = {}