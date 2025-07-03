-- "{C:money} money{}, {C:chips} chips{}, {C:mult} mult{}, {C:red} red{}, {C:blue} blue{}, {C:green} green{}",
-- "{C:attention} attention{}, {C:purple} purple{}, {C:inactive} inactive{}",
-- "{C:spades} spades{}, {C:hearts} hearts{}, {C:clubs} clubs{}, {C:diamonds} diamonds{}",
-- "{C:tarot} tarot{}, {C:planet} planet{}, {C:spectral} spectral{}",
-- "{C:edition} edition{}, {C:dark_edition} dark edition{}, {C:legendary} legendary{}, {C:enhanced} enhanced{}",

-- Jokers
assert(SMODS.load_file("src/jokerscommon.lua"))()
assert(SMODS.load_file("src/jokersuncommon.lua"))()
assert(SMODS.load_file("src/jokersrare.lua"))()
assert(SMODS.load_file("src/jokerslegendary.lua"))()

-- Consumables + Editions/Enchancements
assert(SMODS.load_file("src/misc.lua"))()

-- Other files
assert(SMODS.load_file("src/jokerglobalvals.lua"))()
assert(SMODS.load_file("src/utilsfunctions.lua"))()
