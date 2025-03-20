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


function SPECIAL_BOSSS_BLIND(G, stake_sprite)
  local blindloc = getSpecialBossBlindText((G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind) and
  G.GAME.blind.config.blind.key or "nu")
  return {
    { n = G.UIT.O, config = { object = G.GAME.blind, draw_layer = 1 } },
    {
      n = G.UIT.C,
      config = { align = "cm", r = 0.1, padding = 0.05, emboss = 0.05, minw = 2.9, colour = G.C.BLACK },
      nodes = {
        {
          n = G.UIT.R,
          config = { align = "cm", maxw = 2.8 },
          nodes = {
            { n = G.UIT.T, config = { text = blindloc[1], scale = 0.3, colour = G.C.WHITE, shadow = true } }
          }
        },
        {
          n = G.UIT.R,
          config = { align = "cm", minh = 0.6, maxw = 2.5 },
          nodes = {
            { n = G.UIT.O, config = { w = 0.5, h = 0.5, colour = G.C.BLUE, object = stake_sprite, hover = true, can_collide = false } },
            { n = G.UIT.B, config = { h = 0.1, w = 0.1 } },
            { n = G.UIT.T, config = { ref_table = G.GAME.blind, text = blindloc[2], scale = 0.5, colour = G.C.RED, shadow = true } }
          }
        },
        {
          n = G.UIT.R,
          config = { align = "cm", maxh = 0, maxw = 0 },
          nodes = {
            { n = G.UIT.T, config = { ref_table = G.GAME.blind, scale = 0, colour = G.C.RED, shadow = true, id = 'HUD_blind_count' } }
          }
        },
        {
          n = G.UIT.R,
          config = { align = "cm", minh = 0.45, maxw = 2.8, func = 'HUD_blind_reward' },
          nodes = {
            { n = G.UIT.T, config = { text = localize('ph_blind_reward'), scale = 0.3, colour = G.C.WHITE } },
            { n = G.UIT.O, config = { object = DynaText({ string = { { ref_table = G.GAME.current_round, ref_value = 'dollars_to_be_earned' } }, colours = { G.C.MONEY }, shadow = true, rotate = true, bump = true, silent = true, scale = 0.45 }), id = 'dollars_to_be_earned' } },
          }
        },
      }
    },
  }
end

function SPECIAL_BOSSS_BLIND_TOOLTIP(blind, ability_text, stake_sprite, _dollars)
  local blindloc = getSpecialBossBlindText((blind and blind.key) and blind.key or "nu")
  return
  {
    n = G.UIT.R,
    config = { align = "cm", emboss = 0.05, r = 0.1, minw = 2.5, padding = 0.07, colour = G.C.WHITE },
    nodes = {
      {
        n = G.UIT.R,
        config = { align = "cm", maxw = 2.4 },
        nodes = {
          { n = G.UIT.T, config = { text = blindloc[1], scale = 0.35, colour = G.C.UI.TEXT_DARK } },
        }
      },
      {
        n = G.UIT.R,
        config = { align = "cm" },
        nodes = {
          { n = G.UIT.O, config = { object = stake_sprite } },
          { n = G.UIT.T, config = { text = blindloc[2], scale = 0.4, colour = G.C.RED } },
        }
      },
      {
        n = G.UIT.R,
        config = { align = "cm" },
        nodes = {
          { n = G.UIT.T, config = { text = localize('ph_blind_reward'), scale = 0.35, colour = G.C.UI.TEXT_DARK } },
          { n = G.UIT.O, config = { object = DynaText({ string = { _dollars and string.rep(localize('$'), _dollars) or '-' }, colours = { G.C.MONEY }, rotate = true, bump = true, silent = true, scale = 0.45 }) } },
        }
      },
      ability_text[1] and
      { n = G.UIT.R, config = { align = "cm", padding = 0.08, colour = mix_colours(blind.boss_colour, G.C.GREY, 0.4), r = 0.1, emboss = 0.05, minw = 2.5, minh = 0.9 }, nodes =
      ability_text } or nil
    }
  }
end

function SPECIAL_BOSSS_BLIND_SELECT(G, stake_sprite, disabled, _reward, blind_choice)
  --print(table_to_string_depth(blind_choice.config,1))
  local blindloc = getSpecialBossBlindText((blind_choice.config and blind_choice.config.key) and blind_choice.config.key or
  "nu")
  return {
    {
      n = G.UIT.R,
      config = { align = "cm", maxw = 2 },
      nodes = {
        { n = G.UIT.T, config = { text = blindloc[1], scale = 0.3, colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.WHITE, shadow = not disabled } }
      }
    },
    {
      n = G.UIT.R,
      config = { align = "cm", minh = 0.6, maxw = 2 },
      nodes = {
        { n = G.UIT.O, config = { w = 0.5, h = 0.5, colour = G.C.BLUE, object = stake_sprite, hover = true, can_collide = false } },
        { n = G.UIT.B, config = { h = 0.1, w = 0.1 } },
        { n = G.UIT.T, config = { text = blindloc[2], scale = 0.9, colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.RED, shadow = not disabled } }
      }
    },
    _reward and {
      n = G.UIT.R,
      config = { align = "cm" },
      nodes = {
        { n = G.UIT.T, config = { text = localize('ph_blind_reward'), scale = 0.35, colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.WHITE, shadow = not disabled } },
        { n = G.UIT.T, config = { text = string.rep(localize("$"), blind_choice.config.dollars) .. '+', scale = 0.35, colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.MONEY, shadow = not disabled } }
      }
    } or nil,
  }
