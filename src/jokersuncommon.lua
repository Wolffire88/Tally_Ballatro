SMODS.Atlas({
    key = "mechanicalmuseum",
    path = "THJokers.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "bora",
    path = "THJokers.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "muckablucka",
    path = "THJokers.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "letskillross",
    path = "THJokers.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "hawaiitwo",
    path = "THJokers.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "rasins",
    path = "THJokers.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "hiddeninthesand",
    path = "THJokers.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "shialabeouf",
    path = "THJokers.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "rulerofeverything",
    path = "THJokers.png",
    px = 71,
    py = 95
})

SMODS.Atlas({
    key = "tallymail",
    path = "THJokers.png",
    px = 71,
    py = 95
})


SMODS.Joker {
    key = "mechanicalmuseum",
    config = {},
    pos = {
        x = 3,
        y = 1
    },
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    effect = nil,
    soul_pos = nil,
    atlas = "mechanicalmuseum",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_tb_mechanical
        return { vars = { localize { type = 'name_text', set = 'Enhanced', key = 'm_tb_mechanical' } } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.before and context.main_eval and not context.blueprint then 
            local highest_rank = nil

            for _, pcard in ipairs(context.scoring_hand) do
                if not highest_rank or pcard:get_id() > highest_rank:get_id() then
                    highest_rank = not SMODS.has_no_rank(pcard) and pcard or nil
                end
            end

            if highest_rank and not SMODS.has_enhancement(highest_rank, 'm_tb_mechanical') then
                highest_rank:set_ability('m_tb_mechanical', nil, true)

                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        highest_rank:juice_up()
                        card:juice_up()
                        return true
                    end
                }))
            end
        end
    end
}

SMODS.Joker {
    key = "bora",
    config = { extra = { xmult = 3, is_active = false, timestamp = os.time() } },
    pos = {
        x = 4,
        y = 1
    },
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    effect = nil,
    soul_pos = nil,
    atlas = "bora",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.is_active and 'active' or 'inactive' }}
    end,

    calculate = function(self, card, context)
        if card.debuff then
            card.ability.extra.is_active = false
            return nil
        end

        if context.first_hand_drawn and not context.blueprint then
            local eval = function() return card.ability.extra.is_active and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end

        if context.setting_blind then
            card.ability.extra.timestamp = os.time()
        end

        if context.joker_main and G.GAME.current_round.hands_played == 0 and card.ability.extra.is_active then
            return {
                xmult = card.ability.extra.xmult
            }
        end

        if context.end_of_round then
            card.ability.extra.is_active = false
        end
    end,

    update = function(self, card, dt)
        card.ability.extra.is_active = (
            os.time() - card.ability.extra.timestamp <= 15 and 
            G.GAME.current_round.hands_played == 0
        )
    end
}

