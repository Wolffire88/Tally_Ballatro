SMODS.Joker {
    key = "mechanicalmuseum",
    name = "Mechanical Museum",
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
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker",

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
    name = "15 Seconds of Bora",
    config = { extra = { xmult = 3, is_active = false, timestamp = os.time() } },
    pos = {
        x = 4,
        y = 1
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker",

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
    name = "Mucka Blucka",
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
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker",

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
    name = "These are my last words",
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
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker",

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
    key = "miraclemusical",
    name = "Miracle Musical",
    config = { extra = { xmult = 1, xmult_increase = 0.25, retriggers = 1 } },
    pos = {
        x = 6,
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
    atlas = "tb_joker",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
        return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_increase } }
    end,
    
    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.repetition and context.other_card.edition and context.other_card.edition.polychrome and not context.other_card.debuff then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_increase

            return {
                repetitions = card.ability.extra.retriggers
            }
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
    name = "Rasins",
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
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.triggers } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.individual and context.cardarea == G.play then
            local rasin_card = nil
            local temp_rank = 15
            for _, pcard in ipairs(context.scoring_hand) do
                if temp_rank > pcard:get_id() and not SMODS.has_no_rank(pcard) then
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
    name = "Hidden in the Sand",
    config = { extra = { mult = 0 } },
    pos = {
        x = 2,
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
    atlas = "tb_joker",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.before and not context.blueprint then
            local rand_card = pseudorandom_element(G.hand.cards, 'HITS')

            if not rand_card or SMODS.has_no_rank(rand_card) then return end

            if not rand_card.debuff then
                card.ability.extra.mult = card.ability.extra.mult + TB.id_to_rank(rand_card:get_id())

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    blockable = false,
                    func = function()
                        SMODS.destroy_cards(rand_card, nil, true)
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
    name = "Actual Cannibal Shia LaBeouf!",
    config = {},
    pos = {
        x = 3,
        y = 2
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker",

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.destroy_card and context.cardarea == G.play and not context.blueprint and
            context.destroy_card == context.scoring_hand[#context.scoring_hand] and not SMODS.has_no_rank(context.destroy_card) then
            if not context.destroy_card.debuff then
                local card_rank = TB.id_to_rank(context.destroy_card:get_id())

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
    name = "The Ruler of Everything",
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
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_tb_zirconium
        return { vars = { G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.odds } } 
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.joker_main and G.GAME.probabilities.normal/card.ability.extra.odds then
            local unscored = {}

            for _, pcard in ipairs(context.full_hand) do
                if not TB.is_in_table(context.scoring_hand, pcard) then
                    table.insert(unscored, pcard)
                end
            end

            for _, us_card in ipairs(unscored) do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        us_card:set_edition("e_tb_zirconium", true)
                        return true
                    end
                }))
            end

            if unscored then
                return {
                    message = localize('k_zirconium'),
                    coloug = G.C.FILTER
                }
            end
        end
    end
}

SMODS.Joker {
    key = "tallymail",
    name = "Tally Mail",
    config = { extra = { xmult = 1, xmult_increase = 0.1 } },
    pos = {
        x = 5,
        y = 2
    },
    rarity = 2,
    cost = 7,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker",

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

SMODS.Joker {
    key = "wholeworld",
    name = "The Whole World",
    config = { extra = { xmult_rate = 0.4, xmult = 1, spades = {} } },
    pos = {
        x = 3,
        y = 0
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker_2",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult_rate } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.before and context.full_hand and not context.blueprint then
            for _, pcard in ipairs(context.scoring_hand) do
                if pcard:is_suit("Spades") and not pcard.debuff then
                    table.insert(card.ability.extra.spades, pcard)
                end
            end

            if card.ability.extra.spades then 
                card.ability.extra.xmult = 1 + #card.ability.extra.spades * card.ability.extra.xmult_rate
            end
        end

        if context.after and card.ability.extra.spades and not context.blueprint then
            SMODS.destroy_cards(card.ability.extra.spades)

            card.ability.extra.spades = {}
        end

        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}

SMODS.Joker {
    key = "impressions",
    name = "29 Impressions, 1 Joker",
    config = { extra = { copy_card = nil } },
    pos = {
        x = 0,
        y = 1
    },
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker_2",

    loc_vars = function(self, info_queue, card)
        return { vars = { (card.ability.extra.copy_card and card.ability.extra.copy_card.config.center.name or "None") } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.setting_blind then
            local valid_cards = {}

            for _, jonkler in ipairs(G.jokers.cards) do
                if jonkler ~= card and jonkler.config.center.blueprint_compat then
                    table.insert(valid_cards, jonkler)
                end
            end

            if valid_cards then
                card.ability.extra.copy_card = pseudorandom_element(valid_cards, 'perfect')
            end
        end

        if card.ability.extra.copy_card then
            return SMODS.blueprint_effect(card, card.ability.extra.copy_card, context)
        end
    end,

    set_ability = function(self, card, initial, delay_sprites)
        local valid_cards = {}

        if G.jokers then
            for _, jonkler in ipairs(G.jokers.cards) do
                if jonkler ~= card and jonkler.config.center.blueprint_compat then
                    table.insert(valid_cards, jonkler)
                end
            end
        end

        if valid_cards then
            card.ability.extra.copy_card = pseudorandom_element(valid_cards, 'perfect')
        end
    end
}

SMODS.Joker {
    key = "tapes",
    name = "Tapes",
    config = { extra = { chips = 9 } },
    pos = {
        x = 1,
        y = 1
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker_2",

    calculate = function(self, card, context)   
        if card.debuff or context.blueprint then return nil end

        if context.before and G.hand then
            local unscored = {}

            for _, pcard in ipairs(context.full_hand) do
                if not TB.is_in_table(context.scoring_hand, pcard) then
                    table.insert(unscored, pcard)
                end
            end

            local num_cards = #unscored
            SMODS.destroy_cards(unscored, nil, true)

            local hand_copy = {}
            TB.copy_table(G.hand.cards, hand_copy)

            for i=1, num_cards, 1 do
                if hand_copy then
                    local tie_card = table.remove(hand_copy, math.random(#hand_copy))

                    if tie_card and not tie_card:get_seal() then
                        tie_card:set_seal(SMODS.poll_seal( { key = 'tieseal', guaranteed = true, options = TB.TIES} ))
                    else
                        i = i - 1 --go back because invalid card
                    end
                end
            end
        end
    end
}