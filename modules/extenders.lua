function aiko_load_extender()
    AIKOYORI_CENTERS.AlternateCenters = {}
    AIKOYORI_CENTERS.AlternateCenter = SMODS.GameObject:extend {
        obj_table = AIKOYORI_CENTERS.AlternateCenters,
        obj_buffer = {},
        key = "altCenter",
        set = 'AikoyoriAlternateCenter', -- For logging purposes | Subclasses should change this
        get_obj = function(self, key) return G.P_CENTERS[key] end,
        register = function(self)
            -- 0.9.8 defense
            self.name = self.name or self.key
            SMODS.GameObject.register(self)
        end,
        inject = function(self)
            G.P_CENTERS[self.key] = self
            if not self.omit then SMODS.insert_pool(G.P_CENTER_POOLS[self.set], self) end
            for k, v in pairs(SMODS.ObjectTypes) do
                -- Should "cards" be formatted as `{[<center key>] = true}` or {<center key>}?
                -- Changing "cards" and "pools" wouldn't be hard to do, just depends on preferred format
                if ((self.pools and self.pools[k]) or (v.cards and v.cards[self.key])) then
                    SMODS.ObjectTypes[k]:inject_card(self)
                end
            end
        end,
        delete = function(self)
            G.P_CENTERS[self.key] = nil
            SMODS.remove_pool(G.P_CENTER_POOLS[self.set], self.key)
            for k, v in pairs(SMODS.ObjectTypes) do
                if ((self.pools and self.pools[k]) or (v.cards and v.cards[self.key])) then
                    SMODS.ObjectTypes[k]:remove_card(self)
                end
            end
            local j
            for i, v in ipairs(self.obj_buffer) do
                if v == self.key then j = i end
            end
            if j then table.remove(self.obj_buffer, j) end
            self = nil
            return true
        end,
        generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
            local target = {
                type = 'descriptions',
                key = self.key,
                set = self.set,
                nodes = desc_nodes,
                vars =
                    specific_vars or {}
            }
            local res = {}
            if self.loc_vars and type(self.loc_vars) == 'function' then
                res = self:loc_vars(info_queue, card) or {}
                target.vars = res.vars or target.vars
                target.key = res.key or target.key
                target.set = res.set or target.set
                target.scale = res.scale
                target.text_colour = res.text_colour
            end
            if desc_nodes == full_UI_table.main and not full_UI_table.name then
                full_UI_table.name = self.set == 'AikoyoriExtraBases' and 'temp_value' or localize { type = 'name', set = target.set, key = target.key, nodes = full_UI_table.name }
            elseif desc_nodes ~= full_UI_table.main and not desc_nodes.name and self.set ~= 'AikoyoriExtraBases' then
                desc_nodes.name = localize{type = 'name_text', key = target.key, set = target.set } 
            end
            if specific_vars and specific_vars.debuffed and not res.replace_debuff then
                target = { type = 'other', key = 'debuffed_' ..
                (specific_vars.playing_card and 'playing_card' or 'default'), nodes = desc_nodes }
            end
            if res.main_start then
                desc_nodes[#desc_nodes + 1] = res.main_start
            end
            localize(target)
            if res.main_end then
                desc_nodes[#desc_nodes + 1] = res.main_end
            end
            desc_nodes.background_colour = res.background_colour
        end
    }

    AIKOYORI_CENTERS.ExtraCards = AIKOYORI_CENTERS.AlternateCenter:extend{
        set = 'AikoyoriExtraBases',
        class_prefix = 'aiko_x',
        atlas = 'cardUpgrades',
        pos = { x = 0, y = 0 },
        required_params = {
            'key',
            -- table with keys `name` and `text`
        },
        -- other fields:
        -- replace_base_card
        -- if true, don't draw base card sprite and don't give base card's chips
        -- no_suit
        -- if true, enhanced card has no suit
        -- no_rank
        -- if true, enhanced card has no rank
        -- overrides_base_rank
        -- Set to true if your enhancement overrides the base card's rank.
        -- This prevents rank generators like Familiar creating cards
        -- whose rank is overridden.
        -- any_suit
        -- if true, enhanced card is any suit
        -- always_scores
        -- if true, card always scores
        -- loc_subtract_extra_chips
        -- During tooltip generation, number of chips to subtract from displayed extra chips.
        -- Use if enhancement already displays its own chips.
        -- Future work: use ranks() and suits() for better control
        register = function(self)
            self.config = self.config or {}
            assert(not (self.no_suit and self.any_suit))
            if self.no_rank then self.overrides_base_rank = true end
            AIKOYORI_CENTERS.ExtraCards.super.register(self)
        end,
        -- Produces the description of the whole playing card
        -- (including chips from the rank of the card and permanent bonus chips).
        -- You will probably want to override this if your enhancement interacts with
        -- those parts of the base card.
        generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
            if specific_vars and specific_vars.nominal_chips and not self.replace_base_card then
                localize { type = 'other', key = 'card_chips', nodes = desc_nodes, vars = { specific_vars.nominal_chips } }
            end
            AIKOYORI_CENTERS.ExtraCards.super.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
            if specific_vars and specific_vars.bonus_chips then
                local remaining_bonus_chips = specific_vars.bonus_chips - (self.config.bonus or 0)
                if remaining_bonus_chips > 0 then
                    localize { type = 'other', key = 'card_extra_chips', nodes = desc_nodes, vars = { specific_vars.bonus_chips - (self.config.bonus or 0) } }
                end
            end
        end,
        
        process_loc_text = function(self)
            print("TRYING TO GET THE SHIT FROM "..self.set.."["..self.key.."]")
            if(G.localization.descriptions) then
                SMODS.process_loc_text(G.localization.descriptions[self.set], self.key, self.loc_txt)
            else
                self.loc_txt = {name = "?????", text = {"???????"}}
            end

        end
        -- other methods:
        -- calculate(self, context, effect)
    }

    AIKOYORI_CENTERS.ExtraCards{
        key = "null",
        atlas = 'cardUpgrades',
        pos = {x = 0, y = 0},
        hide_front = true,
        do_not_give_chips = true,
        draw_base_anyway = true,
        no_rank = true,
        no_suit = true,
        always_scores = true,
        weight = 0,
        config = {
            bonus = 0,
            bonus_chips = 0,
            mult = 0,
        }
    }
end
aiko_load_extender()