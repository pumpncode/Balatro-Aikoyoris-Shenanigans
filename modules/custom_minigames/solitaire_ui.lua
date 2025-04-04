local solitaireCardAreaDrawHook = CardArea.draw
function CardArea:draw()
    local c = solitaireCardAreaDrawHook(self)
    
    if self == AKYRS.SOL.stockCardArea then

        if not self.children.redeal_iui then 
            self.children.redeal_iui = UIBox{
                definition = 
                    {n=G.UIT.ROOT, config = {align = 'cm', padding = 0.1, r =0.1, button = "akyrs_draw_from_waste_to_stock", colour = G.C.CLEAR}, nodes={
                        {n=G.UIT.R, config={align = "cm", padding = 0.2, r =0.1, colour = adjust_alpha(G.C.BLACK, 0.5),func = 'set_button_pip', focus_args = {button = 'rightshoulder', orientation = 'bm', scale = 0.6}, button = 'deck_info'}, nodes={
                            {n=G.UIT.R, config={align = "cm", maxw = 2}, nodes={
                                {n=G.UIT.T, config={text = localize('k_akyrs_solitaire_redeal'), scale = 0.48, colour = G.C.WHITE, shadow = true}}
                            }},
                        }},
                    }},
                config = { align = 'cm', offset = {x=0,y=0}, major = self , parent = self}
            }
            self.children.redeal_iui.states.collide.can = false
        end
        if #self.cards <= 0 then
            self.children.redeal_iui:draw()
        end
    end
    return c
end