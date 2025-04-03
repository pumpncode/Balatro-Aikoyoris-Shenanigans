-- solitaire
AKYRS.SOL = {}

AKYRS.SOL.stockCardArea = nil -- the deck basically
AKYRS.SOL.wasteCardArea = nil -- the thing you get from draw pile
AKYRS.SOL.foundationArea1 = nil -- the part where you move aces to to win
AKYRS.SOL.foundationArea2 = nil
AKYRS.SOL.foundationArea3 = nil
AKYRS.SOL.foundationArea4 = nil
AKYRS.SOL.tableauArea1 = nil -- the triangular shaped shit
AKYRS.SOL.tableauArea2 = nil
AKYRS.SOL.tableauArea3 = nil
AKYRS.SOL.tableauArea4 = nil
AKYRS.SOL.tableauArea5 = nil
AKYRS.SOL.tableauArea6 = nil
AKYRS.SOL.tableauArea7 = nil
AKYRS.SOL.cardarea_initialized = false
AKYRS.SOL.cards_protos = {
    "H_2","H_3","H_4","H_5","H_6","H_7","H_8","H_9","H_T","H_J","H_Q","H_K","H_A",
    "C_2","C_3","C_4","C_5","C_6","C_7","C_8","C_9","C_T","C_J","C_Q","C_K","C_A",
    "D_2","D_3","D_4","D_5","D_6","D_7","D_8","D_9","D_T","D_J","D_Q","D_K","D_A",
    "S_2","S_3","S_4","S_5","S_6","S_7","S_8","S_9","S_T","S_J","S_Q","S_K","S_A",
}
AKYRS.SOL.playing_cards = {}
AKYRS.SOL.states = {
    INACTIVE = 0,
    INITIAL = 1,
    START_DRAW = 2,
    PLAY = 3,
    GAME_END = 4,
}
AKYRS.SOL.current_state = 0
AKYRS.SOL.cardAreas = {
    stock = {

    },
    waste = {
        
    },
    foundations = {

    },
    tableau = {

    }
}

AKYRS.SOL.reset_card_areas = function()
    for i,areas in ipairs(AKYRS.SOL.cardAreas) do
        for j,anarea in ipairs(areas) do
            if anarea then
                anarea:remove()
            end
        end
    end
    AKYRS.SOL.cardAreas = {
        stock = {
    
        },
        waste = {
            
        },
        foundations = {
    
        },
        tableau = {
    
        }
    }
    AKYRS.SOL.cardarea_initialized = false
end


AKYRS.SOL.fill_stock_with_fresh_cards = function()
    if AKYRS.SOL.stockCardArea then
        local a = AKYRS.SOL.stockCardArea.T
        for i, proto in ipairs(AKYRS.SOL.cards_protos) do
            local card = Card(a.X,a.Y,G.CARD_W,G.CARD_H, G.P_CARDS[proto], G.P_CENTERS['c_base'])
            card.facing = 'back'
            card.sprite_facing = 'back'
            AKYRS.SOL.stockCardArea:emplace(card)
        end
        AKYRS.SOL.stockCardArea:shuffle('aikoyorisoiltaires')
    end
end
AKYRS.SOL.initial_setup = function()
    if #AKYRS.SOL.cardAreas.tableau > 0 and AKYRS.SOL.stockCardArea then
        G.E_MANAGER:add_event(
            Event{
                trigger = "after",
                delay = 0,
                func = function ()
                    AKYRS.SOL.current_state = AKYRS.SOL.states.START_DRAW
                    
                    for i, ca in ipairs(AKYRS.SOL.cardAreas.tableau) do
                        AKYRS.SOL.draw_from_stock_to_tableau(i,i)
                    end
                    AKYRS.SOL.current_state = AKYRS.SOL.states.PLAY
                    return true
                end
            }
        )
    end
end
AKYRS.SOL.draw_from_stock_to_tableau = function(tableau_no, amount)
    delay(0.01)
    for i=1, amount do
        draw_card(AKYRS.SOL.stockCardArea,AKYRS.SOL.cardAreas.tableau[tableau_no], i*100/amount, 'down', false, nil, 0.1)
    end
end
AKYRS.SOL.draw_from_stock_to_waste = function(amount)
    for i=1, amount do
        draw_card(AKYRS.SOL.stockCardArea,AKYRS.SOL.wasteCardArea, i*100/amount, 'up', false)
    end
end

AKYRS.SOL.draw_from_waste_to_stock = function(amount)

    
    for i=1, amount do
        draw_card(AKYRS.SOL.wasteCardArea,AKYRS.SOL.stockCardArea, i*100/amount, 'down', false, nil, 0.01)
    end
