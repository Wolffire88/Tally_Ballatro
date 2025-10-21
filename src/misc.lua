SMODS.Shader {
    key = "zirconium",
    path = "zirconium.fs"
}

SMODS.Sound {
    key = "e_zirconium",
    path = "e_zirconium.ogg"
}

SMODS.Enhancement {
    key = "mechanical",
    config = { x_mult = 1, extra = { xmult_increase = 0.1 } },
    pos = {
        x = 0,
        y = 0
    },
    unlocked = true,
    discovered = false,
    replace_base_card = false,
    atlas = "mechanical",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.x_mult, card.ability.extra.xmult_increase } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.before then
            for _, hcard in ipairs(G.hand.cards) do
                if hcard == card then
                    card.ability.x_mult = card.ability.x_mult + card.ability.extra.xmult_increase
                    return {
                        message = localize('k_upgrade_ex'),
                        message_card = hcard,
                        colour = G.C.FILTER
                    }
                end
            end
        end
    end
}

SMODS.Edition {
    key = "zirconium",
    shader = "zirconium",
    config = { x_chips = 1.5 },
    extra_cost = 4,
    weight = 5,
    unlocked = true,
    discovered = false,
    in_shop = true,
    sound = { sound = "tb_e_zirconium", per = 1, vol = 0.2 },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.edition.x_chips } }
    end,

    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.post_joker or (context.main_scoring and context.cardarea == G.play) then
            return {
                x_chips = card.edition.x_chips
            }
        end
    end,

    draw = function(self, card, layer)
        -- I'm too lazy to actually code a shader
        local texture = love.graphics.newImage("Mods/Tally_Ballatro/assets/"..G.SETTINGS.GRAPHICS.texture_scaling.."x/zirconium.png")
        G.SHADERS['tb_zirconium']:send('z_text', texture)

        if (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' and (card.config.center.discovered or card.bypass_discovery_center) then
            card.children.center:draw_shader('tb_zirconium', nil, card.ARGS.send_to_shader)
            if card.children.front and card.ability.effect ~= 'Stone Card' then
                card.children.front:draw_shader('tb_zirconium', nil, card.ARGS.send_to_shader)
            end
            card.children.center:draw_shader('negative_shine', nil, card.ARGS.send_to_shader)
        end
    end
}

-- Tarots
SMODS.Consumable {
    key = "cog",
    set = "Tarot",
    config = { max_highlighted = 1, mod_conv = "m_tb_mechanical"},
    pos = {
        x = 0,
        y = 0
    },
    unlocked = true,
    discovered = false,
    atlas = "tb_consum",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end
}

SMODS.Consumable {
    key = "doctorate",
    set = "Tarot",
    config = { extra = { dollars = 5 } },
    pos = {
        x = 1,
        y = 0
    },
    unlocked = true,
    discovered = false,
    atlas = "tb_consum",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars } }
    end,

    use = function(self, card, area, copier)
        local tiecards = {}
        local bluecards = {}
        for _, hcard in ipairs(G.hand.cards) do
            if TB.is_in_table(TB.TIES, hcard:get_seal()) then
                if hcard:get_seal() == "tb_bluetie" then
                    table.insert(bluecards, hcard)
                else
                    table.insert(tiecards, hcard)
                end
            end
        end

        local total_dollars = (card.ability.extra.dollars * 2 * #bluecards) + (card.ability.extra.dollars *  #tiecards) 

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                card:juice_up()
                ease_dollars(total_dollars, true)
                return true
            end
        }))

        delay(0.6)
    end,

    can_use = function(self, card)
        local legal_select = true
        if not (G.hand and #G.hand.cards > 0) then
            legal_select = false
        end

        return legal_select 
    end
}

