SMODS.Joker {
    key = "hawley",
    name = "The Singer",
    config = { extra = { xmult = 1, xmult_increase = 1 } },
    pos = {
        x = 3,
        y = 3
    },
    rarity = 4,
    cost = 20,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = false,
    discovered = false,
    effect = nil,
    soul_pos = {
        x = 4,
        y = 3
    },
    atlas = "tb_joker",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_increase } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.before and not context.blueprint then
            local found_debuff = false
            for _, pcard in ipairs(context.scoring_hand) do
                if pcard.debuff then
                    found_debuff = true
                    card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_increase
                end
            end

            if found_debuff then
                return {
                    message = localize('k_upgrade_ex'),
                    message_card = card,
                    colour = G.C.FILTER
                }
            end
        end

        if context.other_joker and not context.blueprint then
            if context.other_joker.debuff then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_increase
                return {
                    message = localize('k_upgrade_ex'),
                    message_card = card,
                    colour = G.C.FILTER
                }
            end
        end

        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end                
}

SMODS.Joker {
    key = "horowitz",
    name = "The Pianist",
    config = { extra = { create = 1, create_inc = 1, to_play = 30, played = 0, create_cap = 12 } },
    pos = {
        x = 5,
        y = 3
    },
    rarity = 4,
    cost = 20,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = false,
    discovered = false,
    effect = nil,
    soul_pos = {
        x = 6,
        y = 3
    },
    atlas = "tb_joker", 
    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
        return { vars = {
            card.ability.extra.create,
            card.ability.extra.create_inc,
            card.ability.extra.to_play,
            card.ability.extra.played,
            card.ability.extra.create_cap
        }}
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.setting_blind then
            local get_rand_pool = function()
                local pools = { 'Tarot', 'Planet', 'Spectral' }
                return pseudorandom_element(pools, 'horowitz')
            end

            for i = 1, card.ability.extra.create do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        SMODS.add_card({
                            set = get_rand_pool(),
                            edition = 'e_negative'
                        })
                        card:juice_up()
                        return true
                    end
                }))
            end
        end

        if context.individual and context.cardarea == G.play and not context.blueprint then
            if not context.other_card.debuff and not (card.ability.extra.create >= card.ability.extra.create_cap) then
                card.ability.extra.played = card.ability.extra.played + 1

                if card.ability.extra.played >= card.ability.extra.to_play then
                    card.ability.extra.create = card.ability.extra.create + card.ability.extra.create_inc
                    card.ability.extra.played = 0

                    return {
                        message = localize('k_upgrade_ex'),
                        message_card = card,
                        colour = G.C.FILTER
                    }
                end
            end
        end
    end
}

SMODS.Joker {
    key = "seghisi",
    name = "The Bassist",
    config = { extra = { tags = 1, tag_increase = 1, to_skip = 3, skips = 0 } },
    pos = {
        x = 1,
        y = 4
    },
    rarity = 4,
    cost = 20,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = false,
    discovered = false,
    effect = nil,
    soul_pos = {
        x = 2,
        y = 4
    },
    atlas = "tb_joker",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.tags, card.ability.extra.tag_increase, card.ability.extra.to_skip, card.ability.extra.skips } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.skip_blind then
            card.ability.extra.skips = card.ability.extra.skips + 1

            for i = 1, card.ability.extra.tags do
                add_tag(Tag('tag_double'))
            end

            if not context.blueprint and card.ability.extra.skips == card.ability.extra.to_skip then
                card.ability.extra.skips = 0
                card.ability.extra.tags = card.ability.extra.tags + 1
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.FILTER
                }
            end
        end

        if context.setting_blind then
            local current_blind = G.GAME.blind:get_type()
            local b_tags = G.GAME.round_resets.blind_tags
            local tag_to_add = nil

            if current_blind == 'Small' then
                tag_to_add = Tag(b_tags.Small, false, current_blind)
            elseif current_blind == 'Big' then
                tag_to_add = Tag(b_tags.Big, false, current_blind)
            end


            if tag_to_add then
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 0.3,
                    func = function()
                        add_tag(tag_to_add)
                        return true
                    end
                }))
            end
        end
    end
}

