SMODS.Atlas({
    key = "joehawleyjoehawley",
    path = "THJokers.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "purpletie",
    path = "THJokers.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "englishchap",
    path = "THJokers.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "spaghettibathtub",
    path = "THJokers.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "zirconiumpants",
    path = "THJokers.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "naturalketchup",
    path = "THJokers.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "cloudvariations",
    path = "THJokers.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "notatrampoline",
    path = "THJokers.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "goodandevil",
    path = "THJokers.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "missmelody",
    path = "THJokers.png",
    px = 71,
    py = 95
})


SMODS.Joker{
    key = "joehawleyjoehawley",
    config = { extra = { repetitions = 1 } },
    pos = {
        x = 0,
        y = 0
    },
    rarity = 1,
    cost = 3,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    effect = nil,
    soul_pos = nil,
    atlas = "joehawleyjoehawley",

    calculate = function(self, card, context)
        -- Set all cards to have not been played this round
        if context.setting_blind then
            for _, deck_card in ipairs(G.deck.cards) do
                deck_card.ability.JH_played_this_round = false
            end
        end

        if context.repetition and context.cardarea == G.play then
            context.other_card.ability.JH_played_this_round = true

            if context.other_card.ability.JH_played_before and not card.debuff then
                return {
                    repetitions = card.ability.extra.repetitions
                }
            end
        end

        if context.ending_shop then
            for _, deck_card in ipairs(G.deck.cards) do
                deck_card.ability.JH_played_before = deck_card.ability.JH_played_this_round
            end
        end
    end
}

SMODS.Joker{
    key = "purpletie",
    config = { extra = { seal_chance = 6, tarot_chance = 4}},
    pos = {
        x = 1,
        y = 0
    },
    rarity = 1,
    cost = 3,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    effect = nil,
    soul_pos = nil,
    atlas = "purpletie",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS['Purple']
        return { vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.seal_chance, card.ability.extra.tarot_chance } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        -- purple seal chance
        if context.before then
            if pseudorandom('tieseal') < G.GAME.probabilities.normal / card.ability.extra.seal_chance then
                local rand_card = pseudorandom_element(G.play.cards, 'tieseal_card')
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = '1.3',
                    blockable = false,
                    func = function()
                        rand_card:set_seal(SMODS.poll_seal({ guaranteed = true, options = { 'Purple' } }), true, false)
                        play_sound('gold_seal', 1.2, 0.4)
                        rand_card:juice_up()
                        return true
                    end
                }))

                card:juice_up()
            end
        end

        -- extra tarot chance
        if context.discard then
            if pseudorandom('tietarot') < G.GAME.probabilities.normal / card.ability.extra.tarot_chance and
                #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and
                context.other_card:get_seal() == 'Purple' and not context.other_card.debuff then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = '1.3',
                    blockable = false,
                    func = function()
                        SMODS.add_card { set = 'Tarot' }
                        card:juice_up()
                        G.GAME.consumeable_buffer = 0
                        return true
                    end
                }))

                return {
                    message = localize('k_plus_tarot'),
                    colour = G.C.PURPLE,
                    message_card = card
                }
            end
        end
    end
}

SMODS.Joker{
    key = "englishchap",
    config = { extra = { retriggers = 3 }},
    pos = {
        x = 2,
        y = 0
    },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    effect = nil,
    soul_pos = nil,
    atlas = "englishchap",

    loc_vars = function(self, info_queue, card)
        local chap_rank = G.GAME.current_round.english_chap_rank or { rank = 'Ace' }
        return { vars = { chap_rank.rank, 'ranks', card.ability.extra.retriggers } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end
        if context.repetition and context.cardarea == G.play then
            local is_retrigger_card = false
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == G.GAME.current_round.english_chap_rank.id and
                    not context.scoring_hand[i].debuff then
                    is_retrigger_card = context.scoring_hand[i] == context.other_card
                    break
                end
            end

            if is_retrigger_card then
                return {
                    repetitions = card.ability.extra.retriggers
                }
            end
        end
    end
}

SMODS.Joker{
    key = "spaghettibathtub",
    config = { extra = { xchips = 2, xchip_loss = 0.01, eaten = false }},
    pos = {
        x = 3,
        y = 0
    },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = false,
    unlocked = true,
    discovered = true,
    effect = nil,
    soul_pos = nil,
    atlas = "spaghettibathtub",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xchips, card.ability.extra.xchip_loss }}
    end,

    calculate = function(self, card, context)
        if card.debuff or card.ability.extra.eaten then return nil end

        if not context.blueprint and context.individual and context.cardarea == G.play then
            if card.ability.extra.xchips - card.ability.extra.xchip_loss <= 1 then
                card.ability.extra.eaten = true
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up()
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = '0.3',
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))

                return { 
                    message = localize('k_eaten_ex'),
                    message_card = card,
                    colour = G.C.FILTER
                }

            else
                card.ability.extra.xchips = card.ability.extra.xchips - card.ability.extra.xchip_loss

                return {
                    message = localize { type = 'variable', key = 'a_xchips_minus', vars = { card.ability.extra.xchip_loss } },
                    message_card = card,
                    colour = G.C.BLUE
                }
            end
        end

        if context.joker_main then
            return {
                xchips = card.ability.extra.xchips
            }
        end
    end
}

