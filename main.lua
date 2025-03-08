AKYRS = SMODS.current_mod

SMODS.optional_features.cardareas.unscored = true
SMODS.optional_features.retrigger_joker = true

assert(SMODS.load_file("./modules/pre.lua"))() 
assert(SMODS.load_file("./modules/atlasses.lua"))() 
assert(SMODS.load_file("./func/numbers.lua"))()
assert(SMODS.load_file("./func/words/words.lua"))()
assert(SMODS.load_file("./func/word_utils.lua"))() 
assert(SMODS.load_file("./modules/misc.lua"))() 
assert(SMODS.load_file("./modules/hooks/general.lua"))() -- misc hook
assert(SMODS.load_file("./modules/hooks/letter.lua"))() -- for letter & null cards mechanics
assert(SMODS.load_file("./modules/hooks/scoring.lua"))() -- pure scoring
assert(SMODS.load_file("./modules/hooks/debug.lua"))() -- debug
assert(SMODS.load_file("./modules/hooks/ui.lua"))() -- debug
assert(SMODS.load_file("./modules/sounds.lua"))() 
assert(SMODS.load_file("./modules/desc.lua"))() 
assert(SMODS.load_file("./modules/draw_step.lua"))() 
assert(SMODS.load_file("./modules/consumables.lua"))() 
assert(SMODS.load_file("./modules/stickers.lua"))() 
assert(SMODS.load_file("./modules/blinds.lua"))() 
assert(SMODS.load_file("./modules/cards.lua"))() 
assert(SMODS.load_file("./modules/vouchers.lua"))() 
assert(SMODS.load_file("./modules/edition.lua"))() 
assert(SMODS.load_file("./modules/ui.lua"))() 
assert(SMODS.load_file("./modules/jokers.lua"))() 
assert(SMODS.load_file("./modules/compat/sleeves.lua"))() 
assert(SMODS.load_file("./modules/compat/talisman.lua"))() 
assert(SMODS.load_file("./modules/compat/jokerdisplay.lua"))() 
assert(SMODS.load_file("./modules/compat/notjustyet.lua"))() 
assert(SMODS.load_file("./modules/pokerhands.lua"))() 