SMODS.Consumable {
    key = "mashup",
    set = "Tarot",
    config = { max_highlighted = 2 },
    pos = {
        x = 2,
        y = 0
    },
    unlocked = true,
    discovered = false,
    atlas = "tb_consum",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,

    use = function(self, card, area, copier)
        local card1 = G.hand.highlighted[1]
        local card2 = G.hand.highlighted[2]

        local cardtable = {
            set = "Playing Card",
            area = G.hand,
            rank = card2.base.value,
            suit = card1.base.suit
        }

        --get edition
        local c1_ed = card1.edition and card1.edition.key
        local c2_ed = card2.edition and card2.edition.key

        if c1_ed == c2_ed then
            cardtable.edition = c1_ed
        elseif c1_ed then
            if c2_ed and (G.P_CENTERS[c2_ed].order > G.P_CENTERS[c1_ed].order) then
                cardtable.edition = c2_ed
            else
                cardtable.edition = c1_ed
            end
        elseif c2_ed then
            cardtable.edition = c2_ed
        end

        --get enhancement
        local c1_en = (card1.ability.set == "Enhanced") and card1.config.center.key
        local c2_en = (card2.ability.set == "Enhanced") and card2.config.center.key

        if c1_en == c2_en then
            cardtable.enhancement = c1_en
        elseif c1_en then
            if c2_en and (G.P_CENTERS[c2_en].order > G.P_CENTERS[c1_en].order) then
                cardtable.enhancement = c2_en
            else
                cardtable.enhancement = c1_en
            end
        elseif c2_en then
            cardtable.enhancement = c2_en
        end

        --get seal
        local c1_s = card1:get_seal() 
        local c2_s = card2:get_seal()

        if c1_s == c2_s then
            cardtable.seal = c1_s
        elseif c1_s then
            if c2_s and (G.P_CENTERS[c2_s].order > G.P_CENTERS[c1_s].order) then
                cardtable.seal = c2_s
            else
                cardtable.seal = c1_s
            end
        elseif c2_s then
            cardtable.seal = c2_s
        end

        --Additional stuff
        nominal_chips = card1:get_chip_bonus() + card2:get_chip_bonus()
        nominal_mult = card1:get_chip_mult() + card2:get_chip_mult()

        --FUSION DANCE
        local fusion = SMODS.create_card(cardtable)
        fusion.ability.perma_mult = nominal_mult
        fusion.ability.perma_bonus = nominal_chips
        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
        fusion.playing_card = G.playing_card
        table.insert(G.playing_cards, fusion)
        G.hand:emplace(fusion)
        fusion:add_to_deck()

        --Kill the main cards
        SMODS.destroy_cards({card1, card2})
    end
}


-- Spectrals
SMODS.Consumable {
    key = "ego",
    set = "Spectral",
    config = { max_highlighted = 1, destroy_odds = 4 },
    pos = {
        x = 0,
        y = 2
    },
    unlocked = true,
    discovered = false,
    atlas = "tb_consum",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_tb_zirconium
        return { vars = { card.ability.max_highlighted, G.GAME.probabilities.normal, card.ability.destroy_odds } }
    end,

    use = function(self, card, area, copier)
        if pseudorandom('egocentric') < G.GAME.probabilities.normal / card.ability.destroy_odds then
            SMODS.destroy_card(G.hand.highlighted[1])
            return nil
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local ego_card = G.hand.highlighted[1]
                ego_card:set_edition("e_tb_zirconium", true)
                card:juice_up()
                ego_card:juice_up()
                return true
            end
        }))
    end,

    draw = function(self, card, layer)
        if (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' then
            card.children.center:draw_shader('booster', nil, card.ARGS.send_to_shader)
        end
    end
}

SMODS.Consumable {
    key = "band",
    set = "Spectral",
    config = { max_highlighted = 1 },
    pos = {
        x = 1,
        y = 2
    },
    unlocked = true,
    discovered = false,
    atlas = "tb_consum",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                local tie_card = G.hand.highlighted[1]
                tie_card:set_seal(SMODS.poll_seal({ key = "randtie", guaranteed = true, options = TB.TIES }))
                card:juice_up()
                tie_card:juice_up()
                return true
            end
        }))
    end,

    draw = function(self, card, layer)
        if (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' then
            card.children.center:draw_shader('booster', nil, card.ARGS.send_to_shader)
        end
    end
}

SMODS.Consumable {
    key = "hiatus",
    set = "Spectral",
    config = { max_highlighted = 3 },
    pos = {
        x = 2,
        y = 2
    },
    unlocked = true,
    discovered = false,
    atlas = "tb_consum",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,

    use = function(self, card, area, copier)
        local dollars = 0
        for _, sacrifice in ipairs(G.hand.highlighted) do
            SMODS.debuff_card(sacrifice, true, "tb_hiatus")
            dollars = dollars + sacrifice:get_chip_bonus()
        end

        delay(0.5)
        ease_dollars(dollars)
        delay(0.3)
    end,

    can_use = function(self, card)
        local legal_select = true
        for _, sacrifice in ipairs(G.hand.highlighted) do
            if sacrifice:get_seal() == "tb_redtie" then
                legal_select = false
                break
            end
        end

        if #G.hand.highlighted > card.ability.max_highlighted then
            legal_select = false
        end

        if not (G.hand and #G.hand.cards > 0) then
            legal_select = false
        end

        return legal_select 
    end,

    draw = function(self, card, layer)
        if (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' then
            card.children.center:draw_shader('booster', nil, card.ARGS.send_to_shader)
        end
    end
}
