local queue = {
	"Dark Intent",
	"Agony",
	"Corruption",
	"Unstable Affliction",
	"Haunt",
	"Drain Soul",
	"Malefic Grasp"
	
};
local DarkIntent = GetSpellInfo(109773)
local Agony = GetSpellInfo(980)
local Corruption = GetSpellInfo(172)
local UnstableAffliction = GetSpellInfo(30108)
local Haunt = GetSpellInfo(48181)
local MaleficGrasp = GetSpellInfo(103103)
local Drainsoul = GetSpellInfo(1120)

local UnitAffectingCombat, UnitExists, UnitCastingInfo, UnitChannelInfo, UnitIsDeadOrGhost, UnitHealth, UnitHealthMax = UnitAffectingCombat, UnitExists, UnitCastingInfo, UnitChannelInfo, UnitIsDeadOrGhost, UnitHealth, UnitHealthMax;

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
		and ni.unit.debuffremaining("target", "131736", "player") <= 8
		then ni.spell.cast(UnstableAffliction, "target")
		return true
		end
	end,	

["Haunt"] = function()
		if ni.spell.available(Haunt)
		and ni.unit.debuff("target", "Corruption", "Agony", "131736", "player")
		and ni.unit.buff("player", "117198", "player") >= 4 --Soul Shards müssen anders gecodet werden
					then ni.spell.cast(Haunt, "target")
			return true
		end
	end,

["Drain Soul"] = function()
		if ni.spell.available(Drainsoul)
		and ni.unit.hp("target") <= 20
		then ni.spell.cast(Drainsoul, "target")
		return true
		end
	end,

["Malefic Grasp"] = function()
		if ni.spell.available(MaleficGrasp)
		and ni.unit.debuff("target", "Corruption", "Agony", "131736", "player") --Break channeling for Corruption/Agony but not Unstable Affliction.... / Further looking 
		and not ni.unit.debuff("target", "103103", "player")
		or ni.unit.debuff("target", "103103", "player") <= 0.25 -- (103103 is Malefic Grasp Debuff) - For higher uptime
		and ni.unit.debuff("target", "Corruption", "Agony", "131736", "player")
			then ni.spell.cast(MaleficGrasp, "target")
			return true
		end
	end,
	

};
ni.bootstrap.rotation("Brecherbernd_TheSuffering", queue, abilities)