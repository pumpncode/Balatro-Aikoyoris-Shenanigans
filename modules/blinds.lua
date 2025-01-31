assert(SMODS.load_file("./modules/atlasses.lua"))()
assert(SMODS.load_file("./modules/misc.lua"))()
assert(SMODS.load_file("./func/words/puzzle_words.lua"))()

SMODS.Blind{
    key = "the_thought",
    dollars = 5,
    mult = 2,
    boss_colour =HEX('95df3e'),
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 1, max = 10},
    pos = { x = 0, y = 0 },
    debuff = {
        special_blind = true
    },
    vars = {},
    set_blind = function(self)
        G.GAME.aiko_puzzle_win = false
        G.GAME.current_round.advanced_blind = true
        G.GAME.word_todo = aiko_pickRandomInTable(puzzle_words)
        
        G.hand:change_size(3)
        G.FUNCS.draw_from_deck_to_hand(3)
        
        self.discards_sub = G.GAME.current_round.discards_left --math.max(G.GAME.current_round.discards_left,0)
        ease_discard(-self.discards_sub)
        
        self.hands_sub = G.GAME.round_resets.hands-math.max(G.GAME.round_resets.hands,10)
        ease_hands_played(-self.hands_sub)
        
        --print ("Word is "..G.GAME.word_todo)
        G.E_MANAGER:add_event(
            Event({
                delay = 10,
                func = function()
                    ease_background_colour{new_colour = HEX('95df3e'), special_colour = HEX('ffd856'), tertiary_colour = G.C.BLACK, contrast = 3}
                    
                    return true
                end
            })
        )
        G.E_MANAGER:add_event(
            Event({
                delay = 10,
                func = function()
                    recalculateBlindUI()
                    return true
                end
            })
        )
    end,
    in_pool = function(self)
        return G.GAME.letters_enabled or false
    end,
    disable = function(self)
        G.GAME.current_round.advanced_blind = false
        G.hand:change_size(-3)
        
        ease_hands_played(self.hands_sub)
        ease_discard(self.discards_sub)
        
        recalculateBlindUI()
        
    end,
    defeat = function(self)
        G.hand:change_size(-3)
    end,
    press_play = function(self)
        if(G.GAME.aiko_current_word) then
            
            local word_table = {}
            for char in G.GAME.aiko_current_word:gmatch(".") do
                table.insert(word_table, char)
            end
            for i,k in ipairs(word_table) do
                local card = create_card('Alphabet',G.consumeables, nil, nil, nil, nil, "c_akyrs_"..k)
                card:set_edition({negative = true})
                card.ability.akyrs_self_destructs = true
                card.sell_cost = 0
                card:add_to_deck()
                G.consumeables:emplace(card)
                G.GAME.consumeable_buffer = 0
            end
            local todo_table = {}
            for char in G.GAME.word_todo:gmatch(".") do
                table.insert(todo_table, char)
            end

            local result_string = ""
            local result_string_arr = {}
            for i, char in ipairs(todo_table) do
                if word_table[i] and string.upper(word_table[i]) == string.upper(char) then
                    result_string = result_string .. "-"
                    table.insert(result_string_arr,"-")
                else
                    result_string = result_string .. char
                    table.insert(result_string_arr,char)
                end
            end

            local word_for_display = {

            }
            local letter_count = {

            }
            for _, char in ipairs(result_string_arr) do
                local lower_char = string.lower(char)
                letter_count[lower_char] = (letter_count[lower_char] or 0) + 1
            end

            for i, char in ipairs(word_table) do
                if todo_table[i] and string.upper(char) == string.upper(todo_table[i]) then
                    G.GAME.current_round.aiko_round_correct_letter[string.lower(char)] = true
                    table.insert(word_for_display,{string.lower(char), 1})
                elseif letter_count[string.lower(char)] and letter_count[string.lower(char)] > 0 and not G.GAME.current_round.aiko_round_correct_letter[string.lower(char)] then
                    G.GAME.current_round.aiko_round_misaligned_letter[string.lower(char)] = true
                    
                    table.insert(word_for_display,{string.lower(char), letter_count[string.lower(char)] > 0 and 2 or 3})
                    letter_count[string.lower(char)] = letter_count[string.lower(char)] - 1
                else
                    if not G.GAME.current_round.aiko_round_correct_letter[string.lower(char)] and not G.GAME.current_round.aiko_round_misaligned_letter[string.lower(char)] then
                        G.GAME.current_round.aiko_round_incorrect_letter[string.lower(char)] = true
                    end
                    table.insert(word_for_display,{string.lower(char), 3})
                end
            end
            

            table.insert(G.GAME.current_round.aiko_round_played_words,word_for_display)
            


            if string.upper(G.GAME.word_todo) == string.upper(G.GAME.aiko_current_word) then
                --print("WIN!")
                G.GAME.aiko_puzzle_win = true
            end
        end
    end

}