function AKYRS.aikoyori_draw_extras(card, layer)
    if card and AKYRS.aikoyori_letters_stickers and (G.GAME.akyrs_character_stickers_enabled or card.ability.forced_letter_render) then
        if card.ability.aikoyori_letters_stickers and AKYRS.aikoyori_letters_stickers[card.ability.aikoyori_letters_stickers] then
            local movement_mod = 0.05 * math.sin(1.1 * (G.TIMERS.REAL + card.aiko_draw_delay)) - 0.07
            local rot_mod = 0.02 * math.sin(0.72 * (G.TIMERS.REAL + card.aiko_draw_delay)) + 0.03
            if G.GAME.current_round.aiko_round_correct_letter and G.GAME.current_round.aiko_round_correct_letter[card.ability.aikoyori_letters_stickers:lower()] then
                AKYRS.aikoyori_letters_stickers["correct"].role.draw_major = card
                AKYRS.aikoyori_letters_stickers["correct"].VT = card.VT
                AKYRS.aikoyori_letters_stickers["correct"]:draw_shader('dissolve', 0, nil, nil, card.children.center, 0.1,
                    nil, nil, nil)
                AKYRS.aikoyori_letters_stickers["correct"]:draw_shader('dissolve', nil, nil, nil, card.children.center, nil,
                    nil, nil, -0.02 + movement_mod * 0.9, nil)
            elseif G.GAME.current_round.aiko_round_misaligned_letter and G.GAME.current_round.aiko_round_misaligned_letter[card.ability.aikoyori_letters_stickers:lower()] then
                AKYRS.aikoyori_letters_stickers["misalign"].role.draw_major = card
                AKYRS.aikoyori_letters_stickers["misalign"].VT = card.VT
                AKYRS.aikoyori_letters_stickers["misalign"]:draw_shader('dissolve', 0, nil, nil, card.children.center, 0.1,
                    nil, nil, nil)
                AKYRS.aikoyori_letters_stickers["misalign"]:draw_shader('dissolve', nil, nil, nil, card.children.center, nil,
                    nil, nil, -0.02 + movement_mod * 0.9, nil)
            elseif G.GAME.current_round.aiko_round_incorrect_letter and G.GAME.current_round.aiko_round_incorrect_letter[card.ability.aikoyori_letters_stickers:lower()] then
                AKYRS.aikoyori_letters_stickers["incorrect"].role.draw_major = card
                AKYRS.aikoyori_letters_stickers["incorrect"].VT = card.VT
                AKYRS.aikoyori_letters_stickers["incorrect"]:draw_shader('dissolve', 0, nil, nil, card.children.center, 0.1,
                    nil, nil, nil)
                AKYRS.aikoyori_letters_stickers["incorrect"]:draw_shader('dissolve', nil, nil, nil, card.children.center, nil,
                    nil, nil, -0.02 + movement_mod * 0.9, nil)
            end
            local letter_to_render = card.ability.aikoyori_letters_stickers
            local tint = false
            if (card.ability.aikoyori_letters_stickers == "#" and card.ability.aikoyori_pretend_letter) and AKYRS.aikoyori_letters_stickers[letter_to_render] then
                letter_to_render = card.ability.aikoyori_pretend_letter
                tint = true
            end
            if AKYRS.aikoyori_letters_stickers[letter_to_render] then
                AKYRS.aikoyori_letters_stickers[letter_to_render].role.draw_major = card
                AKYRS.aikoyori_letters_stickers[letter_to_render].VT = card.VT
                AKYRS.aikoyori_letters_stickers[letter_to_render]:draw_shader('dissolve', 0, nil, nil,
                    card.children.center, 0.1, nil, nil, nil)
                if tint then
                    AKYRS.aikoyori_letters_stickers[letter_to_render]:draw_shader('akyrs_magenta_tint', nil, nil, nil,
                        card.children.center, nil, nil, nil, -0.02 + movement_mod * 0.9, nil)
                else 
                    AKYRS.aikoyori_letters_stickers[letter_to_render]:draw_shader('dissolve', nil, nil, nil,
                        card.children.center, nil, nil, nil, -0.02 + movement_mod * 0.9, nil)
                end
            end

        end
    end
end


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
    elseif self.children.front then
        self.children.front:remove()
        self.children.front = nil
    end
    end,
})

local origSoulRender = SMODS.DrawSteps.floating_sprite.func
SMODS.DrawStep:take_ownership('floating_sprite',{
    func = function (self, layer)
        if self.config and self.config.center_key and self.config.center_key == "j_akyrs_aikoyori" then
            if self.config.center.soul_pos and (self.config.center.discovered or self.bypass_discovery_center) then
                local scale_mod = 0.1
                local rotate_mod = 0
                if G.PROFILES[G.SETTINGS.profile].akyrs_balance == "absurd" then
                    local x = G.TIMERS.REAL * 0.2
                    rotate_mod = ((1 - math.abs((-x-math.floor(-x)) * math.sin(-x*math.pi)) ^ 0.6)*2) * 2 * math.pi
                else
                    rotate_mod = 0.08*math.cos(1.94236*G.TIMERS.REAL)
                end
                
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
