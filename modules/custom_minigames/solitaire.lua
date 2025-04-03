-- solitaire
AKYRS.SOLITAIRE_UI = {}

AKYRS.SOLITAIRE_UI.stockCardArea = nil -- the deck basically
AKYRS.SOLITAIRE_UI.wasteCardArea = nil -- the thing you get from draw pile
AKYRS.SOLITAIRE_UI.foundationArea1 = nil -- the part where you move aces to to win
AKYRS.SOLITAIRE_UI.foundationArea2 = nil
AKYRS.SOLITAIRE_UI.foundationArea3 = nil
AKYRS.SOLITAIRE_UI.foundationArea4 = nil
AKYRS.SOLITAIRE_UI.tableauArea1 = nil -- the triangular shaped shit
AKYRS.SOLITAIRE_UI.tableauArea2 = nil
AKYRS.SOLITAIRE_UI.tableauArea3 = nil
AKYRS.SOLITAIRE_UI.tableauArea4 = nil
AKYRS.SOLITAIRE_UI.tableauArea5 = nil
AKYRS.SOLITAIRE_UI.tableauArea6 = nil
AKYRS.SOLITAIRE_UI.tableauArea7 = nil
AKYRS.SOLITAIRE_UI.cards_protos = {
    "H_2","H_3","H_4","H_5","H_6","H_7","H_8","H_9","H_T","H_J","H_Q","H_K","H_A",
    "C_2","C_3","C_4","C_5","C_6","C_7","C_8","C_9","C_T","C_J","C_Q","C_K","C_A",
    "D_2","D_3","D_4","D_5","D_6","D_7","D_8","D_9","D_T","D_J","D_Q","D_K","D_A",
    "S_2","S_3","S_4","S_5","S_6","S_7","S_8","S_9","S_T","S_J","S_Q","S_K","S_A",
}
AKYRS.SOLITAIRE_UI.playing_cards = {}
AKYRS.SOLITAIRE_UI.states = {
    INACTIVE = 0,
    INITIAL = 1,
    START_DRAW = 2,
    PLAY = 3,
    GAME_END = 4,
}
AKYRS.SOLITAIRE_UI.current_state = 0
AKYRS.SOLITAIRE_UI.cardAreas = {
    stock = {

    },
    waste = {
        
    },
    foundations = {

    },
    tableau = {

    }
}

AKYRS.SOLITAIRE_UI.reset_cards = function()
    for i,areas in ipairs(AKYRS.SOLITAIRE_UI.cardAreas) do
        for j,anarea in ipairs(areas) do
            if anarea then
                anarea:remove()
            end
        end
    end
    AKYRS.SOLITAIRE_UI.cardAreas = {
        stock = {
    
        },
        waste = {
            
        },
        foundations = {
    
        },
        tableau = {
    
        }
    }
end


