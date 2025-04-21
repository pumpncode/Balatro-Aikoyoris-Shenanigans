-- this file has ui hooks lol


local cardGetUIBoxRef = Card.generate_UIBox_ability_table

function Card:generate_UIBox_ability_table()
    local ret = cardGetUIBoxRef(self)
    local letter = self.ability.aikoyori_letters_stickers

    if letter and letter == "#" then
        letter = "Wild"
    else
        if letter then
            letter = string.upper(letter)
        end
    end
    local loc_vars = {}
    if (letter) then
        loc_vars = {
            (AKYRS.get_scrabble_score(self.ability.aikoyori_letters_stickers)),
            1 + (AKYRS.get_scrabble_score(self.ability.aikoyori_letters_stickers) / 10),
        }
    end
    if self.is_null then
        --print(table_to_string(ret))
        local newRetTable = table.aiko_shallow_copy(ret)

        newRetTable.name = {}
        localize({
            type = 'name_text',
            key = 'aiko_x_akyrs_null',
            set = 'AikoyoriExtraBases',
            vars = { colours = { G.C.BLUE } },
            nodes =
                newRetTable.name
        })
        newRetTable.name = newRetTable.name[1]
        newRetTable.main = {}
        newRetTable.info = {}
        newRetTable.type = {}

        for i, v in ipairs(ret.info) do
            if i > 0 then
                table.insert(newRetTable.info, v)
            end
        end


        if ((G.GAME.akyrs_character_stickers_enabled or self.ability.forced_letter_render) and letter) then
            generate_card_ui({ key = 'letters' .. letter, set = 'AikoyoriExtraBases', vars = loc_vars }, newRetTable)
        else
            generate_card_ui({ key = 'aiko_x_akyrs_null', set = 'AikoyoriExtraBases', vars = loc_vars }, newRetTable)
        end
        if self.ability.set ~= 'Default' then
            for i, v in ipairs(ret.main) do
                if i > 0 then
                    table.insert(newRetTable.main, v)
                end
            end
            for i, v in ipairs(ret.type) do
                if i > 0 then
                    table.insert(newRetTable.type, v)
                end
            end
        else

        end


        ret = newRetTable
    else
        if ((G.GAME.akyrs_character_stickers_enabled or self.ability.forced_letter_render) and letter) then
            generate_card_ui({ key = 'letters' .. letter, set = 'AikoyoriExtraBases', vars = loc_vars }, ret)
        end
    end
    return ret
end

function recalculateBlindUI()
    if G.HUD_blind then
        G.HUD_blind.definition = nil
        G.HUD_blind.definition = create_UIBox_HUD_blind()
        G.HUD_blind:set_parent_child(G.HUD_blind.definition, nil)
        G.HUD_blind:recalculate()
    end
end

function recalculateHUDUI()
    if G.HUD then
        ease_discard(0, true, true)
        G.HUD:recalculate()
    end
end

local easeDiscardHook = ease_discard
function ease_discard(mod, instant, silent)
    local discard_UI = G.HUD:get_UIE_by_ID('discard_UI_count')
    if discard_UI then
        if G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind and G.GAME.blind.config.blind.debuff and G.GAME.blind.config.blind.debuff.infinite_discards and not G.GAME.blind.disabled and not G.GAME.blind.disabled and not G.GAME.aiko_puzzle_win then
            G.GAME.current_round.aiko_infinite_hack = "8"
            discard_UI.config.object.config.string[1].ref_value = "aiko_infinite_hack"
            discard_UI.config.object.T.r = 1.57
            discard_UI.config.object:update()
        else
            discard_UI.config.object.config.string[1].ref_value = "discards_left"
            discard_UI.config.object.T.r = 0
            local ret = easeDiscardHook(mod, instant, silent)
            return ret
        end
    end

end

local cardHoverHook = Card.hover
function Card:hover()
    AKYRS.current_hover_card = self
    local ret = cardHoverHook(self)
    return ret
end

local cardStopHoverHook = Card.stop_hover
function Card:stop_hover()
    local ret = cardStopHoverHook(self)
    return ret
end

