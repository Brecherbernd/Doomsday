local select, GetSpellInfo, ipairs, pairs, GetZoneText, GetInstanceInfo, GetTime, tonumber, IsUsableSpell, IsSpellKnown, IsSpellInRange, UnitExists, UnitCanAttack, GetTotemInfo, wipe, IsMounted, UnitInVehicle, UnitIsDeadOrGhost, UnitChannelInfo, UnitCastingInfo, IsCurrentSpell, GetWeaponEnchantInfo, GetInventoryItemID, BindEnchant, GetItemInfo, IsEquippedItemType, GetItemSpell, GetActionInfo, GetTotemTimeLeft, UnitName, UnitIsEnemy =
		select, GetSpellInfo, ipairs, pairs, GetZoneText, GetInstanceInfo, GetTime, tonumber, IsUsableSpell, IsSpellKnown,
		IsSpellInRange, UnitExists, UnitCanAttack, GetTotemInfo, wipe, IsMounted, UnitInVehicle, UnitIsDeadOrGhost,
		UnitChannelInfo, UnitCastingInfo, IsCurrentSpell, GetWeaponEnchantInfo, GetInventoryItemID, BindEnchant, GetItemInfo,
		IsEquippedItemType, GetItemSpell, GetActionInfo, GetTotemTimeLeft, UnitName, UnitIsEnemy;
local spellCast, spellValid, spellInstant, playerHP, playerPow, playerBuff, playerBuffSta, playerDistance, playerSlot, playerInventory, playerItemR, playerUseIt, unitDebuff, unitDebuffRem, unitBuffType, unitEnemiesRange, unitDistance, unitBoss, drTrack =
		ni.spell.cast, ni.spell.valid, ni.spell.isinstant, ni.player.hp, ni.player.power, ni.player.buff,
		ni.player.buffstacks,
		ni.player.distance, ni.player.slotusable, ni.player.useinventoryitem, ni.player.itemready, ni.player.useitem,
		ni.unit.debuff, ni.unit.debuffremaining, ni.unit.bufftype, ni.unit.enemiesinrange, ni.unit.distance, ni.unit.isboss,
		ni.drtracker.get;
