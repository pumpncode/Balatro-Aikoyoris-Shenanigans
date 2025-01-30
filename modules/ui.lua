
assert(SMODS.load_file("./modules/misc.lua"))() 

SMODS.current_mod.config_tab = function()
	return {n = G.UIT.ROOT, config = {
        align = "cm",
        minw = 4,
        minh = 0.6,
        colour = G.C.UI.TRANSPARENT_DARK, 
        r = 0.1,
        padding = 0.1
	}, nodes = {
        {
            n = G.UIT.C, config = {

                minw = 2,
                minh = 0.6,
                padding = 0.1,
            }, nodes = {
                {
                    n = G.UIT.C, 
                    config = {
                        w = 2,
                        h = 0.6,
                        padding = 0.1,
                    },
                    nodes = {
                        
                        {
                            n = G.UIT.T,
                            config = {
                                text = "X of a Kind Limit",
                                colour = G.C.WHITE,
                                scale = 0.5
                            }
                        }
                    }
                }
                ,
                create_text_input({prompt_text = '100', extended_corpus = true, ref_table = 
                    aikoyori_mod_config
                , ref_value = 'x_of_a_kind_limit', text_scale = 0.5, w = 2, h = 0.6,
                onUpdate = function(val) 
                    aikoyori_mod_config.x_of_a_kind_limit = val
                end
                }),
            }
        }
	}
}
end

function THOUGHT_BOSS_BLIND(G, stake_sprite) 
    return {
        {n=G.UIT.O, config={object = G.GAME.blind, draw_layer = 1}},
        {n=G.UIT.C, config={align = "cm",r = 0.1, padding = 0.05, emboss = 0.05, minw = 2.9, colour = G.C.BLACK}, nodes={
          {n=G.UIT.R, config={align = "cm", maxw = 2.8}, nodes={
            {n=G.UIT.T, config={text = localize('ph_aiko_beat_puzzle'), scale = 0.3, colour = G.C.WHITE, shadow = true}}
          }},
          {n=G.UIT.R, config={align = "cm", minh = 0.6, maxw=2.5}, nodes={
            {n=G.UIT.O, config={w=0.5,h=0.5, colour = G.C.BLUE, object = stake_sprite, hover = true, can_collide = false}},
            {n=G.UIT.B, config={h=0.1,w=0.1}},
            {n=G.UIT.T, config={ref_table = G.GAME.blind, text = localize('ph_word_puzzle'), scale = 0.5, colour = G.C.RED, shadow = true}}
          }},
          {n=G.UIT.R, config={align = "cm", maxh = 0, maxw=0}, nodes={
            {n=G.UIT.T, config={ref_table = G.GAME.blind, scale = 0, colour = G.C.RED, shadow = true, id = 'HUD_blind_count'}}
          }},
          {n=G.UIT.R, config={align = "cm", minh = 0.45, maxw = 2.8, func = 'HUD_blind_reward'}, nodes={
            {n=G.UIT.T, config={text = localize('ph_blind_reward'), scale = 0.3, colour = G.C.WHITE}},
            {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME.current_round, ref_value = 'dollars_to_be_earned'}}, colours = {G.C.MONEY},shadow = true, rotate = true, bump = true, silent = true, scale = 0.45}),id = 'dollars_to_be_earned'}},
          }},
        }},
      }
end