function AKYRS.SOLITAIRE_UI.initialize_card_area(cardarea, destroy)
    local destroy = 1
    if cardarea == "stock" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOLITAIRE_UI.stockCardArea) end
        AKYRS.SOLITAIRE_UI.stockCardArea = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "deck"}
        local cards = AKYRS.word_to_cards("what the fuck did you just fucking say to me you little shit ill have you know that i am the one who made scrabble in balatro")
        for i, k in ipairs(cards) do
            AKYRS.SOLITAIRE_UI.stockCardArea:emplace(k)
        end
        table.insert(AKYRS.SOLITAIRE_UI.cardAreas.stock, AKYRS.SOLITAIRE_UI.stockCardArea)
        return AKYRS.SOLITAIRE_UI.stockCardArea
    end

    if cardarea == "waste" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOLITAIRE_UI.wasteCardArea) end
        AKYRS.SOLITAIRE_UI.wasteCardArea = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "akyrs_solitaire_waste"}
        local cards = AKYRS.word_to_cards("what")
        for i, k in ipairs(cards) do
            AKYRS.SOLITAIRE_UI.wasteCardArea:emplace(k)
        end
        return AKYRS.SOLITAIRE_UI.wasteCardArea
    end
    
    if cardarea == "foundation1" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOLITAIRE_UI.foundationArea1) end
        AKYRS.SOLITAIRE_UI.foundationArea1 = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "akyrs_solitaire_foundation"}
        return AKYRS.SOLITAIRE_UI.foundationArea1
    end
    if cardarea == "foundation2" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOLITAIRE_UI.foundationArea2) end
        AKYRS.SOLITAIRE_UI.foundationArea2 = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "akyrs_solitaire_foundation"}
        return AKYRS.SOLITAIRE_UI.foundationArea2
    end
    if cardarea == "foundation3" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOLITAIRE_UI.foundationArea3) end
        AKYRS.SOLITAIRE_UI.foundationArea3 = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "akyrs_solitaire_foundation"}
        return AKYRS.SOLITAIRE_UI.foundationArea3
    end
    if cardarea == "foundation4" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOLITAIRE_UI.foundationArea4) end
        AKYRS.SOLITAIRE_UI.foundationArea4 = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "akyrs_solitaire_foundation"}
        return AKYRS.SOLITAIRE_UI.foundationArea4
    end

    if cardarea == "tableau1" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOLITAIRE_UI.tableauArea1) end
        AKYRS.SOLITAIRE_UI.tableauArea1 = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "akyrs_solitaire_tableau"}
        local cards = AKYRS.word_to_cards("1")    
        for i, k in ipairs(cards) do
            AKYRS.SOLITAIRE_UI.tableauArea1:emplace(k)
        end
        return AKYRS.SOLITAIRE_UI.tableauArea1
    end
    if cardarea == "tableau2" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOLITAIRE_UI.tableauArea2) end
        AKYRS.SOLITAIRE_UI.tableauArea2 = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "akyrs_solitaire_tableau"}
        local cards = AKYRS.word_to_cards("22")    
        for i, k in ipairs(cards) do
            AKYRS.SOLITAIRE_UI.tableauArea2:emplace(k)
        end
        return AKYRS.SOLITAIRE_UI.tableauArea2
    end
    if cardarea == "tableau3" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOLITAIRE_UI.tableauArea3) end
        AKYRS.SOLITAIRE_UI.tableauArea3 = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "akyrs_solitaire_tableau"}
        local cards = AKYRS.word_to_cards("333")    
        for i, k in ipairs(cards) do
            AKYRS.SOLITAIRE_UI.tableauArea3:emplace(k)
        end
        return AKYRS.SOLITAIRE_UI.tableauArea3
    end
    if cardarea == "tableau4" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOLITAIRE_UI.tableauArea4) end
        AKYRS.SOLITAIRE_UI.tableauArea4 = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "akyrs_solitaire_tableau"}
        local cards = AKYRS.word_to_cards("4444")    
        for i, k in ipairs(cards) do
            AKYRS.SOLITAIRE_UI.tableauArea4:emplace(k)
        end
        return AKYRS.SOLITAIRE_UI.tableauArea4
    end
    if cardarea == "tableau5" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOLITAIRE_UI.tableauArea5) end
        AKYRS.SOLITAIRE_UI.tableauArea5 = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "akyrs_solitaire_tableau"}
        local cards = AKYRS.word_to_cards("55555")    
        for i, k in ipairs(cards) do
            AKYRS.SOLITAIRE_UI.tableauArea5:emplace(k)
        end
        return AKYRS.SOLITAIRE_UI.tableauArea5
    end
    if cardarea == "tableau6" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOLITAIRE_UI.tableauArea6) end
        AKYRS.SOLITAIRE_UI.tableauArea6 = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "akyrs_solitaire_tableau"}
        local cards = AKYRS.word_to_cards("666666")    
        for i, k in ipairs(cards) do
            AKYRS.SOLITAIRE_UI.tableauArea6:emplace(k)
        end
        return AKYRS.SOLITAIRE_UI.tableauArea6
    end
    if cardarea == "tableau7" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOLITAIRE_UI.tableauArea7) end
        AKYRS.SOLITAIRE_UI.tableauArea7 = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "akyrs_solitaire_tableau"}
        local cards = AKYRS.word_to_cards("7777777")    
        for i, k in ipairs(cards) do
            AKYRS.SOLITAIRE_UI.tableauArea7:emplace(k)
        end
        return AKYRS.SOLITAIRE_UI.tableauArea7
    end


