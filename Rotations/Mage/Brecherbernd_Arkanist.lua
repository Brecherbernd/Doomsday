local queue = {
	"Rune of Power",
	"Arcane Brilliance",
	"Living Bomb",
	"Arcane Missiles",
	"Arcane Barrage",
	"Arcane Blast"
};

local runeofpower = GetSpellInfo(116011)
local arcanebrilliance = GetSpellInfo(1459)
local livingbomb = GetSpellInfo(44457)
local arcanemissiles = GetSpellInfo(5143);
local arcanebarrage = GetSpellInfo(44425);
local arcaneblast = GetSpellInfo(30451);

local abilities = {
["Arcane Brilliance"] = function()
		if ni.spell.available(arcanebrilliance) then
			local how = ni.player.buffremaining(arcanebrilliance);
			if how <= 1 then
				ni.spell.cast(arcanebrilliance);
				return true;
			end
		end
	end,	

--Rune of Power doesnt cast
--	["Rune of Power"] = function()
--		if ni.spell.available(runeofpower) then
--			ni.spell.castat("player", "runeofpower")
--			return true;
--		end
--	end,
	
["Living Bomb"] = function()
		if ni.spell.available(livingbomb)
		and ni.unit.debuffremaining("target", "44461", "player") <= 2 then
			ni.spell.cast(livingbomb, "target")
			return true
		end
	end,
	
["Arcane Missiles"] = function()
	local arcanecharge, _, _, arcanecharge_stacks = ni.player.debuff(114664)
		if arcanecharge_stacks == 4
		and ni.unit.buff("player", "79683")
		and ni.spell.available(arcanemissiles) then
			ni.spell.cast(arcanemissiles, "target")
			return true
		end
	end,

["Arcane Barrage"] = function()
	local arcanecharge, _, _, arcanecharge_stacks = ni.player.debuff(114664)
		if arcanecharge_stacks == 4 then
			ni.spell.cast(arcanebarrage, "target")
			return true
		end
	end,
	
["Arcane Blast"] = function()
		if ni.spell.available(arcaneblast) then
		   ni.spell.cast(arcaneblast, "target")
		   return true
	   end
   end,	

};
ni.bootstrap.rotation("Brecherbernd_Arkanist", queue, abilities)