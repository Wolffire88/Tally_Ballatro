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