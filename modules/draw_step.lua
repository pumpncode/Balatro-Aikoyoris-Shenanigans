
if SMODS.DrawStep then
    
    SMODS.DrawStep{
        key = "extras",
        order = 50,
        func = function (card, layer)
            AKYRS.aikoyori_draw_extras(card,layer)
        end
    }
    local old_draw_step = SMODS.DrawSteps.front.func -- if you want to reference the old function
    SMODS.DrawStep:take_ownership('front', {
      func = function(self, layer)
        if not self.is_null then
            old_draw_step(self,layer)
        end
      end,
    })
end
