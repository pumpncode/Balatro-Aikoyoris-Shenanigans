
if SMODS.DrawStep then
    
    SMODS.DrawStep{
        key = "extras",
        order = 50,
        func = function (card, layer)
            AKYRS.aikoyori_draw_extras(card,layer)
        end,
        conditions = { vortex = false, facing = 'front' },
    }
    local old_draw_step_front = SMODS.DrawSteps.front.func
    SMODS.DrawStep:take_ownership('front', {
      func = function(self, layer)
        if not self.is_null then
            old_draw_step_front(self,layer)
        else
            self.children.front = nil
        end
      end,
    })
end


local origSoulRender = SMODS.DrawSteps.floating_sprite.func
SMODS.DrawStep:take_ownership('floating_sprite',{
    func = function (self, layer)
        if self.config and self.config.center_key and self.config.center_key == "j_akyrs_aikoyori" then
            if self.config.center.soul_pos and (self.config.center.discovered or self.bypass_discovery_center) then
                local scale_mod = 0.1
                local rotate_mod = 0.08*math.cos(1.94236*G.TIMERS.REAL)
                local xmod = 0
                local ymod = 0.1*math.sin(2.1654*G.TIMERS.REAL) - 0.1
                self.children.floating_sprite:draw_shader('dissolve',0, nil, nil, self.children.center,scale_mod, rotate_mod,xmod,ymod,nil, 0.6)
                self.children.floating_sprite:draw_shader('dissolve', nil, nil, nil, self.children.center, scale_mod, rotate_mod,xmod,ymod-0.2)
                if self.edition then 
                    for k, v in pairs(G.P_CENTER_POOLS.Edition) do
                        if v.apply_to_float then
                            if self.edition[v.key:sub(3)] then
                                self.children.floating_sprite:draw_shader(v.shader, nil, nil, nil, self.children.center, scale_mod, rotate_mod,xmod,ymod-0.2)
                            end
                        end
                    end
                end
            end
        else
            origSoulRender(self,layer)
        end
    end
})
