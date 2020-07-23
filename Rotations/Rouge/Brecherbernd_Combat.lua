local queue = {
	"Deadly Poison",
	"Stealth",
	"Ambush",
	"Revealing Strike",
	"Sinister Strike",
	"Slice and Dice",
	"Rupture",
	"Eviscerate",

};
local DeadlyPoision = GetSpellInfo(2823)
local Stealth = GetSpellInfo(1784)
local Ambush = GetSpellInfo(8676)
local RevealingStrike = GetSpellInfo(84617)
local SinisterStrike = GetSpellInfo(1752)
local SliceAndDice = GetSpellInfo(5171)
local Rupture = GetSpellInfo(1943)
local Eviscerate = GetSpellInfo(2098)

local abilities = {
	["Deadly Poision"] = function()
		if ni.spell.available(DeadlyPoision) then
			local how = ni.player.buffremaining(DeadlyPoision);
			if how <= 1 then
				ni.spell.cast(DeadlyPoision);
				return true;
			end
		end
	end,	


};
ni.bootstrap.rotation("Brecherbernd_Combat", queue, abilities)