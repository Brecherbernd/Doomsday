local spells = {
	AvengersShield = GetSpellInfo(31935),
	CrusaderStrike = GetSpellInfo(35395),
	Judgement = GetSpellInfo(20271),
}

local queue = {
	"crusader strike",
	"judgement",
	"avengers shield"

}
local abilities = {
	["crusader strike"] = function()
		if ni.spell.available(spells.CrusaderStrike) then
				ni.spell.cast(spells.CrusaderStrike, "target");
				return true;	
		end
	end,
	["judgement"] = function()
		if ni.spell.available(spells.Judgement) then
			ni.spell.cast(spells.Judgement, "target");
			return true;
		end
	end,
	["avengers shield"] = function()
		if ni.sepll.available(spells.AvengersShield) then
			ni.spell.cast(spells.AvengersShield, "target");
			return true;
		end
	end,
}
ni.bootstrap.rotation("Cata_Prot_Brecherbernd", queue, abilities, OnLoad, OnUnload);