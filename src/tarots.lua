-- Tarots
SMODS.Consumable {
    key = "cog",
    set = "Tarot",
    config = { max_highlighted = 1, mod_conv = "m_tb_mechanical"},
    pos = {
        x = 0,
        y = 0
    },
    unlocked = true,
    discovered = false,
    atlas = "tb_consum",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end
}

SMODS.Consumable {
    key = "doctorate",
    set = "Tarot",
    config = { extra = { dollars = 5 } },
    pos = {
        x = 1,
        y = 0
    },
    unlocked = true,
    discovered = false,
    atlas = "tb_consum",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars } }
    end,

    use = function(self, card, area, copier)
        local tiecards = {}
        local bluecards = {}
        for _, hcard in ipairs(G.hand.cards) do
            if TB.is_in_table(TB.TIES, hcard:get_seal()) then
                if hcard:get_seal() == "tb_bluetie" then
                    table.insert(bluecards, hcard)
                else
                    table.insert(tiecards, hcard)
                end
            end
        end

        local total_dollars = (card.ability.extra.dollars * 2 * #bluecards) + (card.ability.extra.dollars *  #tiecards) 

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                card:juice_up()
                ease_dollars(total_dollars, true)
                return true
            end
        }))

        delay(0.5)
    end,

    can_use = function(self, card)
        return G.hand and #G.hand.cards > 0
    end
}

SMODS.Consumable {
    key = "mashup",
    set = "Tarot",
    config = { max_highlighted = 2 },
    pos = {
        x = 2,
        y = 0
    },
    unlocked = true,
    discovered = false,
    atlas = "tb_consum",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,

    use = function(self, card, area, copier)
        local card1 = G.hand.highlighted[1]
        local card2 = G.hand.highlighted[2]

        local cardtable = {
            set = "Base",
            area = G.hand,
            rank = card2.base.value,
            suit = card1.base.suit
        }

        --get edition
        local c1_ed = card1.edition and card1.edition.key
        local c2_ed = card2.edition and card2.edition.key

        if c1_ed == c2_ed then
            cardtable.edition = c1_ed
        elseif c1_ed then
            if c2_ed and (G.P_CENTERS[c2_ed].order > G.P_CENTERS[c1_ed].order) then
                cardtable.edition = c2_ed
            else
                cardtable.edition = c1_ed
            end
        elseif c2_ed then
            cardtable.edition = c2_ed
        end

        --get enhancement
        local c1_en = (card1.ability.set == "Enhanced") and card1.config.center.key
        local c2_en = (card2.ability.set == "Enhanced") and card2.config.center.key

        if c1_en == c2_en then
            cardtable.enhancement = c1_en
        elseif c1_en then
            if c2_en and (G.P_CENTERS[c2_en].order > G.P_CENTERS[c1_en].order) then
                cardtable.enhancement = c2_en
            else
                cardtable.enhancement = c1_en
            end
        elseif c2_en then
            cardtable.enhancement = c2_en
        end

        --get seal
        local c1_s = card1:get_seal() 
        local c2_s = card2:get_seal()

        if c1_s == c2_s then
            cardtable.seal = c1_s
        elseif c1_s then
            if c2_s and (G.P_CENTERS[c2_s].order > G.P_CENTERS[c1_s].order) then
                cardtable.seal = c2_s
            else
                cardtable.seal = c1_s
            end
        elseif c2_s then
            cardtable.seal = c2_s
        end

        --Additional stuff
        nominal_chips = card1.ability.perma_bonus + card2.ability.perma_bonus
        nominal_mult = card1.ability.perma_mult + card2.ability.perma_mult
        nominal_xchips = card1.ability.perma_x_chips + card2.ability.perma_x_chips      -- These ones aren't used by tally mod and are here for cross compatibility
        nominal_xmult = card1.ability.perma_x_mult + card2.ability.perma_x_mult
        held_chips = card1.ability.perma_h_chips + card2.ability.perma_h_chips
        held_mult = card1.ability.perma_h_mult + card2.ability.perma_h_mult
        held_xchips = card1.ability.perma_h_x_chips + card2.ability.perma_h_x_chips
        held_xmult = card1.ability.perma_h_x_mult + card2.ability.perma_h_x_mult

        --FUSION DANCE
        local fusion = SMODS.create_card(cardtable)
        fusion.ability.perma_mult = nominal_mult or 0
        fusion.ability.perma_bonus = nominal_chips or 0
        fusion.ability.perma_x_mult = nominal_xmult or 0
        fusion.ability.perma_x_chips = nominal_xchips or 0
        fusion.ability.perma_h_mult = held_mult or 0
        fusion.ability.perma_h_chips = held_chips or 0
        fusion.ability.perma_h_x_mult = held_xmult or 0
        fusion.ability.perma_h_x_chips = held_xchips or 0
        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
        fusion.playing_card = G.playing_card
        table.insert(G.playing_cards, fusion)
        G.hand:emplace(fusion)
        G.GAME.blind:debuff_card(fusion)
        fusion:add_to_deck()

        --Kill the main cards
        SMODS.destroy_cards({card1, card2})

        delay(0.5)
    end
}

SMODS.Consumable {
    key = "lady",
    set = "Tarot",
    config = { max_highlighted = 4 },
    pos = {
        x = 3,
        y = 0
    },
    unlocked = true,
    discovered = false,
    atlas = "tb_consum",

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,

    use = function(self, card, area, copier)
        for idx = 1, #G.hand.highlighted do
            local percent = 1.15 - (idx - 0.999) / (#G.hand.highlighted - 0.998) * 0.3

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[idx]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[idx]:juice_up()
                    return true
                end
            }))
        end

        for idx = 1, #G.hand.highlighted do
            local to_change = nil
            local ladycard = G.hand.highlighted[idx]

            if ladycard:is_suit('Hearts') then to_change = 'Spades' end
            if ladycard:is_suit('Spades') then to_change = 'Hearts' end
            if ladycard:is_suit('Diamonds') then to_change = 'Clubs' end
            if ladycard:is_suit('Clubs') then to_change = 'Diamonds' end

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    if to_change then
                        SMODS.change_base(ladycard, to_change)
                    end
                    return true
                end
            }))
        end

        for idx = 1, #G.hand.highlighted do
            local percent = 0.85 + (idx - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[idx]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.highlighted[idx]:juice_up()
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
    end
}