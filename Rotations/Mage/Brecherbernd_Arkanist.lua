local queue = {
	"Arcane Brilliance",
  "Rune of Power",
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
local lastcast = 0

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

["Rune of Power"] = function()
      if ni.spell.available(runeofpower)
      and not ni.unit.buff("player", 116014, "player") 
      and GetTime() - lastcast > 4
			then lastcast = GetTime()
			ni.spell.castat(runeofpower, "player")
			return true;
		end
	end,
	
["Living Bomb"] = function()
		if ni.spell.available(livingbomb)
		and ni.unit.debuffremaining("target", "44461", "player") <= 2 then
			ni.spell.cast(livingbomb, "target")
			return true
		end
	end,
	
["Arcane Missiles"] = function() --Channelt noch nicht durch sondern castet erneut
	local arcanecharge, _, _, arcanecharge_stacks = ni.player.debuff(114664)
		if arcanecharge_stacks == 4
      and ni.unit.buff("player", "79683") 
      and not ni.unit.ischanneling("player") then
			ni.spell.cast(arcanemissiles, "target")
			return true
		end
	end,

["Arcane Barrage"] = function()
	local arcanecharge, _, _, arcanecharge_stacks = ni.player.debuff(114664)
    if arcanecharge_stacks == 4 
    and not ni.unit.ischanneling("player") then
			ni.spell.cast(arcanebarrage, "target")
			return true
		end
	end,
	
["Arcane Blast"] = function()
    if ni.spell.available(arcaneblast) 
      and not ni.unit.ischanneling("player") then
		   ni.spell.cast(arcaneblast, "target")
		   return true
	   end
   end,	

};
ni.bootstrap.rotation("Brecherbernd_Arkanist", queue, abilities)