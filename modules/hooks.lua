

assert(SMODS.load_file("./modules/misc.lua"))() 
assert(SMODS.load_file("./modules/atlasses.lua"))() 
assert(SMODS.load_file("./func/word_utils.lua"))() 
local pprint = assert(SMODS.load_file("./func/pprint.lua"))() 

pprint.setup({level_width = 12, wrap_string = true})

function CardArea:aiko_change_playable(delta)
    self.config.highlighted_limit = self.config.highlight_limit or G.GAME.aiko_cards_playable or 5
    if delta ~= 0 then
        G.E_MANAGER:add_event(Event({
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
    end
    
end

function Card:set_letters_random()
    self.ability.aikoyori_letters_stickers = pseudorandom_element(scrabble_letters, pseudoseed('aiko:letters'))
end


function Card:set_letters(letter)
    self.ability.aikoyori_letters_stickers = letter
end

function Card:remove_letters()
    self.ability.aikoyori_letters_stickers = nil
end


function Card:set_special_sprites(_special)
    if _special then 
        if _special.set then
            if self.children.special then
                self.children.special.atlas = G.ASSET_ATLAS[_special.atlas or 'centers']
                self.children.special:set_sprite_pos(_special.pos)
            else
                self.children.special = Sprite(self.T.x, self.T.y, self.T.w, self.T.h, G.ASSET_ATLAS[_special.atlas or 'centers'], _special.pos)
                self.children.special.states.hover = self.states.hover
                self.children.special.states.click = self.states.click
                self.children.special.states.drag = self.states.drag
                self.children.special.states.collide.can = false
                self.children.special:set_role({major = self, role_type = 'Glued', draw_major = self})
            end
        end
    end
end


function Card:set_special_ability(extra_cards_attr, initial, delay_sprites)

    local old_center = self.aikoyori_extra_cards_attr
    self.aikoyori_extra_cards_attr = extra_cards_attr

    if delay_sprites then 
        G.E_MANAGER:add_event(Event({
            func = function()
                if not self.REMOVED then
                    self:set_special_sprites(extra_cards_attr)
                end
                return true
            end
        })) 
    else
        self:set_special_sprites(extra_cards_attr)
    end

    if self.aikoyori_extra_cards_attr and old_center and old_center.bonus then
        self.aikoyori_extra_cards_attr.bonus = self.ability.bonus - old_center.bonus
    end
    
    self.aikoyori_extra_cards_attr = {
        name = extra_cards_attr.name,
        effect = extra_cards_attr.effect,
        set = extra_cards_attr.set,
        mult = extra_cards_attr.config.mult or 0,
        h_mult = extra_cards_attr.config.h_mult or 0,
        h_x_mult = extra_cards_attr.config.h_x_mult or 0,
        h_dollars = extra_cards_attr.config.h_dollars or 0,
        p_dollars = extra_cards_attr.config.p_dollars or 0,
        t_mult = extra_cards_attr.config.t_mult or 0,
        t_chips = extra_cards_attr.config.t_chips or 0,
        x_mult = extra_cards_attr.config.Xmult or 1,
        h_size = extra_cards_attr.config.h_size or 0,
        d_size = extra_cards_attr.config.d_size or 0,
        extra = copy_table(extra_cards_attr.config.extra) or nil,
        extra_value = 0,
        type = extra_cards_attr.config.type or '',
        order = extra_cards_attr.order or nil,
        forced_selection = self.ability and self.ability.forced_selection or nil,
        perma_bonus = self.ability and self.ability.perma_bonus or 0,
    }

    self.aikoyori_extra_cards_attr.bonus = (self.aikoyori_extra_cards_attr.bonus or 0) + (extra_cards_attr.bonus or 0)

    if not initial then G.GAME.blind:debuff_card(self) end
    if self.playing_card and not initial then check_for_unlock({type = 'modify_deck'}) end
end


function aiko_mod_startup(self)
    if not self.aikoyori_letters_stickers then
        self.aikoyori_letters_stickers = {}
    end
    for i, v in ipairs(aiko_alphabets) do
        --print("PREPPING STICKERS "..v, " THE LETTER IS NUMBER "..i.. "should be index x y ",(i - 1) % 10 , math.floor((i-1) / 10))
        self.aikoyori_letters_stickers[v] = Sprite(0, 0, self.CARD_W, self.CARD_H, G.ASSET_ATLAS["akyrs_lettersStickers"], {x =(i - 1) % 10 ,y =  math.floor((i-1) / 10)})
    end
end


local cardBaseHooker = Card.set_base
function Card:set_base(card, initial)
    local ret = cardBaseHooker(self,card, initial)
    self.aiko_draw_delay = math.random() * 1.75 + 0.25
    self.aikoyori_extra_cards_attr = {}
    if self.base.name and not self.ability.aikoyori_letters_stickers then
        self:set_letters_random()
    end
    return ret
end
local cardSave = Card.save
function Card:save()
    local c = cardSave(self)
    c.aikoyori_extra_cards_attr = self.aikoyori_extra_cards_attr
    return c
end


local cardLoad = Card.load
function Card:load(cardTable, other_card)
    local c = cardLoad(self, cardTable, other_card)
    self.aikoyori_extra_cards_attr = cardTable.aikoyori_extra_cards_attr
    return c
end

local igo = Game.init_game_object
function Game:init_game_object()
    local ret = igo(self)
    ret.aiko_cards_playable = 5
    ret.starting_params.special_hook = false
    ret.aiko_last_mult = 0
    ret.aiko_last_chips = 0
    ret.aiko_has_quasi = false
    return ret
end

function aikoyori_draw_extras(card, layer)
    --print("DRAWING EXTRAS")
    if G.aikoyori_letters_stickers then
        if card.ability.aikoyori_letters_stickers then
            local movement_mod = 0.05*math.sin(1.1*(G.TIMERS.REAL + card.aiko_draw_delay)) - 0.07
            local rot_mod = 0.02*math.sin(0.72*(G.TIMERS.REAL + card.aiko_draw_delay)) + 0.03
            local drag_mod = card.velocity
            
            G.aikoyori_letters_stickers[card.ability.aikoyori_letters_stickers].role.draw_major = card
            G.aikoyori_letters_stickers[card.ability.aikoyori_letters_stickers]:draw_shader('dissolve', 0, nil, nil, card.children.center, 0.1, rot_mod - drag_mod.r, drag_mod.x * -3, movement_mod - drag_mod.y * -3)
            G.aikoyori_letters_stickers[card.ability.aikoyori_letters_stickers]:draw_shader('dissolve', nil, nil, nil, card.children.center, nil, rot_mod - drag_mod.r, drag_mod.x * -3, -0.02 + movement_mod*0.9 - drag_mod.y * -3, nil)

        end
        
    end
end

local gameUpdate = EventManager.update

function EventManager:update(dt, forced)
    local s = gameUpdate(self, dt, forced)
    if G.STATE == G.STATES.HAND_PLAYED then
        if G.GAME.aiko_last_chips ~= G.GAME.current_round.current_hand.chips or G.GAME.aiko_last_mult ~=
            G.GAME.current_round.current_hand.mult then
            G.GAME.aiko_last_mult = G.GAME.current_round.current_hand.mult
            G.GAME.aiko_last_chips = G.GAME.current_round.current_hand.chips
            for i = 1, #G.jokers.cards do
                if true then
                    if (G.jokers.cards[i].aiko_trigger_external) and not G.jokers.cards[i].debuff then
                        G.jokers.cards[i]:aiko_trigger_external(G.jokers.cards[i])
                        --G.E_MANAGER:add_event(Event({trigger = "immediate",func = (function()return true end)}), 'base')
                    end
                end
            end
        end
    end
    return s
end

local mod_mult_ref = mod_mult
local mod_chips_ref = mod_chips

function mod_mult(_mult)
    local m = mod_mult_ref(_mult)
    return m
end

function mod_chips(_chips)
    local c = mod_chips_ref(_chips)
    return c
end


function Card:aiko_trigger_external(card)
    if (card.ability.name == "Observer") then
        card.ability.extra.times = card.ability.extra.times - 1

        card_eval_status_text(card, 'jokers', nil, 0.5, nil, {
            instant = true,
            card_align = "m",
            message = localize {
                type = 'variable',
                key = 'a_remaining',
                vars = { card.ability.extra.times }
            },

        })
        update_hand_text({ immediate = true, nopulse = true, delay = 0 }, { mult_stored = stored })

        if card.ability.extra.times == 0 then
            SMODS.eval_this(card, {
                instant = true,
                message = localize {
                    type = 'variable',
                    key = 'a_mult',
                    vars = { (card.ability.extra.mult_stored + card.ability.extra.mult) }
                }
            })
            card.ability.extra.total_times = card.ability.extra.total_times + card.ability.extra.times_increment
            card.ability.extra.times = card.ability.extra.total_times
            card.ability.extra.mult_stored = card.ability.extra.mult_stored + card.ability.extra.mult
        end
        card.ability.extra.mult_change = mult
        card.ability.extra.chip_change = chips
    end
end



local cardReleaseRecalcHook = Card.stop_drag
function Card:stop_drag()
    local c = cardReleaseRecalcHook(self)
    --print("CARD RELEASED!!!!")
    if G.hand and self.area then
        self.area:parse_highlighted()
    end
    return c
end



local debugKeysNShit = Controller.key_press_update
function Controller:key_press_update(key, dt)
    local c = debugKeysNShit(self,key, dt)
    local _card = self.hovering.target
    if not _RELEASE_MODE and _card then
        
        if key == ',' then
            if _card.playing_card then
                _card:set_letters(alphabet_delta(_card.ability.aikoyori_letters_stickers, - 1))
            end
        end
        if key == '.' then
            if _card.playing_card then
                _card:set_letters(alphabet_delta(_card.ability.aikoyori_letters_stickers, 1))
            end
        end
    end
    return c
end

local applyToRunBackHook = Back.apply_to_run
local suits = {"S","H","D","C"}

function Back:apply_to_run()
    if self.effect then
        applyToRunBackHook(self)
        if self.effect.config.all_nulls then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.playing_cards = {}
                    for i, letter in pairs(scrabble_letters) do
                        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                        local front = pseudorandom_element(G.P_CARDS, pseudoseed('marb_fr'))
                        local car = Card(G.deck.T.x, G.deck.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS['c_base'], {playing_card = G.playing_card})
                        car:set_special_ability(G.P_CENTERS['aiko_x_akyrs_null'])
                        G.deck:emplace(car)
                        table.insert(G.playing_cards, car)
                    end
                    return true
                end
            }))
            G.GAME.starting_params.all_nulls = true
        end
        if self.effect.config.selection then
            G.GAME.aiko_cards_playable = G.GAME.aiko_cards_playable + self.effect.config.selection
        end
        if self.effect.config.special_hook then
            G.GAME.starting_params.special_hook = true
        end
    end
end

local getChipBonusHook = Card.get_chip_bonus
function Card:get_chip_bonus()
    if self.aikoyori_extra_cards_attr.do_not_give_chips then return 0 end
    local c = getChipBonusHook(self)
    
    return c
end

function customDeckHooks(self,card_protos)
    if self.GAME.starting_params.special_hook then
        return {}
    end
    return card_protos
end


