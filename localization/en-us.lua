return {
    descriptions = {
        Alphabets = {
            
        },
        Back={
            b_akyrs_letter_deck = {
                name = 'Letter Deck',
                text = { 'Letters-Only Deck',
                        "with Scrabble Distribution", 
                        "{C:mult}Mult{} and {C:white,X:mult}Xmult{} Enabled", 
                        "Play {C:playable}as many{} cards", 
                        "as you want per hand",
                        "{C:red}X#1#{} base Blind Size",
                    },
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
        DescriptionDummy={
            dd_akyrs_maxwell_example={
                name="Example",
                text={
                    "{C:inactive,s:0.8}For example, Spelling {C:spectral,s:0.8}'Spectral'",
                    "{C:inactive,s:0.8}gives you a {C:spectral,s:0.8}Spectral{C:inactive,s:0.8} Card",
                },
            },
            dd_akyrs_yona_yona_ex={
                name="Visual Example",
                text={
                },
            },
            dd_akyrs_2fa_example={
                name="Example Hand",
                text={
                },
            },
        },
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
                    "for every {C:attention}Stone{} Card scored",
                    "{C:red,E:1}Destroy all scored",
                    "{C:attention,E:1}Stone{C:red,E:1} cards afterwards"
                }
            },
            j_akyrs_diamond_pickaxe = {
                name = "Diamond Pickaxe",
                text = {
                    "Gives {C:attention}#2#{} stacks of {C:chips}+#1#{} Chips",
                    "for every {C:attention}Stone{} Card scored",
                    "and change every scored {C:attention}Stone{} card",
                    "to a random {C:attention}non-Stone Upgrades{}"
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
                    "gives you {C:attention}one{} of that card",
                    "Spelling enhancements enhance",
                    "the {C:attention}scored card{} to the one you spelled",
                    "{C:inactive}(Must have room)",
                }
            },
            j_akyrs_it_is_forbidden_to_dog = {
                name = "It is forbidden to dog",
                text = { 
                    "Debuffed Cards gives {X:mult,C:white} X#1#{} Mult",
                    "Both held in hand and at play",
                    "{C:inactive,s:0.8}Does NOT work properly on macOS",
                    "{C:inactive,s:0.8}Please check back later if you're on macOS",
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
                    "Gives value listed",
                    "if played hand sum does not exceed {C:attention}#1#{}",
                    "Joker gain the value listed",
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
            j_akyrs_tldr_joker = {
                name = "TL;DR Joker",
                text = {
                        "In the immersive and strategic world of {C:attention,E:1,s:1.5}Balatro{}, a distinctive role is played by this special joker card,",
                        "equipped with a potent ability known as the '{C:mult}+#1#{} Mult.' This ability dramatically enhances a player's score",
                        "under specific conditions, primarily centered around the presence of any {C:attention}High Card{} in the hand, which includes",
                        "but is not limited to traditional {C:attention}high-ranking cards{} like {C:attention}Aces, Kings, Queens, and Jacks.{}",
                        "Even then, the ability of this card goes further. But let's not get ahead of ourselves by going through with it before learning that",
                        "{C:attention,E:1,s:1.5}Balatro{} expands the definition of scoring to include key strategic cards that heighten gameplay impact.",
                        "This transformative {C:mult}multiplier{} is not just an advantage but a central aspect of strategic planning in {C:attention,E:1,s:1.5}Balatro{}.",
                        "It compels players to consider their hand composition carefully, aiming to incorporate {C:attention}High Cards{} and maximize benefits.",
                        "Delving into the history of gambling, card games have been a corner{C:tarot}stone{} of gaming culture for centuries.",
                        "by {C:attention}activating for every card in hand and at play{}, this ability ensures you will gain a high score by merely playing a {C:attention}High Card{}.",
                        "From the ancient {C:white,X:red}Chinese{} who are credited with inventing playing cards in the {C:attention}9th century{} to the spread of card",
                        "games across Europe during the {C:chips}Middle Ages{}, gambling has evolved into a sophisticated form of entertainment and strategy.",
                        "The concept of {C:mult}multipliers{}, like the '{C:mult}+#1#{} Mult' in {C:attention,E:1,s:1.5}Balatro{}, echoes innovations in probability and risk-taking found",
                        "throughout gambling history, where players sharpened their skills to navigate the {C:green}uncertainties of chance.{}",
                        "These elements of chance and strategy create a rich tapestry of gameplay where players harness both their intuition and",
                        "analytical abilities. The presence of the '{C:mult}+#1#{} Mult' deepens {C:attention,E:1,s:1.5}Balatro{}'s complexity, fostering a richly engaging",
                        "environment where tactical decision-making is crucial. Players dynamically shift the game balance by leveraging the {C:mult}multiplier{},",
                        "turning potential {C:chips}deficits{} into {C:dark_edition,E:1}commanding leads{}. Thus, the '{C:mult}+#1#{} Mult' feature isn't merely a rule but a critical",
                        "strategic tool and an exhilarating element.",
                }
            },
            j_akyrs_reciprocal_joker = {
                name = "Reciprocal Joker",
                text = { 
                    "Set {X:mult,C:white}Mult{} to",
                    "{X:chips,C:white}Chips{} divided by {X:mult,C:white}Mult{}",
                }
            },
            j_akyrs_kyoufuu_all_back = {
                name = "Kyoufuu All Back",
                text = { 
                    "Return previously {C:attention}discarded Cards",
                    "back to deck on {C:attention}final discard{}"
                }
            },
            j_akyrs_2fa = {
                name = "Two-Factor Authentication",
                text = { 
                    "{C:attention}All Played Cards'{} Rank",
                    "and Suit are {C:attention}randomized{} after scoring",
                    "and gains {C:chips} +#1# {} Chips per card played",
                    "{C:attention}Resets{} at the end of the round.",
                    "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
                    "{C:inactive,s:0.8}PSA: Please enable 2FA on all your online accounts!",
                }
            },
            j_akyrs_gaslighting = {
                name = "Gaslighting",
                text = { 
                    "This Joker gains {X:mult,C:white} X#1# {} Mult every hand played",
                    "{C:attention}Will not reset at all if score catches fire.",
                    "{C:inactive,s:0.7}Trust me, not Jimbo.",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
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
                    "{C:attention}Letters{} give {C:white,X:mult}XMult{} based on",
                    "1 + tenth of their {C:attention}Scrabble value{}",
                    "{C:inactive}e.g. 1+(value/10){}",
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
            lettersA = {name = 'Letter A',text = { '{C:mult}+#1#{} Mult'},},
            lettersB = {name = 'Letter B',text = { '{C:mult}+#1#{} Mult'},},
            lettersC = {name = 'Letter C',text = { '{C:mult}+#1#{} Mult'},},
            lettersD = {name = 'Letter D',text = { '{C:mult}+#1#{} Mult'},},
            lettersE = {name = 'Letter E',text = { '{C:mult}+#1#{} Mult'},},
            lettersF = {name = 'Letter F',text = { '{C:mult}+#1#{} Mult'},},
            lettersG = {name = 'Letter G',text = { '{C:mult}+#1#{} Mult'},},
            lettersH = {name = 'Letter H',text = { '{C:mult}+#1#{} Mult'},},
            lettersI = {name = 'Letter I',text = { '{C:mult}+#1#{} Mult'},},
            lettersJ = {name = 'Letter J',text = { '{C:mult}+#1#{} Mult'},},
            lettersK = {name = 'Letter K',text = { '{C:mult}+#1#{} Mult'},},
            lettersL = {name = 'Letter L',text = { '{C:mult}+#1#{} Mult'},},
            lettersM = {name = 'Letter M',text = { '{C:mult}+#1#{} Mult'},},
            lettersN = {name = 'Letter N',text = { '{C:mult}+#1#{} Mult'},},
            lettersO = {name = 'Letter O',text = { '{C:mult}+#1#{} Mult'},},
            lettersP = {name = 'Letter P',text = { '{C:mult}+#1#{} Mult'},},
            lettersQ = {name = 'Letter Q',text = { '{C:mult}+#1#{} Mult'},},
            lettersR = {name = 'Letter R',text = { '{C:mult}+#1#{} Mult'},},
            lettersS = {name = 'Letter S',text = { '{C:mult}+#1#{} Mult'},},
            lettersT = {name = 'Letter T',text = { '{C:mult}+#1#{} Mult'},},
            lettersU = {name = 'Letter U',text = { '{C:mult}+#1#{} Mult'},},
            lettersV = {name = 'Letter V',text = { '{C:mult}+#1#{} Mult'},},
            lettersW = {name = 'Letter W',text = { '{C:mult}+#1#{} Mult'},},
            lettersX = {name = 'Letter X',text = { '{C:mult}+#1#{} Mult'},},
            lettersY = {name = 'Letter Y',text = { '{C:mult}+#1#{} Mult'},},
            lettersZ = {name = 'Letter Z',text = { '{C:mult}+#1#{} Mult'},},
            xlettersA = {name = 'Letter A',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersB = {name = 'Letter B',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersC = {name = 'Letter C',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersD = {name = 'Letter D',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersE = {name = 'Letter E',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersF = {name = 'Letter F',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersG = {name = 'Letter G',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersH = {name = 'Letter H',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersI = {name = 'Letter I',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersJ = {name = 'Letter J',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersK = {name = 'Letter K',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersL = {name = 'Letter L',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersM = {name = 'Letter M',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersN = {name = 'Letter N',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersO = {name = 'Letter O',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersP = {name = 'Letter P',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersQ = {name = 'Letter Q',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersR = {name = 'Letter R',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersS = {name = 'Letter S',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersT = {name = 'Letter T',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersU = {name = 'Letter U',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersV = {name = 'Letter V',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersW = {name = 'Letter W',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersX = {name = 'Letter X',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersY = {name = 'Letter Y',text = { '{C:white,X:mult}X#2#{} Mult'},},
            xlettersZ = {name = 'Letter Z',text = { '{C:white,X:mult}X#2#{} Mult'},},
            lettersWild = {name = 'Wild Card',text = { '{C:mult}No Extra{} Mult'},},
            xlettersWild = {name = 'Wild Card',text = { '{C:white,X:mult}No Extra{} XMult'},},
            letterNotScored = {name = '',text = { 'Allows Words','to be played'},},
        },
        Sleeve = {
            sleeve_akyrs_letter = {
                name = "Letter Sleeve",
                text = { 
                    "Start with {C:red}Letters{} Enabled",
                    "Along with with its {C:white,X:mult}Xmult{}",
             }
            },
            sleeve_akyrs_letter_alt = {
                name = "Letter Sleeve",
                text = { 
                    "Start with",
                    "{C:white,X:dark_edition}X#1#{} Deck Size",
                    "{C:red}+#2#{} Discards",
                    "{C:blue}+#3#{} Hand Size",
                    "{C:red}X#4#{} base Blind Size",
             }
            },
        }
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
            k_akyrs_reciprocaled = "Reciprocal'd!",
            k_akyrs_drawn_discard = "All Back!",
            k_akyrs_2fa_generate = "Generated!",
            k_akyrs_2fa_regen = "Code Refreshed!",
            k_akyrs_2fa_reset = "2FA Reset!",
            k_akyrs_extinguish = "Extinguished...",
            k_akyrs_burn = "Burn!",
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