local chalUnlock = set_challenge_unlock
function set_challenge_unlock()
    local ret = chalUnlock()

    if G.PROFILES[G.SETTINGS.profile].all_unlocked then return end

    if not G.PROFILES[G.SETTINGS.profile].akyrs_hc_challenges_unlocked then
        if G.PROFILES[G.SETTINGS.profile].challenges_unlocked then
            local challenges_unlocked, challenge_alls = 0, #G.CHALLENGES
            for k, v in ipairs(G.CHALLENGES) do
                if v.id and G.PROFILES[G.SETTINGS.profile].challenge_progress.completed[v.id or ''] then
                    challenges_unlocked = challenges_unlocked + 1
                end
            end
            if (challenges_unlocked >= 1) then
                G.PROFILES[G.SETTINGS.profile].akyrs_hc_challenges_unlocked = true
                notify_alert('b_akyrs_hardcore_challenges', "Back")
            end
        end
    end
    return ret
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

G.FUNCS.akyrs_wildcard_open_wildcard_ui = function(e)
    if e.config.ref_table.ability.aikoyori_letters_stickers == "#" then 
        --print("SUCCESS!")
        local card = e.config.ref_table
        G.FUNCS.overlay_menu{
            definition = AKYRS.UIDEF.wildcards_set_letter_ui(card)
        }
        --print(inspect(e.config.ref_table))
    else
        
    end
end


G.FUNCS.akyrs_wildcard_set_letter_wildcard = function(e)
    
    local card = AKYRS.wildcard_current
    card:flip()
    G.E_MANAGER:add_event(
        Event{
            trigger = "after",
            delay = AKYRS.get_speed_mult(card) * 0.5,
            func = function ()
                card.area:remove_from_highlighted(card, true)
                delay(AKYRS.get_speed_mult(card) * 0.5)
                card:flip()
                play_sound('card1')
                card:set_pretend_letters(AKYRS.wildcard_current_data.letter ~= "" and AKYRS.wildcard_current_data.letter or nil)
                AKYRS.wildcard_current = nil
                return true
            end
        }
    )
    G.FUNCS.exit_overlay_menu()
end

G.FUNCS.akyrs_wildcard_set_letter_wildcard_auto = function(e)
    
    local card = AKYRS.wildcard_current
    card:flip()
    G.E_MANAGER:add_event(
        Event{
            trigger = "after",
            delay = AKYRS.get_speed_mult(card) * 0.5,
            func = function ()
                card.area:remove_from_highlighted(card, true)
                delay(AKYRS.get_speed_mult(card) * 0.5)
                card:flip()
                play_sound('card1')
                card:set_pretend_letters("#")
                card:highlight(false)
                AKYRS.wildcard_current = nil
                return true
            end
        }
    )
    card.area:remove_from_highlighted(card, true)
    G.FUNCS.exit_overlay_menu()
end
    
G.FUNCS.akyrs_wildcard_unset_letter_wildcard = function(e)
    
    local card = AKYRS.wildcard_current
    card:flip()
    G.E_MANAGER:add_event(
        Event{
            trigger = "after",
            delay = AKYRS.get_speed_mult(card) * 0.5,
            func = function ()
                card.area:remove_from_highlighted(card, true)
                delay(AKYRS.get_speed_mult(card) * 0.5)
                card:flip()
                play_sound('card1')
                card:set_pretend_letters(nil)
                card:highlight(false)
                AKYRS.wildcard_current = nil
                return true
            end
        }
    )
    G.FUNCS.exit_overlay_menu()
end
G.FUNCS.akyrs_wildcard_switch_case_letter_wildcard = function(e)
    
    local card = AKYRS.wildcard_current
    card:flip()
    G.E_MANAGER:add_event(
        Event{
            trigger = "after",
            delay = AKYRS.get_speed_mult(card) * 0.5,
            func = function ()
                card.area:remove_from_highlighted(card, true)
                delay(AKYRS.get_speed_mult(card) * 0.5)
                card:flip()
                play_sound('card1')
                card:set_pretend_letters(AKYRS.swap_case(card.ability.aikoyori_pretend_letter))
                card:highlight(false)
                AKYRS.wildcard_current = nil
                return true
            end
        }
    )
    G.FUNCS.exit_overlay_menu()
end

G.FUNCS.akyrs_wildcard_quit_set_letter_wildcard_menu = function(e)
    G.FUNCS.exit_overlay_menu()
    AKYRS.wildcard_current = nil
end


