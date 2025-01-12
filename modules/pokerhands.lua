assert(SMODS.load_file("./func/numbers.lua"))()
assert(SMODS.load_file("./func/word_utils.lua"))()
assert(SMODS.load_file("./func/words/words.lua"))()
assert(SMODS.load_file("./modules/misc.lua"))()
function aiko_get_X_same(num, hand, how_many)
    local how_many = how_many or 1
    local vals = { {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {} }
    for i = #hand, 1, -1 do
        local curr = {}
        table.insert(curr, hand[i])
        for j = 1, #hand do
            if hand[i]:get_id() == hand[j]:get_id() and i ~= j then
                table.insert(curr, hand[j])
            end
        end
        if #curr == num then
            vals[curr[1]:get_id()] = curr
        end
    end
    local ret = {}
    for i = #vals, 1, -1 do
        if next(vals[i]) then table.insert(ret, vals[i]) end
    end
    return ret
end

for i = 6, 100 do
    SMODS.PokerHandPart {
        key = '_' .. i,
        func = function(hand) return aiko_get_X_same(i, hand) end
    }
end

local aiko_pickRandomInTable = function(t)
    return t[math.random(1, #t)]
end
local pickableSuit = { "S", "H", "C", "D" }
local pickableRank = { "2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A" }
local rankToNumber = { ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9, ["T"] = 10,
    ["J"] = 11, ["Q"] = 12, ["K"] = 13, ["A"] = 14 }


function aiko_get_flush(hand, flush_amount)
    local ret = {}
    local four_fingers = next(find_joker('Four Fingers'))
    local suits = card_suits
    if #hand < (math.max(flush_amount, 5) - (four_fingers and 1 or 0)) then
        return ret
    else
        for j = 1, #suits do
            local t = {}
            local suit = suits[j]
            local flush_count = 0
            for i = 1, #hand do
                if hand[i]:is_suit(suit, nil, true) then
                    flush_count = flush_count + 1; t[#t + 1] = hand[i]
                end
            end
            if flush_count >= (flush_amount - (four_fingers and 1 or 0)) then
                table.insert(ret, t)
                return ret
            end
        end
        return {}
    end
end

local function concat_table(t1, t2)
    for i = 1, #t2 do
        t1[#t1 + 1] = t2[i]
    end
    return t1
end

local function aiko_search_straight(cards, calculate_wildcard, consider_flush, straight_amount, has_skip)
    local ret = {}
    local count = 1
    for suitNo = 1, #card_suits do
        local suit = card_suits[suitNo]
        local cards_in_straight = {}
        
        local cards_to_check = {}
        -- insert first card so it is included 
        if cards[getFirstKeyOfTable(cards)] and cards[getFirstKeyOfTable(cards)][suit] then
            for j = 1, #cards[getFirstKeyOfTable(cards)][suit] do
                if not cards[getFirstKeyOfTable(cards)][suit][j].counted then
                    table.insert(cards_to_check, cards[getFirstKeyOfTable(cards)][suit][j])
                    --(cards[getFirstKeyOfTable(cards)][suit][j].sort_value.." of "..suit.." inserted")
                    break
                end
            end
        end
        for rank_f = 1, #card_ranks do
            local rank = rank_f
            -- print("LOOPING THRU "..rank)

            --print("LOOPING THRU "..suit)
            ::aiko_suit_loop_continue::
            local keep_going = false
            cards_to_check = {}
            local cards_in_rank = cards[rank]
            if cards[rank] then
                -- print("LOOPING THRU SUIT "..suit)

                if (calculate_wildcard) or not consider_flush then
                    for suit_wild, cards_in_suit_wild in pairs(cards_in_rank) do
                        if cards[rank + 1] and cards[rank + 1][suit_wild] then
                            for k = 1, #cards[rank + 1][suit_wild] do
                                if not cards[rank + 1][suit_wild][k].counted then
                                    if (calculate_wildcard and cards[rank + 1][suit_wild].is_wild) and (not consider_flush) then
                                        table.insert(cards_to_check, cards[rank + 1][suit_wild][k])
                                        keep_going = true
                                        goto aiko_exit_search_loop
                                    end
                                end
                            end
                        end
                        if has_skip then
                            if cards[rank + 2] and cards[rank + 2][suit_wild] then
                                for k = 1, #cards[rank + 2][suit_wild] do
                                    if not cards[rank + 2][suit_wild][k].counted then
                                        if (calculate_wildcard and cards[rank + 2][suit_wild][k].is_wild) and (not consider_flush) then
                                            table.insert(cards_to_check, cards[rank + 2][suit_wild][k])
                                            keep_going = true
                                            goto aiko_exit_search_loop
                                        end
                                    end
                                end
                            end
                        end
                    end
                else
                    if cards[rank + 1] and cards[rank + 1][suit] then
                        for j = 1, #cards[rank + 1][suit] do
                            if not cards[rank + 1][suit][j].counted then
                                table.insert(cards_to_check, cards[rank + 1][suit][j])
                                keep_going = true
                                goto aiko_exit_search_loop
                            end
                        end
                    end
                    if has_skip then
                        if cards[rank + 2] and cards[rank + 2][suit] then
                            for j = 1, #cards[rank + 2][suit] do
                                if not cards[rank + 2][suit][j].counted then
                                    table.insert(cards_to_check, cards[rank + 2][suit][j])
                                    keep_going = true
                                    goto aiko_exit_search_loop
                                end
                            end
                        end
                    end
                end
                
            end
            ::aiko_exit_search_loop::
            local strprint = ""

            for k = 1, #cards_to_check do
                strprint = strprint .. cards_to_check[k].sort_value .. " "
            end
            local has_available_card = false
            for j = 1, #cards_to_check do
                if not cards_to_check[j].counted then
                    count = count + 1
                    cards_to_check[j].counted = true
                    table.insert(cards_in_straight, cards_to_check[j])
                    has_available_card = true
                else
                end
                if not keep_going then
                    count = 1
                    for k = 1, #cards_in_straight do
                        cards_in_straight[k].counted = false
                    end
                    cards_in_straight = {}
                end
                if #cards_in_straight == straight_amount then
                    --print("FOUND STRAIGHT"..(consider_flush and " FLUSH" or ""))
                    local strprint2 = ""

                    for k = 1, #cards_in_straight do
                        strprint2 = strprint2 .. cards_in_straight[k].sort_value .. " "
                    end
                    --print(strprint2)
                    local add_to_return = {}
                    --rank = rank + 1 + (has_skip and 1 or 0)
                    for k = 1, #cards_in_straight do
                        table.insert(add_to_return, cards_in_straight[k].card)
                    end
                    table.insert(ret, add_to_return)
                    goto aiko_suit_loop_continue
                end
            end
        end
    end
    return ret
end
function aiko_get_straight(hand, straight_amount, consider_flush)
    local ret = {}
    local ranks = {}
    -- data structure
    -- rank = { 2 = { Spades = {card},Clubs = {card,card}}, 3 = { Hearts = {card},Diamonds = {card,card}}}
    local four_fingers = next(find_joker('Four Fingers'))
    local can_skip = next(find_joker('Shortcut'))
    if #ranks < 1 then
        return {}
    end
    for i = 1, #hand do
        local card = hand[i]
        local rank = card:get_id()
        local suit = card.base.suit
        if ranks[rank] == nil then
            ranks[rank] = {}
        end
        if ranks[rank][suit] == nil then
            ranks[rank][suit] = {}
        end

        ranks[rank][suit][#ranks[rank][suit] + 1] = { card = card, is_wild = card.ability.name == "Wild Card", sort_value =
        card:get_id(), counted = false }
    end
    -- sort
    for k, v in pairs(ranks) do
        for k2, v2 in pairs(v) do
            table.sort(v2, function(a, b) return a.sort_value < b.sort_value end)
        end
    end
    -- add ace to the starts
    if ranks[14] then
        
        local aces = {}
        for suit, suitStuff in pairs(ranks[14]) do
            local rankAceAtOne = {}
            for i = 1, #suitStuff do
                table.insert(rankAceAtOne, suitStuff[i])
            end
            aces[suit] = rankAceAtOne
        end
        ranks[1] = aces
    end
    --[[
    for k, v in pairs(ranks) do
        local stringForPrint = ""
        for k2, v2 in pairs(v) do
            for i = 1, #v2 do
                stringForPrint = stringForPrint .. v2[i].sort_value .. " "
            end
        end
        print("RANK "..k.." :"..stringForPrint)
    end
    ]]
    ret = concat_table(ret, aiko_search_straight(ranks, false, consider_flush, straight_amount - (four_fingers and 1 or 0), can_skip))
    ret = concat_table(ret, aiko_search_straight(ranks, true, consider_flush, straight_amount - (four_fingers and 1 or 0), can_skip))
    return ret
end

local function randomCard()
    local suit = aiko_pickRandomInTable(pickableSuit)
    local rank = aiko_pickRandomInTable(pickableRank)
    return suit .. "_" .. rank
end

local function randomSameRank(cardCode)
    local suit = string.sub(cardCode, 1, 1)
    local rank = string.sub(cardCode, 3, 3)
    local newSuit = aiko_pickRandomInTable(pickableSuit)
    while newSuit == suit do
        newSuit = aiko_pickRandomInTable(pickableSuit)
    end
    return newSuit .. "_" .. rank
end

local function randomSameSuit(cardCode)
    local suit = string.sub(cardCode, 1, 1)
    local rank = string.sub(cardCode, 3, 3)
    local newRank = aiko_pickRandomInTable(pickableRank)
    while newRank == rank do
        newRank = pickableRank[math.random(1, 13)]
    end
    return suit .. "_" .. newRank
end

local function randomConsecutiveRank(cardCode, up, randomSuit)
    local suit = string.sub(cardCode, 1, 1)
    local rank = string.sub(cardCode, 3, 3)
    local newRank = rank
    newRank = pickableRank[math.fmod(rankToNumber[rank] - 1, #pickableRank) + 1]
    if randomSuit then
        local newSuit = aiko_pickRandomInTable(pickableSuit)
        while newSuit == suit do
            newSuit = aiko_pickRandomInTable(pickableSuit)
        end
        return newSuit .. "_" .. newRank
    else
        return suit .. "_" .. newRank
    end
end

for i = 6, aikoyori_mod_config.x_of_a_kind_limit do
    flushCardTable = {}
    local acard = randomCard()
    for i = 1, i do
        table.insert(flushCardTable, { acard, true })
    end
    ofAkindTable = {}
    local acard = randomCard()
    for i = 1, i do
        table.insert(ofAkindTable, { randomSameRank(acard), true })
    end
    SMODS.PokerHand {
        key = aiko_numberToWords(i) .. " of a Kind",
        visible = false,
        example = ofAkindTable,
        loc_txt = {
            name = aiko_numberToWords(i) .. " of a Kind",
            description = { i .. ' cards with the same rank' },
        },
        evaluate = function(parts, hand)
            if not next(aiko_get_X_same(i, hand)) then return {} end
            return { aiko_get_X_same(i, hand) }
        end,
        chips = (30 * i),
        mult = 2 * i + 3,
        l_chips = 5 * (i + 3),
        l_mult = math.ceil(i / 1.77),
    }
    SMODS.PokerHand {
        key = "Flush " .. aiko_numberToWords(i),
        visible = false,
        example = flushCardTable,
        loc_txt = {
            name = 'Flush ' .. aiko_numberToWords(i),
            description = { i .. ' cards with the same rank and suit' },
        },
        evaluate = function(parts, hand)
            if not next(aiko_get_X_same(i, hand)) or not next(aiko_get_flush(hand, i)) then return {} end
            return { SMODS.merge_lists(aiko_get_X_same(i, hand), aiko_get_flush(hand, i)) }
        end,
        chips = (40 + 50 * i) * i,
        mult = (4 + i) * i,
        l_chips = 10 * i,
        l_mult = math.ceil(i / 2 + 1),
    }
end

local function setCardRank(cardCode, rank)
    local suit = string.sub(cardCode, 1, 1)
    return suit .. "_" .. rank
end

local function setCardSuit(cardCode, suit)
    local rank = string.sub(cardCode, 3, 3)
    return suit .. "_" .. rank
end

local function SPC(s)
    if not s or s == "" then

        return ""
    end
    return s .. " "
end

for j = #card_ranks, 5, -1 do
    for i = 1, #card_suits_with_meta do
        local straightFlushTable = {}
        local card = randomCard()
        for i = 1, i do
            card = setCardSuit(card, card_suits_with_meta[i].card_key)
            for i = 1, j do
                table.insert(straightFlushTable, { card, true })
                card = randomConsecutiveRank(card, math.random(2) == 1, false)
            end
        end
        local straightTable = {}
        local card = randomCard()
        for i = 1, i do
            local card = randomCard()
            for i = 1, j do
                table.insert(straightTable, { card, true })
                card = randomConsecutiveRank(card, math.random(2) == 1, true)
            end
        end
        if i == 1 and j == 5 then goto straights_continue end
        local strflName = SPC(getTupleWord(i)) .. aiko_numberToWords(j) .. " Straight Flush"
        if j == 13 and i == 4 then
            strflName = "The Deck:tm:"
        end
        SMODS.PokerHand {
            key = SPC(getTupleWord(i)) .. aiko_numberToWords(j) .. " Straight Flush",
            visible = false,
            example = straightFlushTable,
            loc_txt = {
                name = strflName,
                description = { j .. ' cards in a row', 'Cards share the same suit', i > 1 and "in " .. i .. " Sets" or "" },
            },
            evaluate = function(parts, hand)
                local straight_flushes = aiko_get_straight(hand, j - 1, true)
                if not next(straight_flushes) or #straight_flushes < i then return {} end
                return { SMODS.merge_lists(straight_flushes) }
            end,
            chips = (j - 4) * 100 ^ (i / 1.5) * 5,
            mult = (6 + 2 * j + 7 ^ (i/1.1)) * 5,
            l_chips = 25 * j * i * i * i * i * j,
            l_mult = math.ceil(j + 1) * i  * i * j,
        }
        SMODS.PokerHand {
            key = SPC(getTupleWord(i)) .. aiko_numberToWords(j) .. " Straight",
            visible = false,
            example = straightTable,
            loc_txt = {
                name = SPC(getTupleWord(i)) .. aiko_numberToWords(j) .. " Straight",
                description = { j .. ' cards in a row', i > 1 and "For " .. i .. " Sets" or "" },
            },
            evaluate = function(parts, hand)
                local straights = aiko_get_straight(hand, j - 1, false)
                if not next(straights) or #straights < i then return {} end
                return { SMODS.merge_lists(straights) }
            end,
            chips = (j - 4) * 70 ^ (i / 1.6),
            mult = (4 + j +  5 ^ (i/1.2)),
            l_chips = (8 + j) * i * i * i * j,
            l_mult = math.ceil(j / 1.75) * i * i * j,
        }
        ::straights_continue::
    end
end

-- i don't care enough

-- for suit_no = 2, #card_suits do
-- 
--     
--     for of_a_kind_factor = 2, aikoyori_mod_config.x_of_a_kind_limit / suit_no do
--         if of_a_kind_factor == 2 and suit_no == 2 then
--             break
--         end
--         local flushCardTable = {}
--         for x = 1, suit_no do
--             local acard = randomCard()
--             for i = 1, of_a_kind_factor do
--                 table.insert(flushCardTable, { setCardSuit(acard,card_suits_with_meta[x].card_key), true })
--             end
--         end
--         local partialflushCardTable = {}
--         for x = 1, suit_no do
--             
--             local acard = randomCard()
--             for i = 1, of_a_kind_factor do
--                 table.insert(partialflushCardTable, { setCardSuit(acard,card_suits_with_meta[x].card_key), true })
--             end
--         end
--         local ofAkindTable = {}
--         local acard = randomCard()
--         
--         for x = 1, suit_no do
--             local acard = randomCard()
--             for i = 1, of_a_kind_factor do
--                 table.insert(ofAkindTable, { randomSameRank(acard), true })
--             end
--         end
--         SMODS.PokerHand {
--             key = SPC(getTupleWord(suit_no))..aiko_numberToWords(of_a_kind_factor) .. " of a Kind",
--             visible = false,
--             example = ofAkindTable,
--             loc_txt = {
--                 name = SPC(getTupleWord(suit_no))..aiko_numberToWords(of_a_kind_factor) .. " of a Kind",
--                 description = { of_a_kind_factor .. ' cards with the same rank',  "For " .. suit_no .. " Sets" },
--             },
--             evaluate = function(parts, hand)
--                 if not next(aiko_get_X_same(of_a_kind_factor, hand)) or not #aiko_get_X_same(of_a_kind_factor, hand) <= suit_no * of_a_kind_factor  then return {} end
--                 return { aiko_get_X_same(of_a_kind_factor, hand) }
--             end,
--             chips = (30 * of_a_kind_factor)  * suit_no,
--             mult = 2 * of_a_kind_factor + 3 * suit_no,
--             l_chips = 5 * (of_a_kind_factor + 3) * suit_no,
--             l_mult = math.ceil(of_a_kind_factor / 1.77) * suit_no ,
--         }
--         SMODS.PokerHand {
--             key = SPC(getTupleWord(suit_no)).." Full Flush " .. aiko_numberToWords(of_a_kind_factor),
--             visible = false,
--             example = flushCardTable,
--             loc_txt = {
--                 name = SPC(getTupleWord(suit_no))..'Flush ' .. aiko_numberToWords(of_a_kind_factor),
--                 description = { of_a_kind_factor .. ' cards with all of them having the same rank',  "For " .. suit_no .. " Sets and all of them are in the same suit"  },
--             },
--             evaluate = function(parts, hand)
--                 if not next(aiko_get_X_same(of_a_kind_factor, hand)) or not next(aiko_get_flush(hand, of_a_kind_factor)) or #aiko_get_X_same(of_a_kind_factor, hand) <= suit_no * of_a_kind_factor  then return {} end
--                 return { SMODS.merge_lists(aiko_get_X_same(of_a_kind_factor, hand), aiko_get_flush(hand, of_a_kind_factor)) }
--             end,
--             chips = (40 + 50 * of_a_kind_factor) * of_a_kind_factor * suit_no ^ 1.2,
--             mult = (4 + of_a_kind_factor) * of_a_kind_factor * suit_no ^ 1.2,
--             l_chips = 10 * of_a_kind_factor * suit_no,
--             l_mult = math.ceil(of_a_kind_factor / 2 + 1) * suit_no,
--         }
--         SMODS.PokerHand {
--             key = SPC(getTupleWord(suit_no)).." Partial Flush " .. aiko_numberToWords(of_a_kind_factor),
--             visible = false,
--             example = partialflushCardTable,
--             loc_txt = {
--                 name = SPC(getTupleWord(suit_no))..'Flush ' .. aiko_numberToWords(of_a_kind_factor),
--                 description = { of_a_kind_factor .. ' cards with the same rank and suit',  "For " .. suit_no .. " Sets"  },
--             },
--             evaluate = function(parts, hand)
--                 if not next(aiko_get_X_same(of_a_kind_factor, hand)) or not next(aiko_get_flush(hand, of_a_kind_factor)) or  #aiko_get_X_same(of_a_kind_factor, hand) <= suit_no * of_a_kind_factor  then return {} end
--                 return { SMODS.merge_lists(aiko_get_X_same(of_a_kind_factor, hand), aiko_get_flush(hand, of_a_kind_factor)) }
--             end,
--             chips = (40 + 50 * of_a_kind_factor) * of_a_kind_factor * suit_no ^ 1.1,
--             mult = (4 + of_a_kind_factor) * of_a_kind_factor * suit_no ^ 1.1,
--             l_chips = 10 * of_a_kind_factor * suit_no,
--             l_mult = math.ceil(of_a_kind_factor / 2 + 1) * suit_no,
--         }
--     end
-- end
local example_words = {
    "cry",
    "card",
    "jimbo",
    "thrash",
    "sticker",
    "foreword",
    "mainframe",
    "mainlander",
    "hyperactive",
    "skeletonised",
    "neanderthaler",
    "televisionally",
    "demographically",
    "tropostereoscope",
    "erythroneocytosis",
    "heteroscedasticity",
    "unmisunderstandable",
    "adrenocorticosteroid",
    "poluphloisboiotatotic",
    "polioencephalomyelitis",
    "overintellectualization",
    "formaldehydesulphoxylate",
    "demethylchlortetracycline",
    "##########################",
    "electroencephalographically",
    "antidisestablishmentarianism",
    "cyclotrimethylenetrinitramine",
    "##############################",
    "dichlorodiphenyltrichloroethane",
}
local function replace_char(pos, str, r)
    return str:sub(1, pos-1) .. r .. str:sub(pos+1)
end
for i = 3, 31 do
    local exampler = {}
    for j = 1, #example_words[i-2] do
        local c = example_words[i-2]:sub(j,j)
        table.insert(exampler,{
            randomCard(),
            true,
            c
        })
    end
        

    SMODS.PokerHand {
        key = i.."-letter Word",
        visible = i <= 5,
        example = exampler,
        loc_txt = {
            name =  i.."-letter Word",
            description = { 'Create a valid '..i..'-letter English word', 'with Exact Amount of Character' },
        },
        evaluate = function(parts, hand)
            local word_hand = {}
            table.sort(hand, function(a,b) return a.T.x < b.T.x end)
            for _, v in pairs(hand) do
                
                table.insert(word_hand, v.ability.aikoyori_letters_stickers)
                    
            end
            if #word_hand ~= i then
                return {}
            end
            if check_word(word_hand, i) then
                return {hand}
            else 
                return {}
            end
        end,
        chips = 8 * i + (i-1.22) ^ (1 + i * 0.17),
        mult = ((i - 2) ^ 1.07) + 0.75 * i,
        l_chips = 5*i,
        l_mult = 2*i,
    }
end