SMODS.Joker {
    key = "federman",
    name = "The Drummer",
    config = {},
    pos = {
        x = 3,
        y = 4
    },
    rarity = 4,
    cost = 20,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = false,
    discovered = false,
    effect = nil,
    soul_pos = {
        x = 4,
        y = 4
    },
    atlas = "tb_joker",
    
    loc_vars = function(self, info_queue, card)
        if card.area and card.area == G.jokers then
            local joker1, joker2

            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then 
                    joker1 = G.jokers.cards[i - 1]
                    joker2 = G.jokers.cards[i + 1]
                end
            end

            local l_compatible = joker1 and joker1 ~= card and joker1.config.center.blueprint_compat
            local r_compatible = joker2 and joker2 ~= card and joker2.config.center.blueprint_compat

            main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "l", colour = l_compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (l_compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        },
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "r", colour = r_compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (r_compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
        end

        return { main_end = main_end }
    end,

    calculate = function(self, card, context) 
        if card.debuff then return nil end

        local joker1 = nil
        local joker2 = nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then
                joker1 = G.jokers.cards[i - 1]
                joker2 = G.jokers.cards[i + 1]
            end
        end

        return TB.federman_effect(card, joker1, joker2, context)
    end
}

SMODS.Joker {
    key = "cantor",
    name = "The Guitarist",
    config = { extra = { xmult = 1, xmult_increase = 0.5 } },
    pos = {
        x = 5,
        y = 4
    },
    rarity = 4,
    cost = 20,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = false,
    discovered = false,
    effect = nil,
    soul_pos = {
        x = 6,
        y = 4
    },
    atlas = "tb_joker",
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_increase } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.individual and context.cardarea == G.play and not context.blueprint then
            if context.other_card:is_face() and context.other_card:is_suit('Hearts') then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_increase

                return {
                    message = localize('k_upgrade_ex'),
                    message_card = card,
                    colour = G.C.FILTER
                }
            end
        end

        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}

SMODS.Joker {
    key = "karaca",
    name = "The Performer",
    config = { extra = { xmult = 1, xmult_increase = 0.34 } },
    pos = {
        x = 0,
        y = 2
    },
    rarity = 4,
    cost = 20,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = false,
    discovered = false,
    effect = nil,
    soul_pos = {
        x = 1,
        y = 2
    },
    atlas = "tb_joker_2",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult_increase, card.ability.extra.xmult } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end

        if context.end_of_round and context.cardarea == G.jokers and G.GAME.last_hand_played == 'High Card' and not context.blueprint then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_increase
            return {
                message = localize('k_upgrade_ex')
            }
        end
    end
}

SMODS.Joker {
    key = "shea",
    name = "The Stand In",
    config = { extra = { rounds_left = 2, odds = 3 } },
    pos = {
        x = 2,
        y = 2
    },
    rarity = 4,
    cost = 20,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = false,
    discovered = false,
    effect = nil,
    soul_pos = {
        x = 3,
        y = 2
    },
    atlas = "tb_joker_2",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.rounds_left, (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,

    calculate = function(self, card, context)
        if card.debuff and context.blueprint then return nil end

        if context.end_of_round and card.ability.extra.rounds_left > 0 and context.cardarea == G.jokers then
            local retmessage = nil

            card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1
            if card.ability.extra.rounds_left == 0 then
                juice_card_until(card, function() return not card.REMOVED end, true)
                retmessage = localize("k_active_ex")
            else
                retmessage = (2 - card.ability.extra.rounds_left).."/2"
            end

            return {
                message = retmessage
            }
        end

        if context.selling_self and card.ability.extra.rounds_left == 0 then
            if #G.jokers.cards <= G.jokers.config.card_limit then
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 0.3,
                    func = function()
                        local legendary_card = create_card("Joker", G.jokers, true)
                        G.jokers:emplace(legendary_card)
                        legendary_card:add_to_deck()
                        return true
                    end
                }))
            end

            if #G.jokers.cards <= G.jokers.config.card_limit and pseudorandom('shea_return') < G.GAME.probabilities.normal / card.ability.extra.odds then
                G.E_MANAGER:add_event(Event({
                    trigger = after,
                    delay = 0.3,
                    func = function()
                        local shea_copy = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_tb_shea")
                        G.jokers:emplace(shea_copy)
                        shea_copy:add_to_deck()
                        return true
                    end
                }))
            end
        end
    end
}