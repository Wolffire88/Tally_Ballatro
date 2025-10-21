SMODS.Seal {
    key = "redtie",
    atlas = "ties",
    badge_colour = G.C.RED,
    config = {},
    pos = {
        x = 0,
        y = 0
    },
    unlocked = true,
    discovered = false,
}

SMODS.Seal {
    key = "bluetie",
    atlas = "ties",
    badge_colour = G.C.BLUE,
    config = { extra = { odds = 3 } },
    pos = {
        x = 1,
        y = 0
    },
    unlocked = true,
    discovered = false,

    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.seal.extra.odds } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.other_card == card and 
        pseudorandom('bluetie_chance') < G.GAME.probabilities.normal / card.ability.seal.extra.odds then
            local randtag = Tag(pseudorandom_element(G.P_TAGS, 'bluetie_tag').key, nil, nil)
            if randtag.name == "Orbital Tag" then
                local pokerhands = {}
                for k, v in pairs(G.GAME.hands) do
                    if v.visible then
                        pokerhands[#pokerhands + 1] = k
                    end
                end
                randtag.ability.orbital_hand = pseudorandom_element(pokerhands, 'bluetie_orbital')
            end

            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = "0.5",
                blockable = false,
                func = function()
                    card:juice_up()
                    play_sound('tarot1', 1, 1)
                    add_tag(randtag)
                    return true
                end
            }))
        end
    end
}

SMODS.Seal {
    key = "greentie",
    atlas = "ties",
    badge_colour = G.C.GREEN,
    config = { extra = { xmult = 1.2 } },
    pos = {
        x = 2,
        y = 0
    },
    unlocked = true,
    discovered = false,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.seal.extra.xmult } }
    end,

    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            local xmult_actual = card.ability.seal.extra.xmult ^ #G.consumeables.cards
            return {
                xmult = xmult_actual
            }
        end
    end
}

SMODS.Seal {
    key = "yellowtie",
    atlas = "ties",
    badge_colour = G.C.GOLD,
    config = { extra = { mult = 15 } },
    pos = {
        x = 0,
        y = 1
    },
    unlocked = true,
    discovered = false,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.seal.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            --No need to check every other card if this one is a heart
            if card:is_suit('Hearts', false, nil) then
                return {
                    mult = card.ability.seal.extra.mult
                }
            end

            --But in case it isn't
            for _, pcard in ipairs(context.scoring_hand) do
                if pcard:is_suit('Hearts', false, nil) then
                    return {
                        mult = card.ability.seal.extra.mult
                    }
                end
            end
        end
    end
}

SMODS.Seal {
    key = "graytie",
    atlas = "ties",
    badge_colour = G.C.GREY,
    config = { extra = { cards = {} } },
    pos = {
        x = 1,
        y = 1
    },
    unlocked = true,
    discovered = false,

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            card.ability.seal.extra.cards = {}
            for i=1, #context.cardarea.cards do
                if context.cardarea.cards[i] == card then
                    table.insert(card.ability.seal.extra.cards, context.cardarea.cards[i-1])
                    table.insert(card.ability.seal.extra.cards, context.cardarea.cards[i+1])
                end
            end

            if card.ability.seal.extra.cards[1] then
                local ret1 = {
                    card_eval_status_text(card.ability.seal.extra.cards[1], 'extra', nil, nil, nil, {
                        message = localize('k_again_ex'),
                        colour = G.C.FILTER,
                    }),
                    SMODS.score_card(card.ability.seal.extra.cards[1], {cardarea = context.cardarea, full_hand = context.full_hand, scoring_hand = context.scoring_hand, scoring_name = context.scoring_name, poker_hands = context.poker_hands})
                }
            end
            if card.ability.seal.extra.cards[2] then
                local ret2 = {
                    card_eval_status_text(card.ability.seal.extra.cards[2], 'extra', nil, nil, nil, {
                        message = localize('k_again_ex'),
                        colour = G.C.FILTER,
                    }),
                    SMODS.score_card(card.ability.seal.extra.cards[2], {cardarea = context.cardarea, full_hand = context.full_hand, scoring_hand = context.scoring_hand, scoring_name = context.scoring_name, poker_hands = context.poker_hands})
                }
            end

            if ret1 then
                if ret2 then
                    finalret = SMODS.merge_effects(ret1, ret2, context)
                else
                    finalret = ret1
                end
            elseif ret2 then
                finalret = ret2
            end

            if finalret then
                finalret.message_card = card
                return finalret
            end
        end
    end
}

--[[ I'll figure it out later
SMODS.Seal {
    key = "blacktie",
    atlas = "ties",
    badge_colour = HEX("101010"),
    config = { extra = { seals = { "Red", "Blue", "Gold", "Purple" }, current_seal = "Red", dummy_card = nil } },
    pos = {
        x = 2,
        y = 1
    },
    unlocked = true,
    discovered = false,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_SEALS[card.ability.seal.extra.current_seal]
        return { vars = { card.ability.seal.extra.current_seal.." seal" } }
    end,

    calculate = function(self, card, context)
        if context.after then
            print("we changin it up in here")
            card.ability.seal.extra.current_seal = pseudorandom_element(card.ability.seal.extra.seals, 'blacktie_seal')
            dummy_card = dummy_card or create_fake_card()
            dummy_card:set_seal(SMODS.poll_seal({guaranteed = true, options = { card.ability.seal.extra.current_seal }}))
        end
    end
}
]]

SMODS.Seal {
    key = "orangetie",
    atlas = "ties",
    badge_colour = G.C.ORANGE,
    config = { extra = { odds = 3 } },
    pos = {
        x = 0,
        y = 2
    },
    unlocked = true,
    discovered = false,

    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.seal.extra.odds } }
    end,

    calculate = function(self, card, context)
        if context.discard and context.other_card == card and 
        pseudorandom("orangetie_level") < G.GAME.probabilities.normal/card.ability.seal.extra.odds then
            SMODS.smart_level_up_hand(card, "High Card", false, 1)
        end
    end
}