end

function INFINITE_DISCARD_UI(temp_col2, scale)
  return {
    {
      n = G.UIT.R,
      config = { align = "cm", r = 0.1, minw = 1.2, minh = 0.7, colour = temp_col2 },
      nodes = {
        { n = G.UIT.O, config = { object = DynaText({ string = { { string = "" } }, font = G.LANGUAGES['en-us'].font, colours = { HEX("00000000") }, shadow = true, rotate = true, scale = 2 * scale }), id = 'discard_UI_count' } },
        { n = G.UIT.T, config = { text = "8", hover = true, shadow = true, colour = G.C.RED, vert = true, scale = 2 * scale } },
      }
    }
  }
end

function create_UIBOX_Aikoyori_WordPuzzleBox()
  local nodesnshit = {}
  for a, x in ipairs(G.GAME.current_round.aiko_round_played_words) do
    local subnoteforrow = {}
    for b, y in ipairs(x) do
      -- 1 is letter and [2] is stats
      table.insert(subnoteforrow, {
        n = G.UIT.C,
        config = { padding = 0.1, minw = 0.4, maxh = 0.5, colour = numberToColor(y[2]) },
        nodes = {
          {
            n = G.UIT.T,
            config = {
              align = "c",
              text = y[1],
              colour = G.C.WHITE,
              scale = 0.3
            }
          }
        }
      })
    end
    table.insert(
      nodesnshit,
      {
        n = G.UIT.R,
        config = { padding = 0.0, maxh = 0.5 },
        nodes = subnoteforrow

      }
    )
  end
  return {
    n = G.UIT.ROOT,
    config = {
      align = "cm",
      minw = 2,
      minh = 0.6,
      padding = 0.2,
      colour = G.C.UI.TRANSPARENT_DARK,
      r = 0.1,
    },
    nodes = {
      {
        n = G.UIT.R,
        config = {
        },
        nodes = nodesnshit
      }
    }
  }
end

SMODS.current_mod.extra_tabs = function()
  return {
    {
      label = localize("k_akyrs_credits"),
      tab_definition_function = function()
        local cards1 = AKYRS.word_to_cards("Aikoyori (https://aikoyori.xyz)")
        local cards2 = AKYRS.word_to_cards("@larantula_l")
        return {
          n = G.UIT.ROOT,
          config = { w = 8, align = "tm", r = 0.1 , h = 6, padding = 0.2},
          nodes = {
            {
              n = G.UIT.C,
              config = {padding = 0.2},
              nodes = {
                {
                  n = G.UIT.R,
                  config = { align = "tm" },
                  nodes = {
                    { n = G.UIT.O, config = { object = 
                    DynaText{
                      string = localize("k_akyrs_title"), 
                      scale = 1, 
                      colours = {SMODS.Gradients["akyrs_mod_title"]},
                      pop_in = 0.1,
                      float = 1,
                      bump_rate = 10,
                      bump_amount = 5,
                    }
                   } }
                  }
                },
                {
                  n = G.UIT.R,
                  config = {},
                  nodes = {
                    { n = G.UIT.T, config = { text = localize("k_akyrs_created_by"), scale = 0.5, colour = G.C.WHITE } }
                  }
                },
                {
                  n = G.UIT.R,
                  config = { w = 4 },
                  nodes = {
                    {
                      n = G.UIT.C,
                      config = { w = 4, align = "tm" },
                      nodes = {
                        AKYRS.embedded_ui_sprite("akyrs_aikoyori_credits", { x = 0, y = 0 }, nil, {
                          w = 480,
                          h = 480,
                          rounded = 0.5
                        }),
                      }
                    },
                    {
                      n = G.UIT.C,
                      config = { w = 4, align = "tm" },
                      nodes = {
                        AKYRS.card_area_preview(G.creditCardArea, nil, {
                          cards = cards1,
                          h = 0.6,
                          w = 5.5,
                          override = true,
                          scale = 0.7,
                          type = "akyrs_credits",
                        }),
                      }
                    },
                  }
                },
                {
                  n = G.UIT.R,
                  config = {},
                  nodes = {
                    { n = G.UIT.T, config = { text = localize("k_akyrs_additional_art_by"), scale = 0.5, colour = G.C.WHITE } }
                  }
                },
                {
                  n = G.UIT.R,
                  config = { w = 4 },
                  nodes = {
                    {
                      n = G.UIT.C,
                      config = { w = 4, align = "tm" },
                      nodes = {
                        AKYRS.embedded_ui_sprite("akyrs_larantula_l_credits", { x = 0, y = 0 }, nil, {
                          w = 480,
                          h = 480,
                          rounded = 0.5
                        }),
                      }
                    },
                    {
                      n = G.UIT.C,
                      config = { w = 4, align = "tm" },
                      nodes = {
                        AKYRS.card_area_preview(G.creditCardArea, nil, {
                          cards = cards2,
                          h = 0.6,
                          w = 3.5,
                          override = true,
                          scale = 0.5,
                          type = "akyrs_credits",
                        }),
                      }
                    },
                  }
                }
              }
            }
          }
        }
      end
    }
  }