end


function AKYRS.SOL.initialize_card_area(cardarea, destroy)
    
    if cardarea == "stock" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOL.stockCardArea) end
        AKYRS.SOL.stockCardArea = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "deck"}
        
        table.insert(AKYRS.SOL.cardAreas.stock, AKYRS.SOL.stockCardArea)
        AKYRS.SOL.stockCardArea.states.click.can = true
        AKYRS.SOL.stockCardArea.states.hover.can = true
        AKYRS.SOL.stockCardArea.states.collide.can = true
        AKYRS.SOL.fill_stock_with_fresh_cards()
        return AKYRS.SOL.stockCardArea
    end

    if cardarea == "waste" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOL.wasteCardArea) end
        AKYRS.SOL.wasteCardArea = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "akyrs_solitaire_waste"}
        table.insert(AKYRS.SOL.cardAreas.waste, AKYRS.SOL.wasteCardArea)
        return AKYRS.SOL.wasteCardArea
    end
    
    if cardarea == "foundation1" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOL.foundationArea1) end
        AKYRS.SOL.foundationArea1 = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "akyrs_solitaire_foundation"}
        table.insert(AKYRS.SOL.cardAreas.foundations, AKYRS.SOL.foundationArea1)
        return AKYRS.SOL.foundationArea1
    end
    if cardarea == "foundation2" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOL.foundationArea2) end
        AKYRS.SOL.foundationArea2 = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "akyrs_solitaire_foundation"}
        table.insert(AKYRS.SOL.cardAreas.foundations, AKYRS.SOL.foundationArea2)
        return AKYRS.SOL.foundationArea2
    end
    if cardarea == "foundation3" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOL.foundationArea3) end
        AKYRS.SOL.foundationArea3 = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "akyrs_solitaire_foundation"}
        table.insert(AKYRS.SOL.cardAreas.foundations, AKYRS.SOL.foundationArea3)
        return AKYRS.SOL.foundationArea3
    end
    if cardarea == "foundation4" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOL.foundationArea4) end
        AKYRS.SOL.foundationArea4 = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "akyrs_solitaire_foundation"}
        table.insert(AKYRS.SOL.cardAreas.foundations, AKYRS.SOL.foundationArea4)
        return AKYRS.SOL.foundationArea4
    end

    if cardarea == "tableau1" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOL.tableauArea1) end
        AKYRS.SOL.tableauArea1 = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "akyrs_solitaire_tableau"}
            
        table.insert(AKYRS.SOL.cardAreas.tableau, AKYRS.SOL.tableauArea1)
        return AKYRS.SOL.tableauArea1
    end
    if cardarea == "tableau2" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOL.tableauArea2) end
        AKYRS.SOL.tableauArea2 = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "akyrs_solitaire_tableau"}
        
        table.insert(AKYRS.SOL.cardAreas.tableau, AKYRS.SOL.tableauArea2)
        return AKYRS.SOL.tableauArea2
    end
    if cardarea == "tableau3" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOL.tableauArea3) end
        AKYRS.SOL.tableauArea3 = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "akyrs_solitaire_tableau"}
            
        table.insert(AKYRS.SOL.cardAreas.tableau, AKYRS.SOL.tableauArea3)
        return AKYRS.SOL.tableauArea3
    end
    if cardarea == "tableau4" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOL.tableauArea4) end
        AKYRS.SOL.tableauArea4 = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "akyrs_solitaire_tableau"}
            
        table.insert(AKYRS.SOL.cardAreas.tableau, AKYRS.SOL.tableauArea4)
        return AKYRS.SOL.tableauArea4
    end
    if cardarea == "tableau5" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOL.tableauArea5) end
        AKYRS.SOL.tableauArea5 = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "akyrs_solitaire_tableau"}
            
        table.insert(AKYRS.SOL.cardAreas.tableau, AKYRS.SOL.tableauArea5)
        return AKYRS.SOL.tableauArea5
    end
    if cardarea == "tableau6" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOL.tableauArea6) end
        AKYRS.SOL.tableauArea6 = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "akyrs_solitaire_tableau"}
            
            
        table.insert(AKYRS.SOL.cardAreas.tableau, AKYRS.SOL.tableauArea6)
        return AKYRS.SOL.tableauArea6
    end
    if cardarea == "tableau7" then
        if destroy then AKYRS.destroy_existing_cards(AKYRS.SOL.tableauArea7) end
        AKYRS.SOL.tableauArea7 = 
            AKYRS.make_new_card_area{ w = G.CARD_W , h = G.CARD_H, type = "akyrs_solitaire_tableau"}
            
            table.insert(AKYRS.SOL.cardAreas.tableau, AKYRS.SOL.tableauArea7)
        AKYRS.SOL.cardarea_initialized = true -- jank
        return AKYRS.SOL.tableauArea7
    end


