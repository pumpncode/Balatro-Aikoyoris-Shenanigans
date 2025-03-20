AKYRS.Fonts = {}

-- modified from https://github.com/Steamodded/smods/blob/main/src/game_object.lua

AKYRS.Font = SMODS.GameObject:extend {
    obj_table = AKYRS.Fonts,
    obj_buffer = {},
    disable_mipmap = false,
    required_params = {
        'key',
        'path',
        'render_scale',
        'TEXT_HEIGHT_SCALE',
        'TEXT_OFFSET',
        'FONTSCALE',
        'squish',
        'DESCSCALE',
    },
    register = function(self)
        if self.registered then
            sendWarnMessage(('Detected duplicate register call on object %s'):format(self.key), self.set)
            return
        end
        self.name = self.key
        AKYRS.Font.super.register(self)
    end,
    inject = function(self)
        local file_path = type(self.path) == 'table' and
            ((G.SETTINGS.real_language and self.path[G.SETTINGS.real_language]) or self.path[G.SETTINGS.language] or self.path['default'] or self.path['en-us']) or self.path
        if file_path == 'DEFAULT' then return end

        self.full_path = (self.mod and self.mod.path or SMODS.path) ..
            'assets/fonts/' .. file_path
        local file_data = assert(NFS.newFileData(self.full_path),
            ('Failed to collect file data for Font %s'):format(self.key))
        local rs = (self.render_scale or 1) * G.TILESIZE
        self.FONT = assert(love.graphics.newFont(file_data, rs),
            ('Failed to initialize font data for Font %s'):format(self.key))
        
    end,
    process_loc_text = function() end,
}

AKYRS.Font{
    key = "NotoEmoji",
    path = "NotoEmoji-Bold.ttf",
    render_scale = 7,
    TEXT_HEIGHT_SCALE = 0.65, 
    TEXT_OFFSET = {x=0,y=0}, 
    FONTSCALE = 0.12,
    squish = 1, 
    DESCSCALE = 1
}