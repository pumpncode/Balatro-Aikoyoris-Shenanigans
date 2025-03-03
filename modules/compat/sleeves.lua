if CardSleeves then
    CardSleeves.Sleeve {
        key = "letter",
        atlas = "aikoyoriSleeves",
        pos = { x = 0, y = 0 },
        config = {
            vouchers = {'v_akyrs_alphabet_soup' } 
        },
        loc_vars = function(self)
            local key, vars
            --print(self.get_current_deck_key())
            if self.get_current_deck_key() == "b_akyrs_letter_deck" then
                key = self.key .. "_alt"
                self.config = { deck_size = 2, discards = 6, hand_size = 6, ante_scaling = 6 }
                vars = { self.config.deck_size, self.config.discards, self.config.hand_size, self.config.ante_scaling  }
            else
                key = self.key
                self.config = { vouchers = {'v_akyrs_alphabet_soup' }, ante_scaling = 2, deck_size = 1 }
                vars = {}
            end
            return { key = key, vars = vars }
        end,
        apply = function(self, sleeve)
            CardSleeves.Sleeve.apply(sleeve)
            G.GAME.starting_params.deck_size_letter = sleeve.config.deck_size
            G.GAME.starting_params.ante_scaling = sleeve.config.ante_scaling
        end
    }
end