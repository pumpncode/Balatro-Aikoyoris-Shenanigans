assert(SMODS.load_file("./func/numbers.lua"))()
function aiko_get_X_same(num, hand)
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
local rankToNumber = { ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9, ["T"] = 10, ["J"] = 11, ["Q"] = 12, ["K"] = 13, ["A"] = 14 }


function aiko_get_flush(hand, flush_amount)
    local ret = {}
    local four_fingers = next(find_joker('Four Fingers'))
    local suits = {
        "Spades",
        "Hearts",
        "Clubs",
        "Diamonds"
    }
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


--    for k, v in pairs(suits) do
--        if v then
--            for ind = 1,#v do
--                local card_to_insert = { card = v[ind].card, sort_value = v[ind].sort_value+ 13, checked = false }
--                table.insert(v, card_to_insert)
--                
--            end
--            if #v > 0 then
--                while suits[k][#suits[k]].sort_value == 27 or (suits[k][#suits[k]].sort_value == 26 and can_skip) do
--                    table.remove(suits[k])
--                end
--            end
--        end
--    end
    
--    for k, v in pairs(suits) do
--        print(k)
--        if v then
--            for i = 1, #v do
--                print(v[i].sort_value)
--            end
--        end
--    end

function aiko_get_straight(hand, straight_amount)
    local ret = {}
    local suits = {}
    suits["Spades"] = {}
    suits["Hearts"] = {}
    suits["Clubs"] = {}
    suits["Diamonds"] = {}
    local four_fingers = next(find_joker('Four Fingers'))
    local can_skip = next(find_joker('Shortcut'))
    local hands = hand
    -- put them in suits
    for k, v in pairs(suits) do
        if hands then
            for i = 1, #hands do
                if hands[i]:is_suit(k, nil, true) then

                    local abc = {card = hands[i], sort_value = hands[i].base.id}
                    abc.card.aiko_is_counted_towards_straight = false
                    suits[k][#suits[k] + 1] = abc
                end
            end
        end
    end
    -- sort them
    
    for k, v in pairs(suits) do
        if v then
            if v[1] and v[1].sort_value == 14 then
                local card_to_insert = { card = v[1].card, sort_value = 1 }
                table.insert(v, card_to_insert)
            end
        end
    end

    for k, v in pairs(suits) do
        table.sort(v, function(a, b) return a.sort_value < b.sort_value end)
    end
    for k, v in pairs(suits) do
        local count = 1
        local last = v[1]
        local amnt = straight_amount - (four_fingers and 1 or 0)
        local current_streak = {}
        local current_streak_copy = {}
        local has_straight = false
        for i = 2, #v do
            if v[i].card.aiko_is_counted_towards_straight then
                goto aiko_straight_counted
            end
            if (v[i].sort_value == last.sort_value + 1 or (v[i].sort_value == last.sort_value + 2 and can_skip))then
                count = count + 1
                --print("FOUND CARD WITH VALUE " .. v[i].sort_value)
                table.insert(current_streak, v[i].card)
                if count >= (amnt) then
                    has_straight = true   
                end
            elseif v[i].sort_value ~= last.sort_value then
                current_streak_copy = current_streak
                count = 1
                current_streak = {}
            end
            if has_straight then
                for ix = 1, #current_streak_copy do
                    v[i].card.aiko_is_counted_towards_straight = true
                    table.insert(ret, current_streak_copy)   
                    --print("FOUND STRAIGHT")        
                end
            end
            
            ::aiko_straight_counted::
            last = v[i]
        end
    end
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
    newRank = pickableRank[math.fmod(rankToNumber[rank]-1, #pickableRank)+1]
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

for i = 6, 100 do
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
    return s .. " "
end

for j = 14, 5,-1 do
    for i = 1, 4 do
        straightFlushTable = {}
        local card = randomCard()
        for i = 1, i do
            card = setCardSuit(card, pickableSuit[i])
            for i = 1, j do
                table.insert(straightFlushTable, { card, true })
                card = randomConsecutiveRank(card, math.random(2) == 1, false)
            end
        end
        straightTable = {}
        local card = randomCard()
        for i = 1, i do
            local card = randomCard()
            for i = 1, j do
                table.insert(straightTable, { card, true })
                card = randomConsecutiveRank(card, math.random(2) == 1, true)
            end
        end
        if i == 1 and j == 5 then goto straights_continue end
        SMODS.PokerHand {
            key = SPC(getPleWord(i)) .. aiko_numberToWords(j) .. " Straight Flush",
            visible = false,
            example = straightFlushTable,
            loc_txt = {
                name = SPC(getPleWord(i)) .. aiko_numberToWords(j) .. " Straight Flush",
                description = { j .. ' cards in a row', 'all cards share the same suit', i > 1 and "For " .. i .. " Sets" or "" },
            },
            evaluate = function(parts, hand)
                if not next(aiko_get_straight(hand, j)) or #aiko_get_straight(hand, j) < i or not next(aiko_get_flush(hand, j)) then return {} end
                return { SMODS.merge_lists(aiko_get_straight(hand, i), aiko_get_flush(hand, i)) }
            end,
            chips = (60 * j*i + 20) * j * i,
            mult = (5 + j + i) * j * i,
            l_chips = 15 * j * i,
            l_mult = math.ceil(j + 1) * i,
        }
        SMODS.PokerHand {
            key = SPC(getPleWord(i)) .. aiko_numberToWords(j) .. " Straight",
            visible = false,
            example = straightTable,
            loc_txt = {
                name = SPC(getPleWord(i)) .. aiko_numberToWords(j) .. " Straight",
                description = { j .. ' cards in a row', i > 1 and "For " .. i .. " Sets" or "" },
            },
            evaluate = function(parts, hand)
                if not next(aiko_get_straight(hand, j)) or #aiko_get_straight(hand, j) < i then return {} end
                return { aiko_get_straight(hand, j) }
            end,
            chips = (6 * j) * i,
            mult = 2+(2*j)* math.ceil(i/1.4),
            l_chips = (8 + j) * i,
            l_mult = math.ceil(j / 1.75) * i,
        }
        ::straights_continue::
    end
end
