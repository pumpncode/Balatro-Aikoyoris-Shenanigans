local caSave = CardArea.save
function CardArea:save(cardAreaTable)
    if G.GAME.akyrs_any_drag and cardAreaTable then
        cardAreaTable.akyrs_drag_to_target_save = self.states.collide.can
    end
    return caSave(self,cardAreaTable)
end
local caLoad = CardArea.load
function CardArea:load(cardAreaTable)
    
    if G.GAME.akyrs_any_drag and cardAreaTable then
        self.states.collide.can = cardAreaTable.akyrs_drag_to_target_save
    end
    return caLoad(self,cardAreaTable)
end