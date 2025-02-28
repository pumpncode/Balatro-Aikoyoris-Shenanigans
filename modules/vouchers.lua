SMODS.Voucher {
    key = "alphabet_soup",
    atlas = 'aikoyoriVouchers', pos = { x = 2, y = 0 } ,
    cost = 10,
    redeem = function (self, card) 
        G.GAME.letters_enabled = true
    end,
    unredeem = function (self, card) 
        G.GAME.letters_enabled = false
    end
}

SMODS.Voucher {
    key = "crossing_field",
    atlas = 'aikoyoriVouchers', pos = { x = 3, y = 0 } ,
    cost = 10,
    requires = { "v_akyrs_alphabet_soup" },
    redeem = function (self, card) 
        G.GAME.letters_mult_enabled = true
    end,
    unredeem = function (self, card) 
        G.GAME.letters_mult_enabled = false
    end
}