--[[
Joe Hawley Joe Hawley (Common)
Joker retriggers all cards played in the previous round
]]--
SMODS.Joker{
    key = "joehawleyjoehawley",
    name = "Jow Hawley Joe Hawley",
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
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker",

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            if G.GAME.current_round.played_before and TB.is_in_table(G.GAME.current_round.played_before, context.other_card) and not card.debuff then
                return {
                    repetitions = card.ability.extra.repetitions
                }
            end
        end
    end
}

--[[
Purple Tie (Common)
Has a one in six chance to generate a purple seal on a played card
One in 4 chance for a purple seal to give an extra tarot
]]
SMODS.Joker{
    key = "purpletie",
    name = "Purple Tie",
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
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS['Purple']
        return { vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.seal_chance, card.ability.extra.tarot_chance } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        -- purple seal chance
        if context.before then
            if pseudorandom('tieseal') < G.GAME.probabilities.normal / card.ability.extra.seal_chance then
                local rand_card = pseudorandom_element(context.scoring_hand, 'tieseal_card')

                --Generate the actual purple seal
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
        if context.discard and context.other_card:get_seal() == 'Purple' and not context.other_card.debuff then
            if pseudorandom('tietarot') < G.GAME.probabilities.normal / card.ability.extra.tarot_chance and
                #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1

                --Create the tarot
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

                --Return an extra tarot message
                return {
                    message = localize('k_plus_tarot'),
                    colour = G.C.PURPLE,
                    message_card = card
                }
            end
        end
    end
}

--[[
English Chap (Common)
Retriggers the first played card of a given rank 3 additional times.
The rank changes every round.
]]
SMODS.Joker{
    key = "englishchap",
    name = "English Chap",
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
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker",

    loc_vars = function(self, info_queue, card)
        local chap_rank = G.GAME.current_round.english_chap_rank or { rank = 'Ace' }
        return { vars = { chap_rank.rank, 'ranks', card.ability.extra.retriggers } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end
        if context.repetition and context.cardarea == G.play then
            --Check for retriggerable cards
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

--[[
Spaghetti Bathtub (Common)
Gives xchips. Loses xchips per card played
]]
SMODS.Joker{
    key = "spaghettibathtub",
    name = "Spaghetti Bathtub",
    config = { extra = { xchips = 2, xchip_loss = 0.01, eaten = false }},
    pos = {
        x = 3,
        y = 0
    },
    rarity = 1,
    cost = 3,
    blueprint_compat = true,
    eternal_compat = false,
    unlocked = true,
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xchips, card.ability.extra.xchip_loss }}
    end,

    calculate = function(self, card, context)
        if card.debuff or card.ability.extra.eaten then return nil end

        if not context.blueprint and context.individual and context.cardarea == G.play then
            if card.ability.extra.xchips - card.ability.extra.xchip_loss <= 1 then
                --Destroy joker if xchips drops too low
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
                --remove xchips per played card
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

--[[
Zirconium Pants (Common)
Creates the Trance spectral when scoring a pair of zirconium cards
]]
SMODS.Joker {
    key = "zirconiumpants",
    name = "Zirconium Pants",
    config = { extra = { odds = 3, poker_hand = "Pair" } },
    pos = {
        x = 4,
        y = 0
    },
    rarity = 1,
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker",

    loc_vars = function(self, info_queue, card) 
        info_queue[#info_queue + 1] = G.P_CENTERS.e_tb_zirconium
        info_queue[#info_queue + 1] = G.P_CENTERS.c_trance
        return { vars = { G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.odds, card.ability.extra.poker_hand } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        --Check conditions for enacting effect
        if context.before and context.scoring_name == card.ability.extra.poker_hand and 
            pseudorandom('likehowidance') < G.GAME.probabilities.normal/card.ability.extra.odds then
            local all_zirc = true

            --Check editions of cards in scoring hand
            for _, pcard in ipairs(context.scoring_hand) do
                if pcard.edition then
                    if not pcard.edition.tb_zirconium then
                        all_zirc = false
                        break
                    end
                else
                    all_zirc = false
                    break
                end
            end

            --Generate the card if the scored hand was solely zirconium
            if all_zirc and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        trance_card = SMODS.add_card({
                            set = 'Spectral',
                            key = 'c_trance'
                        })
                        card:juice_up()
                        G.GAME.consumeable_buffer = 0
                        return true
                    end
                }))

                return {
                    message = localize('k_trance'),
                    colour = G.C.BLUE
                }
            end
        end
    end,

    in_pool = function(self, args)
        for _, card in ipairs(G.playing_cards) do
            if card.edition and card.edition.tb_zirconium then
                return true
            end
        end

        return false
    end
}

--[[
Natural Ketchup (Common)
Gives 20 mult. Loses 0.5 per discard.
]]
SMODS.Joker {
    key = "naturalketchup",
    name = "Natural Ketchup",
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
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_loss } }
    end,

    calculate = function(self, card, context)
        if card.debuff or card.ability.extra.eaten then return nil end

        if not context.blueprint and context.discard then
            if card.ability.extra.mult - card.ability.extra.mult_loss <= 0 then
                --Destroy card if mult drops too low
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
                --Decrease mult otherwise
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

