-- Sprite sheet logic, Jokers As Neco Arc compatibality
sprite_path = ""
local neco = next(SMODS.find_mod("JokersAsNecoArc"))
if neco then
    sprite_path = "NecoHall.png"
else
    sprite_path = "THJokers.png"
end

-- Atlases
assert(SMODS.load_file("src/atlases.lua"))()

-- Jokers
assert(SMODS.load_file("src/jokerscommon.lua"))()
assert(SMODS.load_file("src/jokersuncommon.lua"))()
assert(SMODS.load_file("src/jokersrare.lua"))()
assert(SMODS.load_file("src/jokerslegendary.lua"))()

-- Consumables + Editions/Enchancements
assert(SMODS.load_file("src/misc.lua"))()

-- Seals
assert(SMODS.load_file("src/seals.lua"))()

-- Other files
assert(SMODS.load_file("src/jokerglobalvals.lua"))()
assert(SMODS.load_file("src/utilsfunctions.lua"))()