SMODS.Joker {
    key = "muckablucka",
    config = {},
    pos = {
        x = 5,
        y = 1
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    effect = nil,
    soul_pos = nil,
    atlas = "muckablucka",

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.joker_main then
            local get_smallest = function(hand)
                local sort = {}
                for idx, pcard in ipairs(hand) do
                    sort[idx] = pcard
                end
                table.sort(sort, function(i, j) return i:get_id() < j:get_id() end)
                return sort[1]
            end

            local lowest_rank = get_smallest(context.scoring_hand)
            local rank_chips = lowest_rank:get_chip_bonus()

            if not lowest_rank.debuff then
                return {
                    dollars = rank_chips
                }
            else
                return {
                    message = localize('k_debuffed'),
                    message_card = lowest_rank,
                    colour = G.C.RED
                }
            end
        end
    end
}

SMODS.Joker {
    key = "letskillross",
    config = { extra = { xchips = 1, xchips_increase = 0.2 } },
    pos = {
        x = 6,
        y = 1
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    effect = nil,
    soul_pos = nil,
    atlas = "letskillross",

    loc_vars = function(self, info_queue, card)
        local ross_suit = G.GAME.current_round.ross_suit or { suit = 'Spades' }
        return { vars = { localize(ross_suit.suit, 'suits_singular'), card.ability.extra.xchips_increase, card.ability.extra.xchips, colours = { G.C.SUITS[ross_suit.suit] } } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.remove_playing_cards and not context.blueprint then
            local suit_match = 0
            for _, rm_card in ipairs(context.removed) do
                if rm_card:is_suit(G.GAME.current_round.ross_suit.suit) and not rm_card.debuff then
                    suit_match = suit_match + 1
                end
            end

            if suit_match > 0 then
                card.ability.extra.xchips = card.ability.extra.xchips + (suit_match * card.ability.extra.xchips_increase)
                return {
                    message = localize { type = 'variable', key = 'a_xchips', vars = { card.ability.extra.xchips } },
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
    discovered = true,
    effect = nil,
    soul_pos = nil,
    atlas = "hawaiitwo",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult_increase, card.ability.extra.xmult } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.before then
            local num_queens = 0
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

        if context.destroy_card and context.cardarea == G.play and not context.blueprint then
            if context.destroy_card:get_id() == 12 and not context.destroy_card.debuff then
                return {
                    remove = true
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
    key = "rasins",
    config = { extra = { xmult = 2, triggers = 10 } },
    pos = {
        x = 1,
        y = 2
    },
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = false,
    unlocked = true,
    discovered = true,
    effect = nil,
    soul_pos = nil,
    atlas = "rasins",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.triggers } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.individual and context.cardarea == G.play then
            local rasin_card = nil
            local temp_rank, temp_mult = 15, 15
            for _, pcard in ipairs(context.scoring_hand) do
                if temp_rank > pcard:get_id() and not SMODS.has_no_rank(pcard) then
                    temp_mult = pcard:get_nominal()
                    temp_rank = pcard:get_id()
                    rasin_card = pcard
                end
            end
            
            if rasin_card == context.other_card then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED
                    }

                else
                    return {
                        xmult = card.ability.extra.xmult
                    }
                end
            end
        end

        if context.after and context.main_eval and not context.blueprint then
            card.ability.extra.triggers = card.ability.extra.triggers - 1

            if card.ability.extra.triggers == 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.15,
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
                return {
                    message = localize { type = 'variable', key = 'a_remaining', vars = { card.ability.extra.triggers } }
                }
            end
        end
    end
}

SMODS.Joker {
    key = "hiddeninthesand",
    config = { extra = { mult = 0 } },
    pos = {
        x = 2,
        y = 2
    },
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    effect = nil,
    soul_pos = nil,
    atlas = "hiddeninthesand",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.before and not context.blueprint then
            local rand_card = pseudorandom_element(G.hand.cards, 'HITS')

            if not rand_card.debuff then
                card.ability.extra.mult = card.ability.extra.mult + 2 * id_to_rank(rand_card:get_id())

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    blockable = false,
                    func = function()
                        rand_card:start_dissolve()
                        return true
                    end
                }))

                return {
                    message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
                    colour = G.C.RED
                }
            else
                return {
                    message = localize('k_debuffed'),
                    message_card = rand_card,
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
    key = "shialabeouf",
    config = {},
    pos = {
        x = 3,
        y = 2
    },
    rarity = 2,
    cost = 5,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    effect = nil,
    soul_pos = nil,
    atlas = "shialabeouf",

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.destroy_card and context.cardarea == G.play and not context.blueprint and
            context.destroy_card == context.scoring_hand[#context.scoring_hand] and not SMODS.has_no_rank(context.destroy_card) then
            if not context.destroy_card.debuff then
                local card_rank = id_to_rank(context.destroy_card:get_id())

                return {
                    dollars = card_rank,
                    remove = true
                }
            else
                return {
                    message = localize('k_debuffed'),
                    message_card = context.destroy_card,
                    colour = G.C.RED,
                    remove = false
                }
            end    
        end
    end
}

SMODS.Joker {
    key = "rulerofeverything",
    config = { extra = { odds = 3 } },
    pos = {
        x = 4,
        y = 2
    },
    rarity = 2,
    cost = 5,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    effect = nil,
    soul_pos = nil,
    atlas = "rulerofeverything",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_tb_zirconium
        return { vars = { G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.odds } } 
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        -- Placeholder
        if context.joker_main and G.GAME.probabilities.normal/card.ability.extra.odds then
            local all_zirc = true

            for _, pcard in ipairs(context.scoring_hand) do
                if not pcard.edition and not pcard.edition.tb_zirconium then
                    all_zirc = false
                    break
                end
            end

            if all_zirc and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        SMODS.create_card({
                            set = 'Spectral'
                        })
                        card:juice_up()
                        return true
                    end
                }))
                
                return {
                    message = localize('k_tarot')
                }
            end
        end
    end
}

SMODS.Joker {
    key = "tallymail",
    config = { extra = { xmult = 1, xmult_increase = 0.1 } },
    pos = {
        x = 5,
        y = 2
    },
    rarity = 2,
    cost = 5,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    effect = nil,
    soul_pos = nil,
    atlas = "tallymail",

    loc_vars = function(self, info_queue, card)
        local tally_rank = G.GAME.current_round.tallymail or { rank = 'Ace' } 
        return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_increase, tally_rank.rank } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.discard and not context.other_card.debuff and not context.blueprint and
            context.other_card:get_id() == G.GAME.current_round.tallymail.id then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_increase

            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult } },
                colour = G.C.RED
            }
        end

        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}