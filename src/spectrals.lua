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
        return { vars = { card.ability.max_highlighted, G.GAME and G.GAME.probabilities.normal or 1, card.ability.destroy_odds } }
    end,

    use = function(self, card, area, copier)
        if pseudorandom('egocentric') < G.GAME.probabilities.normal / card.ability.destroy_odds then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                func = function()
                    SMODS.destroy_cards(G.hand.highlighted[1])
                    return true
                end
            }))
            
            return nil
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local ego_card = G.hand.highlighted[1]
                ego_card:set_edition("e_tb_zirconium", true)
                ego_card:juice_up()
                return true
            end
        }))

        delay(0.5)

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                G.hand:unhighlight_all()
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
            trigger = 'before',
            delay = 0.3,
            func = function()
                local tie_card = G.hand.highlighted[1]
                tie_card:set_seal(SMODS.poll_seal({ key = "randtie", guaranteed = true, options = TB.TIES }), nil, true)
                tie_card:juice_up()
                play_sound('tarot1')
                return true
            end
        }))

        delay(0.5)

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                G.hand:unhighlight_all()
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

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
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

SMODS.Consumable {
    key = "and",
    set = "Spectral",
    config = { max_highlighted = 1, destroy_odds = 2 },
    pos = {
        x = 3,
        y = 2
    },
    unlocked = true,
    discovered = false,
    atlas = "tb_consum",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
        return { vars = { G.GAME and G.GAME.probabilities.normal or 1, card.ability.destroy_odds } }
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.3,
            func = function()
                local tocopy = copy_card(G.hand.highlighted[1], nil, nil, G.playing_card)
                tocopy:set_edition('e_negative', true)
                tocopy:add_to_deck()
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                table.insert(G.playing_cards, tocopy)
                G.hand:emplace(tocopy)
                tocopy:start_materialize()
                SMODS.calculate_context({ playing_card_added = true, cards = { tocopy } })
                return true
            end
        }))

        if pseudorandom('&') < G.GAME.probabilities.normal / card.ability.destroy_odds then
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.3,
                func = function()
                    SMODS.destroy_cards(G.hand.highlighted[1])
                    return true
                end
            }))
        end

        delay(0.5)

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                G.hand:unhighlight_all()
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
    key = "storm",
    set = "Spectral",
    pos = {
        x = 4,
        y = 2
    },
    unlocked = true,
    discovered = false,
    atlas = "tb_consum",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_tb_blossom
    end,

    can_use = function(self, card)
        return G.hand and #G.hand.cards > 1
    end,

    use = function(self, card, area, copier)
        for _, hcard in ipairs(G.hand.cards) do
            if SMODS.has_enhancement(hcard, 'm_tb_blossom') then
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 0.3,
                    func = function()
                        local tocopy = copy_card(hcard, nil, nil, G.playing_card)
                        tocopy:add_to_deck()
                        G.deck.config.card_limit = G.deck.config.card_limit + 1
                        table.insert(G.playing_cards, tocopy)
                        G.hand:emplace(tocopy)
                        tocopy:start_materialize()
                        SMODS.calculate_context({ playing_card_added = true, cards = { tocopy } })
                        return true
                    end
                }))
            end
        end
    end,

    draw = function(self, card, layer)
        if (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' then
            card.children.center:draw_shader('booster', nil, card.ARGS.send_to_shader)
        end
    end
}