function AKYRS.UIDEF.wildcards_set_letter_ui(card)
    AKYRS.wildcard_current_data = { letter = card.ability.aikoyori_pretend_letter or "" }
    AKYRS.wildcard_current = card
    return create_UIBox_generic_options({
        back_func = 'akyrs_wildcard_quit_set_letter_wildcard_menu',
        contents = {
                {
                    n = G.UIT.R,
                    config = { padding = 0.05,  w = 6, colour = G.C.CLEAR, align = 'cm' },
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = { padding = 0.05, w = 4.5, align = 'cm' },
                            nodes = {
                                AKYRS.create_better_text_input({
                                    w = 4.5,
                                    h = 1,
                                    max_length = 1, 
                                    extended_corpus = true, 
                                    prompt_text = localize("k_akyrs_type_in_letter"),
                                    ref_table = AKYRS.wildcard_current_data,
                                    current_prompt_text = AKYRS.wildcard_current_data.letter,
                                    ref_value = "letter",
                                    keyboard_offset = 4.5,
                                })
                            }
                        },
                        {
                            n = G.UIT.R,
                            config = { align = "cm", padding = 0.1 },
                            nodes = {
                                {
                                    n = G.UIT.C,
                                    config = { align = "cm" },
                                    nodes = {
                                        UIBox_button({
                                            colour = G.C.GREEN,
                                            button = "akyrs_wildcard_set_letter_wildcard",
                                            label = { localize("k_akyrs_letter_btn_set") },
                                            minw = 2.5,
                                            focus_args = { set_button_pip = true, button = 'leftshoulder', orientation = 'rm'},
                                        }),
                                    },
                                },
                                {
                                    n = G.UIT.C,
                                    config = { align = "cm" },
                                    nodes = {
                                        UIBox_button({
                                            colour = G.C.YELLOW,
                                            text_colour = G.C.UI.TEXT_DARK,
                                            button = "akyrs_wildcard_set_letter_wildcard_auto",
                                            label = { localize("k_akyrs_letter_btn_auto") },
                                            minw = 2.5,
                                            focus_args = { set_button_pip = true, button = 'rightshoulder', orientation = 'rm', snap_to = true },
                                        }),
                                    },
                                },
                                {
                                    n = G.UIT.C,
                                    config = { align = "cm" },
                                    nodes = {
                                        UIBox_button({
                                            colour = G.C.RED,
                                            text_colour = G.C.WHITE,
                                            button = "akyrs_wildcard_unset_letter_wildcard",
                                            label = { localize("k_akyrs_letter_btn_unset") },
                                            minw = 2.5,
                                            focus_args = {},
                                        }),
                                    },
                                },
                            },
                        },
                        {
                            n = G.UIT.R,
                            config = { padding = 0.05, w = 4.5, align = 'cl' },
                            nodes = {
                                {
                                    n = G.UIT.T,
                                    config = {
                                        colour = G.C.UI.TEXT_INACTIVE,
                                        scale = 0.3,
                                        text = localize("k_akyrs_textbox_notice")
                                    }
                                }
                            }
                        },
                        {
                            n = G.UIT.R,
                            config = { padding = 0.05, w = 4.5, align = 'cl' },
                            nodes = {
                                {
                                    n = G.UIT.T,
                                    config = {
                                        colour = G.C.UI.TEXT_INACTIVE,
                                        scale = 0.3,
                                        text = localize("k_akyrs_textbox_notice_2")
                                    }
                                }
                            }
                        },
                    }
                },
            }
        }
    )
end