--[[
Variations on a Cloud (Common)
Increases xchips payout whenever a hand of 2 stone cards is played
Starts at 1x and increases by 0.5x
]]
SMODS.Joker {
    key = "cloudvariations",
    name = "Variations on a Cloud",
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
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
        return { vars = { card.ability.extra.xchips_increase, card.ability.extra.xchips } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if not context.blueprint and context.before then
            --Check for stones
            local num_stone = 0
            for _, played_card in ipairs(G.play.cards) do
                if not played_card.debuff and SMODS.has_enhancement(played_card, 'm_stone') then
                    num_stone = num_stone + 1
                end
            end

            --If we have 2 stones, upgrade card.
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
    end,

    in_pool = function(self, args)
        stone_count = 0

        for _, card in ipairs(G.playing_cards) do
            if SMODS.has_enhancement(card, 'm_stone') then
                stone_count = stone_count + 1
            end
        end

        return stone_count >= 2
    end
}

--[[
Not a Trampoline (Common)
Gives +12 mult if played hand doesn't have gaps in rank
]]
SMODS.Joker {
    key = "notatrampoline",
    name = "Not a Trampoline",
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
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.before then
            --Copy poker hand to a dummy table as to not interfere with scoring anims
            local card_sorted = {}
            TB.copy_table(G.play.cards, card_sorted)

            --Sort by rank function
            local rank_sort = function(i, j)
                return i:get_id() > j:get_id()
            end
            table.sort(card_sorted, rank_sort)

            --Check for gaps
            card.ability.extra.no_gap = true
            for idx, _ in ipairs(card_sorted) do
                if card_sorted[idx + 1] and card_sorted[idx]:get_id() - card_sorted[idx + 1]:get_id() > 1 then
                    --Check for ace and two special case
                    if not (card_sorted[idx]:get_id() == 14 and card_sorted[#card_sorted]:get_id() == 2) then 
                        card.ability.extra.no_gap = false
                    end
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

--[[
Good and evil (Common)
Gives 84 chips and 82 mult.
Slowly loses chips and mult overtime.
]]
SMODS.Joker {
    key = "goodandevil",
    name = "Good and Evil",
    config = { extra = { chips = 84, chip_loss = 2, mult = 82, mult_loss = 1, hiatus = false } },
    pos = {
        x = 1,
        y = 1
    },
    rarity = 1,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = false,
    unlocked = true,
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.chip_loss, card.ability.extra.mult, card.ability.extra.mult_loss,} }
    end,

    calculate = function(self, card, context)
        if card.debuff or card.ability.extra.hiatus then return nil end

        local check_death = function()
            if card.ability.extra.mult - card.ability.extra.mult_loss <= 0 and
            card.ability.extra.chips - card.ability.extra.chip_loss <= 0 then
                --Destroy card if mult AND chips drop too low
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
                --Chip away at mult
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
                --Molt away the chips
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

--[[
Miss Melody (Common)
Gives +9 chips per played non-face card.
]]
SMODS.Joker {
    key = "missmelody",
    name = "Miss Melody",
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
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker",

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

SMODS.Joker {
    key = "twowuv",
    name = "Two Wuv",
    config = {},
    pos = {
        x = 0,
        y = 0
    },
    rarity = 1,
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker_2",

    calculate = function(self, card, context)
        if card.debuff or context.blueprint then return nil end

        if context.before and context.full_hand and #context.full_hand == 3 then
            local king_card = nil
            local queen_count = 0

            for _, pcard in ipairs(context.full_hand) do
                if pcard:get_id() == 12 then
                    queen_count = queen_count + 1
                elseif pcard:get_id() == 13 then
                    king_card = pcard
                end
            end

            if queen_count == 2 and king_card then
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 0.3,
                    func = function()
                        local enhancement = SMODS.poll_enhancement( { guaranteed = true } )
                        king_card:set_ability(G.P_CENTERS[enhancement], true, false)
                        card:juice_up()
                        return true
                    end
                }))
            end
        end

        if context.modify_scoring_hand then
            local add = false
            local queen_count = 0

            --we have to do the check seperately here
            if context.other_card:get_id() == 13 then
                for _, pcard in ipairs(context.full_hand) do
                    if pcard:get_id() == 12 then
                        queen_count = queen_count + 1
                    end
                end

                if queen_count == 2 then
                    add = true
                end
            end

            return {
               add_to_hand = add 
            }
        end
    end

}

SMODS.Joker {
    key = "edu",
    name = "edu",
    config = { extra = { mult = 11 } },
    pos = {
        x = 1,
        y = 0
    },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker_2",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 3 or context.other_card:get_id() == 8 then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    end
}

SMODS.Joker {
    key = "bananaman",
    name = "The Banana Man",
    config = { extra = { xmult = 1, xmult_increase = 0.5, cavendish_increase = 5, odds = 5 } },
    pos = {
        x = 2,
        y = 0
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = false,
    effect = nil,
    soul_pos = nil,
    atlas = "tb_joker_2",
    yes_pool_flag = 'gros_michel_extinct',

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue] = G.P_CENTERS['j_gros_michel']
        return {
            vars = {
                card.ability.extra.xmult_increase,
                card.ability.extra.xmult + (G.GAME and G.GAME.bananas_destroyed or 0) * card.ability.extra.xmult_increase 
                + (G.GAME and G.GAME.cavendish_destroyed or 0) * card.ability.extra.cavendish_increase,
                G.GAME and G.GAME.probabilities.normal or 1,
                card.ability.extra.odds,
            }
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        G.GAME.pool_flags.michel_in_pool = true
        G.GAME.force_banana = true
    end,

    calculate = function(self, card, context)
        if card.debuff then return nil end

        --Prevent bananaman from killing himself
        if context.card_added and context.card ~= card and not context.blueprint and
        pseudorandom('bananaman') < G.GAME.probabilities.normal / card.ability.extra.odds then
            local bought_card = context.card

            if bought_card.config.center.set == "Joker" and bought_card.config.center.name ~= 'Gros Michel' then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = '0.3',
                    blockable = false,
                    func = function()
                        SMODS.destroy_cards(bought_card, nil, true)
                        michel = create_card("joker", G.jokers, nil, nil, nil, nil, "j_gros_michel" )
                        michel:add_to_deck()
                        G.jokers:emplace(michel)
                        return true
                    end
                }))
            end
        end

        --Check for banana death, only for displaying an upgrade message
        if context.joker_type_destroyed then
            if context.card.config.center.name == 'Gros Michel' or context.card.config.center.name == 'Cavendish' then
                return {
                    message = localize('k_upgrade_ex')
                }
            end
        end

        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult + (G.GAME.bananas_destroyed * card.ability.extra.xmult_increase)
            }
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.GAME.pool_flags.michel_in_pool = false
        G.GAME.force_banana = false
    end,
}