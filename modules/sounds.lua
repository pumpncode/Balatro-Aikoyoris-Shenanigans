SMODS.Sound({
    key = "letter_booster_pack_music",
    path = "letterPack.ogg",
    sync = {
        ['music1'] = true,
        ['music2'] = true,
        ['music3'] = true,
        ['music4'] = true,
        ['music5'] = true,
    },
    select_music_track = function(self) 
        return G.booster_pack and not G.booster_pack.REMOVED and SMODS.OPENED_BOOSTER and SMODS.OPENED_BOOSTER.config.center.kind == 'letter_pack' and 100 or nil
    end

    
})

SMODS.Sound({
    key = "noire_sfx",
    path = "noire.ogg",
    
})

SMODS.Sound({
    key = "texelated_sfx",
    path = "texelated.ogg",
})

SMODS.Sound({
    key = "sliced_sfx",
    path = "sliced.ogg",
})

SMODS.Sound({
    key = "burnt_sfx",
    path = "burnt.ogg",
})
