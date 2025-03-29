

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

AKYRS.math_default_const = {
    e = 2.7182818284590452353602874713526624977572470936999595749669676277240766303535475945713821785251664274,
    pi = math.pi,
}

AKYRS.math_default_functions = {
    ["sin"] = math.sin,
    ["cos"] = math.cos,
    ["tan"] = math.tan,
    ["ceil"] = math.ceil,
    ["floor"] = math.floor,
    ["abs"] = math.abs,
    ["log"] = math.log10,
    ["ln"] = function (e)
        return math.log(e,AKYRS.math_default_const.e)
    end,
}

AKYRS.MathParserLibrary = assert(SMODS.load_file("./lib/MathParser.min.lua"))()

AKYRS.reset_math_parser = function(config)
    config = config or {}
    local vars = config.vars or {}
    local functions = config.functions or {}
    AKYRS.MathParser = AKYRS.MathParserLibrary:new()
    AKYRS.MathParser:addVariables(vars)
    AKYRS.MathParser:addFunctions(AKYRS.math_default_functions)
    AKYRS.MathParser:addFunctions(functions)
end

AKYRS.parser_set_var = function(varname, value)
    AKYRS.MathParser:addVariable(varname, value)
    G.GAME.akyrs_parser_var = AKYRS.MathParser.variables
end

AKYRS.reset_math_parser({})