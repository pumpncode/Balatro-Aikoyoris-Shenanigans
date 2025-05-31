AKYRS.TradeProfessions = {}
AKYRS.Trades = {}
AKYRS.TradeProfessionTrades = {}


AKYRS.TradeProfession = SMODS.GameObject:extend{
    set = 'TradeProfession',
    obj_table = AKYRS.TradeProfessions,
    obj_buffer = {},
    atlas = "villager",
    pos = { x = 0, y = 0},
    required_params = {
        'key',
    },
    class_prefix = 'profession',

    register = function(self)
        if self.registered then
            sendWarnMessage(('Detected duplicate register call on object %s'):format(self.key), self.set)
            return
        end
        self.name = self.key
        AKYRS.TradeProfessionTrades[self.trade_profession] = {}
        AKYRS.TradeProfession.super.register(self)
    end,
}

AKYRS.Trade = SMODS.GameObject:extend{
    set = 'Trade',
    obj_table = AKYRS.Trades,
    obj_buffer = {},
    required_params = {
        'key',
        'trade_profession',
        'level',
        'card_emplace_function',
        'calculate_reward_function',
        'trade', -- function
        'default_stock', -- usually 12
    },
    stock = 12,
    exp = 3, -- experience gain for villager
    register = function(self)
        if self.registered then
            sendWarnMessage(('Detected duplicate register call on object %s'):format(self.key), self.set)
            return
        end
        self.name = self.key
        AKYRS.TradeProfessionTrades[self.trade_profession] = AKYRS.TradeProfessionTrades[self.trade_profession] or {}
        table.insert(AKYRS.TradeProfessionTrades[self.trade_profession],self.key)
        AKYRS.Trade.super.register(self)
    end,

}