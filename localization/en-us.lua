return {
    descriptions = {
        Alphabets = {
            
        },
        Back={
            b_akyrs_letter_deck = {
                name = 'Letter Deck',
                text = { 'Play with {C:red}No Ranks and Suits{}', 'Letters enabled by default', "Play {C:playable}as many{} card as you want per hand" },
            }
        },
        Blind={
            bl_akyrs_the_thought= {
                name = "The Thought",
                text = {
                    "Solve 5-letter puzzle to win!",
                }
            },
        },
        Edition={},
        Enhanced={},
        Joker={
            j_akyrs_utage_charts = {
                name = "Utage Charts",
                text = {
                    "{C:playable}+#1#{} Hand Selection"
                }
            },
            j_akyrs_netherite_pickaxe = {
                name = "Netherite Pickaxe",
                text = {
                    "Gives {C:attention}#2#{} stacks of {C:chips}+#1#{} Chips",
                    "for every {C:attention}Stone{} Cards scored",
                    "{C:red,E:1}Destroys that card"
                }
            },
            j_akyrs_diamond_pickaxe = {
                name = "Diamond Pickaxe",
                text = {
                    "Gives {C:attention}#2#{} stacks of {C:chips}+#1#{} Chips",
                    "for every {C:attention}Stone{} Cards scored",
                    "Randomly change that card's upgrades"
                }
            },
            j_akyrs_redstone_repeater = {
                name = "Redstone Repeater",
                text = { "Swaps the current {C:white,X:mult} Mult {}", "with the stored {C:mult}Mult",
                    "then {C:white,X:mult} X#2# {} Mult", "Start with X {C:white,X:mult}   #3#   {} {C:mult}Mult{}",
                    "{C:inactive}(Currently X {C:white,X:mult}   #1#   {} {C:mult}Mult{}{C:inactive}){}" }
            },
            j_akyrs_observer = {
                name = "Observer",
                text = { "This Joker gains {C:mult}#1#{} Mult", "for every{C:attention} #4# {}times {C:inactive}(#3#)",
                    "{C:chips}Chips{} or {C:mult}Mult{} value changes",
                    "{s:0.8}Times needed increases by {C:attention}#5#{}",
                    "{s:0.8}every time this Joker gains {C:mult}Mult{}",
                    "{C:inactive}(Currently {C:mult}+#2#{} Mult{C:inactive}){}" }
            },
            j_akyrs_quasi_connectivity = {
                name = "Quasi Connectivity",
                text = { "{C:white,X:mult} X#1# {} Mult", "Disables one {C:attention}random Joker{}",
                    "after a hand is played",
                    "{s:0.8}Debuffs itself if it's",
                    "{s:0.8}the sole card"
                }
            },
            j_akyrs_maxwells_notebook = {
                name = "Maxwell's Notebook",
                text = { 
                    "Spelling the name of a card",
                    "gives you one of that card",
                    "Spelling enhancements enhance",
                    "the scored card to the one you spelled",
                    "{C:inactive,s:0.8}For example, Spelling {C:spectral,s:0.8}'Spectral'",
                    "{C:inactive,s:0.8}gives you a {C:spectral,s:0.8}Spectral{C:inactive,s:0.8} Card",
                    "{C:inactive,s:0.8}(Must have room)",
                }
            },
            j_akyrs_it_is_forbidden_to_dog = {
                name = "It is forbidden to dog",
                text = { 
                    "Debuffed Cards gives {X:mult,C:white} X#1#{} Mult",
                    "Both held in hand and at play",
                }
            },
            j_akyrs_eat_pant = {
                name = "eat pant",
                text = { 
                    "If played hand contains exactly {C:attention}#1#{} cards",
                    "This joker gains {X:mult,C:white} X#2# {} Mult for every scored cards",
                    "{C:red}Destroys all played cards{}",
                    "{C:inactive}(Currently {X:mult,C:white} X#3# {C:inactive} Mult)",
                }
            },
            j_akyrs_tsunagite = {
                name = "Tsunagite",
                text = { 
                    "Gives value listed in 'Gives'",
                    "if played hand sum does not exceed {C:attention}#1#{}",
                    "Joker gain the value listed in 'Joker Gains'",
                    "When a {C:planet}Planet{} card is used",
                    "{C:attention}Resets{} at the end of the ante.",
                }
            },
            j_akyrs_yona_yona_dance = {
                name = "Yona Yona Dance",
                text = { 
                    "Retrigger each played {C:attention}4{} and {C:attention}7{}",
                    "{C:attention}#1#{} additional times",
                    "{C:inactive,s:0.9}naraba odoranya son{}",
                    "{C:inactive,s:0.9}odoranya son desu{}",
                }
            },
        },
        Other={
            akyrs_self_destructs={
                name="Self Destructs",
                text={
                    "{C:red}Self-Destructs{} at ",
                    "the end of the round",
                },
            },
            akyrs_debuff_seal={
                name="Debuff Seal",
                text={
                    "{C:red}Debuffs itself{}",
                    "when drawn to hand",
                },
            },
            akyrs_art_by_larantula_l={
                name="Art",
                text={
                    "larantula_l",
                },
            },
            akyrs_chip_mult_xchip_xmult={
                name="Gives",
                text={
                    "{C:chips}+#1#{} Chips {C:mult}+#2#{} Mult",
                    "{X:chips,C:white} X#3# {} Chips {X:mult,C:white} X#4# {} Mult",
                    "per scored card",
                },
            },
            akyrs_gain_chip_mult_xchip_xmult={
                name="Joker Gains",
                text={
                    "Joker gains",
                    "{C:chips}+#1#{} Chips {C:mult}+#2#{} Mult",
                    "{X:chips,C:white} X#3# {} Chips {X:mult,C:white} X#4# {} Mult",
                },
            },
            akyrs_tsunagite_scores={
                name="Totals",
                text={
                    "Aces count as 1",
                    "Face Cards count as 10",
                },
            },
        },
        Planet={},
        Spectral={},
        Stake={},
        Tag={},
        Tarot={},
        Voucher={
            v_akyrs_alphabet_soup={
                name="Alphabet Soup",
                text={
                    "{C:attention}Letters{} appear on playing cards",
                    "Words can be made with playing cards",
                },
            },
            v_akyrs_crossing_field={
                name="Crossing Field",
                text={
                    "{C:attention}Letters{} give {C:mult}Mult{}",
                    "based on their {C:attention}Scrabble value{}",
                },
            },
        },
        AikoyoriExtraBases={
            aiko_x_akyrs_null = {
                name = 'Null',
                text = { 'No rank or suit'},
            },
            lettersA = {
                name = 'Letter A',
                text = { '{C:mult}+1{} Mult'},
            },
            lettersB = {
                name = 'Letter B',
                text = { '{C:mult}+3{} Mult'},
            },
            lettersC = {
                name = 'Letter C',
                text = { '{C:mult}+3{} Mult'},
            },
            lettersD = {
                name = 'Letter D',
                text = { '{C:mult}+2{} Mult'},
            },
            lettersE = {
                name = 'Letter E',
                text = { '{C:mult}+1{} Mult'},
            },
            lettersF = {
                name = 'Letter F',
                text = { '{C:mult}+4{} Mult'},
            },
            lettersG = {
                name = 'Letter G',
                text = { '{C:mult}+2{} Mult'},
            },
            lettersH = {
                name = 'Letter H',
                text = { '{C:mult}+4{} Mult'},
            },
            lettersI = {
                name = 'Letter I',
                text = { '{C:mult}+1{} Mult'},
            },
            lettersJ = {
                name = 'Letter J',
                text = { '{C:mult}+8{} Mult'},
            },
            lettersK = {
                name = 'Letter K',
                text = { '{C:mult}+5{} Mult'},
            },
            lettersL = {
                name = 'Letter L',
                text = { '{C:mult}+1{} Mult'},
            },
            lettersM = {
                name = 'Letter M',
                text = { '{C:mult}+3{} Mult'},
            },
            lettersN = {
                name = 'Letter N',
                text = { '{C:mult}+1{} Mult'},
            },
            lettersO = {
                name = 'Letter O',
                text = { '{C:mult}+1{} Mult'},
            },
            lettersP = {
                name = 'Letter P',
                text = { '{C:mult}+3{} Mult'},
            },
            lettersQ = {
                name = 'Letter Q',
                text = { '{C:mult}+10{} Mult'},
            },
            lettersR = {
                name = 'Letter R',
                text = { '{C:mult}+1{} Mult'},
            },
            lettersS = {
                name = 'Letter S',
                text = { '{C:mult}+1{} Mult'},
            },
            lettersT = {
                name = 'Letter T',
                text = { '{C:mult}+1{} Mult'},
            },
            lettersU = {
                name = 'Letter U',
                text = { '{C:mult}+1{} Mult'},
            },
            lettersV = {
                name = 'Letter V',
                text = { '{C:mult}+4{} Mult'},
            },
            lettersW = {
                name = 'Letter W',
                text = { '{C:mult}+4{} Mult'},
            },
            lettersX = {
                name = 'Letter X',
                text = { '{C:mult}+8{} Mult'},
            },
            lettersY = {
                name = 'Letter Y',
                text = { '{C:mult}+4{} Mult'},
            },
            lettersZ = {
                name = 'Letter Z',
                text = { '{C:mult}+10{} Mult'},
            },
            lettersWild = {
                name = 'Wild Card',
                text = { '{C:mult}No Extra{} Mult'},
            },
            letterNotScored = {
                name = '',
                text = { 'Allows Words','to be played'},
            },
        },
            
    },
    misc = {
        achievement_descriptions={},
        achievement_names={},
        blind_states={},
        challenge_names={},
        collabs={},
        dictionary={
            b_akyrs_alphabets="Alphabet Cards",
            k_aikoyoriextrabases = "Extra Base",
            k_akyrs_alphabets = "Alphabet",
            k_akyrs_alphabets_pack = "Alphabet Pack",
            k_alphabets = "Alphabet Pack",
            k_created = "Created!",
            ph_aiko_beat_puzzle = "Solve the following",
            ph_word_puzzle = "Word Puzzle",
            ph_puzzle_clear = "Puzzle Clear!",
            ph_akyrs_unknown = "???",
        },
        high_scores={},
        labels={
            akyrs_self_destructs="Self Destructs",
            akyrs_debuff_seal="Seal-Debuffed",
        },
        poker_hand_descriptions={},
        poker_hands={},
        quips={},
        ranks={},
        suits_plural={},
        suits_singular={},
        tutorial={},
        v_dictionary={},
        v_text={},
    },
}