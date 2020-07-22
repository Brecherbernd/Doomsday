local queue = {
	"Dark Intent",
	"Agony",
	"Corruption",
	"Unstable Affliction",
	"Haunt",
	"Malefic Grasp"
};
local DarkIntent = GetSpellInfo(109773)
local Agony = GetSpellInfo(980)
local Corruption = GetSpellInfo(172)
local UnstableAffliction = GetSpellInfo(30108)
local Haunt = GetSpellInfo(48181)
local MaleficGrasp = GetSpellInfo(103103)

local abilities = {
	["Dark Intent"] = function()
		if ni.spell.available(DarkIntent) then
			local how = ni.player.buffremaining(DarkIntent);
			if how <= 1 then
				ni.spell.cast(DarkIntent);
				return true;
			end
		end
	end,	

["Agony"] = function()
		if ni.spell.available(Agony)
		and ni.unit.debuffremaining("target", "Agony", "player") <= 17 
		then ni.spell.cast(Agony, "target")
		return true
		end
	end,
	
["Corruption"] = function()
		if ni.spell.available(Corruption)
		and ni.unit.debuffremaining("target", "Corruption", "player") <= 13
		then ni.spell.cast(Corruption, "target")
		return true
		end
	end,

["Unstable Affliction"] = function()
		if ni.spell.available(UnstableAffliction)
		and ni.unit.debuffremaining("target", "131736", "player") <= 2
		then ni.spell.cast(UnstableAffliction, "target")
		return true
		end
	end,	

["Haunt"] = function()
		if ni.spell.available(Haunt)
		and ni.unit.debuffremaining("target", "48181", "player") <= 3
			or ni.unit.debuff("target", "Corruption", "player") <=8
				and ni.unit.debuff("target", "131736", "player") <=8
				and ni.unit.debuff("target", "Agony", "player") <=8
		and ni.unit.buff("player", "17941", "player")	
		then ni.spell.cast(Haunt, "target")
		return true
		end
	end,	

["Malefic Grasp"] = function()
		if ni.spell.available(MaleficGrasp)
		and ni.unit.debuff("target", "Corruption", "player")
		and ni.unit.debuff("target", "131736", "player")
		and ni.unit.debuff("target", "Agony", "player")
		and not ni.unit.debuff("target", "103103", "player")
		then ni.spell.cast(MaleficGrasp, "target")
		return true
		end
	end,	
};
ni.bootstrap.rotation("Brecherbernd_Affliction", queue, abilities)