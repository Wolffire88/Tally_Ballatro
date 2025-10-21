-- Removing Neco arc compatibality for now
--[[
filename = ""
local neco = next(SMODS.find_mod("JokersAsNecoArc"))
if neco then
    filename = "NecoHall"
else
    filename = "THJokers"
end
]]--
filename = "THJokers"

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
assert(SMODS.load_file("src/utils.lua"))()
