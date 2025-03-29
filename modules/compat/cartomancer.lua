if Cartomancer then
    local cartomancer_strng_hook = Card.cart_to_string
    function Card:cart_to_string(arg) 
        local r =  cartomancer_strng_hook(self,arg)
        if arg.deck_view and Cartomancer.SETTINGS.deck_view_stack_enabled then
            if self.is_null then
                r = self.ability.aikoyori_letters_stickers
            else
                r = r..self.ability.aikoyori_letters_stickers
            end
        end
        return r
        
    end
end