end
AKYRS.SOL.get_UI_definition = function(params)
    if AKYRS.SOL.cardarea_initialized then
        AKYRS.SOL.reset_card_areas()

    end
    AKYRS.SOL.fill_stock_with_fresh_cards()
    AKYRS.SOL.initial_setup()
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
                                                { n = G.UIT.O, config = { object = AKYRS.SOL.initialize_card_area('stock') }}
                                            }}
                                        }
                                    },
                                    {
                                        n = G.UIT.C, 
                                        config = { align = "cm" },
                                        nodes = {
                                            { n = G.UIT.C, config = { align = "cm" }, nodes = { -- deck draw area
                                                { n = G.UIT.O, config = { object = AKYRS.SOL.initialize_card_area('waste') }}
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
                                                { n = G.UIT.O, config = { object = AKYRS.SOL.initialize_card_area('foundation1') }}
                                            }}
                                        }
                                    },
                                    {
                                        n = G.UIT.C, 
                                        config = { colour = G.C.UI.TRANSPARENT_DARK, r = 0.1},
                                        nodes = {
                                            { n = G.UIT.C, config = {  }, nodes = {
                                                { n = G.UIT.O, config = { object = AKYRS.SOL.initialize_card_area('foundation2') }}
                                            }}
                                        }
                                    },
                                    {
                                        n = G.UIT.C, 
                                        config = { colour = G.C.UI.TRANSPARENT_DARK, r = 0.1},
                                        nodes = {
                                            { n = G.UIT.C, config = {  }, nodes = {
                                                { n = G.UIT.O, config = { object = AKYRS.SOL.initialize_card_area('foundation3') }}
                                            }}
                                        }
                                    },
                                    {
                                        n = G.UIT.C, 
                                        config = { colour = G.C.UI.TRANSPARENT_DARK, r = 0.1},
                                        nodes = {
                                            { n = G.UIT.C, config = {  }, nodes = {
                                                { n = G.UIT.O, config = { object = AKYRS.SOL.initialize_card_area('foundation4') }}
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
                            { n = G.UIT.O, config = { object = AKYRS.SOL.initialize_card_area('tableau1') } }
                        }
                    },
                    {
                        n = G.UIT.C, 
                        config = { align = "tm" },
                        nodes = {
                            { n = G.UIT.O, config = { object = AKYRS.SOL.initialize_card_area('tableau2') } }
                        }
                    },
                    {
                        n = G.UIT.C, 
                        config = { align = "tm" },
                        nodes = {
                            { n = G.UIT.O, config = { object = AKYRS.SOL.initialize_card_area('tableau3') } }
                        }
                    },
                    {
                        n = G.UIT.C, 
                        config = { align = "tm" },
                        nodes = {
                            { n = G.UIT.O, config = { object = AKYRS.SOL.initialize_card_area('tableau4') } }
                        }
                    },
                    {
                        n = G.UIT.C, 
                        config = { align = "tm" },
                        nodes = {
                            { n = G.UIT.O, config = { object = AKYRS.SOL.initialize_card_area('tableau5') } }
                        }
                    },
                    {
                        n = G.UIT.C, 
                        config = { align = "cm" },
                        nodes = {
                            { n = G.UIT.O, config = { object = AKYRS.SOL.initialize_card_area('tableau6') } }
                        }
                    },
                    {
                        n = G.UIT.C, 
                        config = { align = "cm" },
                        nodes = {
                            { n = G.UIT.O, config = { object = AKYRS.SOL.initialize_card_area('tableau7') } }
                        }
                    },
                }
            },                    
        }
    }
end

-- hooks 
local solitaireCardClickHook = Card.click
function Card:click()
    local c = solitaireCardClickHook(self)
    if self.area == AKYRS.SOL.stockCardArea then
        AKYRS.SOL.draw_from_stock_to_waste(1)
    end
    return c
end

local solitaireCardAreaClickHook = CardArea.click
function CardArea:click()
    local c = solitaireCardAreaClickHook(self)
    if self == AKYRS.SOL.stockCardArea and #self.cards <= 0 and AKYRS.SOL.wasteCardArea then
        AKYRS.SOL.draw_from_waste_to_stock(#AKYRS.SOL.wasteCardArea.cards)
    end
    return c
end

G.FUNCS.akyrs_draw_from_waste_to_stock = function ()
    AKYRS.SOL.draw_from_waste_to_stock(#AKYRS.SOL.wasteCardArea.cards)
end