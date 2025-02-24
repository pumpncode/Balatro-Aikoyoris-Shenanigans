aikoyori_mod_config = SMODS.current_mod.config

aikoyori_mod_config.x_of_a_kind_limit = 100

G.C.PLAYABLE = HEX("ee36ff")

function table_contains(tbl, x)
    found = false
    for _, v in pairs(tbl) do
        if v == x then
            found = true
        end
    end
    return found
end


aiko_pickRandomInTable = function(t)
    return t[math.random(1, #t)]
end

aiko_alphabets = {}
aiko_alphabets_no_wilds = {}
aiko_alphabets_to_num = {}
for i = 97, 122 do
    table.insert(aiko_alphabets, string.char(i))
    table.insert(aiko_alphabets_no_wilds, string.char(i))
    aiko_alphabets_to_num[string.char(i)] = i - 96
end
table.insert(aiko_alphabets,"#")
aiko_alphabets_to_num["#"] = 27

function alphabet_delta(alpha, delta) 
    local numero = aiko_alphabets_to_num[alpha] + delta
    while numero < 1 do
        numero = numero + #aiko_alphabets
    end
    if numero > #aiko_alphabets then
        numero = math.fmod(numero, #aiko_alphabets)
    end
    --print(aiko_alphabets[numero])
    return aiko_alphabets[numero]
end

card_suits = {}
card_suits_with_meta = {}
card_ranks = {}
card_rank_numbers = {}
card_ranks_with_meta = {}
for k, v in pairs(SMODS.Ranks) do
    table.insert(card_ranks_with_meta,v)
end

table.sort(card_ranks_with_meta, function(s1,s2)
    --print("COMPARING "..s1.key.." and "..s2.key)
    return s1.sort_nominal < s2.sort_nominal
end)

for i, v in pairs(card_ranks_with_meta) do
    table.insert(card_ranks,v.key)
    card_rank_numbers[v.key] = i
    --print(v.key,i)
end


for k, v in pairs(SMODS.Suits) do
    table.insert(card_suits, k)
    table.insert(card_suits_with_meta, v)
end

function getNextIDs(id)
    nexts = {}
    if(card_ranks_with_meta[id]) then
            --print(table_to_string(card_ranks_with_meta[id]))
        for i, v in ipairs(card_ranks_with_meta[id].next) do
            table.insert(nexts,card_rank_numbers[v]) 
        end
    end
    --print(table_to_string(nexts))
    return nexts
end


function aiko_intersect_table(a,b)
    local ai = {}
    for _,v in ipairs(a) do
        ai[v] = true
    end
    local ret = {}
    for _,v in ipairs(b) do
        if ai[v] then
            ret[#ret + 1] = v
        end
    end
    return ret
end


function concat_table(t1, t2)
    for i = 1, #t2 do
        t1[#t1 + 1] = t2[i]
    end
    return t1
end

function getFirstElementOfTable(t)
    for k, v in pairs(t) do
        return v
    end
end

function getFirstKeyOfTable(t)
    for k, v in pairs(t) do
        return k
    end
end


function table_to_string(tables)
    if type(tables) == "nil" then
        return "nil"
    end
    local strRet = ""
    for k,v in pairs(tables) do
        local stra = v
        if type(stra) == "table" then
            strRet = strRet..k.." :( "..table_to_string(stra).." ), "
        else
            strRet = strRet..k.." : "..tostring(stra)..", "
        end
    end
    return strRet
end
function table_to_string_depth(tables, depth)
    if depth == 0 then
        local keys = ""
        for k, _ in pairs(tables) do
            keys= keys..k..":k , "
        end
        return "["..#tables.."]"
    end
    if type(tables) == "nil" then
        return "nil"
    end
    local strRet = ""
    for k,v in pairs(tables) do
        local stra = v
        if type(stra) == "table" then
            strRet = strRet..k.." :( "..table_to_string_depth(stra, depth - 1).." ), "
        else
            strRet = strRet..k.." : "..tostring(stra)..", "
        end
    end
    return strRet
end

function getSpecialBossBlindText(key)
    if (key == "bl_akyrs_the_thought") then
        return {localize("ph_aiko_beat_puzzle"),localize("ph_word_puzzle")}
    else
        return {localize("ph_akyrs_unknown"),localize("ph_akyrs_unknown")}
    end
end
function getGameOverBlindText()
    if G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind and G.GAME.blind.config.blind.key then
        if (G.GAME.blind.config.blind.key == "bl_akyrs_the_thought") then
            return string.upper(G.GAME.word_todo)
        else
            return "?????"
        end
    else
        return "?????"
    end
end

function isBlindKeyAThing()
    return G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind and G.GAME.blind.config.blind.key or nil
end


function aikoyori_debuff_score_card(card, context)
    local reps = { 1 }
    local j = 1
    while j <= #reps do
        if reps[j] ~= 1 then
            local _, eff = next(reps[j])
            SMODS.calculate_effect(eff, eff.card)
            percent = percent + percent_delta
        end

        context.main_scoring = true
        a = {}
        local jokers = card:calculate_joker(context)
        if jokers then 
            rjokers = jokers
        end
    
        local effects = { { jokers = rjokers} }
        SMODS.calculate_quantum_enhancements(card, effects, context)
        context.main_scoring = nil
        context.individual = true
        context.other_card = card

        if next(effects) then
            for _, area in ipairs(SMODS.get_card_areas('jokers')) do
                for _, _card in ipairs(area.cards) do
                    if not _card.ability.should_trigger_individual_debuff or _card.debuff then return end
                    --calculate the joker individual card effects
                    local eval, post = eval_card(_card, context)
                    if next(eval) then
                        if eval.jokers then eval.jokers.juice_card = eval.jokers.juice_card or eval.jokers.card or _card end
                        table.insert(effects, eval)
                        for _, v in ipairs(post) do effects[#effects+1] = v end
                        if eval.retriggers then
                            context.retrigger_joker = true
                            for rt = 1, #eval.retriggers do
                                local rt_eval, rt_post = eval_card(_card, context)
                                table.insert(effects, { eval.retriggers[rt] })
                                table.insert(effects, rt_eval)
                                for _, v in ipairs(rt_post) do effects[#effects+1] = v end
                            end
                            context.retrigger_joker = nil
                        end
                    end
                end
            end
        end

        SMODS.trigger_effects(effects, card)
        local deck_effect = G.GAME.selected_back:trigger_effect(context)
        if deck_effect then SMODS.calculate_effect(deck_effect, G.deck.cards[1] or G.deck) end

        context.individual = nil
        if reps[j] == 1 and effects.calculated then
            context.repetition = true
            context.card_effects = effects
            SMODS.calculate_repetitions(card, context, reps)
            context.repetition = nil
            context.card_effects = nil
        end
        j = j + (effects.calculated and 1 or #reps)
        context.other_card = nil
        card.lucky_trigger = nil
    end
    card.extra_enhancements = nil
end