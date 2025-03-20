

AKYRS.DescriptionDummies = {}


AKYRS.DescriptionDummy = SMODS.Center:extend{
    set = 'DescriptionDummy',
    obj_buffer = {},
    obj_table = AKYRS.DescriptionDummies,
    class_prefix = 'dd',
    required_params = {
        'key',
    },
    pre_inject_class = function(self)
        G.P_CENTER_POOLS[self.set] = {}
    end,
    inject = function(self)
        SMODS.Center.inject(self)
    end,
    get_obj = function(self, key)
        if key == nil then
            return nil
        end
        return self.obj_table[key]
    end
}

AKYRS.C = {
    DARKER_TRANS = HEX('22222299')
}

SMODS.optional_features.cardareas.unscored = true
SMODS.optional_features.retrigger_joker = true

AKYRS.HC_CHALLENGES = {}
AKYRS.UIDEF = {}