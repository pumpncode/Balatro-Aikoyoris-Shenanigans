
SMODS.ConsumableType{
    atlas = "consumablesAlphabetPacks",
    key = "Alphabet",
    primary_colour = HEX("747482"),
    secondary_colour = HEX("3e63c2"),
    collection_rows = {6,6,6},
    shop_rate = 0,
    loc_txt = {
        collection = "Alphabet Cards",
        name = "Alphabet",

        undiscovered = { -- description for undiscovered cards in the collection
            name = 'Unknown Alphabet',
            text = { 'Find this card when', 'letters are enabled' },
        },
    },
}

local word_letter = {
    "Apple", "Bee", "Cat", "Dog", "Earth", "Fire", "Ghost", "Hat", "Ice", "Jar", 
    "Kite", "Lemon", "Mushroom", "Night", "Onion", "Pie", "Quill", "Rat", "Spoon", "Tea", 
    "Umbrella", "Vase", "Water", "Xylophone", "Yarn", "Zoom"
}


for k, v in ipairs(aiko_alphabets_no_wilds) do
    local upper = string.upper(v)
    
    SMODS.Consumable{
        key = v,
        set = "Alphabet",
        atlas = 'consumablesAlphabetPacks',
        pos = { x = math.fmod(k-1,20), y = math.floor((k-1)/20) } ,
        loc_txt = {
            name = upper.." for "..word_letter[k],
            text = { "Convert all selected cards'","letter to {C:red}#1#{}","{C:inactive,s:0.75}(up to #2# cards){}" },
        },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue+1] = {key = 'letters'..string.upper(card.ability.extra.letter), set = 'AikoyoriExtraBases' ,vars = {
      
                (AKYRS.get_scrabble_score(card.ability.extra.letter)),
                1 + (AKYRS.get_scrabble_score(card.ability.extra.letter)/10),
            }}
            return {
                vars = {
                    string.upper(card.ability.extra.letter),
                    card.ability.extra.max_selected,
                },
            }
        end,
        
        config = {extra = {letter = v, max_selected = 999999}},
        
        can_use = function(self, card)
            return #G.hand.highlighted <= card.ability.extra.max_selected and #G.hand.highlighted > 0
        end,
        use = function(self, card, area, copier)
            for i=1, #G.hand.highlighted do
                local percent = math.abs(1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3)
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
            
            delay(0.5)
            
            for i=1, #G.hand.highlighted do
                local percent = math.abs(0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3)
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function()
                    G.hand.highlighted[i].ability.aikoyori_letters_stickers = card.ability.extra.letter G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end
        end,
        in_pool = function(self, args)
            return G.GAME.letters_enabled
        end,
    }

end
-- Letters
SMODS.Consumable{
    key = "Wild",
    set = "Alphabet",
    atlas = 'consumablesAlphabetPacks',
    pos = { x = 6, y = 1 } ,
    cost = 6,
    loc_txt = {
        name = "? for ????",
        text = { "Convert up to #2# selected card's","letter to {C:red}Wild (#1#){}" },
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'lettersWild', set = 'AikoyoriExtraBases'}
        return {
            vars = {
                string.upper(card.ability.extra.letter),
                card.ability.extra.max_selected,
            },
        }
    end,
    config = {extra = {letter = "#", max_selected = 1}},
    
    can_use = function(self, card)
        return #G.hand.highlighted <= card.ability.extra.max_selected and #G.hand.highlighted > 0
    end,
    use = function(self, card, area, copier)
        for i=1, #G.hand.highlighted do
            local percent = math.abs(1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3)
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
        end
        
        delay(0.5)
        
        for i=1, #G.hand.highlighted do
            local percent = math.abs(0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3)
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function()
                G.hand.highlighted[i].ability.aikoyori_letters_stickers = card.ability.extra.letter
                G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
        end
    end,
    in_pool = function(self, args)
        return G.GAME.letters_enabled
    end,
}

local constellations = {
    "ara", "crux", "indus", "puppis", "lacerta", "eridanus", "reticulum","horologium","telescopium","microscopium"
}

function AKYRS.get_hand_in_game(_c)
    return (G.GAME and 
    G.GAME.hands and 
    _c.ability and 
    _c.ability.hand_type and 
    G.GAME.hands[_c.ability.hand_type]) 
    and G.GAME.hands[_c.ability.hand_type] or nil
end

local to_number = to_number or function(x) return x end