local cata = ni.vars.build == 40300 or false;
-- local licensed = licensing.licensed()
if cata
-- and licensed 
then
	local AntiAFKTime = 0
	local KnowEngineer = ni.player.getskillinfo(GetSpellInfo(4036)) > 500 or false;
	local Cache = {}
	local Information = false
	local spells = {
		--Affliction icon = select(2, GetSpellTabInfo(2))
		BaneofAgony = { id = 980, name = GetSpellInfo(980), icon = select(3, GetSpellInfo(980)) },
		BaneofDoom = { id = 603, name = GetSpellInfo(603), icon = select(3, GetSpellInfo(603)) },
		Corruption = { id = 172, name = GetSpellInfo(172), icon = select(3, GetSpellInfo(172)) },
		CurseoftheElements = { id = 1490, name = GetSpellInfo(1490), icon = select(3, GetSpellInfo(1490)) },
		CurseofTongues = { id = 1714, name = GetSpellInfo(1714), icon = select(3, GetSpellInfo(1714)) },
		CurseofWeakness = { id = 702, name = GetSpellInfo(702), icon = select(3, GetSpellInfo(702)) },
		DarkIntent = { id = 80398, name = GetSpellInfo(80398), icon = select(3, GetSpellInfo(80398)) },
		DeathCoil = { id = 6789, name = GetSpellInfo(6789), icon = select(3, GetSpellInfo(6789)) },
		DrainLife = { id = 689, name = GetSpellInfo(689), icon = select(3, GetSpellInfo(689)) },
		DrainSoul = { id = 1120, name = GetSpellInfo(1120), icon = select(3, GetSpellInfo(1120)) },
		Fear = { id = 5782, name = GetSpellInfo(5782), icon = select(3, GetSpellInfo(5782)) },
		Haunt = { id = 48181, name = GetSpellInfo(48181), icon = select(3, GetSpellInfo(48181)) },
		HowlofTerror = { id = 5484, name = GetSpellInfo(5484), icon = select(3, GetSpellInfo(5484)) },
		LifeTap = { id = 1454, name = GetSpellInfo(1454), icon = select(3, GetSpellInfo(1454)) },
		SeedofCorruption = { id = 27243, name = GetSpellInfo(27243), icon = select(3, GetSpellInfo(27243)) },
		ShadowMastery = { id = 87339, name = GetSpellInfo(87339), icon = select(3, GetSpellInfo(87339)) },
		SoulSwap = { id = 86121, name = GetSpellInfo(86121), icon = select(3, GetSpellInfo(86121)) },
		UnstableAffliction = { id = 30108, name = GetSpellInfo(30108), icon = select(3, GetSpellInfo(30108)) },
		--Demonology icon = select(2, GetSpellTabInfo(3))
		Banish = { id = 710, name = GetSpellInfo(710), icon = select(3, GetSpellInfo(710)) },
		ControlDemon = { id = 93375, name = GetSpellInfo(93375), icon = select(3, GetSpellInfo(93375)) },
		CreateHealthstone = { id = 6201, name = GetSpellInfo(6201), icon = select(3, GetSpellInfo(6201)) },
		CreateSoulstone = { id = 693, name = GetSpellInfo(693), icon = select(3, GetSpellInfo(693)) },
		DemonArmor = { id = 687, name = GetSpellInfo(687), icon = select(3, GetSpellInfo(687)) },
		DemonSoul = { id = 77801, name = GetSpellInfo(77801), icon = select(3, GetSpellInfo(77801)) },
		DemonicCircleSummon = { id = 48018, name = GetSpellInfo(48018), icon = select(3, GetSpellInfo(48018)) },
		DemonicCircleTeleport = { id = 48020, name = GetSpellInfo(48020), icon = select(3, GetSpellInfo(48020)) },
		EnslaveDemon = { id = 1098, name = GetSpellInfo(1098), icon = select(3, GetSpellInfo(1098)) },
		EyeofKilrogg = { id = 126, name = GetSpellInfo(126), icon = select(3, GetSpellInfo(126)) },
		FelArmor = { id = 28176, name = GetSpellInfo(28176), icon = select(3, GetSpellInfo(28176)) },
		HealthFunnel = { id = 755, name = GetSpellInfo(755), icon = select(3, GetSpellInfo(755)) },
		RitualofSouls = { id = 29893, name = GetSpellInfo(29893), icon = select(3, GetSpellInfo(29893)) },
		RitualofSummoning = { id = 698, name = GetSpellInfo(698), icon = select(3, GetSpellInfo(698)) },
		ShadowWard = { id = 6229, name = GetSpellInfo(6229), icon = select(3, GetSpellInfo(6229)) },
		SoulHarvest = { id = 79268, name = GetSpellInfo(79268), icon = select(3, GetSpellInfo(79268)) },
		SoulLink = { id = 19028, name = GetSpellInfo(19028), icon = select(3, GetSpellInfo(19028)) },
		Soulburn = { id = 74434, name = GetSpellInfo(74434), icon = select(3, GetSpellInfo(74434)) },
		Soulshatter = { id = 29858, name = GetSpellInfo(29858), icon = select(3, GetSpellInfo(29858)) },
		SummonImp = { id = 688, name = GetSpellInfo(688), icon = select(3, GetSpellInfo(688)) },
		SummonVoidwalker = { id = 697, name = GetSpellInfo(697), icon = select(3, GetSpellInfo(697)) },
		SummonFelhunter = { id = 691, name = GetSpellInfo(691), icon = select(3, GetSpellInfo(691)) },
		SummonSuccubus = { id = 712, name = GetSpellInfo(712), icon = select(3, GetSpellInfo(712)) },
		SummonFelguard = { id = 30146, name = GetSpellInfo(30146), icon = select(3, GetSpellInfo(30146)) },
		SummonDoomguard = { id = 18540, name = GetSpellInfo(18540), icon = select(3, GetSpellInfo(18540)) },
		SummonInfernal = { id = 1122, name = GetSpellInfo(1122), icon = select(3, GetSpellInfo(1122)) },
		UnendingBreath = { id = 5697, name = GetSpellInfo(5697), icon = select(3, GetSpellInfo(5697)) },
		--Destruction icon = select(2, GetSpellTabInfo(4))
		FelFlame = { id = 77799, name = GetSpellInfo(77799), icon = select(3, GetSpellInfo(77799)) },
		Hellfire = { id = 1949, name = GetSpellInfo(1949), icon = select(3, GetSpellInfo(1949)) },
		Immolate = { id = 348, name = GetSpellInfo(348), icon = select(3, GetSpellInfo(348)) },
		Incinerate = { id = 29722, name = GetSpellInfo(29722), icon = select(3, GetSpellInfo(29722)) },
		RainofFire = { id = 5740, name = GetSpellInfo(5740), icon = select(3, GetSpellInfo(5740)) },
		SearingPain = { id = 5676, name = GetSpellInfo(5676), icon = select(3, GetSpellInfo(5676)) },
		ShadowBolt = { id = 686, name = GetSpellInfo(686), icon = select(3, GetSpellInfo(686)) },
		Shadowflame = { id = 47897, name = GetSpellInfo(47897), icon = select(3, GetSpellInfo(47897)) },
		SoulFire = { id = 6353, name = GetSpellInfo(6353), icon = select(3, GetSpellInfo(6353)) },
		-- Racial
		Berserking = { id = 26297, name = GetSpellInfo(26297), icon = select(3, GetSpellInfo(26297)) },
	};

	local items = {
		settingsfile = "Cata_Affliction_Trojan.json",
		{
			type = "title",
			text =
			">                          Warlock - Affliction PvE by |cFFFF0000Trojan                          |cFFFFFFFF<"
		},
		{ type = "separator" },
		{ type = "page",     number = 1,                          text = "|cffFFFF00Main Settings" },
		{ type = "separator" },
		{ type = "title",    text = "|cffFFFF00Mechanic Settings" },
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. select(3, GetSpellInfo(7849)) .. ":18:18\124t Do Boss Mechanics",
			tooltip = "Do Boss Mechanics",
			enabled = true,
			key = "Mechanics"
		},
		{ type = "separator" },
		{
			type = "entry",
			text = ni.spell.icon(22888, 22, 22) .. " Boss Detect",
			tooltip =
			"When |cff00D700ENABLED|r - Auto detect Bosses.\nWhen |cffFF0D00DISABLED|r - use CD bottom for Spells.",
			enabled = true,
			key = "detect",
		},
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. select(3, GetSpellInfo(6603)) .. ":18:18\124t Do Auto Targeting",
			tooltip =
			"Enable auto targeting",
			enabled = true,
			key = "AutoTargeting"
		},
		{ type = "separator" },
		{
			type = "entry",
			text = ni.spell.icon(2382, 22, 22) .. " |cffffa500Debug Printing|r",
			tooltip =
			"Enable for debug if you have problems.\n\nUse the macro |cff00D700/ppause|r to pause CR.\n\nThe value in the seconds field for which the CR will stop.",
			value = 1.5,
			min = 1,
			max = 6,
			step = 0.1,
			width = 40,
			enabled = false,
			key = "Debug",
		},
		--{ type = "separator" },
		--{
		--	type = "entry",
		--	text = "\124T" .. spells.Corruption.icon .. ":18:18\124t Do multidoting",
		--	tooltip =
		--	"Enable multidoting",
		--	enabled = true,
		--	key = "multidoting"
		--},
		{ type = "separator" },
		{ type = "title",    text = "|cffFFFF00Mana Settings" },
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.LifeTap.icon .. ":18:18\124t Life Tap",
			tooltip = "Use Life Tap when mana < %. (0 = disabled)",
			enabled = true,
			value = 35,
			key = "lifetapuse"
		},
		{ type = "separator" },
		{ type = "title",    text = "|cffFFFF00Buff Settings" },
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.DarkIntent.icon .. ":18:18\124t Dark Intent",
			tooltip = "Use Dark Intent",
			enabled = true,
			key = "DarkIntent"
		},
		{ type = "page",     number = 2,             text = "|cffFFFF00Defensive Settings" },
		{ type = "separator" },
		{ type = "title",    text = "Spell Settings" },
		{ type = "separator" },
		{
			type = "entry",
			text = ni.player.itemicon(5512, 18, 18) .. " Healthstone",
			tooltip = "Use Warlock Healthstone (if you have) when player |cff00D700HP|r < %.",
			enabled = true,
			value = 35,
			min = 25,
			max = 65,
			step = 1,
			width = 40,
			key = "healthstoneuse"
		},
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.CreateSoulstone.icon .. ":18:18\124t Soulstone",
			tooltip = "Use Warlock Soulstone (if you have).",
			enabled = true,
			key = "soulstoneuse"
		},
	};

	local queue = {
		"Information",
		"Pause",
		"Cache",
		"Mechanics",
		"Targeting",
		"Buff - Dark Intent",
		"Pet Summon",
		"Buff - Fel Armor",
		"Buff - Soul Link",
		"CD - Soul Harvest",
		"PetAttack",
		"AOE - Seed of Corruption",
		"CD - Soulshatter",
		"Healthstone (Use)",
		"Soulstone (Use)",
		"AOE - SoulSwap",
		"CD - Life Tap",
		"CD - Fel Flame",
		"Curse - Elements",
		"Use Castable Items",
		"Racial (Use)",
		"CD - Deamon Soul",
		"CD - Soulburn",
		"DoT - Corruption",
		"DoT - Unstable Affliction",
		"DoT - Bane of Doom",
		"DoT - Bane of Agony",
		"DoT - Haunt",
		"CD - Doomguard",
		"Proc - Soul Fire",
		"Filler - Shadow Bolt",
		"AOE - Shadowflame",
		"Filler - Drain Soul",
	};

	local function GetSetting(name)
		for k, v in ipairs(items) do
			if v.type == "entry"
					and v.key ~= nil
					and v.key == name then
				return v.value, v.enabled
			end
		end
	end

	function math.sign(v)
		return (v >= 0 and 1) or -1
	end

	function math.round(v, bracket)
		bracket = bracket or 1
		return math.floor(v / bracket + math.sign(v) * 0.5) * bracket
	end

	--local pestilence = { [GetSpellInfo(50842)] = true } -- spells that i wanna check in UNIT_SPELLCAST_SUCCEEDED
	local function CombatEventCatcher(event, ...)
		if event == "UNIT_SPELLCAST_SUCCEEDED" then
			local unitID, spellName = ...
		end
	end

	local function SortByHP(x, y)
		return x.hp() < y.hp()
	end

	local function TTDChecker(t, valueTime, valueTTD, hp)
		valueTime = valueTime or 0
		valueTTD = valueTTD or 0
		hp = hp or 0
		if ni.vars.combat.time ~= 0
				and GetTime() - ni.vars.combat.time > valueTime
				and ni.unit.ttd(t) > valueTTD
				and ni.unit.hp(t) >= hp then
			return true;
		end
		return false;
	end

	local function BossOrCD(t, valueTime, valueTTD, hp, enabled)
		if ni.vars.combat.cd then
			return true;
		end
		;
		local isboss = false;
		if enabled then
			isboss = unitBoss(t);
			if not isboss then
				return false;
			end
		end
		if TTDChecker(t, valueTime, valueTTD, hp) then
			if enabled then
				if isboss then
					return true;
				end
				return true;
			end
		end
		return false;
	end

	local function OnLoad()
		-- debug mode
		ni.vars.debug = false
		-- register the combatlog event handler
		ni.combatlog.registerhandler("Cata_Affliction_Trojan", CombatEventCatcher);
		-- add the gui frame
		if not ni.vars.stream then
			ni.GUI.AddFrame("Cata_Affliction_Trojan", items);
		end
	end


	local function OnUnLoad()
		-- unregister the handler
		ni.combatlog.unregisterhandler("Cata_Affliction_Trojan");
		-- remove the gui frame
		if not ni.vars.stream then
			ni.GUI.DestroyFrame("Cata_Affliction_Trojan");
		end
		-- Stop Attack
		StopAttack()
		PetStopAttack()
		-- Reset information
		Information = false;
	end
	local spellreflects = "92659"

	local abilities = {
		["Information"] = function()
			if not Information then
				print("|cffFFFF00  ___________________________________________ |r")
				print("|cffFFFF00 | |r")
				print("|cffFFFF00 |        Warlock Affli PvE by |cFFFF0000Trojan |cffFFFF00loaded.|r")
				print("|cffFFFF00 | Use |cFFFF0000LShift |cffFFFF00to use Soul Swap on |cFFFF0000Focus |cffFFFF00Target.|r")
				print("|cffFFFF00 |___________________________________________ |r")
				Information = true
			end
		end,

		["Pause"] = function()
			local value = GetSetting("Debug");
			SLASH_PPAUSE1 = "/ppause"
			SlashCmdList.PPAUSE = function()
				ni.spell.stopcasting()
				ni.rotation.delay(value);
			end
			if IsMounted()
					or UnitIsDeadOrGhost("player")
					or ni.player.ischanneling()
					or ni.player.iscasting()
					or ni.unit.isimmune("target")
					or ni.unit.buffs("target", spellreflects)
					or UnitInVehicle("player")
			then
				return true;
			end
			ni.vars.debug = select(2, GetSetting("Debug"));
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
			Cache.PlayerLevel = UnitLevel("player") or 0
			Cache.members = ni.members or {}
			if #Cache.members > 0 then
				table.sort(Cache.members, SortByHP)
			end
			Cache.mana = ni.player.power(0) or 0
			Cache.rawmana = ni.player.powerraw(0) or 0
			Cache.shards = ni.player.power(7) or 0
		end,

		["Mechanics"] = function()
			local _, enabled = GetSetting("Mechanics")
			if enabled then
				if UnitIsDeadOrGhost("player") or not UnitExists("boss1") then
					InitMessage = nil
				end

				if UnitExists("boss1") then
					npcid = tonumber((UnitGUID("boss1")):sub(-12, -9), 16)

					if npcid == 55294 then
						-- Avoid sudden death on Ultraxion
						local fadingtime = select(7, ni.unit.debuff("player", 110070))
						if fadingtime and fadingtime - GetTime() < 1.5 then RunMacroText("/click ExtraActionButton1") end

						-- Avoid Hour of Twilight on Ultraxion, Delete next 3 lines if you are working as tank
						local channelSpell, _, _, _, _, endTime = UnitCastingInfo("boss1")
						if channelSpell == GetSpellInfo(109417) and endTime / 1000 - GetTime() < 1.1
						then
							RunMacroText("/click ExtraActionButton1")
						end
					end

					if npcid == 56173 then
						-- Avoid sudden death on Madness
						local tentacledeath = select(7, ni.unit.debuff("player", 109597))
						if tentacledeath and tentacledeath - GetTime() < 1 then RunMacroText("/click ExtraActionButton1") end
					end

					-- Shannox START
					if npcid == 53691 then
						for i = 1, #Cache.members do
							if ni.unit.debuffs(Cache.members[i].unit, "99947||99948||100129") then
								TargetUnit(tostring(53695))
							end
						end
						if ni.unit.id("target") == 53694 then -- riplimb

						end
						if ni.unit.id("target") == 53695 then -- rageface

						end
					end
					-- Shannox END
				end
			end
		end,

		["Targeting"] = function()
			local _, enabled = GetSetting("AutoTargeting")
			if not enabled then
				return false;
			end
			if Cache.PlayerCombat then
				if not UnitExists("target")
						or ((UnitExists("target")
								and UnitIsDeadOrGhost("target"))
							or not UnitCanAttack("player", "target"))
						and not IsCurrentSpell(GetSpellInfo(6603))
						or ni.unit.isimmune("target") then
					local enemies = ni.player.enemiesinrange(40);
					for i = 1, #enemies do
						local tar = enemies[i].guid;
						if enemies[i].distance <= 40
								and not ni.unit.istotem(tar)
								and ni.player.isfacing(tar)
								and not ni.unit.isimmune(tar) then
							ni.player.target(tar)
							ni.spell.cast(GetSpellInfo(6603), tar)
							return true;
						end
					end
				end
			end
		end,

		["Buff - Dark Intent"] = function()
			local _, enabled = GetSetting("DarkIntent")
			local IntentTarget = nil
			if GetNumGroupMembers() > 2 or GetNumRaidMembers() > 0 then
				if enabled then
					if ni.spell.available(spells.DarkIntent.id) then
						if IntentTarget == nil then
							for i = 1, #Cache.members do
								if Cache.members[i]:iscaster() then
									if not ni.unit.buff(Cache.members[i].unit, spells.DarkIntent.id, "player")
											and not UnitIsUnit(Cache.members[i].unit, "player")
											and not Cache.PlayerControled then
										ni.spell.cast(spells.DarkIntent.name, Cache.members[i].unit)
										IntentTarget = Cache.members[i].unit
										return true;
									end
								end
							end
						else
							if ni.unit.exists(IntentTarget) then
								if not ni.unit.buff(IntentTarget, spells.DarkIntent.id, "player")
										and not Cache.PlayerControled then
									ni.spell.cast(spells.DarkIntent.name, IntentTarget)
									return true;
								end
							else
								IntentTarget = nil
							end
						end
					end
				end
			end
		end,

		["Pet Summon"] = function()
			if ni.spell.available(spells.SummonFelhunter.id) then
				if not ni.unit.exists("pet")
						and not Cache.PlayerControled
						and not Cache.PlayerCombat
						and not Cache.moving then
					ni.spell.cast(spells.SummonFelhunter.name)
					return true;
				end
			end
		end,

		["Buff - Fel Armor"] = function()
			if ni.spell.available(spells.FelArmor.id) then
				if not ni.unit.buff("player", spells.FelArmor.id)
						and not Cache.PlayerControled then
					ni.spell.cast(spells.FelArmor.name)
					return true;
				end
			end
		end,

		["Buff - Soul Link"] = function()
			if ni.spell.available(spells.SoulLink.id) then
				if not ni.unit.buff("player", spells.SoulLink.id)
						and ni.unit.exists("pet")
						and not Cache.PlayerControled then
					ni.spell.cast(spells.SoulLink.name)
					return true;
				end
			end
		end,

		["CD - Soul Harvest"] = function()
			if ni.spell.available(spells.SoulHarvest.id) then
				if Cache.shards <= 1
						and not Cache.PlayerControled
						and not Cache.PlayerCombat
						and not Cache.moving then
					ni.spell.cast(spells.SoulHarvest.name)
					return true;
				end
			end
		end,

		["PetAttack"] = function()
			if UnitExists("pet") and not UnitIsDeadOrGhost("pet")
					and Cache.PlayerCombat then
				--Attack the same unit as player
				local petTarget = UnitGUID("pettarget")
				local playerTarget = UnitGUID("target")
				if petTarget ~= playerTarget then
					ni.player.runtext("/petattack")
				end
			end
		end,

		["AOE - Seed of Corruption"] = function()
			if Cache.AOE then
				if ni.unit.exists("target")
						and ni.spell.valid("target", spells.SeedofCorruption.name, false, true, false)
						and not Cache.PlayerControled
						and Cache.PlayerCombat
						and not Cache.moving then
					ni.spell.cast(spells.SeedofCorruption.name, "target")
					return true;
				end
			end
		end,

		["CD - Soulshatter"] = function()
			if ni.spell.available(spells.Soulshatter.id) then
				if GetNumRaidMembers() > 0 or GetNumPartyMembers() > 0 then
					if ni.unit.threat("player") == 3
							and not Cache.PlayerControled
							and Cache.PlayerCombat then
						ni.spell.cast(spells.Soulshatter.name)
						return true;
					end
				end
			end
		end,

		["Healthstone (Use)"] = function()
			local hpVal, enabled = GetSetting("healthstoneuse");
			if not enabled then
				return false;
			end
			if not ni.player.hasitem(5512)
					and not Cache.moving
					and not Cache.PlayerControled
					and not Cache.PlayerCombat
					and ni.spell.available(spells.CreateHealthstone.id) then
				ni.spell.cast(spells.CreateHealthstone.name)
				return true
			end
			if not Cache.PlayerControled
					and Cache.PlayerCombat
					and ni.player.hp() <= hpVal then
				if ni.player.itemready(5512) then
					ni.player.useitem(5512)
					return true;
				end
			end
		end,

		["Soulstone (Use)"] = function()
			local _, enabled = GetSetting("soulstoneuse");
			if enabled then
				if not ni.player.hasitem(5232)
						and not Cache.moving
						and not Cache.PlayerControled
						and not Cache.PlayerCombat
						and ni.spell.available(spells.CreateSoulstone.id) then
					ni.spell.cast(spells.CreateSoulstone.name)
					return true
				end
				if not Cache.PlayerControled
						and Cache.PlayerCombat
						and not Cache.moving then
					local inrangeMembers = Cache.members.inrange("player", 40)
					for i = 1, #inrangeMembers do
						if UnitIsCorpse(inrangeMembers[i].unit)
								and ni.player.itemready(5232)
								and (inrangeMembers[i]:istank() or inrangeMembers[i]:ishealer()) then
							ni.player.useitem(5232, inrangeMembers[i].unit)
							return true;
						end
					end
				end
			end
		end,

		["AOE - SoulSwap"] = function()
			local NI_DebuffsToCheck = { spells.Corruption.id, spells.BaneofAgony.id, spells.UnstableAffliction.id }
			local NI_NeedSoulSwap = false
			if ni.spell.available(spells.SoulSwap.id) then
				if ni.unit.exists("focus")
						and ni.spell.valid("focus", spells.SoulSwap.id, true, true, false)
						and ni.spell.valid("target", spells.SoulSwap.id, true, true, false)
						and not UnitIsUnit("target", "focus") then
					for i = 1, #NI_DebuffsToCheck do
						if ni.unit.debuff("focus", NI_DebuffsToCheck[i]) then
							if select(7, ni.unit.debuff("focus", NI_DebuffsToCheck[i])) - GetTime() <= 3 then
								NI_NeedSoulSwap = true
								break
							end
						else
							NI_NeedSoulSwap = true
							break
						end
					end
				end
				if NI_NeedSoulSwap then
					if ni.unit.buff("player", 86211) then
						ni.spell.cast(GetSpellInfo(86213), "focus")
						return true
					else
						if ni.unit.debuff("target", spells.UnstableAffliction.id)
								and ni.unit.debuff("target", spells.Corruption.id) then
							if ni.unit.debuff("target", spells.BaneofAgony.id) then
								ni.spell.cast(spells.SoulSwap.name, "target")
								return true
							else
								ni.spell.cast(spells.BaneofAgony.name, "target")
								return true
							end
						end
					end
				end
			end
		end,

		["CD - Life Tap"] = function()
			local value, enabled = GetSetting("lifetapuse");
			if not enabled then
				return false;
			end
			if ni.spell.available(spells.LifeTap.id) then
				if Cache.mana <= value or (Cache.moving and Cache.mana < 80 and Cache.mana < ni.unit.hp("target")) then
					if not Cache.PlayerControled
							and Cache.PlayerCombat then
						ni.spell.cast(spells.LifeTap.name)
						return true;
					end
				end
			end
		end,

		["CD - Fel Flame"] = function()
			if ni.spell.available(spells.FelFlame.id) then
				if ni.spell.valid("target", spells.FelFlame.name, true, true, false)
						and Cache.moving
						and not Cache.PlayerControled
						and Cache.PlayerCombat then
					ni.spell.cast(spells.FelFlame.name)
					return true;
				end
			end
		end,

		["Curse - Elements"] = function()
			--Reorderd the list for better management
			---60433, 65142, 93068, 34889, 24844, 86105, 85547, 1490
			---60433 Earth and Moon
			---65142 Ebon Plague
			---93068 Master Poisoner
			---34889 Fire Breath
			---24844 Lighning Breath
			---86105 Jinx: Curse of the Elements
			---85547 Jinx: Curse of the Elements
			---1490 curse of the elements
			local debuffCurse = "60433||65142||93068||34889||24844||86105||85547||1490";
			if ni.unit.exists("target")
					and Cache.PlayerCombat
					and not Cache.PlayerControled
					and ni.spell.valid("target", spells.CurseoftheElements.id, true, true, false) then
				if BossOrCD("target", 5, 5, 1, true) then
					if not ni.unit.debuffs("target", debuffCurse) then
						ni.spell.cast(spells.CurseoftheElements.name, "target")
						return true;
					end
				end
			end
		end,

		["Use Castable Items"] = function()
			if Cache.PlayerControled
					or not Cache.PlayerCombat then
				return false;
			end
			local _, enabled = GetSetting("detect");
			if BossOrCD("target", 5, 5, 1, enabled) then
				local trinket_slots = { 13, 14 };
				for _, slot_id in ipairs(trinket_slots) do
					local trinket_id = GetInventoryItemID("player", slot_id)
					if trinket_id
							and ni.player.slotusable(slot_id) then
						ni.player.useinventoryitem(slot_id)
						return true;
					end
				end
				if KnowEngineer then
					if ni.player.slotusable(10) then
						ni.player.useinventoryitem(10, "target")
						return true;
					end
				end
			end
		end,

		["Racial (Use)"] = function()
			if Cache.PlayerControled
					or not Cache.PlayerCombat then
				return false;
			end
			if ni.unit.exists("target") then
				-- Berserking (Troll)(All Classes)
				if ni.spell.available(spells.Berserking.id)
				then
					if BossOrCD("target", 5, 5, 1, true) then
						ni.spell.cast(spells.Berserking.name)
						return true
					end
				end
			end
		end,

		["CD - Deamon Soul"] = function()
			if ni.spell.available(spells.DemonSoul.id) then
				if ni.unit.exists("target")
						and Cache.PlayerCombat
						and not Cache.PlayerControled then
					if BossOrCD("target", 5, 5, 1, true) then
						ni.spell.cast(spells.DemonSoul.name)
						return true;
					end
				end
			end
		end,

		["CD - Soulburn"] = function()
			if ni.spell.available(spells.Soulburn.id) then
				if ni.unit.exists("target")
						and Cache.PlayerCombat
						and not Cache.PlayerControled then
					if BossOrCD("target", 5, 5, 1, true) then
						ni.spell.cast(spells.Soulburn.name)
						return true;
					end
				end
			end
		end,

		["DoT - Corruption"] = function()
			if ni.spell.available(spells.Corruption.id) then
				if ni.spell.valid("target", spells.Corruption.id, false, true, false)
						and not Cache.PlayerControled
						and Cache.PlayerCombat then
					if ni.unit.debuffremaining("target", spells.Corruption.id, "player") < 2 then
						ni.spell.cast(spells.Corruption.name, "target")
						return true;
					end
				end
			end
		end,

		["DoT - Unstable Affliction"] = function()
			if ni.spell.available(spells.UnstableAffliction.id) then
				if ni.spell.valid("target", spells.UnstableAffliction.id, false, true, false)
						and not Cache.PlayerControled
						and Cache.PlayerCombat then
					if ni.unit.debuffremaining("target", spells.UnstableAffliction.id, "player") < 3 and ni.unit.hp("target") > 25 then
						ni.spell.cast(spells.UnstableAffliction.name, "target")
						return true;
					end
				end
			end
		end,

		["DoT - Bane of Doom"] = function()
			if ni.spell.available(spells.BaneofDoom.id) then
				if ni.spell.valid("target", spells.BaneofDoom.id, false, true, false)
						and not Cache.PlayerControled
						and Cache.PlayerCombat then
					if BossOrCD("target", 5, 5, 1, true) then
						doom = true
						if ni.unit.debuffremaining("target", spells.BaneofDoom.id, "player") < 13 then
							ni.spell.cast(spells.BaneofDoom.name, "target")
							return true;
						end
					else
						doom = false
					end
				end
			end
		end,

		["DoT - Bane of Agony"] = function()
			if ni.spell.available(spells.BaneofAgony.id) then
				if ni.spell.valid("target", spells.BaneofAgony.id, false, true, false)
						and not Cache.PlayerControled
						and Cache.PlayerCombat
						and not doom then
					if not ni.unit.debuff("target", spells.BaneofAgony.id, "player") then
						ni.spell.cast(spells.BaneofAgony.name, "target")
						return true;
					end
				end
			end
		end,

		["DoT - Haunt"] = function()
			if ni.spell.available(spells.Haunt.id) then
				if ni.spell.valid("target", spells.Haunt.id, true, true, false)
						and not Cache.PlayerControled
						and Cache.PlayerCombat then
					ni.spell.cast(spells.Haunt.name, "target")
					return true;
				end
			end
		end,

		["CD - Doomguard"] = function()
			if ni.spell.available(spells.SummonDoomguard.id) then
				if ni.unit.exists("target")
						and Cache.PlayerCombat
						and not Cache.PlayerControled
						and BossOrCD("target", 5, 5, 1, true) then
					ni.spell.cast(spells.SummonDoomguard.name)
					return true;
				end
			end
		end,

		["Proc - Soul Fire"] = function()
			local SoulburnUP = ni.unit.buff("player", 74434)
			if ni.spell.available(spells.SoulFire.id) then
				if ni.spell.valid("target", spells.SoulFire.id, true, true, false)
						and not Cache.PlayerControled
						and Cache.PlayerCombat then
					if SoulburnUP then
						ni.spell.cast(spells.SoulFire.name, "target")
						return true;
					end
				end
			end
		end,

		["Filler - Shadow Bolt"] = function()
			SFlame = select(7, ni.unit.debuff("target", 17800))
			STrance = select(7, ni.unit.buff("player", 17941))
			if ni.spell.available(spells.ShadowBolt.id) then
				if ni.unit.exists("target") then
					if ni.spell.valid("target", spells.ShadowBolt.id, true, true, false)
							and not Cache.PlayerControled
							and Cache.PlayerCombat then
						if ni.unit.hp("target") > 25 then
							ni.spell.cast(spells.ShadowBolt.name, "target")
							return true;
						end
						if STrance then
							ni.spell.cast(spells.ShadowBolt.name, "target")
							return true;
						end
						if ni.unit.hp("target") < 25 then
							if SFlame == nil then
								ni.spell.cast(spells.ShadowBolt.name, "target")
								return true;
							end
						end
					end
				end
			end
		end,

		["AOE - Shadowflame"] = function()
			if ni.spell.available(spells.Shadowflame.id) then
				if CheckInteractDistance("target", 3)
						and GetCurrentMapZone ~= "Spine of Deathwing"
						or not npcid == 55294 -- Ultraxion
						and ni.unit.exists("target")
						and not UnitIsUnit("target", "player") then
					if Cache.PlayerCombat
							and not Cache.PlayerControled then
						ni.spell.cast(spells.Shadowflame.name, "target")
						return true;
					end
				end
			end
		end,

		["Filler - Drain Soul"] = function()
			if ni.spell.available(spells.DrainSoul.id) then
				if ni.unit.exists("target") then
					if ni.unit.hp("target") <= 25 and not Cache.moving then
						if STrance == nil then
							if ni.spell.valid("target", spells.DrainSoul.id, true, true, false)
									and not Cache.PlayerControled
									and Cache.PlayerCombat then
								ni.spell.cast(spells.DrainSoul.name, "target")
								return true;
							end
						end
					end
				end
			end
		end,

	};

	ni.bootstrap.profile("Cata_Affliction_Trojan", queue, abilities, OnLoad, OnUnLoad);
else
	local queue = {
		"Error",
	};
	local abilities = {
		["Error"] = function()
			ni.vars.profiles.enabled = false;
			--if not licensed then
			--	ni.frames.floatingtext:message("This profile requires a valid license!")
			--end
			if not cata then
				ni.frames.floatingtext:message("This profile is for 4.3.4 Cataclysm!")
			end
		end,
	};
	ni.bootstrap.profile("Cata_Affliction_Trojan", queue, abilities);
end
;