end
AKYRS.SOLITAIRE_UI.get_UI_definition = function(params)

    params = params or {}
    local width = params.width or 8
    local height = params.height or 6
    return {
        n = G.UIT.ROOT, 
        config = {
            w = width, minh = height,
            r = 0.1,
            colour = G.C.UI.TRANSPARENT_DARK
        },
        nodes =                 {
            { -- top row with stock waste and foundation
                n = G.UIT.R, config = {
                    align = "tc",
                    h = 1,
                    w = width / 2,
                },
                nodes = {
                    {
                        n = G.UIT.C, -- deck and draw deck area
                        config = { maxh = 1, padding = 0.1 ,},
                        nodes = {
                            {
                                n = G.UIT.R,
                                config = {},
                                nodes = {
                                    {
                                        n = G.UIT.C, 
                                        config = { align = "cm" },
                                        nodes = {
                                            { n = G.UIT.C, config = { align = "cm" }, nodes = { -- deck area
                                                { n = G.UIT.O, config = { object = AKYRS.SOLITAIRE_UI.initialize_card_area('stock') }}
                                            }}
                                        }
                                    },
                                    {
                                        n = G.UIT.C, 
                                        config = { align = "cm" },
                                        nodes = {
                                            { n = G.UIT.C, config = { align = "cm" }, nodes = { -- deck draw area
                                                { n = G.UIT.O, config = { object = AKYRS.SOLITAIRE_UI.initialize_card_area('waste') }}
                                            }}
                                        }
                                    },
                                }
                            }
                        }
                    },
                    {
                        n = G.UIT.B,
                        config = { w = 3, h = 1 },
                        nodes = {}
                    },
                    {
                        n = G.UIT.C, -- for the part where you move shit
                        config = { align = "r", maxh = 1, padding = 0.1 },
                        nodes = {
                            {
                                n = G.UIT.R,
                                config = {padding = 0.1},
                                nodes = {
                                    {
                                        n = G.UIT.C, 
                                        config = { colour = G.C.UI.TRANSPARENT_DARK, r = 0.1},
                                        nodes = {
                                            { n = G.UIT.C, config = {  }, nodes = { -- these are for the thing
                                                { n = G.UIT.O, config = { object = AKYRS.SOLITAIRE_UI.initialize_card_area('foundation1') }}
                                            }}
                                        }
                                    },
                                    {
                                        n = G.UIT.C, 
                                        config = { colour = G.C.UI.TRANSPARENT_DARK, r = 0.1},
                                        nodes = {
                                            { n = G.UIT.C, config = {  }, nodes = {
                                                { n = G.UIT.O, config = { object = AKYRS.SOLITAIRE_UI.initialize_card_area('foundation2') }}
                                            }}
                                        }
                                    },
                                    {
                                        n = G.UIT.C, 
                                        config = { colour = G.C.UI.TRANSPARENT_DARK, r = 0.1},
                                        nodes = {
                                            { n = G.UIT.C, config = {  }, nodes = {
                                                { n = G.UIT.O, config = { object = AKYRS.SOLITAIRE_UI.initialize_card_area('foundation3') }}
                                            }}
                                        }
                                    },
                                    {
                                        n = G.UIT.C, 
                                        config = { colour = G.C.UI.TRANSPARENT_DARK, r = 0.1},
                                        nodes = {
                                            { n = G.UIT.C, config = {  }, nodes = {
                                                { n = G.UIT.O, config = { object = AKYRS.SOLITAIRE_UI.initialize_card_area('foundation4') }}
                                            }}
                                        }
                                    },
                                }
                            }
                        }
                    },
                }
            },            
            { -- bottom row with tableaus
                n = G.UIT.R, config = { w = width, padding = 0.2, minh = height - 1, align = "tm", },
                nodes = {
                    {
                        n = G.UIT.C, 
                        config = { align = "tm"},
                        nodes = {
                            { n = G.UIT.O, config = { object = AKYRS.SOLITAIRE_UI.initialize_card_area('tableau1') } }
                        }
                    },
                    {
                        n = G.UIT.C, 
                        config = { align = "tm" },
                        nodes = {
                            { n = G.UIT.O, config = { object = AKYRS.SOLITAIRE_UI.initialize_card_area('tableau2') } }
                        }
                    },
                    {
                        n = G.UIT.C, 
                        config = { align = "tm" },
                        nodes = {
                            { n = G.UIT.O, config = { object = AKYRS.SOLITAIRE_UI.initialize_card_area('tableau3') } }
                        }
                    },
                    {
                        n = G.UIT.C, 
                        config = { align = "tm" },
                        nodes = {
                            { n = G.UIT.O, config = { object = AKYRS.SOLITAIRE_UI.initialize_card_area('tableau4') } }
                        }
                    },
                    {
                        n = G.UIT.C, 
                        config = { align = "tm" },
                        nodes = {
                            { n = G.UIT.O, config = { object = AKYRS.SOLITAIRE_UI.initialize_card_area('tableau5') } }
                        }
                    },
                    {
                        n = G.UIT.C, 
                        config = { align = "cm" },
                        nodes = {
                            { n = G.UIT.O, config = { object = AKYRS.SOLITAIRE_UI.initialize_card_area('tableau6') } }
                        }
                    },
                    {
                        n = G.UIT.C, 
                        config = { align = "cm" },
                        nodes = {
                            { n = G.UIT.O, config = { object = AKYRS.SOLITAIRE_UI.initialize_card_area('tableau7') } }
                        }
                    },
                }
            },                    
        }
    }
end
