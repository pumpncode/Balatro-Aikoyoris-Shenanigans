
assert(SMODS.load_file("./modules/misc.lua"))() 

AKYRS.DescriptionDummy{
    key = "maxwell_example",
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local cards = {}
        table.insert(cards, AKYRS.create_random_card("maxwellui") )
        table.insert(cards, AKYRS.create_random_card("maxwellui") )
        table.insert(cards, AKYRS.create_random_card("maxwellui") )
        table.insert(cards, AKYRS.create_random_card("maxwellui") )
        local letters = {'g','o','l','d'}
        for index, value in ipairs(cards) do
            value.ability.forced_letter_render = true
            value.ability.aikoyori_letters_stickers = letters[index]
        end
        SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        if desc_nodes ~= full_UI_table.main then
            AKYRS.card_area_preview(G.akyrsCardsPrev, desc_nodes, {
                cards = cards,
                override = true,
                w = 2.4,
                h = 0.6,
                ml = 0,
                scale = 0.5,
                func_delay = 1,
                func_after = function(ca) 
                    if ca and ca.cards then
                        for i,k in ipairs(ca.cards) do
                            if not k.removed then
                                k:flip()
                                G.E_MANAGER:add_event(Event{
                                    trigger = "after",
                                    blockable = false,
                                    delay = 0.5 + 0.1*i,
                                    func = function ()
                                        k:set_ability(G.P_CENTERS["m_gold"],true, false)
                                        k:flip()
                                        return true
                                    end
                                })
                            end
                        end
                    end
                end,
            })            
        end

    end,
}