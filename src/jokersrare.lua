SMODS.Atlas({
    key = "hawaiitwo",
    path = sprite_path,
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "morewishes",
    path = sprite_path,
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "technicaldifficulties",
    path = sprite_path,
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "maryashley",
    path = sprite_path,
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "gallagher",
    path = sprite_path,
    px = 71,
    py = 95
})


SMODS.Joker {
    key = "hawaiitwo",
    config = { extra = { xmult = 1, xmult_increase = 0.5 } },
    pos = {
        x = 0,
        y = 2
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "hawaiitwo",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult_increase, card.ability.extra.xmult } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if not context.blueprint then
            local num_queens = 0
            if context.before then
                for _, pcard in ipairs(context.scoring_hand) do
                    if not pcard.debuff and pcard:get_id() == 12 then
                        num_queens = num_queens + 1
                    end
                end

                if num_queens > 0 then
                    card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_increase * num_queens

                    return {
                        message = localize('k_upgrade_ex'),
                        message_card = card,
                        colour = G.C.FILTER
                    }
                end
            end 

            if context.destroy_card and context.cardarea == G.play then
                if context.destroy_card:get_id() == 12 and not context.destroy_card.debuff then
                    return {
                        remove = true
                    } 
                end
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
    key = "morewishes",
    config = { extra = { current_card = nil, t_retrig = 0, highest = 0 } },
    pos = {
        x = 0,
        y = 3
    },
    rarity = 3,
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "morewishes",

    calculate = function(self, card, context)
        if card.debuff then return nil end

        -- Reset all values for the following hand
        if context.before then
            card.ability.extra.current_card = nil
            card.ability.extra.t_retrig = 0
            card.ability.extra.highest = 0
        end

        -- track retriggers by checking the current card
        if context.individual and context.cardarea == G.play then
            if card.ability.extra.current_card ~= context.other_card then
                card.ability.extra.t_retrig = 0
                card.ability.extra.current_card = context.other_card
            
            else
                card.ability.extra.t_retrig = card.ability.extra.t_retrig + 1

                if card.ability.extra.t_retrig > card.ability.extra.highest then
                    card.ability.extra.highest = card.ability.extra.t_retrig
                end
            end
        end

        -- scoring phase
        if context.joker_main then
            return {
                xmult = card.ability.extra.highest + 1
            }
        end
    end
}

SMODS.Joker {
    key = "technicaldifficulties",
    config = { extra = { xmult = 1, xmult_increase = 0.2, odds = 6 } },
    pos = {
        x = 1,
        y = 3
    },
    rarity = 3,
    cost = 9,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "technicaldifficulties",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_increase, G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.odds } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.before and not context.blueprint then
            local was_debuffed = false

            for _, pcard in ipairs(context.scoring_hand) do
                if pseudorandom('pleasestandby') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    SMODS.debuff_card(pcard, true, 'prevent_score')
                    card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_increase
                    was_debuffed = true
                end
            end

            if was_debuffed then
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

        if context.after then
            for _, pcard in ipairs(context.scoring_hand) do
                SMODS.debuff_card(pcard, false, 'prevent_score')
                SMODS.recalc_debuff(pcard)
            end
        end
    end
}

SMODS.Joker {
    key = "maryashley",
    config = { extra = { xmult = 3, num_queens = 0} },
    pos = {
        x = 2,
        y = 3
    },
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "maryashley",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end
        if context.before then card.ability.extra.num_queens = 0 end

        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 12 then
            card.ability.extra.num_queens = card.ability.extra.num_queens + 1
        end

        if context.joker_main and card.ability.extra.num_queens >= 2 then
            return {
                xmult = card.ability.extra.xmult
            }
        end
        
    end
}

SMODS.Joker {
    key = "gallagher",
    config = { extra = { odds = 4 } },
    pos = {
        x = 0,
        y = 4
    },
    rarity = 3,
    cost = 11,
    blueprint_compat = true,
    eternal_compat = false,
    unlocked = true,
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "gallagher",

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

        return { vars = { G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.odds }, main_end = main_end }
    end,

    calculate = function(self, card, context) 
        if card.debuff then return nil end

        if context.end_of_round and context.game_over == false and not context.blueprint and context.main_eval then
            if pseudorandom("definitely_legendary") < G.GAME.probabilities.normal/card.ability.extra.odds then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = '0.3',
                    blockable = false,
                    func = function()
                        card:start_dissolve()
                        return true
                    end
                }))

                return {
                    message = localize('k_left_ex'),
                    message_card = card,
                    colour = G.C.FILTER,
                    remove = true
                }
            else
                return {
                    message = localize('k_safe_ex'),
                    message_card = card,
                    colour = G.C.FILTER
                }
            end
        end

        local joker1 = nil
        local joker2 = nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then
                joker1 = G.jokers.cards[i - 1]
                joker2 = G.jokers.cards[i + 1]
            end
        end

        local ret1 = SMODS.blueprint_effect(card, joker1, context)
        local ret2 = SMODS.blueprint_effect(card, joker2, context)

        if ret1 then 
            ret1.colour = G.C.GREY 
        end
        if ret2 then 
            ret2.colour = G.C.GREY
        end

        -- works but I also don't know why
        if ret1 then
            if ret2 then
                return SMODS.merge_effects({ ret1, ret2 })      -- i hate merge effects
            else
                return ret1
            end
        elseif ret2 then
            return ret2
        end

        -- dunno why this doesn't work
        -- if ret1 or ret2 then
        --     print("Merged tables:")
        --     print(SMODS.merge_effects({ ret1, ret2 }))
        -- end

        -- return SMODS.merge_effects({ ret1, ret2 })
    end
}