for i, k in ipairs(constellations) do
    local raw_hand =  (i+2).."-letter Word"
    local hand =  AKYRS.prefix.."_"..raw_hand
    if k == "microscopium" then
        break
    end
    
    SMODS.Planet{
        atlas = "aikoConstellationCards",
        pos = { x = i-1 , y=0},
        key = "p_"..k,
        config = {
            hand_type = hand,
            softlock = true
        },
        set_card_type_badge = function(self, card, badges)
            badges[1] = create_badge(localize('k_akyrs_constellation'), get_type_colour(self or card.config, card), nil, 1.2)
        end,
        loc_vars = function (self,iq,_c)
            local level = AKYRS.get_hand_in_game(_c) and AKYRS.get_hand_in_game(_c).level or 1
            local handlevelcol = G.C.HAND_LEVELS[math.min(7, level)]
            if Talisman then
                handlevelcol = G.C.HAND_LEVELS[math.min(7, to_number(level))]
            end
            return {
                vars = {
                    level,
                    localize(hand, 'poker_hands') or "???", 
                    SMODS.PokerHands[hand].l_mult or 1, 
                    SMODS.PokerHands[hand].l_chips or 1,
                    colours = {
                        (to_number(level) == 1 and 
                        G.C.UI.TEXT_DARK or 
                        handlevelcol)
                    }
                },
            }
        end,
        
        calculate = function(self, card, context)
            if G.GAME.used_vouchers.v_observatory
                and context.joker_main
                and (
                    context.scoring_name == hand
                )
            then
                local value = G.P_CENTERS.v_observatory.config.extra
                return {
                    message = localize({ type = "variable", key = "a_xmult", vars = { value } }),
                    Xmult_mod = value,
                }
            end
        end,
        in_pool = function(self, args)
            return G.GAME.letters_enabled
        end,

    }
end

function AKYRS.bulk_level_up(center, card, area, copier, number)
	local used_consumable = copier or card
	if not number then
		number = 1
	end
	for _, v in pairs(card.config.center.config.akyrs_hand_types) do
		update_hand_text({ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 }, {
			handname = localize(v, "poker_hands"),
			chips = G.GAME.hands[v].chips,
			mult = G.GAME.hands[v].mult,
			level = G.GAME.hands[v].level,
		})
		level_up_hand(used_consumable, v, nil, number)
	end
	update_hand_text(
		{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
		{ mult = 0, chips = 0, handname = "", level = "" }
	)
end

function AKYRS.silent_bulk_level_up(center, card, area, copier, number)
	local used_consumable = copier or card
	if not number then
		number = 1
	end

    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_words_long'),chips = '...', mult = '...', level=''})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
        play_sound('tarot1')
        card:juice_up(0.8, 0.5)
        G.TAROT_INTERRUPT_PULSE = true
        return true end }))
    update_hand_text({delay = 0}, {mult = '+', StatusText = true})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
        play_sound('tarot1')
        card:juice_up(0.8, 0.5)
        return true end }))
    update_hand_text({delay = 0}, {chips = '+', StatusText = true})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
        play_sound('tarot1')
        card:juice_up(0.8, 0.5)
        G.TAROT_INTERRUPT_PULSE = nil
        return true end }))
    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level='+1'})
    delay(1.3)
    for k, v in pairs(card.config.center.config.akyrs_hand_types) do
		level_up_hand(used_consumable, v, true, number)
    end
    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
end

local hands_multi = {}
local hands_multi_rev = {}
for i = 12 ,31 do
    table.insert(hands_multi,AKYRS.prefix.."_"..(i).."-letter Word")
    hands_multi_rev[AKYRS.prefix.."_"..(i).."-letter Word"] = true
end

SMODS.Planet{
    atlas = "aikoConstellationCards",
    pos = { x = 9 , y=0},
    key = "p_microscopium",
    config = {
        akyrs_hand_types = hands_multi,
        softlock = true
    },
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge(localize('k_akyrs_constellation'), get_type_colour(self or card.config, card), nil, 1.2)
    end,
    loc_vars = function (self,iq,_c)
        local level = AKYRS.get_hand_in_game(_c) and AKYRS.get_hand_in_game(_c).level or 1
        return {
            vars = {
                localize(hands_multi[1], 'poker_hands') or "???", 
            },
        }
    end,
    use = function (self,card,area,copier)
        AKYRS.silent_bulk_level_up(self, card, area, copier, 1)
    end,
    can_use = function(self, card) return true end,
    calculate = function(self, card, context)
        if G.GAME.used_vouchers.v_observatory
            and context.joker_main
            and (
                hands_multi_rev[context.scoring_name]
            )
        then
            local value = G.P_CENTERS.v_observatory.config.extra
            return {
                message = localize({ type = "variable", key = "a_xmult", vars = { value } }),
                Xmult_mod = value,
            }
        end
    end,
    in_pool = function(self, args)
        return G.GAME.letters_enabled
    end,

}