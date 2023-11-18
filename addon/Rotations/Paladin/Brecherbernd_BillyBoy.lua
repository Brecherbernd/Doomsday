---Credits to Scizzydo for the base of this rotation
local spells = {
	AvengersShield = GetSpellInfo(31935),
	CrusaderStrike = GetSpellInfo(35395),
	Judgement = GetSpellInfo(20271),
	ShieldOfTheRighteous = GetSpellInfo(53600),
	HammerOfWrath = GetSpellInfo(24275),
	Consecration = GetSpellInfo(26573),
	HolyWrath = GetSpellInfo(2812),
	HammerOfTheRighteous = GetSpellInfo(53595),
	SealOfInsight =	GetSpellInfo(20165),
	SealOfRighteousness =  GetSpellInfo(20154),
	SealOfTruth = GetSpellInfo(31801),
	BlessingOfKings	= GetSpellInfo(20217),
	BlessingOfMight	= GetSpellInfo(19740) 
}

local items = {
	settingsfile = "Brecherbernd_BillyBoy.json",
	{ type = "title", text = "Billy Boy by |cffF58CBABrecherbernd" },
	{ type = "separator" },
	{ type = "page", number = 1, text = "|cffFFFF00Main Settings" },
	{ type = "separator" },
	{ type = "entry", text = "Cast Seal", enabled = true, key = "Seal" },
	{ type = "dropdown", menu = {
		{ selected = true, value = 1, text = "|cffFF0066Auto" },
		{ selected = false, value = 2, text = "|cffFFFF33Truth" },
		{ selected = false, value = 3, text = "|cffFF9900Insight" },
		{ selected = false, value = 4, text = "|cff24E0FBRighteousness" },
	}, key = "ActiveSeal" },
	{ type = "separator" },
	{ type = "entry", text = "Auto Blessing", enabled = true, key = "Blessing" },
	{ type = "dropdown", menu = {
		{ selected = true, value = 1, text = "|cffFF0066Auto" },
		{ selected = false, value = 2, text = "|cff24E0FBKings" },
		{ selected = false, value = 3, text = "|cffFF9900Might" },
	}, key = "ActiveBlessing" },
	{ type = "separator" },
	-------------------
	{ type = "page", number = 2, text = "|cffFFFF00Utility" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..select(3, GetSpellInfo(759))..":26:26\124t Mana Gem", tooltip = "Conjure Mana Gem", enabled = true, key = "ConjureManaGem" },
	{ type = "entry", text = "\124T"..GetItemIcon(36799)..":26:26\124t Use Mana Gem < MP%", tooltip = "Mana Gem", enabled = true, value = 50, key = "managem" },
};
 
 
local function GetSetting(name)
    for k, v in ipairs(items) do
        if v.type == "entry"
         and v.key ~= nil
         and v.key == name then
            return v.value, v.enabled
        end
        if v.type == "dropdown"
         and v.key ~= nil
         and v.key == name then
            for k2, v2 in pairs(v.menu) do
                if v2.selected then
                    return v2.value
                end
            end
        end
        if v.type == "input"
         and v.key ~= nil
         and v.key == name then
            return v.value
        end
    end
end;
local function OnLoad()
	ni.GUI.AddFrame("Brecherbernd_BillyBoy", items);
end
local function OnUnLoad()  
	ni.GUI.DestroyFrame("Brecherbernd_BillyBoy");
end	

local function GetSeal()
	local seal = GetSetting("ActiveSeal")
	if seal == 1 then
		return spells.SealOfTruth
	elseif seal == 2 then
		return spells.SealOfRighteousness
	elseif seal == 3 then
		return spells.SealOfInsight
	elseif seal == 4 then
		return spells.SealOfRighteousness
	end
end

local queue = {
	"Pause",
	"Auto Target",
	"Seal",
	"Blessings",
	"ShieldOfTheRighteous",
	"HammerOfRighteous",
	"AvengersShield",
	"HammerofWrath",
	"Judgement",
	"Consecration",
	"HolyWrath"
}

local abilities = {
	["Pause"] = function()
		if not UnitExists("target")
		 or (UnitExists("target")
		 and (not UnitCanAttack("player", "target")
		 or UnitIsDeadOrGhost("target")))
		 or UnitChannelInfo("player")
		 or UnitIsDeadOrGhost("player")
		 or IsMounted()
		 or delayrotation then
			return true;
		end
	end,

	["Auto Target"] = function()
		if UnitAffectingCombat("player")
		 and ((ni.unit.exists("target")
		 and UnitIsDeadOrGhost("target")
		 and not UnitCanAttack("player", "target")) 
		 or not ni.unit.exists("target")) then
			ni.player.runtext("/targetenemy")
		end
	end,

	["Seal"] = function()
		local seal = GetSeal()
		if seal and not ni.player.buff(seal) then
			ni.spell.cast(seal)
			return true
		end
	end,

	["Blessings"] = function()
		local blessing = GetSetting("ActiveBlessing")
		if blessing == 1 then
			if not ni.player.buff(spells.BlessingOfKings) then
				ni.spell.cast(spells.BlessingOfKings)
				return true
			end
		elseif blessing == 2 then
			if not ni.player.buff(spells.BlessingOfKings) then
				ni.spell.cast(spells.BlessingOfKings)
				return true
			end
		elseif blessing == 3 then
			if not ni.player.buff(spells.BlessingOfMight) then
				ni.spell.cast(spells.BlessingOfMight)
				return true
			end
		end
	end,

	["HammerOfRighteous"] = function()
		if ni.spell.available(spells.HammerOfTheRighteous) then
			ni.spell.cast(spells.HammerOfTheRighteous, "target")
			return true
		end
	end,

	["ShieldOfTheRighteous"] = function()
		if ni.spell.available(spells.ShieldOfTheRighteous) and ni.player.powerraw("holy") >= 3 then
				ni.spell.cast(spells.ShieldOfTheRighteous, "target");
				return true;
			end
		end,

	["HammerOfWrath"] = function()
		if ni.spell.available(spells.HammerOfWrath)
			and ni.unit.hp("target") <= 20 then
			ni.spell.cast(spells.HammerOfWrath, "target");
			return true;
		end
	end,

	["Consecration"] = function()
		if ni.spell.available(spells.Consecration) then
			ni.spell.cast(spells.Consecration);
			return true;
		end
	end,

	["HolyWrath"] = function()
		if ni.spell.available(spells.HolyWrath) then
			ni.spell.cast(spells.HolyWrath);
			return true;
		end
	end,
	
	["AvengersShield"] = function()
		if ni.spell.available(spells.AvengersShield) then
			ni.spell.cast(spells.AvengersShield, "target");
			return true;
		end
	end,

	["Judgement"] = function()
		if ni.spell.available(spells.Judgement) then
			ni.spell.cast(spells.Judgement, "target");
			return true;
		end
	end,

}
ni.bootstrap.profile("Brecherbernd_BillyBoy", queue, abilities, OnLoad, OnUnLoad);	