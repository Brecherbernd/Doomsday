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
	BlessingOfMight	= GetSpellInfo(19740),
	ConcentrationAura = GetSpellInfo(19746),
	DevotionAura = GetSpellInfo(465),
	ResistanceAura = GetSpellInfo(19891),
	CrusaderAura = GetSpellInfo(32223),
	RetributionAura = GetSpellInfo(7294)
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
	{ type = "page", number = 2, text = "Healing Options" },
	{ type = "separator" },
	{ type = "entry", text = "Active Healing", enabled = true, key = "GroupHeal" },
	{ type = "entry", text = "Eternal Flame (Self)", enabled = true, value = 70, key = "EternalFlame" },
	{ type = "entry", text = "Word of Glory", enabled = true, value = 60, key = "WoG" },
	{ type = "entry", text = "Lay on Hands", enabled = true, value = 17, key = "LoH" },
	{ type = "entry", text = "Holy Prism", enabled = true, value = 32, key = "HolyPrism" },
	{ type = "entry", text = "Flash of Light", enabled = true, value = 70, key = "FoL" },
	{ type = "entry", text = "Healthstone", enabled = true, value = 25, key = "Healthstone" },
	{ type = "entry", text = "Selfless Healer", enabled = true, value = 60, key = "SelflessHealer" },
	{ type = "page", number = 3, text = "Utility Options" },
	{ type = "separator" },
	{ type = "entry", text = "Hand of Sacrifice", enabled = true, value = 35, key = "HandOfSac" },
	{ type = "entry", text = "Hand of Salvation", enabled = true, value = 80, key = "HandofSalv" },
	{ type = "entry", text = "Hand of Protection", enabled = true, value = 45, key = "HandOfProt" },
	{ type = "entry", text = "Hand of Freedom (Self)", enabled = false, key = "HandOfFreedom" },
	{ type = "entry", text = "Ardent Defender", enabled = true, value = 12, key = "ArdentDefender" },
	{ type = "page", number = 4, text = "Utility Options #2" },
	{ type = "separator" },
	{ type = "entry", text = "Divine Protection", enabled = false, value = 45, key = "DivineProtection" },
	{ type = "entry", text = "Guardian of Ancient Kings", enabled = false, value = 30, key = "GoAK" },
	{ type = "entry", text = "Sacred Shield", enabled = false, value = 100, key = "SacredShield" },
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
	"Aura",
	"Seal",
	"Blessings",
	"Pause",
	"Auto Target",
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

	["Aura"] = function()
		if not IsMounted() then
			if not ni.player.buff(spells.DevotionAura) then
				ni.spell.cast(spells.DevotionAura)
				return true
			end
		else
			if not ni.player.buff(spells.CrusaderAura) then
				ni.spell.cast(spells.CrusaderAura)
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
		if ni.spell.available(spells.Consecration) 
			and not ni.unit.ismoving("player") then
			ni.spell.cast(spells.Consecration)
			return true
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