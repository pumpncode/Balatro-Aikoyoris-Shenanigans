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
            (scrabble_scores[self.ability.aikoyori_letters_stickers]),
            1 + (scrabble_scores[self.ability.aikoyori_letters_stickers] / 10),
        }
    end
    if self.is_null then
        --print(table_to_string(ret))
        local newRetTable = table.aiko_shallow_copy(ret)

        newRetTable.name = {}
        localize({ type = 'name_text', key = 'aiko_x_akyrs_null', set = 'AikoyoriExtraBases', vars = { colours = { G.C.BLUE } }, nodes =
        newRetTable.name })
        newRetTable.name = newRetTable.name[1]
        newRetTable.main = {}
        newRetTable.info = {}
        newRetTable.type = {}

        for i, v in ipairs(ret.info) do
            if i > 0 then
                table.insert(newRetTable.info, v)
            end
        end


        if (G.GAME.letters_enabled and letter) then
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
        if (G.GAME.letters_enabled and letter) then
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
