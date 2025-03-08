
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
        special_blind = true,
        infinite_discards = true,
    },
    vars = {},
    set_blind = function(self)
        G.GAME.aiko_puzzle_win = false
        G.GAME.current_round.advanced_blind = true
        G.GAME.word_todo = aiko_pickRandomInTable(puzzle_words)
        
        G.hand:change_size(3)
        G.FUNCS.draw_from_deck_to_hand(3)
        
        G.GAME.current_round.discards_sub = G.GAME.current_round.discards_left + 1
        self.discards_sub = G.GAME.current_round.discards_left + 1 -- math.max(G.GAME.current_round.discards_left, 0)
        ease_discard(-self.discards_sub)
        
        G.GAME.current_round.hand_sub = G.GAME.round_resets.hands-math.max(G.GAME.round_resets.hands,6)
        self.hands_sub = G.GAME.round_resets.hands-math.max(G.GAME.round_resets.hands,6)
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
                    recalculateHUDUI()
                    recalculateBlindUI()
                    return true
                end
            })
        )
    end,
    drawn_to_hand = function(self)
        G.FUNCS.draw_from_discard_to_deck()
        G.deck:shuffle('akyrthought')
    end,
    in_pool = function(self)
        return G.GAME.letters_enabled or false
    end,
    disable = function(self)
        G.GAME.current_round.advanced_blind = false
        G.hand:change_size(-3)
        
        ease_hands_played(self.hands_sub or G.GAME.current_round.hand_sub)
        ease_discard(self.discards_sub or G.GAME.current_round.discards_sub)
        
        recalculateHUDUI()
        recalculateBlindUI()
        
    end,
    defeat = function(self)
        G.GAME.current_round.advanced_blind = false
        G.hand:change_size(-3)
        
        recalculateHUDUI()
        recalculateBlindUI()
    end,
    press_play = function(self)
        if(G.GAME.aiko_current_word) then
            
            local word_table = {}
            for char in G.GAME.aiko_current_word:gmatch(".") do
                table.insert(word_table, char)
            end
            for k,v in ipairs(G.hand.cards) do
                if v.highlighted then
                    local _card = copy_card(v, nil, nil, G.playing_card)
                    _card.ability.akyrs_self_destructs = true
                    _card.ability.aikoyori_letters_stickers = v.ability.aikoyori_letters_stickers
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    table.insert(G.playing_cards, _card)
                    G.deck:emplace(_card)
                    _card:add_to_deck()
                end

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

local function talismanCheck(v,big,omega,jen)
    if Talisman then
        if Talisman.config_file.break_infinity == "omeganum" then
            if Jen then
                return jen
            end
            return omega
        end
        return big
    end
    return v
end

SMODS.Blind{
    key = "the_libre",
    dollars = 5,
    mult = 2,
    boss_colour = HEX('a74ce8'),
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 1, max = 10},
    pos = { x = 0, y = 5 },
    debuff = {
        disable_chip_x = talismanCheck(3,3333,333)
    },
    loc_vars = function(self)
        local to_big = not to_big and function(x) return x end or to_big
        local orig_chips = to_big(get_blind_amount(G.GAME.round_resets.ante)*self.mult*G.GAME.starting_params.ante_scaling)
        
        if Talisman then
            if Talisman.config_file.break_infinity == "omeganum" then
                local val = orig_chips:tetrate(self.debuff.disable_chip_x)
                if Jen and G.GAME.blind.chips then
                    val = val:tetrate(self.debuff.disable_chip_x)
                end
                
                return { vars = {}, key = self.key }
            else
                
                return { vars = {orig_chips^self.debuff.disable_chip_x}, key = self.key }
            end
        else
            return { vars = {orig_chips ^ self.debuff.disable_chip_x}, key = self.key }
        end
    end,
    collection_loc_vars = function(self)
        local s = talismanCheck("3","3333","^333","^333 and another ^^333")
        return { vars = {"^"..s.." of current"}, key = self.key }
    end,
    set_blind = function(self)
    end,
    drawn_to_hand = function(self)
        
    end,
    in_pool = function(self)
        return true
    end,
    disable = function(self)
        local to_big = not to_big and function(x) return x end or to_big
        if Talisman then
            if Talisman.config_file.break_infinity == "omeganum" then 
                local val = to_big(get_blind_amount(G.GAME.round_resets.ante)*self.mult*G.GAME.starting_params.ante_scaling):tetrate(to_big(self.debuff.disable_chip_x))
                if Jen and G.GAME.blind.chips then
                    val = val:tetrate(to_big(self.debuff.disable_chip_x))
                end
                G.GAME.blind.chips = val
            else
                G.GAME.blind.chips = to_big(get_blind_amount(G.GAME.round_resets.ante)*self.mult*G.GAME.starting_params.ante_scaling) ^ to_big(self.debuff.disable_chip_x)

            end
        else
            G.GAME.blind.chips = get_blind_amount(G.GAME.round_resets.ante)*self.mult*G.GAME.starting_params.ante_scaling ^ self.debuff.disable_chip_x
        end
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            
    end,
    defeat = function(self)
        
    end,
    press_play = function(self)
    end

}
AKYRS.picker_primed_action = function ()
    
    G.E_MANAGER:add_event(Event({
        trigger = "after",
        func = function ()
            G.GAME.blind.chips = G.GAME.blind.chips * G.GAME.blind.debuff.score_change
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            play_sound('timpani')
            return true
        end
    }))