function AKYRS.UIDEF.wildcards_ui(card)
    local colour = G.C.GREEN
    local text_colour = G.C.UI.TEXT_LIGHT
    local text = ""
    if card.ability.aikoyori_letters_stickers == "#" then
        if not card.ability.aikoyori_pretend_letter then
            text = localize("k_akyrs_letter_btn_unset")
            colour = AKYRS.config.wildcard_behaviour == 3 and SMODS.Gradients["akyrs_unset_letter"] or G.C.RED
        elseif card.ability.aikoyori_pretend_letter == "#" then
            text = localize("k_akyrs_letter_btn_auto")
            colour = G.C.YELLOW
            text_colour = G.C.UI.TEXT_DARK
        else
            text = localize("k_akyrs_letter_btn_set")
        end
    end
    if card.area and card.area == G.hand then
        return {
            n = G.UIT.ROOT,
            config = { padding = 0, colour = G.C.CLEAR },
            nodes = {
                {
                    n = G.UIT.C,
                    config = { padding = 0.15, align = 'cl' },
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = { align = 'cl' },
                            nodes = {
                                {

                                    n = G.UIT.C,
                                    config = { align = "cl" },
                                    nodes = {
                                        {
                                            n = G.UIT.C,
                                            config = { 
                                                    ref_table = card, 
                                                    align = "cl", 
                                                    maxw = 1.25, 
                                                    padding = 0.1, 
                                                    r = 0.08, 
                                                    minw = 1.9, 
                                                    minh = 1.5, 
                                                    hover = true, 
                                                    shadow = true, 
                                                    colour = colour, 
                                                    button = "akyrs_wildcard_open_wildcard_ui", 
                                                },
                                            nodes = {
                                                {
                                                    n = G.UIT.R,
                                                    nodes = {
                                                        { n = G.UIT.T, config = { text = localize("k_akyrs_letter_btn_currently"), colour = text_colour, scale = 0.4, shadow = true } },
                                                    }
                                                },
                                                {
                                                    n = G.UIT.R,
                                                    nodes = {
                                                        { n = G.UIT.T, config = { text = text, colour = text_colour, scale = 0.6, shadow = true, func = 'set_button_pip', 
                                                            focus_args = {
                                                            button = 'leftshoulder', 
                                                            orientation = 'bm',
                                                        }, } },
                                                    }
                                                },
                                            }
                                        }
                                    }
                                },
                                { n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
                                { n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
                                { n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
                            }
                        },
                    }
                },
            }
        }
    end
end

local cardhighlighthook = Card.highlight
function Card:highlight(is_higlighted)
    local ret = cardhighlighthook(self, is_higlighted)

    if self.base and (self.area and self.area == G.hand) and self.ability.aikoyori_letters_stickers == "#" then
        if self.highlighted and self.area and self.area.config.type ~= 'shop' then

            self.children.use_button = UIBox {
                definition = AKYRS.UIDEF.wildcards_ui(self),
                config = { align =
                    "cl",
                    offset = { x = 1, y = -0.75 },
                    parent = self }
            }
        elseif self.children.use_button then
            self.children.use_button:remove()
            self.children.use_button = nil
        end
    end
    return ret
end

local useCardHook = G.FUNCS.use_card
G.FUNCS.use_card = function (e,m,ns)
    local card = e.config.ref_table
    local area = card.area
    local prev_state = G.STATE
    local dont_dissolve = nil
    local delay_fac = 1
    if area == G.hand and card.ability.aikoyori_letters_stickers == "#" then
        G.FUNCS.akyrs_wildcard_open_wildcard_ui(e)
        return true
    end
    local r = useCardHook(e,m,ns)
    return r
    
end

local canPlayHook = G.FUNCS.can_play
G.FUNCS.can_play = function(e)
    local shouldDisableButton = false
    local runOGHook = true
    if AKYRS.config.wildcard_behaviour == 2 and G.GAME.akyrs_character_stickers_enabled then
        
        for i,k in ipairs(G.hand.highlighted) do
            if k.ability.aikoyori_letters_stickers == "#" and not k.ability.aikoyori_pretend_letter then
                shouldDisableButton = true
                break
            end
        end
    elseif G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_mathematics_enabled then
        
        local word_hand = {}
        local hand = {}
        for i,k in ipairs(G.hand.highlighted) do
            table.insert(hand,k)
        end
        table.sort(hand, AKYRS.hand_sort_function)
        for _, v in pairs(hand) do
            if not v.ability then return {} end
            local alpha = v.ability.aikoyori_letters_stickers:lower()
            if alpha == "#" and v.ability.aikoyori_pretend_letter then
                -- if wild is set fr tbh
                alpha = v.ability.aikoyori_pretend_letter:lower()
            elseif alpha == "#" and AKYRS.config.wildcard_behaviour == 3 then -- if it's unset in mode 3 then just make it a random letter i guess
                alpha = '★'
            end
            table.insert(word_hand, alpha)
                
        end
        
        local to_number = to_number or function(l) return l end
        local expression = table.concat(word_hand)
        local stat, val = pcall(AKYRS.MathParser.solve,AKYRS.MathParser,expression)
        local stat2, val = pcall(AKYRS.MathParser.solve,AKYRS.MathParser,""..to_number(G.GAME.chips)..expression)
        local assignment_parts = {}
        for part in expression:gmatch("[^=]+") do
            table.insert(assignment_parts, part)
        end
        local stat3 = false
        if #assignment_parts == 2 then
            local variable, value_expression = assignment_parts[1], assignment_parts[2]
            local status, value = pcall(AKYRS.MathParser.solve, AKYRS.MathParser, value_expression)
            if status then
                stat3 = true
            end
        end


        if not stat and not stat2 and not stat3 then
            shouldDisableButton = true
            runOGHook = false
        end
    end
    if shouldDisableButton then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
        runOGHook = false
    end
    if runOGHook then
        return canPlayHook(e)
    end
end

local UIESetH = UIElement.set_values
function UIElement:set_values(_T, recalculate)
    local c = UIESetH(self,_T,recalculate)
    self.states.release_on.can = true
    return c
end

function UIBox:akyrs_set_parent_child_with_pos(node, parent, pos)
    local UIE = UIElement(parent, self, node.n, node.config)

    --set the group of the element
    if parent and parent.config and parent.config.group then if UIE.config then UIE.config.group = parent.config.group else UIE.config = {group = parent.config.group} end end

    --set the button for the element
    if parent and parent.config and parent.config.button then if UIE.config then UIE.config.button_UIE = parent else UIE.config = {button_UIE = parent} end end
    if parent and parent.config and parent.config.button_UIE then if UIE.config then UIE.config.button_UIE = parent.config.button_UIE else UIE.config = {button = parent.config.button} end end

    if node.n and node.n == G.UIT.O and UIE.config.button then
        UIE.config.object.states.click.can = false
    end

    --current node is a container
    if (node.n and node.n == G.UIT.C or node.n == G.UIT.R or node.n == G.UIT.ROOT) and node.nodes then
        for k, v in pairs(node.nodes) do
            self:set_parent_child(v, UIE)
        end
    end

    if not parent then
        self.UIRoot = UIE 
        self.UIRoot.parent = self
    else
        table.insert(parent.children, pos, UIE)
    end
    if node.config and node.config.mid then 
        self.Mid = UIE
    end
end


local ogBlindBox = create_UIBox_HUD_blind
function create_UIBox_HUD_blind()
    local x = ogBlindBox()
    local blind_setup = G.P_BLINDS[G.GAME.round_resets.blind_choices[G.GAME.blind_on_deck]]
    local shit = AKYRS.add_blind_extra_info(blind_setup,nil,{text_size = 0.35,border_size = 0.3, difficulty_text_size = 0.3, cached_icons = true, row = true})

    local bldis = G.GAME.blind and G.GAME.blind.disabled or false

    --print(inspect(G.GAME.blind))

    
    local bl = G.P_BLINDS[G.GAME.round_resets.blind_choices[G.GAME.blind_on_deck]]
    local elem = x.nodes[2].nodes[2].nodes[2]
    if bl and bl.debuff.special_blind and elem and not bldis then
        local blindloc = getSpecialBossBlindText(G.GAME.round_resets.blind_choices[G.GAME.blind_on_deck] or "nololxd")
        local stake_sprite = get_stake_sprite(G.GAME.stake or 1, 0.5)
        elem.nodes[1].nodes[1].config.text = blindloc[1]
        elem.nodes[2].nodes = {
            { n = G.UIT.O, config = { w = 0.5, h = 0.5, colour = G.C.BLUE, object = stake_sprite, hover = true, can_collide = false } },
            { n = G.UIT.B, config = { h = 0.1, w = 0.1 } },
            { n = G.UIT.T, config = { text = blindloc[2], scale = 0.4, colour = G.C.RED, id = 'HUD_blind_count', shadow = true } }
        }
    end    

    table.insert(x.nodes[2].nodes,2,{
        n = G.UIT.R, config = { align = "cm", id = "akyrs_blind_attributes"}, nodes = shit
    })
    table.insert(x.nodes[2].nodes,2, { n = G.UIT.B, config = { h = 0.1, w = 0.1 } })

    return x
end

local blindSetTextHook = Blind.set_text
function Blind:set_text()
    local x = blindSetTextHook(self)
    G.HUD_blind:recalculate()
    return x
end

local ogBlindSel = create_UIBox_blind_choice
function create_UIBox_blind_choice(type, run_info)
    local x = ogBlindSel(type, run_info)
    local bl = G.P_BLINDS[G.GAME.round_resets.blind_choices[type]]
    local elem = AKYRS.search_UIT_for_id(x, "blind_desc")
    if bl and bl.debuff.special_blind and elem then
        local blindloc = getSpecialBossBlindText(G.GAME.round_resets.blind_choices[type] or "nololxd")
        local stake_sprite = get_stake_sprite(G.GAME.stake or 1, 0.5)
        elem.nodes[2].nodes[1].nodes[1].config.text = blindloc[1]
        elem.nodes[2].nodes[2].nodes = {
            
            { n = G.UIT.O, config = { w = 0.5, h = 0.5, colour = G.C.BLUE, object = stake_sprite, hover = true, can_collide = false } },
            { n = G.UIT.B, config = { h = 0.1, w = 0.1 } },
            { n = G.UIT.T, config = { text = blindloc[2], scale = 0.4, colour = G.C.RED, shadow = true } }
        }
    end
    return x
end
