local spells = {
	AvengersShield = GetSpellInfo(31935),
	CrusaderStrike = GetSpellInfo(35395),
	Judgement = GetSpellInfo(20271),
	ShieldOfTheRighteous = GetSpellInfo(53600),
	HammerOfWrath = GetSpellInfo(24275),
	Consecration = GetSpellInfo(26573),
	HolyWrath = GetSpellInfo(2812),
	HammerOfTheRighteous = GetSpellInfo(53595)
}

local queue = {
	"Pause",
	"Targeting",
--	"ShieldOfTheRighteous",
	"HammerOfRighteous",
--	"CrusaderStrike",
	"AvengersShield",
	"HammerOfWrath",
	"Judgement",
	"Consecration",
	"HolyWrath"
}

local abilities = {
	["Pause"] = function()
		if IsMounted()
				and not ni.player.buff(spells.CrusaderAura.id)
				and not UnitIsDeadOrGhost("player") then
			ni.spell.cast(spells.CrusaderAura.name)
			return true;
		end
		if IsMounted()
				or UnitIsDeadOrGhost("player")
				or ni.player.ischanneling()
				or ni.player.iscasting()
				or ni.unit.isimmune("target")
				or UnitInVehicle("player")
		then
			return true;
		end
	end,

	["Cache"] = function()
		if GetTime() - AntiAFKTime > 80 then
			ni.utils.resetlasthardwareaction();
			AntiAFKTime = GetTime();
		end

		-- Alysrazor START
		if ni.unit.buff("player", 97128) then
			Cache.moving = false
		else
			Cache.moving = ni.player.ismoving() or false
		end
		-- Alyzrazor END
		Cache.guid = UnitGUID("target") or nil
		Cache.AOE = ni.vars.combat.aoe or false
		Cache.CD = ni.vars.combat.cd or false
		Cache.targets = ni.unit.enemiesinrange("target", 10) or {}
		Cache.PlayerControled = (ni.player.issilenced()
					or ni.player.isstunned()
					or ni.player.isconfused()
					or ni.player.isfleeing())
				or false;
		Cache.PlayerCombat = ni.player.incombat() or false;
		Cache.members = ni.members or {}
		if #Cache.members > 0 then
			table.sort(Cache.members, SortByHP)
		end
		Cache.holypower = ni.player.powerraw("holy") or 0
		Cache.mana = ni.player.power(0) or 0
		Cache.rawmana = ni.player.powerraw(0) or 0
	end,

	["HammerOfRighteous"] = function()
		if ni.spell.available(spells.HammerOfTheRighteous) then
			ni.spell.cast(spells.HammerOfTheRighteous, "target");
			return true;
		end
	end,
	
	["CrusaderStrike"] = function()
		if ni.spell.available(spells.CrusaderStrike) then
			ni.spell.cast(spells.CrusaderStrike, "target");
			return true;
		end
	end,

	["ShieldOfTheRighteous"] = function()
		if ni.spell.available(spells.ShieldOfTheRighteous)
			and Cache.holypower >= 3 then
			ni.spell.cast(spells.ShieldOfTheRighteous, "target");
			return true;
		end
	end,

	["HammerOfWrath"] = function()
		if ni.spell.available(spells.HammerOfWrath) then
			ni.spell.cast(spells.HammerOfWrath, "target");
			return true;
		end
	end,

	["Consecration"] = function()
		if ni.spell.available(spells.Consecration) 
			and not ni.unit.ismoving("player")	then
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

ni.bootstrap.rotation("Cata_Prot_Brecherbernd", queue, abilities, OnLoad, OnUnload);