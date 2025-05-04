local l = SMODS.Rank{
    key = "non_playing",
    card_key = "SP",
    pos = { x = 0 },
    lc_atlas = 'blank',
    hc_atlas = 'blank',
    nominal = 0,
    suit_map = {
        akyrs_joker = 0
    },
    shorthand = "-",
    strength_effect = {
        ignore = true
    },
    in_pool = function (self, args)
        if args and args.suit == '' and G.GAME.akyrs_any_drag then
            return true
        end
        return false
    end,
    inject = function(self)
    end,
    
}

SMODS.Suit{
    key = "joker",
    card_key = "j",
    pos = { y = 0 },
    ui_pos = { x = 0, y = 0 },
    lc_atlas = 'blank',
    hc_atlas = 'blank',
    lc_ui_atlas  = '18blank',
    hc_ui_atlas  = '18blank',
    
    inject = function(self)
        SMODS.inject_p_card(self, SMODS.Ranks[l.key])
    end,
    lc_colour = AKYRS.C.JOKER_LC,
    hc_colour = AKYRS.C.JOKER_HC,
    in_pool = function (self, args)
        if args and args.rank == '' and G.GAME.akyrs_any_drag then
            return true
        end
        return false
    end
}
SMODS.Suit{
    key = "consumable",
    card_key = "c",
    pos = { y = 0 },
    ui_pos = { x = 0, y = 0 },
    lc_atlas = 'blank',
    hc_atlas = 'blank',
    lc_ui_atlas  = '18blank',
    hc_ui_atlas  = '18blank',
    
    inject = function(self)
        SMODS.inject_p_card(self, SMODS.Ranks[l.key])
    end,
    lc_colour = AKYRS.C.CONSU_LC,
    hc_colour = AKYRS.C.CONSU_HC,
    in_pool = function (self, args)
        if args and args.rank == '' and G.GAME.akyrs_any_drag then
            return true
        end
        return false
    end
}
SMODS.Suit{
    key = "thing",
    card_key = "th",
    pos = { y = 0 },
    ui_pos = { x = 0, y = 0 },
    lc_atlas = 'blank',
    hc_atlas = 'blank',
    lc_ui_atlas  = '18blank',
    hc_ui_atlas  = '18blank',
    
    inject = function(self)
        SMODS.inject_p_card(self, SMODS.Ranks[l.key])
    end,
    lc_colour = AKYRS.C.THING_LC,
    hc_colour = AKYRS.C.THING_HC,
    in_pool = function (self, args)
        if args and args.rank == '' and G.GAME.akyrs_any_drag then
            return true
        end
        return false
    end
}