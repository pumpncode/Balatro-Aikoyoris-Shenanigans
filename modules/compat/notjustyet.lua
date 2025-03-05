if G.FUNCS.njy_endround then
    G.E_MANAGER:add_event(Event{
        trigger="after",
        func = function ()
            local notjustyetCanEndRoundHook = G.FUNCS.njy_can_endround
            G.FUNCS.njy_can_endround = function (e)
                if (G.GAME.current_round.advanced_blind) then 
                    if G.GAME.aiko_puzzle_win then
                        e.config.colour = G.C[G.njy_colour]
                        e.config.button = 'njy_attempt_endround'
                    else
                        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
                        e.config.button = nil
                    end
                else
                    local r = notjustyetCanEndRoundHook(e)
                end
            end
            return true
        end
    })
end
