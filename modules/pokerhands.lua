assert(SMODS.load_file("./func/numbers.lua"))()
assert(SMODS.load_file("./modules/misc.lua"))()
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


local function aiko_recurse_straight(current_rank, current_suit, cards, calculate_wildcard, consider_flush, straight_amount, has_skip, current_streak)
    -- if current streak length equals straight amount then return the thing with a true
    -- then check if cards has cards in current rank
    -- if not then return blank 
    -- but if so then set the card as counted
    -- if has cards then check if next rank has any card then check if card is not counted then add to the streak
    -- do it again for has skip but instead of next card do next 2 cards
    -- recursively do it
    -- unintuitively the card that has number 2 on it has index 1 here because ace is the last one and it is moved to 13
    if #current_streak.streaks == straight_amount then
        return {streaks = current_streak.streaks, found = true}
    end
    if #current_streak.streaks < straight_amount and #current_streak.streaks > 1 and card_ranks_with_meta[current_rank].straight_edge then
        --print("failure to go past Ace")
        return {streaks = {}, found = false}
    end
    if #current_streak.streaks > 4 then
        
        print(table_to_string(current_streak), current_rank, current_suit)
    end
    --print(table_to_string(current_streak))
    local suits_to_check = {current_suit}
    if (calculate_wildcard or not consider_flush) and card_suits then
        for i, v in ipairs(card_suits) do
            if not table_contains(suits_to_check,v) then
                table.insert(suits_to_check,v)
            end
        end
    end
    --print("SUITS "..table_to_string(suits_to_check))
    for ind,le_suit in pairs(suits_to_check) do
        local le_suit = suits_to_check[ind]
        local should_skip = true
        local found_next = false
        local nexts = getNextIDs(current_rank)
        --print(le_suit)
        
        for _, next in pairs(nexts) do
            --print(next, " do we have next card  ? "..(cards[next] and "yes" or "no").. " streak "..#current_streak.streaks .." suit "..le_suit)
            --print("====== ")
            --print(table_to_string_depth(cards[next],3))
            --print("SUIT "..le_suit)
            --print("====== ")
            --print("CARD NEXT IN SUIT "..cards[next][le_suit])
            if cards[next] then
                if cards[next][le_suit] then
                    --print(next, " do we have next card with suit  ? "..(cards[next][le_suit] and "yes" or "no").. " streak "..#current_streak.streaks)
                    for _, card in pairs(cards[next][le_suit]) do
                        if (card.is_wild or not consider_flush) and not card.counted then
                            should_skip = false
                            found_next = true
                            card.counted = true
                            table.insert(current_streak.streaks,card)
                            --print(table_to_string(card))
                            local straighters = aiko_recurse_straight(next, current_suit, cards, calculate_wildcard, consider_flush, straight_amount, has_skip, current_streak)
                            return straighters
                        end
                    end
                end

                
            end
            
            if has_skip and should_skip then
                local nexts2 = getNextIDs(next)
                
                for i3, next2 in pairs(nexts2) do
                    
                    if cards[next2] and cards[next2][le_suit] then
                        for _, card in pairs(cards[next][le_suit]) do
                            if (cards[next2][le_suit].is_wild or not consider_flush) and not card.counted then
                                found_next = true
                                card.counted = true
                                table.insert(current_streak.streaks,card)
                                local straighters = aiko_recurse_straight(next2, current_suit, cards, calculate_wildcard, consider_flush, straight_amount, has_skip, current_streak)
                                return straighters
                            end
                        end
                    end

                end

            end
        end
        if not found_next then
            return {streaks = {}, found = false}
        end
    end
end



local function aiko_search_straight(cards, calculate_wildcard, consider_flush, straight_amount, has_skip)
    local ret = {}
    local skip = (has_skip and 1 or 0)
    for suitNo = 1, #card_suits do
        local Suit = card_suits[suitNo]
        local streaks = {}
        local keep_going = false
        -- insert first card so it is included 
        for RankIndex, rankMetadata in pairs(card_ranks_with_meta) do
            local Rank = rankMetadata.key
            if cards[Rank] and cards[Rank][Suit] then
                local card = nil
                for cards_t in cards[Rank][Suit] do
                    if not cards_t.counted then
                        card = cards_t
                    end
                end
                if #streaks == 0 and card then
                    table.insert(streaks,card)
                end
            end
            local straight = aiko_recurse_straight(RankIndex, Suit, cards, calculate_wildcard, consider_flush, straight_amount, has_skip, {streaks = {},found = false})
            
            if straight and straight.found then
                local le_tabloid = {}
                for _,la_fucking_idk_anymore_dude in pairs(straight.streaks) do
                    table.insert(le_tabloid,la_fucking_idk_anymore_dude.card)
                end
                table.insert(ret,le_tabloid)
            end
        end
    end
    return ret
end
table_to_string({sus={scrofa={"domesticus"},sussy=true}})
function aiko_get_straight(hand, straight_amount, consider_flush)
    local ret = {}
    local ranks = {}
    -- data structure
    -- rank = { 2 = { Spades = {card},Clubs = {card,card}}, 3 = { Hearts = {card},Diamonds = {card,card}}}
    local four_fingers = next(find_joker('Four Fingers'))
    local can_skip = next(find_joker('Shortcut'))
    for i, v in ipairs(hand) do
        local card = v
        local rank = card_rank_numbers[card.base.value]
        local suit = card.base.suit
        if not ranks[rank] then
            ranks[rank] = {}
        end
        if not ranks[rank][suit] then
            ranks[rank][suit] = {}
        end

        ranks[rank][suit][#ranks[rank][suit] + 1] = { card = card, is_wild = card.ability.name == "Wild Card", sort_value =
        card:get_id(), counted = false }
    end
    for rank, cards_in_rank in pairs(ranks) do
        -- print("RANK "..rank)
        for suit, cards_in_suit in pairs(cards_in_rank) do
            -- print("SUIT "..suit)
            local strprint = rank.." of "..suit..": "
            for i = 1, #cards_in_suit do
                -- print(cards_in_suit[i].sort_value)
                strprint = strprint .. cards_in_suit[i].sort_value .. " "
            end
            --print(strprint)
        end
    end
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
        visible = true,
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
        visible = true,
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

for j = 13, 5, -1 do
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
        local strflName = SPC(getTupleWord(i)) .. aiko_numberToWords(j) .. " Straight Flush"
        if j == 13 and i == 4 then
            strflName = "The Deck:tm:"
        end
        SMODS.PokerHand {
            key = SPC(getTupleWord(i)) .. aiko_numberToWords(j) .. " Straight Flush",
            visible = true,
            example = straightFlushTable,
            loc_txt = {
                name = strflName,
                description = { j .. ' cards in a row', 'Cards share the same suit', i > 1 and "in " .. i .. " Sets" or "" },
            },
            evaluate = function(parts, hand)
                local straight_flushes = aiko_get_straight(hand, j, true)
                if not next(straight_flushes) or #straight_flushes < i then return {} end
                return { SMODS.merge_lists(straight_flushes) }
            end,
            chips = (j - 4) * 100 ^ (i / 1.5),
            mult = (6 + 2 * j + 7 ^ (i/1.1)),
            l_chips = 25 * j * i * i * i * i * j,
            l_mult = math.ceil(j + 1) * i  * i * j,
        }
        SMODS.PokerHand {
            key = SPC(getTupleWord(i)) .. aiko_numberToWords(j) .. " Straight",
            visible = true,
            example = straightTable,
            loc_txt = {
                name = SPC(getTupleWord(i)) .. aiko_numberToWords(j) .. " Straight",
                description = { j .. ' cards in a row', i > 1 and "For " .. i .. " Sets" or "" },
            },
            evaluate = function(parts, hand)
                local straights = aiko_get_straight(hand, j, false)
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
