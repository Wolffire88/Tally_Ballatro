SMODS.Joker {
    key = "hawaiitwo",
    name = "Hawaii Pt.2",
    config = { extra = { xmult = 1, xmult_increase = 0.25 } },
    pos = {
        x = 0,
        y = 2
    },
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult_increase, card.ability.extra.xmult } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if not context.blueprint then
            local num_queens = 0

            -- Remove all queens from the scoring hand
            if context.modify_scoring_hand then
                if not context.other_card.debuff and context.other_card:get_id() == 12 then
                    context.other_card.to_destroy = true
                    return {
                        remove_from_hand = true
                    }
                end
            end

            -- Count and destroy all queens marked for destruction, then upgrade the joker
            if context.before then
                for _, pcard in ipairs(context.full_hand) do
                    if pcard.to_destroy then
                        pcard.to_destroy = nil
                        num_queens = num_queens + 1
                        SMODS.destroy_cards(pcard, nil, true)
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
        end

        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,

    in_pool = function(self, args)
        for _, card in ipairs(G.playing_cards) do
            if card:get_id() == 12 then
                return true
            end
        end

        return false
    end
}


SMODS.Joker {
    key = "morewishes",
    name = "More Wishes",
    config = { extra = { current_card = nil, t_retrig = 0, highest = 0 } },
    pos = {
        x = 0,
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
    atlas = "tb_joker",

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
    name = "Technical Difficulties",
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
    atlas = "tb_joker",

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
    name = "The Ad Twins",
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
    atlas = "tb_joker",

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
        
    end,

    in_pool = function(self, args)
        queen_count = 0

        for _, card in ipairs(G.playing_cards) do
            if card:get_id() == 12 then
                queen_count = queen_count + 1
            end
        end

        return queen_count >= 2
    end
}

SMODS.Joker {
    key = "gallagher",
    name = "The Drummer?",
    config = { extra = { odds = 3 } },
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

        return TB.federman_effect(card, joker1, joker2, context)
    end
}

SMODS.Joker {
    key = "boralogue",
    name = "Boralogue",
    config = { extra = { bora_rank = 1, xmult = 1, xmult_increase = 1, xmult_cap = 13 } },
    pos = {
        x = 2,
        y = 1
    },
    rarity = 3,
    cost = 9,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker_2",

    loc_vars = function(self, info_queue, card)
        return { vars = { 
            TB.to_roman[card.ability.extra.bora_rank], 
            card.ability.extra.xmult, 
            card.ability.extra.xmult_increase, 
            card.ability.extra.xmult_cap 
        }}
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end

        if context.end_of_round and context.beat_boss and not context.blueprint and 
        card.ability.extra.xmult < card.ability.extra.xmult_cap and context.cardarea == G.jokers then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_increase
            card.ability.extra.bora_rank = card.ability.extra.xmult

            return {
                message = localize('k_upgrade_ex')
            }
        end
    end
}

SMODS.Joker {
    key = "dreamjournal",
    name = "Dream Journal",
    config = { extra = { 
        --Main
        dream_effect = 0, 

        --Zubin
        chips = 91, 

        --Rob
        xmult = 1.2,

        --Joe
        emult = 2, 
        echips = 0.5, 

        --Ross
        poker_hand = "High Card", 

        --Andrew
        permamult = 9,
        randcard = nil
    } },
    pos = {
        x = 3,
        y = 1
    },
    rarity = 3,
    cost = 10,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker_2",

    loc_vars = function(self, info_queue, card)
        local EffectTable = {
            { set = "Other", key = "tb_d_ross", specific_vars = {card.ability.extra.poker_hand} },
            { set = "Other", key = "tb_d_rob", specific_vars = {card.ability.extra.xmult} },
            { set = "Other", key = "tb_d_joe", specific_vars = {card.ability.extra.echips, card.ability.extra.emult} },
            { set = "Other", key = "tb_d_andrew", specific_vars = {card.ability.extra.permamult} },
            { set = "Other", key = "tb_d_zubin", specific_vars = {card.ability.extra.chips} },
            { set = "Other", ley = "tb_d_none" }
        }

        info_queue[#info_queue + 1] = EffectTable[card.ability.extra.dream_effect] or EffectTable[6]
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.end_of_round and context.main_eval and not context.blueprint then
            local previous = card.ability.extra.dream_effect
            while previous == card.ability.extra.dream_effect do
                card.ability.extra.dream_effect = math.floor((pseudorandom('dreamjournal') * 5) + 1)
            end

            if card.ability.extra.dream_effect == 1 then
                local pokerhand = {}
                for handname, _ in pairs(G.GAME.hands) do
                    if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
                        pokerhand[#pokerhand + 1] = handname
                    end
                end
                card.ability.extra.poker_hand = pseudorandom_element(pokerhand, 'DJ_pokerhand')
            end
            
            return {
                message = localize('k_reset')
            }
        end

        local ret = nil
        if card.ability.extra.dream_effect == 1 then
            ret = TB.DreamJournal.Ross(card, context)

        elseif card.ability.extra.dream_effect == 2 then
            ret = TB.DreamJournal.Rob(card, context)

        elseif card.ability.extra.dream_effect == 3 then
            ret = TB.DreamJournal.Joe(card, context)

        elseif card.ability.extra.dream_effect == 4 then
            ret = TB.DreamJournal.Andrew(card, context)

        elseif card.ability.extra.dream_effect == 5 then
            ret = TB.DreamJournal.Zubin(card, context)

        end

        if ret then return ret end

    end,

    set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra.dream_effect = math.floor((pseudorandom('dreamjournal') * 5) + 1)
    end
}

SMODS.Joker {
    key = "stars",
    name = "Fate of the Stars",
    config = {},
    pos = {
        x = 4,
        y = 1
    },
    rarity = 3,
    cost = 8,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker_2",

    loc_vars = function(self, info_queue, card) 
        info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
    end,

    calculate = function(self, card, context)
        if card.debuff or context.blueprint then return nil end

        if context.before then
            if not TB.is_in_table(TB.POKERHANDS, context.scoring_name) then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.3,
                    func = function()
                        card:juice_up()
                        return true
                    end
                }))

                editionless = {}
                for _, hcard in ipairs(G.hand.cards) do
                    if not hcard.edition then
                        table.insert(editionless, hcard)
                    end
                end

                to_edition = pseudorandom_element(editionless, "fatedstars")
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.3,
                    func = function()
                        if to_edition then
                            to_edition:set_edition("e_negative", true)
                        end
                        return true
                    end
                }))
            end
        end
    end
}

SMODS.Joker {
    key = "mindelectric",
    name = "The Mind Electric",
    config = {},
    pos = {
        x = 4,
        y = 0
    },
    rarity = 3,
    cost = 10,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker_2",

    calculate = function(self, card, context)
        if nil then print("lmao this card fucking sucks") end   --comment with extra steps amirite chat?
    end
}