end
AKYRS.picker_initial_action = function() 
    G.E_MANAGER:add_event(Event({
        trigger = "before",
        func = function ()
            G.hand:unhighlight_all()
            
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.2,
                func = function ()
                    local i=1
                    while i <= G.hand.config.highlighted_limit do
                        if i > #G.hand.cards then
                            break
                        end
                        local card = pseudorandom_element(G.hand.cards,pseudoseed("akyrpickerseed"))
                        if card and not card.highlighted then
                            card:highlight(true)
                            G.hand:add_to_highlighted(card)
                            i = i + 1
                        end
                    end
                    
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        func = function ()
                            G.GAME.blind.debuff.primed = true
                            return true
                        end
                    }))
                    return true
                end
            }))
            return true
        end
    },"base",true))
end
SMODS.Blind{
    key = "the_picker",
    dollars = 5,
    mult = 1.5,
    boss_colour = HEX('67e38b'),
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 1, max = 10},
    pos = { x = 0, y = 6 },
    debuff = {
        primed = false,
        acted = false,
        initial_action_acted = false,
        initial_action_act_set = false,
        hand_per_hand = 3,
        lock = false,
        score_change = 1.25
    },
    loc_vars = function(self)
        return { vars = {G.hand.config.highlighted_limit, self.debuff.score_change}, key = self.key }
    end,
    collection_loc_vars = function(self)
        return { vars = { "Up to selection limit amount of", 1.2 }, key = self.key }
    end,
    set_blind = function(self)
        G.GAME.blind.debuff.orig_chips = G.GAME.blind.chips
    end,
    drawn_to_hand = function(self)
    end,
    in_pool = function(self)
        return true
    end,
    disable = function(self)
        G.GAME.blind.chips = G.GAME.blind.debuff.orig_chips * 2
    end,
    defeat = function(self)
    end,
    press_play = function(self)
        G.GAME.blind.debuff.primed = false
        G.GAME.blind.debuff.acted = false
        G.E_MANAGER:add_event(Event{
            trigger = "after",
            func = function ()
                G.GAME.blind.debuff.initial_action_act_set = false
                return true
            end
        })
    end
}

SMODS.Blind {
    key = "the_height",
    dollars = 7,
    mult = 0.5,
    boss_colour = HEX('36adff'),
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 1, max = 10},
    pos = { x = 0, y = 7 },
    debuff = {
        requirement_scale = 2
    },
    loc_vars = function(self)
        return { vars = {self.debuff.requirement_scale}, key = self.key }
    end,
    collection_loc_vars = function(self)
        return { vars = { "2"}, key = self.key }
    end,
}
SMODS.Blind {
    key = "the_expiry",
    dollars = 5,
    mult = 2,
    boss_colour = HEX('ca60ff'),
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 1, max = 10},
    pos = { x = 0, y = 8 },
    set_blind = function (self)
        for i,k in ipairs(G.consumeables.cards) do
            k.ability.akyrs_perma_debuff = true
        end
    end
}

SMODS.Blind {
    key = "the_nature",
    dollars = 5,
    mult = 2,
    boss_colour = HEX('3d8a55'),
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 1, max = 10},
    debuff = {
        dec_mult = 0.5,
        akyrs_score_face_with_my_dec_mult = true
    },
    
    loc_vars = function (self)
        return {
            vars = { self.debuff.dec_mult }
        }
    end,
    collection_loc_vars = function (self)
        return {
            vars = { 0.5 }
        }
    end,
    pos = { x = 0, y = 9 },
    set_blind = function (self)
        for i,k in ipairs(G.consumeables.cards) do
            k.ability.akyrs_perma_debuff = true
        end
    end
}
SMODS.Blind {
    key = "final_periwinkle_pinecone",
    dollars = 8,
    mult = 2,
    boss_colour = HEX('7da8f0'),
    atlas = 'aikoyoriBlindsChips', 
    debuff = {
        akyrs_all_seals_perma_debuff = true
    },
    boss = {min = 1, max = 10, showdown = true},
    pos = { x = 0, y = 10 },
}
SMODS.Blind {
    key = "final_razzle_raindrop",
    dollars = 8,
    mult = 2,
    boss_colour = HEX('ff40ac'),
    debuff = {
        akyrs_suit_debuff_hand = true
    },
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 1, max = 10, showdown = true},
    pos = { x = 0, y = 11 },
}