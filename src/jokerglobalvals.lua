local function reset_chap_rank()
    G.GAME.current_round.english_chap_rank = { rank = 'Ace' }
    local valid_ranks = {}
    for _, playing_card in ipairs(G.playing_cards) do
        if not SMODS.has_no_rank(playing_card) then
            valid_ranks[#valid_ranks + 1] = playing_card
        end
    end

    local chap_rank = pseudorandom_element(valid_ranks, 'english_chap')
    if chap_rank then
        G.GAME.current_round.english_chap_rank.rank = chap_rank.base.value
        G.GAME.current_round.english_chap_rank.id = chap_rank.base.id
    end
end

local function reset_ross_suit()
    G.GAME.current_round.ross_suit = { suit = 'Spades' }
    local valid_suits = {}
    for _, playing_card in ipairs(G.playing_cards) do
        if not SMODS.has_no_suit(playing_card) then
            valid_suits[#valid_suits + 1] = playing_card
        end
    end

    local ross_suit = pseudorandom_element(valid_suits, 'lets_kill_ross')
    if ross_suit then
        G.GAME.current_round.ross_suit.suit = ross_suit.base.suit
    end
end

local function reset_tallymail_rank()
    G.GAME.current_round.tallymail = { rank = 'Ace' }
    local valid_ranks = {}
    for _, playing_card in ipairs(G.playing_cards) do
        if not SMODS.has_no_rank(playing_card) then
            valid_ranks[#valid_ranks + 1] = playing_card
        end
    end

    local tally_rank = pseudorandom_element(valid_ranks, 'tallymail')
    if tally_rank then
        G.GAME.current_round.tallymail.rank = tally_rank.base.value
        G.GAME.current_round.tallymail.id = tally_rank.base.id
    end
end

local function JH_lastplayed_check()
    G.GAME.current_round.played_before = {}
    for _, playing_card in ipairs(G.playing_cards) do
        if playing_card.ability.played_this_round then
            G.GAME.current_round.played_before[#G.GAME.current_round.played_before + 1] = playing_card
        end
    end
end

function SMODS.current_mod.reset_game_globals(run_start)
    if run_start and G.GAME then
        --Seperate flag for Gros Michel for use with bananaman
        G.GAME.bananas_destroyed = 0
        G.GAME.pool_flags.michel_in_pool = true
    end
    reset_chap_rank()
    reset_ross_suit()
    reset_tallymail_rank()
    JH_lastplayed_check()
end