
assert(SMODS.load_file("./modules/misc.lua"))() 

local function numberToColor(num)
  if num == 1 then
    return G.C.GREEN
  elseif num == 2 then
    return G.C.ORANGE
  elseif num == 3 then
    return G.C.GREY
  end
  return G.C.TRANSPARENT_DARK
end

SMODS.current_mod.config_tab = function()

  local nodesnshit = {}
  for a,x in ipairs(G.GAME.current_round.aiko_round_played_words) do
    local subnoteforrow = {}
    for b,y in ipairs(x) do
      -- 1 is letter and [2] is stats
      table.insert(subnoteforrow,{
        n = G.UIT.C,
        config = {padding = 0.1,w=3,h=1,colour = numberToColor(y[2])},
        nodes = {
          {
            n = G.UIT.T,
            config = {
              text = y[1],
              colour = G.C.WHITE,
              scale = 0.5
            }
          }
        }
      })
    end
    table.insert(
      nodesnshit,
      {
        n = G.UIT.R,
        config = {padding = 0.0,w=3,h=1},
        nodes = subnoteforrow

      }
    )
  end
	return {n = G.UIT.ROOT, config = {
        align = "cm",
        minw = 4,
        minh = 0.6,
        colour = G.C.UI.TRANSPARENT_DARK, 
        r = 0.1,
        padding = 0.1
	}, nodes = nodesnshit
}
end

function SPECIAL_BOSSS_BLIND(G, stake_sprite) 
  local blindloc = getSpecialBossBlindText((G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind) and G.GAME.blind.config.blind.key or "nu")
    return {
        {n=G.UIT.O, config={object = G.GAME.blind, draw_layer = 1}},
        {n=G.UIT.C, config={align = "cm",r = 0.1, padding = 0.05, emboss = 0.05, minw = 2.9, colour = G.C.BLACK}, nodes={
          {n=G.UIT.R, config={align = "cm", maxw = 2.8}, nodes={
            {n=G.UIT.T, config={text = blindloc[1], scale = 0.3, colour = G.C.WHITE, shadow = true}}
          }},
          {n=G.UIT.R, config={align = "cm", minh = 0.6, maxw=2.5}, nodes={
            {n=G.UIT.O, config={w=0.5,h=0.5, colour = G.C.BLUE, object = stake_sprite, hover = true, can_collide = false}},
            {n=G.UIT.B, config={h=0.1,w=0.1}},
            {n=G.UIT.T, config={ref_table = G.GAME.blind, text = blindloc[2], scale = 0.5, colour = G.C.RED, shadow = true}}
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
function SPECIAL_BOSSS_BLIND_SELECT(G, stake_sprite, disabled,_reward,blind_choice) 
    --print(table_to_string_depth(blind_choice.config,1))
    local blindloc = getSpecialBossBlindText((blind_choice.config and blind_choice.config.key ) and blind_choice.config.key or "nu")
    return {
      {n=G.UIT.R, config={align = "cm", maxw = 2}, nodes={
        {n=G.UIT.T, config={text = blindloc[1], scale = 0.3, colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.WHITE, shadow = not disabled}}
      }},
      {n=G.UIT.R, config={align = "cm", minh = 0.6, maxw=2}, nodes={
        {n=G.UIT.O, config={w=0.5,h=0.5, colour = G.C.BLUE, object = stake_sprite, hover = true, can_collide = false}},
        {n=G.UIT.B, config={h=0.1,w=0.1}},
        {n=G.UIT.T, config={text = blindloc[2], scale=0.9, colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.RED, shadow =  not disabled}}
      }},
      _reward and {n=G.UIT.R, config={align = "cm"}, nodes={
        {n=G.UIT.T, config={text = localize('ph_blind_reward'), scale = 0.35, colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.WHITE, shadow = not disabled}},
        {n=G.UIT.T, config={text = string.rep(localize("$"), blind_choice.config.dollars)..'+', scale = 0.35, colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.MONEY, shadow = not disabled}}
      }} or nil,
    }
end