end


-- copied from breeze https://discord.com/channels/1116389027176787968/1337300709602754611/1337705824859979817
AKYRS.save_config = function(e)
  local status, err = pcall(SMODS.save_mod_config,AKYRS)
  if status == false then
      sendErrorMessage("Failed to perform a manual mod config save.", 'Aikoyori\'s Shenanigans') -- sorry 
  end
end

G.FUNCS.akyrs_change_wildcard_behaviour = function (e)
  AKYRS.config.wildcard_behaviour = e.to_key
  AKYRS.save_config(e)
  AKYRS.config_dyna_desc_txt_1 = localize('k_akyrs_wildcard_behaviours_description')[AKYRS.config.wildcard_behaviour][1]
  AKYRS.config_dyna_desc_txt_2 = localize('k_akyrs_wildcard_behaviours_description')[AKYRS.config.wildcard_behaviour][2]
  AKYRS.config_wildcard_desc_dyna_1:update_text(true)
  AKYRS.config_wildcard_desc_dyna_1:update()
  AKYRS.config_wildcard_desc_dyna_2:update_text(true)
  AKYRS.config_wildcard_desc_dyna_2:update()
end

SMODS.current_mod.config_tab = function ()
  AKYRS.config_dyna_desc_txt_1 = localize('k_akyrs_wildcard_behaviours_description')[AKYRS.config.wildcard_behaviour][1]
  AKYRS.config_dyna_desc_txt_2 = localize('k_akyrs_wildcard_behaviours_description')[AKYRS.config.wildcard_behaviour][2]
  AKYRS.config_wildcard_desc_dyna_1 = DynaText{
    scale = 0.4,
    colours = {G.C.UI.TEXT_INACTIVE},
    string = {{ref_table = AKYRS ,ref_value = "config_dyna_desc_txt_1"}},
    shadow = true, float = true, silent = true
  }  
  AKYRS.config_wildcard_desc_dyna_2 = DynaText{
    scale = 0.4,
    colours = {G.C.UI.TEXT_INACTIVE},
    string = {{ref_table = AKYRS ,ref_value = "config_dyna_desc_txt_2"}},
    shadow = true, float = true, silent = true
  }
  return {
    n = G.UIT.ROOT, config = { minw = 18, minh = 6 ,align = "tm", r = 0.1 },
      nodes = {
        { n = G.UIT.R, config = { colour = G.C.UI.TRANSPARENT_DARK ,align = "tm"}, nodes = {
          { n = G.UIT.C, config = {
            align = "cm", padding = 0.2,
          }, nodes = {
            {n = G.UIT.T, config = {
              text = "Wildcards Behaviour",
              scale = 0.5,
              colour = G.C.UI.TEXT_LIGHT
            }}
            }
          },          
          { n = G.UIT.C, config = {
            align = "cm", padding = 0.2,
            id = "akyrs_wildcard_behaviour_desc_dyna"
          }, nodes = {
              create_option_cycle({
                options = localize('k_akyrs_wildcard_behaviours'),
                scale = 0.7,
                w = 4.5,
                current_option = AKYRS.config.wildcard_behaviour,
                opt_callback = "akyrs_change_wildcard_behaviour",
                ref_table = AKYRS.config,
                ref_value = "wildcard_behaviour"

              })
            }
          },       
        } 
      },
      {
        n = G.UIT.R,{
          align = "cm", padding = 0.2,
        },
        nodes = {
          {
            n = G.UIT.O,
            config = {
              align = "cm",
              object = AKYRS.config_wildcard_desc_dyna_1
            }
          }
        }
      },
      {
        n = G.UIT.R,{
          align = "cm", padding = 0.2,
        },
        nodes = {
          {
            n = G.UIT.O,
            config = {
              align = "cm",
              object = AKYRS.config_wildcard_desc_dyna_2
            }
          }
        }
      },
    }
  }
end

  
G.FUNCS.akyrs_letter_dialog = function(e)
  G.FUNCS.overlay_menu{
    definition = create_UIBox_options(),
  }
end
