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


        if ((G.GAME.letters_enabled or self.ability.forced_letter_render) and letter) then
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
        if ((G.GAME.letters_enabled or self.ability.forced_letter_render) and letter) then
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
    if e.config.ref_table.ability.aikoyori_letters_stickers == "#" then 
        e.config.colour = G.C.RED
        e.config.button = 'use_card'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.akyrs_wildcard_open_wildcard_ui = function(e)
    if e.config.ref_table.ability.aikoyori_letters_stickers == "#" then 
        print("SUCCESS!")
    else
        print("FAILURE!")
    end
end

function AKYRS.UIDEF.wildcards_ui(card)
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
                                            config = { ref_table = card, align = "cl", maxw = 1.25, padding = 0.1, r = 0.08, minw = 1.25, minh = 0, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = "akyrs_wildcard_open_wildcard_ui", func = 'akyrs_wildcard_check' },
                                            nodes = {
                                                { n = G.UIT.T, config = { text = "!", colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true } }
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
                    "cl"
                , offset =
                    { x = 1, y = 0 } ,
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