SMODS.Joker {
    key = "zirconiumpants",
    config = { extra = { odds = 6, poker_hand = "Pair" } },
    pos = {
        x = 4,
        y = 0
    },
    rarity = 1,
    cost = 3,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    effect = nil,
    soul_pos = nil,
    atlas = "zirconiumpants",

    loc_vars = function(self, info_queue, card) 
        info_queue[#info_queue + 1] = G.P_CENTERS.e_tb_zirconium
        return { vars = { G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.odds, card.ability.extra.poker_hand } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.before and context.scoring_name == card.ability.extra.poker_hand and 
            pseudorandom('likehowidance') < G.GAME.probabilities.normal/card.ability.extra.odds then
            local only_unscored = {}
            for _, pcard in ipairs(G.play.cards) do
                if not is_in_table(context.scoring_hand, pcard) then
                    table.insert(only_unscored, pcard)
                end
            end

            for _, unscored in ipairs(only_unscored) do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        unscored:set_edition("e_tb_zirconium", true)
                        return true
                    end
                }))
            end

            if only_unscored then
                return {
                    message = localize('k_zirconium'),
                    colour = G.C.FILTER
                }
            end
        end
    end
}

SMODS.Joker {
    key = "naturalketchup",
    config = { extra = { mult = 20, mult_loss = 0.5, eaten = false } },
    pos = {
        x = 5,
        y = 0
    },
    rarity = 1,
    cost = 3,
    blueprint_compat = true,
    eternal_compat = false,
    unlocked = true,
    discovered = true,
    effect = nil,
    soul_pos = nil,
    atlas = "naturalketchup",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_loss } }
    end,

    calculate = function(self, card, context)
        if card.debuff or card.ability.extra.eaten then return nil end

        if not context.blueprint and context.discard then
            if card.ability.extra.mult - card.ability.extra.mult_loss <= 0 then
                card.ability.extra.eaten = true

                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.03,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.FILTER
                }
            else
                card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_loss
                return {
                    message = localize { type = 'variable', key = 'a_mult_minus', vars = { card.ability.extra.mult_loss } },
                    colour = G.C.RED
                }
            end
        end

        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker {
    key = "cloudvariations",
    config = { extra = { xchips = 1, xchips_increase = 0.5 } },
    pos = {
        x = 6,
        y = 0
    },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    effect = nil,
    soul_pos = nil,
    atlas = "cloudvariations",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
        return { vars = { card.ability.extra.xchips_increase, card.ability.extra.xchips } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if not context.blueprint and context.before then
            local num_stone = 0
            for _, played_card in ipairs(G.play.cards) do
                if not played_card.debuff and SMODS.has_enhancement(played_card, 'm_stone') then
                    num_stone = num_stone + 1
                end
            end

            if num_stone == 2 then
                card.ability.extra.xchips = card.ability.extra.xchips + card.ability.extra.xchips_increase

                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIP,
                    message_card = card
                }
            end
        end

        if context.joker_main then
            return {
                xchips = card.ability.extra.xchips
            }
        end
    end
}

SMODS.Joker {
    key = "notatrampoline",
    config = { extra = { mult = 12, no_gap = true } },
    pos = {
        x = 0,
        y = 1
    },
    rarity = 1,
    cost = 3,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    effect = nil,
    soul_pos = nil,
    atlas = "notatrampoline",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.before then
            local copy_table = function(ts, td)
                for idx, item in pairs(ts) do
                    td[idx] = item
                end
            end

            local card_sorted = {}
            copy_table(G.play.cards, card_sorted)

            local rank_sort = function(i, j)
                return i:get_id() > j:get_id()
            end

            table.sort(card_sorted, rank_sort)

            card.ability.extra.no_gap = true
            for idx, _ in ipairs(card_sorted) do
                if card_sorted[idx + 1] and card_sorted[idx]:get_id() - card_sorted[idx + 1]:get_id() > 1 then
                    card.ability.extra.no_gap = false
                    break           -- We don't need to keep looking
                end
            end
        end

        if context.joker_main and card.ability.extra.no_gap then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker {
    key = "goodandevil",
    config = { extra = { chips = 84, chip_loss = 2, mult = 82, mult_loss = 1, hiatus = false } },
    pos = {
        x = 1,
        y = 1
    },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = false,
    unlocked = true,
    discovered = true,
    effect = nil,
    soul_pos = nil,
    atlas = "goodandevil",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.chip_loss, card.ability.extra.mult, card.ability.extra.mult_loss,} }
    end,

    calculate = function(self, card, context)
        if card.debuff or card.ability.extra.hiatus then return nil end

        local check_death = function()
            if card.ability.extra.mult - card.ability.extra.mult_loss <= 0 and
            card.ability.extra.chips - card.ability.extra.chip_loss <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))

                return true
            else
                return false
            end
        end

        if not context.blueprint and context.discard then
            if check_death() then
                card.ability.extra.hiatus = true
                
                return {
                    message = localize('k_hiatus'),
                    colour = G.C.FILTER
                }
            else
                if card.ability.extra.mult > 0 then
                    card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_loss
                    return {
                        message = localize { type = 'variable', key = 'a_mult_minus', vars = { card.ability.extra.mult_loss } },
                        colour = G.C.RED,
                        message_card = card
                    }
                end
            end
        end

        if not context.blueprint and context.individual and context.cardarea == G.play then
            if check_death() then
                card.ability.extra.hiatus = true
                
                return {
                    message = localize('k_hiatus'),
                    colour = G.C.FILTER
                }
            else
                if card.ability.extra.chips > 0 then
                    card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chip_loss
                    return {
                        message = localize { type = 'variable', key = 'a_chips_minus', vars = { card.ability.extra.chip_loss } },
                        colour = G.C.BLUE,
                        message_card = card
                    }
                end
            end
        end

        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker {
    key = "missmelody",
    config = { extra = { chips = 9 } },
    pos = {
        x = 2,
        y = 1
    },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    effect = nil,
    soul_pos = nil,
    atlas = "missmelody",

    loc_vars = function(self, info_queue, card) 
        return { vars = { card.ability.extra.chips } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.individual and context.cardarea == G.play then
            if not context.other_card:is_face() then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end
    end
}
