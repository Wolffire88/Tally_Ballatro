if not TB then
    TB = {}
end

TB.config = SMODS.current_mod.config
TB.prefix = SMODS.current_mod.prefix

TB.copy_table = function(ts, td)
    for idx, item in pairs(ts) do
        td[idx] = item
    end
end

--Convert a card ID to a numerical rank
TB.id_to_rank = function(rank, acehigh)
    if rank <= 10 then return rank end
    if rank > 10 and rank < 14 then return 10 end
    if rank == 14 then 
        if acehigh then return 11 else return 1 end
    end
end

--Basic table search function
TB.is_in_table = function(table, item)
    for _, t in ipairs(table) do
        if item == t then
            return true
        end
    end

    return false
end

TB.reverse_table = function(tb)
    if not tb then return nil end

    for i = 1, math.floor(#tb/2), 1 do
        tb[i], tb[#tb - i + 1] = tb[#tb - i + 1], tb[i]
    end
end

TB.concat_tables = function(t1, t2)
    t_copy = {}
    TB.copy_table(t1, t_copy)
    for _, v in ipairs(t2) do
        t_copy[#t_copy + 1] = v
    end
    return t_copy
end

--Blueprint but complicated
TB.federman_effect = function(card, j1, j2, context)
    -- Federman cannot copy itself or it ends the universe
    local ret1 = j1 and j1 ~= card and SMODS.blueprint_effect(card, j1, context)
    local ret2 = j2 and j2 ~= card and SMODS.blueprint_effect(card, j2, context)

    if ret1 then 
        ret1.colour = G.C.GREY 
    end
    if ret2 then 
        ret2.colour = G.C.GREY
    end

    if ret1 then
        if ret2 then
            return SMODS.merge_effects({ ret1, ret2 })      -- i hate merge effects
        else
            return ret1
        end
    elseif ret2 then
        return ret2
    end
end

--Roman numerals
TB.to_roman = {
    "I",
    "II",
    "III",
    "IV",
    "V",
    "VI",
    "VII",
    "VIII",
    "IX",
    "X",
    "XI",
    "XII",
    "XIII",
}

--List of Ties
TB.TIES = {
    "tb_redtie",
    "tb_yellowtie",
    "tb_greentie",
    "tb_bluetie",
    "tb_graytie",
    "tb_orangetie"
}

--List of standard poker hands
TB.POKERHANDS = {
    "Straight Flush",
    "Four of a Kind",
    "Full House",
    "Flush",
    "Straight",
    "Three of a Kind",
    "Two Pair",
    "Pair",
    "High Card"
}

TB.DreamJournal = {
    Ross = function(card, context)
        if context.before and context.scoring_name == card.ability.extra.poker_hand then
            local randcard = pseudorandom_element(context.scoring_hand, 'DJ_tiecard')
            randcard:set_seal(SMODS.poll_seal({ guaranteed = true, options = {"tb_graytie"} }))
            card:juice_up()
        end
    end,

    Rob = function(card, context)
        if context.individual and next(SMODS.get_enhancements(context.other_card)) and context.cardarea == G.play then
            return {
                xmult = 1.2
            }
        end
    end,

    Joe = function(card, context)
        if context.joker_main then
            return {
                echips = 0.5,
                emult = 2
            }
        end
    end,

    Andrew = function(card, context)
        if context.before and context.cardarea == G.jokers and context.scoring_hand then
            card.ability.extra.randcard = pseudorandom_element(context.scoring_hand, "DJ_andrew")

            card.ability.extra.randcard.ability.perma_mult = card.ability.extra.randcard.ability.perma_mult or 0
            card.ability.extra.randcard.ability.perma_mult = card.ability.extra.randcard.ability.perma_mult + card.ability.extra.permamult

            return {
                message = localize("k_upgrade_ex"),
                message_card = card.ability.extra.randcard
            }
        end

        if context.repetition and context.cardarea == G.play then
            if context.other_card == card.ability.extra.randcard then
                return {
                    repetitions = 1
                }
            end
        end
    end,

    Zubin = function(card, context)
        if context.joker_main then
            return {
                chips = 91
            }
        end
    end
}

--Add funny exponentation so we don't have to rely on Talisman, but don't do it if Talisman is already here.
if not next(SMODS.find_mod('Talisman')) then
    local calc = SMODS.calculate_individual_effect
    SMODS.calculate_individual_effect = function(effect, scored_card, key, amount, from_edition)
        local default = calc(effect, scored_card, key, amount, from_edition)
        if default then return default end

        if key == "emult" and amount ~= 1 then
            if effect.card then juice_card(effect.card) end

            local mult = SMODS.Scoring_Parameters["mult"]
            mult:modify(mult.current ^ amount - mult.current)

            if not effect.remove_default_message then
                if from_edition then
                    card_eval_status_text(scored_card, "Joker", nil, percent, nil, {message = "^"..amount..localize("k_mult"), colour = G.C.EDITION, edition = true})
                elseif effect.emult_message then
                    card_eval_status_text(scored_card or effect.card or effect.focus, "extra", nil, percent, nil, effect.emult_message)
                else
                    card_eval_status_text(scored_card or effect.card or effect.focus, "e_mult", amount, percent)
                end
            end

        end

        if key == "echips" and amount ~= 1 then
            if effect.card then juice_card(effect.card) end

            local chips = SMODS.Scoring_Parameters["chips"]
            chips:modify(chips.current ^ amount - chips.current)

            if not effect.remove_default_message then
                if from_edition then
                    card_eval_status_text(scored_card, "Joker", nil, percent, nil, {message = "^"..amount, colour = G.C.EDITION, edition = true})
                elseif effect.echip_message then
                    card_eval_status_text(scored_card or effect.card or effect.focus, "extra", nil, percent, nil, effect.echip_message)
                else
                    card_eval_status_text(scored_card or effect.card or effect.focus, "e_chips", amount, percent)
                end
            end
        end
    end

    for _, v in ipairs({"echips", "emult"}) do
        table.insert(SMODS.scoring_parameter_keys or SMODS.calculation_keys, v)
    end
end

-- The Mind Electric compatability
local calc_main = SMODS.calculate_main_scoring
SMODS.calculate_main_scoring = function(context, scoring_hand)
    if next(find_joker('The Mind Electric')) and scoring_hand and context.cardarea.cards then
        TB.reverse_table(context.cardarea.cards)

        preserve = context.cardarea
        calc_main(context, scoring_hand)

        if context.cardarea == "unscored" then  --I don't know why it does this
            context.cardarea = preserve         --this undoes it
        end

        TB.reverse_table(context.cardarea.cards)
    end
    
    calc_main(context, scoring_hand)
end