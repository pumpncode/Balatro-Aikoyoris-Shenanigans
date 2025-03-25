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
          config = { w = 8, align = "tm", r = 0.1 , h = 6, padding = 0.2, colour = G.C.UI.TRANSPARENT_DARK},
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

G.FUNCS.akyrs_change_joker_preview_stuff = function (e)
  AKYRS.save_config(e)
end

SMODS.current_mod.config_tab = function ()
  AKYRS.config_dyna_desc_txt_1 = localize('k_akyrs_wildcard_behaviours_description')[AKYRS.config.wildcard_behaviour][1]
  AKYRS.config_dyna_desc_txt_2 = localize('k_akyrs_wildcard_behaviours_description')[AKYRS.config.wildcard_behaviour][2]
  AKYRS.config_wildcard_desc_dyna_1 = DynaText{
    scale = 0.4,
    colours = {G.C.UI.TEXT_LIGHT},
    string = {{ref_table = AKYRS ,ref_value = "config_dyna_desc_txt_1"}},
    shadow = true, float = true, silent = true
  }  
  AKYRS.config_wildcard_desc_dyna_2 = DynaText{
    scale = 0.4,
    colours = {G.C.UI.TEXT_LIGHT},
    string = {{ref_table = AKYRS ,ref_value = "config_dyna_desc_txt_2"}},
    shadow = true, float = true, silent = true
  }
  return {
    n = G.UIT.ROOT, config = { minw = 18, minh = 6 ,align = "tm",colour = G.C.UI.TRANSPARENT_DARK, r = 0.1 },
      nodes = {
        { n = G.UIT.R, config = {align = "tm"}, nodes = {
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
      -- wildcard description
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
      -- joker previews
      
      { n = G.UIT.R, config = { align = "tm"}, nodes = {
        { n = G.UIT.C, config = {
          align = "cm", padding = 0.2,
        }, nodes = {
          
          create_toggle({
            label = localize("k_akyrs_joker_preview"),
            ref_table = AKYRS.config,
            ref_value = "show_joker_preview",
            label_scale = 0.5,
            callback = G.FUNCS.akyrs_change_joker_preview_stuff
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
            n = G.UIT.T,
            config = {
              text = localize("k_akyrs_joker_preview_description")[1],
              scale = 0.4,
              colour = G.C.UI.TEXT_LIGHT,
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
            n = G.UIT.T,
            config = {
              text = localize("k_akyrs_joker_preview_description")[2],
              scale = 0.4,
              colour = G.C.UI.TEXT_LIGHT,
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
            n = G.UIT.T,
            config = {
              text = localize("k_akyrs_joker_preview_description")[3],
              scale = 0.4,
              colour = G.C.UI.TEXT_LIGHT,
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

-- thunk didn't have this so i might as well add the shift key

function AKYRS.create_better_keyboard_input(args)
  local keyboard_rows = {
    '`1234567890-=',
    'qwertyuiop[]\\',
    'asdfghjkl;\'"',
    'zxcvbnm,./',
    args.space_key and ' ' or nil
  }
  local keyboard_button_rows = {
      {},{},{},{},{},{}
  }
  for k, v in ipairs(keyboard_rows) do
      for i = 1, #v do
          local c = v:sub(i,i)
          if c == ' ' then
            keyboard_button_rows[k][#keyboard_button_rows[k] +1] = AKYRS.create_better_keyboard_button(c, c == ' ' and 'y' or nil)
          else
            keyboard_button_rows[k][#keyboard_button_rows[k] +1] = AKYRS.create_dynamic_keyboard_button(c, c == ' ' and 'y' or nil)
          end
      end
  end
  return {n=G.UIT.ROOT, config={align = "cm", padding = 0.1, r = 0.1, colour = {G.C.GREY[1], G.C.GREY[2], G.C.GREY[3],0.7}}, nodes={
    {n=G.UIT.C, config={align = "cm", padding = 0.05, colour = G.C.CLEAR}, nodes = {
      {n=G.UIT.C, config={align = "cm", padding = 0.05, colour = G.C.BLACK, emboss = 0.05, r = 0.1, mid = true}, nodes = {
        {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes = {
          {n=G.UIT.C, config={align = "cm", padding = 0.05, colour = G.C.CLEAR}, nodes = {
              {n=G.UIT.R, config={align = "cm", padding = 0.07, colour = G.C.CLEAR}, nodes=keyboard_button_rows[1]},
              {n=G.UIT.R, config={align = "cm", padding = 0.07, colour = G.C.CLEAR}, nodes=keyboard_button_rows[2]},
              {n=G.UIT.R, config={align = "cm", padding = 0.07, colour = G.C.CLEAR}, nodes=keyboard_button_rows[3]},
              {n=G.UIT.R, config={align = "cm", padding = 0.07, colour = G.C.CLEAR}, nodes=keyboard_button_rows[4]},
              {n=G.UIT.R, config={align = "cm", padding = 0.07, colour = G.C.CLEAR}, nodes=keyboard_button_rows[5]},
              {n=G.UIT.R, config={align = "cm", padding = 0.07, colour = G.C.CLEAR}, nodes=keyboard_button_rows[6]}
          }},
          (args.backspace_key or args.return_key) and {n=G.UIT.C, config={align = "cm", padding = 0.05, colour = G.C.CLEAR}, nodes = {
              args.backspace_key and {n=G.UIT.R, config={align = "cm", padding = 0.05, colour = G.C.CLEAR}, nodes={AKYRS.create_better_keyboard_button('backspace', 'x')}} or nil,
              args.return_key and {n=G.UIT.R, config={align = "cm", padding = 0.05, colour = G.C.CLEAR}, nodes={AKYRS.create_better_keyboard_button('return', 'start')}} or nil,
              args.shift_key and {n=G.UIT.R, config={align = "cm", padding = 0.05, colour = G.C.CLEAR}, nodes={AKYRS.create_toggle_keyboard_button('lshift', 'leftstick')}} or nil,
              {n=G.UIT.R, config={align = "cm", padding = 0.05, colour = G.C.CLEAR}, nodes={AKYRS.create_better_keyboard_button('back', 'b')}}
          }} or nil
        }},
      }}
    }},
    
  }}
end

-- mainly for shift button support

function AKYRS.create_better_keyboard_button(key, binding)
  local key_label = (key == 'backspace' and 'Backspace') or (key == ' ' and 'Space') or (key == 'back' and 'Back') or (key == 'return' and 'Enter')  or (key == 'lshift' and 'Shift') or key
  local is_one_of_those = key == 'backspace' or key == ' ' or key == 'back' or key == 'return' or key == 'lshift' and true or false
  return UIBox_button{ label = {key_label}, button = "key_button", func = not is_one_of_those and 'akyrs_shifted_keyboard_keys' or nil, ref_table = {key = key == 'back' and 'return' or key},
      minw = key == ' ' and 6 or key == 'return' and 2.5 or key == 'backspace' and 2.5 or key == 'back' and 2.5 or key == 'shift' and 3 or 0.5,
      minh = key == 'return' and 1 or key == 'backspace' and 1 or key == 'back' and 0.5 or key == 'shift' and 0.7 or 0.4,
      col = true, colour = G.C.GREY, scale = 0.3, focus_args = binding and {button = binding, orientation = 'cr', set_button_pip= true} or nil}
end
function AKYRS.create_dynamic_keyboard_button(key, binding)
  local key_label = (key == 'backspace' and 'Backspace') or (key == ' ' and 'Space') or (key == 'back' and 'Back') or (key == 'return' and 'Enter')  or (key == 'lshift' and 'Shift') or key
  local is_one_of_those = key == 'backspace' or key == ' ' or key == 'back' or key == 'return' or key == 'lshift' and true or false
  return AKYRS.UIBox_dynatext_button{ label = {key_label}, button = "key_button", func = not is_one_of_those and 'akyrs_shifted_keyboard_keys' or nil, ref_table = {key = key == 'back' and 'return' or key},
      minw = key == ' ' and 6 or key == 'return' and 2.5 or key == 'backspace' and 2.5 or key == 'back' and 2.5 or key == 'shift' and 3 or 0.5,
      minh = key == 'return' and 1 or key == 'backspace' and 1 or key == 'back' and 0.5 or key == 'shift' and 0.7 or 0.4,
      key = "keyboardKey_"..key,
      col = true, colour = G.C.GREY, scale = 0.3, focus_args = binding and {button = binding, orientation = 'cr', set_button_pip= true} or nil}
end
function AKYRS.create_toggle_keyboard_button(key, binding)
  local key_label = (key == 'lshift' and 'Shift') or key
  return UIBox_button{ label = {key_label}, button = "akyrs_toggle_key_button", func = key=="lshift" and "akyrs_shift_enabled" or nil, ref_table = {key = key == 'back' and 'return' or key},
      minw = key == ' ' and 6 or key == 'return' and 2.5 or key == 'backspace' and 2.5 or key == 'back' and 2.5 or key == 'lshift' and 3 or 0.5,
      minh = key == 'return' and 1 or key == 'backspace' and 1 or key == 'back' and 0.5 or key == 'lshift' and 0.7 or 0.4,
      col = true, colour = G.C.GREY, scale = 0.3, focus_args = binding and {button = binding, orientation = 'cr', set_button_pip= true} or nil}
end



G.FUNCS.akyrs_wildcard_check = function(e)
  G.FUNCS.set_button_pip(e)
  local colour = G.C.GREEN
  local button = nil
  if e.config.ref_table.ability.aikoyori_letters_stickers == "#" then
      button = 'akyrs_wildcard_open_wildcard_ui'
      if not e.config.ref_table.ability.aikoyori_pretend_letter then
          colour = AKYRS.config.wildcard_behaviour == 3 and SMODS.Gradients["akyrs_unset_letter"] or G.C.RED
      elseif e.config.ref_table.ability.aikoyori_pretend_letter == "#" then
          colour = G.C.YELLOW
      end
  else
      colour = G.C.UI.BACKGROUND_INACTIVE
      button = nil
  end
  e.config.button = button
  e.config.colour = colour
end

G.FUNCS.akyrs_shift_enabled = function(e)
  if AKYRS.shift_toggled then
    e.config.colour = G.C.PURPLE
  else
    e.config.colour = G.C.GREY
  end
end
G.FUNCS.akyrs_shifted_keyboard_keys = function(e)
  local args = e.config.ref_table
  local old = e.children[1].children[1].config.object.config.string
  local new = nil
  if AKYRS.shift_toggled and args.key then
    new = AKYRS.get_shifted_from_key(args.key)
  elseif AKYRS.shift_toggled and old:upper() ~= old then
    new = old:upper()
  else
    new = args.key
  end
  if new and old ~= new then
    e.children[1].children[1].config.object.config.string = {new}
    e.children[1].children[1].config.object:update_text(true)
  end
end

--[[
G.FUNCS.akyrs_shifted_keyboard_keys = function(e)
  local args = e.config.ref_table
  local old = e.children[1].children[1].children[1].config.text
  local old_node = e.children[1].children[1].children[1].config
  local new = nil
  if AKYRS.shift_toggled and args.key then
    new = AKYRS.get_shifted_from_key(args.key)
  elseif AKYRS.shift_toggled and old:upper() ~= old then
    new = old:upper()
  else
    new = args.key
  end
  if new and old ~= new then
    e.children[1].children[1]:remove()
    old_node.text = new
    e.children[1].children[1] = UIBox{
      definition = {n=G.UIT.T, config=old_node},
      config = { align = 'cm', offset = {x=0,y=0}, major = e.children[1], parent = e.children[1]}

    }
  end
end
]]

G.FUNCS.akyrs_toggle_key_button = function(e)
  local args = e.config.ref_table
  if args.key and args.key == "lshift" then
    AKYRS.shift_toggled = not AKYRS.shift_toggled
  end
end
-- so it support shift and disables the fullscreen dim

function AKYRS.create_better_text_input(args)
  args = args or {}
  args.colour = copy_table(args.colour) or copy_table(G.C.BLUE)
  args.hooked_colour = copy_table(args.hooked_colour) or darken(copy_table(G.C.BLUE), 0.3)
  args.w = args.w or 2.5
  args.h = args.h or 0.7
  args.text_scale = args.text_scale or 0.4
  args.max_length = args.max_length or 16
  args.all_caps = args.all_caps or false
  args.prompt_text = args.prompt_text or localize('k_enter_text')
  args.current_prompt_text = ''
  args.id = args.id or "text_input"

  local text = {ref_table = args.ref_table, ref_value = args.ref_value, letters = {}, current_position = string.len(args.ref_table[args.ref_value])}
  local ui_letters = {}
  for i = 1, args.max_length do
    text.letters[i] = (args.ref_table[args.ref_value] and (string.sub(args.ref_table[args.ref_value], i, i) or '')) or ''
    ui_letters[i] = {n=G.UIT.T, config={ref_table = text.letters, ref_value = i, scale = args.text_scale, colour = G.C.UI.TEXT_LIGHT, id = args.id..'_letter_'..i}}
  end
  args.text = text

  local position_text_colour = lighten(copy_table(G.C.BLUE), 0.4)

  ui_letters[#ui_letters+1] = {n=G.UIT.T, config={ref_table = args, ref_value = 'current_prompt_text', scale = args.text_scale, colour = lighten(copy_table(args.colour), 0.4), id = args.id..'_prompt'}}
  ui_letters[#ui_letters+1] = {n=G.UIT.B, config={r = 0.03,w=0.1, h=0.4, colour = position_text_colour, id = args.id..'_position', func = 'flash'}}

  local t = 
      {n=G.UIT.C, config={align = "cm", colour = G.C.CLEAR}, nodes = {
          {n=G.UIT.C, config={id = args.id, align = "cm", padding = 0.05, r = 0.1, hover = true, colour = args.colour,minw = args.w, min_h = args.h, button = 'select_text_input', shadow = true}, nodes={
            {n=G.UIT.R, config={ref_table = args, padding = 0.05, align = "cm", r = 0.1, colour = G.C.CLEAR}, nodes={
              {n=G.UIT.R, config={ref_table = args, align = "cm", r = 0.1, colour = G.C.CLEAR, func = 'akyrs_text_input'}, nodes=
                ui_letters
              }
            }}
          }}
        }}
  return t
end

-- TEXT INPUT IS JANK

G.FUNCS.akyrs_text_input = function(e)
  local args =e.config.ref_table
  if G.CONTROLLER.text_input_hook == e then
    e.parent.parent.config.colour = args.hooked_colour
    args.current_prompt_text = ''
    args.current_position_text = args.position_text
  else
    e.parent.parent.config.colour = args.colour
    args.current_prompt_text = (args.text.ref_table[args.text.ref_value] == '' and args.prompt_text or '')
    args.current_position_text = ''
  end

  local OSkeyboard_e = e.parent.parent.parent
  if G.CONTROLLER.text_input_hook == e and G.CONTROLLER.HID.controller then
    if not OSkeyboard_e.children.controller_keyboard then 
      OSkeyboard_e.children.controller_keyboard = UIBox{
        definition = AKYRS.create_better_keyboard_input{backspace_key = true, return_key = true, space_key = true, shift_key = true},
        config = {
          align= 'cm',
          offset = {x = 0, y = G.CONTROLLER.text_input_hook.config.ref_table.keyboard_offset or -4},
          major = e.UIBox, parent = OSkeyboard_e}
      }
      G.CONTROLLER.screen_keyboard = OSkeyboard_e.children.controller_keyboard
      G.CONTROLLER:mod_cursor_context_layer(1)
    end
  elseif OSkeyboard_e.children.controller_keyboard then
    OSkeyboard_e.children.controller_keyboard:remove()
    OSkeyboard_e.children.controller_keyboard = nil
    G.CONTROLLER.screen_keyboard = nil
    AKYRS.shift_toggled = nil
    G.CONTROLLER:mod_cursor_context_layer(-1)
  end
end


function AKYRS.UIBox_dynatext_button(args)
  args = args or {}
  args.button = args.button or "exit_overlay_menu"
  args.func = args.func or nil
  args.key = args.key or "generic"
  args.colour = args.colour or G.C.RED
  args.choice = args.choice or nil
  args.chosen = args.chosen or nil
  args.label = args.label or {}
  args.minw = args.minw or 2.7
  args.maxw = args.maxw or (args.minw - 0.2)
  if args.minw < args.maxw then args.maxw = args.minw - 0.2 end
  args.minh = args.minh or 0.9
  args.scale = args.scale or 0.5
  args.focus_args = args.focus_args or nil
  args.text_colour = args.text_colour or G.C.UI.TEXT_LIGHT
  local but_UIT = args.col == true and G.UIT.C or G.UIT.R

  local but_UI_label = {}
  AKYRS.dynatext = AKYRS.dynatext or {}
  AKYRS.dynatext[args.key] = AKYRS.dynatext[args.key] or DynaText{
    string = args.label,
    scale = args.scale,
    colours = {args.text_colour},
    shadow = args.shadow,
  }
  local button_pip = nil
  if args.focus_args and args.focus_args.set_button_pip then 
    button_pip ='set_button_pip'
  end
  table.insert(but_UI_label, {n=G.UIT.R, config={align = "cm", padding = 0, minw = args.minw, maxw = args.maxw}, nodes={
    {n=G.UIT.O, config={
      object = AKYRS.dynatext[args.key]
    },
    {n=G.UIT.T, config={text = '', scale = args.scale, colour = args.text_colour, shadow = args.shadow, focus_args = button_pip and args.focus_args or nil, func = button_pip, ref_table = args.ref_table}},
  }}})
  return 
  {n= but_UIT, config = {align = 'cm'}, nodes={
  {n= G.UIT.C, config={
      align = "cm",
      padding = args.padding or 0,
      r = 0.1,
      hover = true,
      colour = args.colour,
      one_press = args.one_press,
      button = (args.button ~= 'nil') and args.button or nil,
      choice = args.choice,
      chosen = args.chosen,
      focus_args = args.focus_args,
      minh = args.minh - 0.3*(args.count and 1 or 0),
      shadow = true,
      func = args.func,
      id = args.id,
      back_func = args.back_func,
      ref_table = args.ref_table,
      mid = args.mid
    }, nodes=
    but_UI_label
    }}}
end
