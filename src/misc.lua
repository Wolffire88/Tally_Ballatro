SMODS.Atlas {
    key = "modicon",
    path = "tb_logo.png",
    px = 32,
    py = 32
}

SMODS.Atlas {
    key = "mechanical",
    path = "mechanical.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "cog",
    path = "consumables.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "ego",
    path = "consumables.png",
    px = 71,
    py = 95
}

SMODS.Shader {
    key = "zirconium",
    path = "zirconium.fs"
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
    weight = 4,
    unlocked = true,
    discovered = false,
    in_shop = true,
    sound = { sound = "holo1", per = 1.5, vol = 0.4 },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.edition.x_chips } }
    end,

    get_weight = function(self)
        return (G.GAME.edition_rate - 1) * G.P_CENTERS["e_negative"].weight + G.GAME.edition_rate * self.weight
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
    atlas = "cog",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end
}

SMODS.Consumable {
    key = "ego",
    set = "Spectral",
    config = { max_highlighted = 1, destroy_odds = 4 },
    pos = {
        x = 1,
        y = 0
    },
    unlocked = true,
    discovered = false,
    atlas = "ego",

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
