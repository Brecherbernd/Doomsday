local queue = {
	"Dark Intent",
	"Agony",
	"Corruption",
	"Unstable Affliction",
	"Malefic Grasp"
};
local DarkIntent = GetSpellInfo(109773);
local Agony = GetSpellInfo(980);
local Corruption = GetSpellInfo(172);
local UnstableAffliction = GetSpellInfo(30108);
local MaleficGrasp = GetSpellInfo(103103);

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
		and ni.unit.debuffremaining("target", "Agony", "player") < 17 then
		ni.spell.cast(Agony, "target")
		return true
		end
	end,
	
["Corruption"] = function()
		if ni.spell.available(Corruption)
		and ni.unit.debuffremaining("target", "Corruption", "player") < 13
		then ni.spell.cast(Corruption, "target")
		return true
		end
	end,

["Unstable Affliction"] = function()
		if ni.spell.available(UnstableAffliction)
		and ni.unit.debuffremaining("target", "UnstableAffliction", "player") < 2
		then ni.spell.cast(UnstableAffliction, "target")
		return true
		end
	end,	

["MaleficGrasp"] = function()
		if ni.spell.available(MaleficGrasp)
		and ni.unit.debuff("target", "Corruption", "player")
		and ni.unit.debuff("target", "UnstableAffliction", "player")
		and ni.unit.debuff("target", "Agony", "player")
		then ni.spell.cast(UnstableAffliction, "target")
		return true
		end
	end,	
};
ni.bootstrap.rotation("Brecherbernd_Affliction", queue, abilities)