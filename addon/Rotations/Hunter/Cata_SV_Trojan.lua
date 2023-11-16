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
local Cache = {}
local Information = false;
-- local licensed = licensing.licensed()
if cata
-- and licensed 
then
	local AntiAFKTime = 0
	local KnowEngineer = ni.player.getskillinfo(GetSpellInfo(4036)) > 500 or false;
	local spells = {
		--Beast Mastery icon = select(2, GetSpellTabInfo(2))
		CallPet1 = { id = 883, name = GetSpellInfo(883), icon = select(3, GetSpellInfo(883)) },
		CallPet2 = { id = 83242, name = GetSpellInfo(83242), icon = select(3, GetSpellInfo(83242)) },
		CallPet3 = { id = 83243, name = GetSpellInfo(83243), icon = select(3, GetSpellInfo(83243)) },
		CallPet4 = { id = 83244, name = GetSpellInfo(83244), icon = select(3, GetSpellInfo(83244)) },
		CallPet5 = { id = 83245, name = GetSpellInfo(83245), icon = select(3, GetSpellInfo(83245)) },
		RevivePet = { id = 982, name = GetSpellInfo(982), icon = select(3, GetSpellInfo(982)) },
		BeastLore = { id = 1462, name = GetSpellInfo(1462), icon = select(3, GetSpellInfo(1462)) },
		ControlPet = { id = 93321, name = GetSpellInfo(93321), icon = select(3, GetSpellInfo(93321)) },
		DismissPet = { id = 2641, name = GetSpellInfo(2641), icon = select(3, GetSpellInfo(2641)) },
		FeedPet = { id = 6991, name = GetSpellInfo(6991), icon = select(3, GetSpellInfo(6991)) },
		KillCommand = { id = 34026, name = GetSpellInfo(34026), icon = select(3, GetSpellInfo(34026)) },
		TameBeast = { id = 1515, name = GetSpellInfo(1515), icon = select(3, GetSpellInfo(1515)) },
		AspectoftheHawk = { id = 13165, name = GetSpellInfo(13165), icon = select(3, GetSpellInfo(13165)) },
		EagleEye = { id = 6197, name = GetSpellInfo(6197), icon = select(3, GetSpellInfo(6197)) },
		MendPet = { id = 136, name = GetSpellInfo(136), icon = select(3, GetSpellInfo(136)) },
		AspectoftheCheetah = { id = 5118, name = GetSpellInfo(5118), icon = select(3, GetSpellInfo(5118)) },
		ScareBeast = { id = 1513, name = GetSpellInfo(1513), icon = select(3, GetSpellInfo(1513)) },
		WidowVenom = { id = 82654, name = GetSpellInfo(82654), icon = select(3, GetSpellInfo(82654)) },
		AspectofthePack = { id = 13159, name = GetSpellInfo(13159), icon = select(3, GetSpellInfo(13159)) },
		AspectoftheWild = { id = 20043, name = GetSpellInfo(20043), icon = select(3, GetSpellInfo(20043)) },
		MastersCall = { id = 53271, name = GetSpellInfo(53271), icon = select(3, GetSpellInfo(53271)) },
		AspectoftheFox = { id = 82661, name = GetSpellInfo(82661), icon = select(3, GetSpellInfo(82661)) },
		HeartofThePhoenix = { id = 55709, name = GetSpellInfo(55709), icon = select(3, GetSpellInfo(55709)) },
		--Marksmanship icon = select(2, GetSpellTabInfo(3))
		ArcaneShot = { id = 3044, name = GetSpellInfo(3044), icon = select(3, GetSpellInfo(3044)) },
		AutoShot = { id = 75, name = GetSpellInfo(75), icon = select(3, GetSpellInfo(75)) },
		SteadyShot = { id = 56641, name = GetSpellInfo(56641), icon = select(3, GetSpellInfo(56641)) },
		ConcussiveShot = { id = 5116, name = GetSpellInfo(5116), icon = select(3, GetSpellInfo(5116)) },
		HuntersMark = { id = 1130, name = GetSpellInfo(1130), icon = select(3, GetSpellInfo(1130)) },
		MultiShot = { id = 2643, name = GetSpellInfo(2643), icon = select(3, GetSpellInfo(2643)) },
		KillShot = { id = 53351, name = GetSpellInfo(53351), icon = select(3, GetSpellInfo(53351)) },
		TranquilizingShot = { id = 19801, name = GetSpellInfo(19801), icon = select(3, GetSpellInfo(19801)) },
		Flare = { id = 1543, name = GetSpellInfo(1543), icon = select(3, GetSpellInfo(1543)) },
		DistractingShot = { id = 20736, name = GetSpellInfo(20736), icon = select(3, GetSpellInfo(20736)) },
		RapidFire = { id = 3045, name = GetSpellInfo(3045), icon = select(3, GetSpellInfo(3045)) },
		--Survival icon = select(2, GetSpellTabInfo(4))
		RaptorStrike = { id = 2973, name = GetSpellInfo(2973), icon = select(3, GetSpellInfo(2973)) },
		Parry = { id = 82243, name = GetSpellInfo(82243), icon = select(3, GetSpellInfo(82243)) },
		SerpentSting = { id = 1978, name = GetSpellInfo(1978), icon = select(3, GetSpellInfo(1978)) },
		WingClip = { id = 2974, name = GetSpellInfo(2974), icon = select(3, GetSpellInfo(2974)) },
		Disengage = { id = 781, name = GetSpellInfo(781), icon = select(3, GetSpellInfo(781)) },
		ScatterShot = { id = 19503, name = GetSpellInfo(19503), icon = select(3, GetSpellInfo(19503)) },
		ImmolationTrap = { id = 13795, name = GetSpellInfo(13795), icon = select(3, GetSpellInfo(13795)) },
		FreezingTrap = { id = 1499, name = GetSpellInfo(1499), icon = select(3, GetSpellInfo(1499)) },
		FeignDeath = { id = 5384, name = GetSpellInfo(5384), icon = select(3, GetSpellInfo(5384)) },
		ExplosiveTrap = { id = 13813, name = GetSpellInfo(13813), icon = select(3, GetSpellInfo(13813)) },
		IceTrap = { id = 13809, name = GetSpellInfo(13809), icon = select(3, GetSpellInfo(13809)) },
		TrapLauncher = { id = 77769, name = GetSpellInfo(77769), icon = select(3, GetSpellInfo(77769)) },
		SnakeTrap = { id = 34600, name = GetSpellInfo(34600), icon = select(3, GetSpellInfo(34600)) },
		Misdirection = { id = 34477, name = GetSpellInfo(34477), icon = select(3, GetSpellInfo(34477)) },
		Deterrence = { id = 19263, name = GetSpellInfo(19263), icon = select(3, GetSpellInfo(19263)) },
		CobraShot = { id = 77767, name = GetSpellInfo(77767), icon = select(3, GetSpellInfo(77767)) },
		Camouflage = { id = 51753, name = GetSpellInfo(51753), icon = select(3, GetSpellInfo(51753)) },
		ExplosiveShot = { id = 53301, name = GetSpellInfo(53301), icon = select(3, GetSpellInfo(53301)) },
		BlackArrow = { id = 3674, name = GetSpellInfo(3674), icon = select(3, GetSpellInfo(3674)) },
		WyvernSting = { id = 19386, name = GetSpellInfo(19386), icon = select(3, GetSpellInfo(19386)) },
		-- Racial
		Berserking = { id = 26297, name = GetSpellInfo(26297), icon = select(3, GetSpellInfo(26297)) },
	};

	local pet1, pet2, pet3, pet4, pet5 = "|cffFFFF33Pet 1", "|cffFFFF33Pet 2", "|cffFFFF33Pet 3", "|cffFFFF33Pet 4",
			"|cffFFFF33Pet 5";
	local menus = {
		["Pet"] = 1,
	}

	local function GUICallback(key, item_type, value)
		if item_type == "menu" then
			menus[key] = value
		end
	end

	local items = {
		settingsfile = "Cata_SV_Trojan.json",
		callback = GUICallback,
		{
			type = "title",
			text =
			">                          Hunter - SV PvE by |cFFFF0000Trojan                          |cFFFFFFFF<"
		},
		{ type = "separator" },
		{ type = "page",     number = 1,            text = "|cffFFFF00Main Settings" },
		{ type = "separator" },
		{ type = "title",    text = "Pet Selection" },
		{ type = "separator" },
		{
			type = "dropdown",
			menu = {
				{
					selected = (menus["Pet"] == 1),
					value = 1,
					text = "\124T" .. spells.CallPet1.icon .. ":15:15\124t " .. pet1
				},
				{
					selected = (menus["Pet"] == 2),
					value = 2,
					text = "\124T" .. spells.CallPet2.icon .. ":15:15\124t " .. pet2
				},
				{
					selected = (menus["Pet"] == 3),
					value = 3,
					text = "\124T" .. spells.CallPet3.icon .. ":15:15\124t " .. pet3
				},
				{
					selected = (menus["Pet"] == 4),
					value = 4,
					text = "\124T" .. spells.CallPet4.icon .. ":15:15\124t " .. pet4
				},
				{
					selected = (menus["Pet"] == 5),
					value = 5,
					text = "\124T" .. spells.CallPet5.icon .. ":15:15\124t " .. pet5
				}
			},
			key = "Pet"
		},
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
			tooltip = "When |cff00D700ENABLED|r - Auto detect Bosses.\nWhen |cffFF0D00DISABLED|r - use CD bottom for Spells.",
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
		{ type = "page",     number = 3,            text = "|cffFFFF00Trap Settings" },
		{ type = "separator" },
		{ type = "title",    text = "Trap Settings" },
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.IceTrap.icon .. ":18:18\124t Ice Trap",
			tooltip = "Use Ice Trap on AOE to kite",
			enabled = true,
			key = "IceTrap"
		}
	};

	local queue = {
		"Information",
		"Pause",
		"Cache",
		"Mechanics",
		"Targeting",
		"CallPet",
		"Healthstone (Use)",
		"Trap - Launcher",
		"Trap - Explosive",
		"Trap - Freezing",
		"Trap - Ice",
		"Mark - Hunter",
		"Pet - Mend Pet",
		"Shot - Tranquilizing",
		"Shot - Misdirection",
		"Use Castable Items",
		"Racial (Use)",
		"PetAttack",
		"Strike - Wing Clip",
		"Strike - Raptor",
		"AOE - Multi Shot",
		"Sting - Serpent",
		"Shot - Explosive/LNL",
		"Shot - Arcane/LNL",
		"Shot - Explosive",
		"Shot - Kill",
		"Spec - Black Arrow",
		"CD - Rapid Fire",
		"Shot - Arcane",
		"Shot - Cobra",
		"Shot - Steady",
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

	--local inquisition, GOAK = { [GetSpellInfo(84963)] = true }, { [GetSpellInfo(86150)] = true }
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
		ni.combatlog.registerhandler("Cata_SV_Trojan", CombatEventCatcher);
		-- add the gui frame
		if not ni.vars.stream then
			ni.GUI.AddFrame("Cata_SV_Trojan", items);
		end
	end


	local function OnUnLoad()
		-- unregister the handler
		ni.combatlog.unregisterhandler("Cata_SV_Trojan");
		-- remove the gui frame
		if not ni.vars.stream then
			ni.GUI.DestroyFrame("Cata_SV_Trojan");
		end
		-- Stop Attack
		StopAttack()
		PetStopAttack()
		-- Reset information
		Information = false;
	end

	local abilities = {
		["Information"] = function()
			if not Information then
				print("|cffFFFF00  ___________________________________________ |r")
				print("|cffFFFF00 |                                                                        | |r")
				print("|cffFFFF00 |        Hunter SV PvE by |cFFFF0000Trojan |cffFFFF00loaded.             | |r")
				print("|cffFFFF00 | Use |cFFFF0000LShift |cffFFFF00to Freeze your |cFFFF0000Focus |cffFFFF00Target.       | |r")
				print("|cffFFFF00 |___________________________________________| |r")
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
					or ni.player.buff("80169")
					or ni.player.buff(spells.FeignDeath.id)
					or ni.unit.isimmune("target")
					or UnitInVehicle("player")
			then
				return true;
			end
			ni.vars.debug = select(2, GetSetting("Debug"));
			if ni.unit.debuff("target", 3355)
					or ni.unit.debuff("target", spells.WyvernSting.id) -- sleeping from sting
			then
				PetStopAttack()
				StopAttack()
				ni.spell.stopcasting()
				return true;
			end
		end,


		["Cache"] = function()
			-- Anti AFK
			if GetTime() - AntiAFKTime > 80 then
				ni.utils.resetlasthardwareaction();
				AntiAFKTime = GetTime();
			end

			-- Player info
			Cache.PlayerFocus = UnitPower("player") or 0
			Cache.PlayerHP = 100 * UnitHealth("player") / UnitHealthMax("player")
			Cache.PlayerCombat = ni.player.incombat() or false;
			Cache.PlayerThreat = UnitThreatSituation("player", "target")
			Cache.PlayerLevel = UnitLevel("player") or 0
			Cache.PlayerPet = ni.unit.exists("pet") or false
			Cache.PlayerPetHP = ni.unit.hp("pet") or 0

			-- Ni Functions
			-- Alysrazor START
			if ni.unit.buff("player", 97128) then
				Cache.moving = false
			else
				Cache.moving = ni.player.ismoving() or false
			end
			-- Alyzrazor END

			local hasTarget = UnitExists("target") or false
			Cache.EnemyHP = 0
			Cache.EnemyLevel = 0
			Cache.EnemyExists = false
			Cache.InteractRange = false
			Cache.EnemyID = 0
			if hasTarget then
				-- Target info
				Cache.guid = UnitGUID("target") or nil
				Cache.EnemyHP = 100 * UnitHealth("target") / UnitHealthMax("target")
				Cache.EnemyLevel = UnitLevel("target")
				Cache.EnemyExists = ni.unit.exists("target")
				Cache.InteractRange = CheckInteractDistance("target", 3)
				Cache.EnemyID = tonumber(UnitGUID("target"):sub(-13, -9), 16)
				if ctInit == nil then
					ctInit = true
					function SwitchToHawk()
						if ni.spell.available(spells.AspectoftheHawk.id) then
							if not ni.player.buff(spells.AspectoftheHawk.id) and not UnitIsDeadOrGhost("player") and not ni.player.buff(spells.FeignDeath.id) then
								ni.spell.cast(spells.AspectoftheHawk.name)
							end
						end
					end

					function SwitchToFox()
						local FoxBuff = ni.player.buff(spells.AspectoftheFox.id)
						if ni.spell.available(spells.AspectoftheFox.id) then
							if Cache.moving and not FoxBuff and hasTarget and not UnitIsDeadOrGhost("player") and not ni.player.buff(spells.FeignDeath.id) then
								ni.spell.cast(spells.AspectoftheFox.name)
							end
						end
					end
				end
			end

			Cache.AOE = ni.vars.combat.aoe or false
			Cache.CD = ni.vars.combat.cd or false
			Cache.targets = ni.unit.enemiesinrange("target", 10) or {}
			Cache.PlayerControled = (ni.player.issilenced()
						or ni.player.isstunned()
						or ni.player.isconfused()
						or ni.player.isfleeing())
					or false;
			Cache.members = ni.members or {}
			if #Cache.members > 0 then
				table.sort(Cache.members, SortByHP)
			end
		end,

		["Mechanics"] = function()
			local enabled = GetSetting("Mechanics")
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
			local value, enabled = GetSetting("AutoTargeting")
			if not enabled then
				return false;
			end
			if Cache.PlayerCombat then
				if not UnitExists("target")
						or ((UnitExists("target")
								and UnitIsDeadOrGhost("target"))
							or not UnitCanAttack("player", "target"))
						and not IsCurrentSpell(GetSpellInfo(6603))
						or ni.unit.isimmune("target")
						or ni.unit.debuff("target", spells.WyvernSting.id)
						or ni.unit.debuff("target", 3355) then
					local enemies = ni.player.enemiesinrange(40);
					for i = 1, #enemies do
						local tar = enemies[i].guid;
						if enemies[i].distance <= 40
								and not ni.unit.istotem(tar)
								and ni.player.isfacing(tar)
								and not ni.unit.debuff(tar, 3355)
								and not ni.unit.debuff(tar, spells.WyvernSting.id)
								and not ni.unit.isimmune(tar) then
							ni.player.target(tar)
							ni.spell.cast(GetSpellInfo(6603), tar)
							return true;
						end
					end
				end
			end
		end,

		["CallPet"] = function()
			if UnitIsDead("pet") then
				if ni.spell.available(spells.HeartofThePhoenix.id)
						and not Cache.PlayerControled
						and Cache.PlayerCombat then
					ni.spell.cast(spells.HeartofThePhoenix.name)
					return true
				end
				if ni.spell.available(spells.RevivePet.id)
						and not Cache.moving
						and not Cache.PlayerControled
						and not Cache.PlayerCombat then
					ni.spell.cast(spells.RevivePet.name)
					return true
				end
			end
			local p = menus["Pet"]
			if p == 1 and ni.spell.available(spells.CallPet1.id) and not Cache.PlayerPet then
				ni.spell.cast(spells.CallPet1.name)
				return true
			end
			if p == 2 and ni.spell.available(spells.CallPet2.id) and not Cache.PlayerPet then
				ni.spell.cast(spells.CallPet2.name)
				return true
			end
			if p == 3 and ni.spell.available(spells.CallPet3.id) and not Cache.PlayerPet then
				ni.spell.cast(spells.CallPet3.name)
				return true
			end
			if p == 4 and ni.spell.available(spells.CallPet4.id) and not Cache.PlayerPet then
				ni.spell.cast(spells.CallPet4.name)
				return true
			end
			if p == 5 and ni.spell.available(spells.CallPet5.id) and not Cache.PlayerPet then
				ni.spell.cast(spells.CallPet5.name)
				return true
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

		["Healthstone (Use)"] = function()
			local hpVal, enabled = GetSetting("healthstoneuse");
			if not enabled then
				return false;
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

		["AOE - Multi Shot"] = function()
			if ni.spell.available(spells.MultiShot.id) then
				if Cache.AOE
						and ni.spell.valid("target", spells.MultiShot.name, true, true, false)
						and Cache.PlayerCombat
						and not Cache.PlayerControled then
					SwitchToHawk()
					ni.spell.cast(spells.MultiShot.name, "target")
				end
			end
		end,

		["CD - Rapid Fire"] = function()
			if ni.spell.available(spells.RapidFire.id) then
				if BossOrCD("target", 5, 5, 1, true)
						and Cache.PlayerCombat
						and not Cache.PlayerControled then
					ni.spell.cast(spells.RapidFire.name)
					return true
				end
			end
		end,

		["Mark - Hunter"] = function()
			if ni.spell.available(spells.HuntersMark.id) then
				if ni.spell.valid("target", spells.HuntersMark.name, false, false, false) then
					if not ni.unit.debuff("target", spells.HuntersMark.id)
							and not Cache.PlayerControled
							and Cache.PlayerHP <= Cache.EnemyHP then
						ni.spell.cast(spells.HuntersMark.name, "target")
						return true
					end
				end
			end
		end,

		["Pet - Mend Pet"] = function()
			if ni.spell.available(spells.MendPet.id) then
				if Cache.PlayerPet
						and not UnitIsDead("pet")
						and Cache.PlayerPetHP < 90
						and ni.spell.valid("pet", spells.MendPet.name, false, false, true)
						and not ni.unit.buff("pet", spells.MendPet.id) then
					ni.spell.cast(spells.MendPet.name, "pet")
					return true
				end
			end
		end,

		["Shot - Arcane"] = function()
			if ni.spell.available(spells.ArcaneShot.id) then
				if ni.spell.valid("target", spells.ArcaneShot.name, true, true, false)
						and Cache.PlayerCombat
						and not Cache.PlayerControled
						and Cache.PlayerFocus > 67
						and not ni.player.buff(56453) then
					SwitchToHawk()
					ni.spell.cast(spells.ArcaneShot.name, "target")
					return true
				end
			end
		end,

		["Shot - Arcane/LNL"] = function()
			if ni.spell.available(spells.ArcaneShot.id) then
				if select(2, GetSpellCooldown(spells.ExplosiveShot.id)) == 0
						and Cache.PlayerFocus > 67
						and not ni.player.buff(56453)
						and ni.unit.buff("target", spells.ExplosiveShot.id, "player") then
					SwitchToHawk()
					ni.spell.delaycast(spells.ArcaneShot.name, "target", 2.0)
				end
			end
		end,

		["Shot - Cobra"] = function()
			if ni.spell.available(spells.CobraShot.id) then
				if ni.spell.valid("target", spells.CobraShot.name, true, true, false)
						and Cache.PlayerCombat
						and not Cache.PlayerControled then
					if Cache.PlayerLevel >= 83 then
						SwitchToFox()
					end
					ni.spell.cast(spells.CobraShot.name, "target")
					return true
				end
			end
		end,

		["Shot - Steady"] = function()
			if ni.spell.available(spells.SteadyShot.id) and Cache.PlayerLevel < 81 then
				if ni.spell.valid("target", spells.SteadyShot.name, true, true, false)
						and Cache.PlayerCombat
						and not Cache.PlayerControled
						and not Cache.moving then
					SwitchToHawk()
					ni.spell.cast(spells.SteadyShot.name, "target")
					return true
				end
			end
		end,

		["Shot - Explosive"] = function()
			if ni.spell.available(spells.ExplosiveShot.id) then
				if ni.spell.valid("target", spells.ExplosiveShot.name, true, true, false)
						and Cache.PlayerCombat
						and not Cache.PlayerControled then
					SwitchToHawk()
					ni.spell.cast(spells.ExplosiveShot.name, "target")
					return true
				end
			end
		end,

		["Shot - Explosive/LNL"] = function()
			if ni.spell.available(spells.ExplosiveShot.id) then
				if ni.spell.valid("target", spells.ExplosiveShot.name, true, true, false)
						and Cache.PlayerCombat
						and not Cache.PlayerControled
						and ni.player.buff(56453) then
					SwitchToHawk()
					ni.spell.cast(spells.ExplosiveShot.name, "target")
					return true
				end
			end
		end,

		["Shot - Kill"] = function()
			if ni.spell.available(spells.KillShot.id) then
				if ni.spell.valid("target", spells.KillShot.name, true, true, false)
						and Cache.PlayerCombat
						and not Cache.PlayerControled
						and Cache.EnemyHP <= 20 then
					ni.spell.cast(spells.KillShot.name, "target")
					return true
				end
			end
		end,

		["Shot - Misdirection"] = function()
			local inParty = GetNumPartyMembers()
			if ni.spell.available(spells.Misdirection.id) then
				if inParty > 0 and not UnitInRaid("player") then
					for i = 1, inParty, 1 do
						local member = "party" .. tostring(i)
						if UnitGroupRolesAssigned(member) == "TANK"
								and UnitThreatSituation(member, "target") ~= 3
								and ni.spell.valid(member, spells.Misdirection.name, false, false, true) then
							ni.spell.cast(spells.Misdirection.name, member)
							return true
						end
					end
				end
			end
		end,

		["Shot - Tranquilizing"] = function()
			if ni.spell.available(spells.TranquilizingShot.id) then
				local i = 1
				local buff, _, _, _, bufftype = UnitBuff("target", i)
				while buff do
					if bufftype == "Magic" or buff == "Enrage" then
						if ni.spell.valid("target", spells.TranquilizingShot.name, true, true, false)
								and Cache.PlayerCombat
								and not Cache.PlayerControled then
							ni.spell.cast(spells.TranquilizingShot.name, "target")
							return true
						end
					end
					i = i + 1;
					buff, _, _, _, bufftype = UnitBuff("target", i)
				end
			end
		end,

		["Spec - Black Arrow"] = function()
			if not Cache.AOE then
				if ni.spell.available(spells.BlackArrow.id) then
					if ni.spell.valid("target", spells.BlackArrow.name, true, true, false)
							and Cache.PlayerCombat
							and not Cache.PlayerControled
							and not ni.player.buff(56453) then
						SwitchToHawk()
						ni.spell.cast(spells.BlackArrow.name, "target")
						return true
					end
				end
			end
		end,

		["Sting - Serpent"] = function()
			if ni.spell.available(spells.SerpentSting.id) then
				if ni.spell.valid("target", spells.SerpentSting.name, true, true, false)
						and Cache.PlayerCombat
						and not Cache.PlayerControled
						and not ni.unit.debuff("target", spells.SerpentSting.id) then
					SwitchToHawk()
					ni.spell.cast(spells.SerpentSting.name, "target")
					return true
				end
			end
		end,

		["Sting - Widow Venom"] = function()
			if ni.spell.available(spells.WidowVenom.id) then
				if ni.spell.valid("target", spells.WidowVenom.name, true, true, false)
						and Cache.PlayerCombat
						and not Cache.PlayerControled
						and not ni.unit.debuffs("target", "12294||82654||54680||13219") then
					ni.spell.cast(spells.WidowVenom.name, "target")
					return true
				end
			end
		end,

		["Strike - Raptor"] = function()
			if ni.spell.available(spells.RaptorStrike.id) then
				if ni.spell.valid("target", spells.RaptorStrike.name, true, true, false)
						and Cache.PlayerCombat
						and not Cache.PlayerControled then
					ni.spell.cast(spells.RaptorStrike.name, "target")
					return true
				end
			end
		end,

		["Strike - Wing Clip"] = function()
			if ni.spell.available(spells.WingClip.id)
					and not ni.spell.available(spells.RaptorStrike.id) then
				if ni.spell.valid("target", spells.WingClip.name, true, true, false)
						and Cache.PlayerCombat
						and not Cache.PlayerControled then
					ni.spell.cast(spells.WingClip.name, "target")
					return true
				end
			end
		end,

		["Trap - Explosive"] = function()
			if not ni.player.buff(spells.TrapLauncher.name) then
				return false;
			end
			local LauncherExplosiveTrap = GetSpellInfo(82939)
			if ni.spell.available(LauncherExplosiveTrap) and Cache.AOE then
				ni.spell.castat(LauncherExplosiveTrap, "target")
				return true;
			end
		end,

		["Trap - Freezing"] = function()
			if not ni.player.buff(spells.TrapLauncher.name) then
				return false;
			end
			local LauncherFreezingTrap = GetSpellInfo(60192)
			if IsLeftShiftKeyDown() and GetCurrentKeyBoardFocus() == nil and ni.spell.available(LauncherFreezingTrap) and not Cache.PlayerCombat then
				if ni.unit.exists("focus") then
					ni.spell.castat(LauncherFreezingTrap, "focus")
					return true;
				end
			end
		end,

		["Trap - Ice"] = function()
			local enabled = GetSetting("IceTrap")
			if not ni.player.buff(spells.TrapLauncher.name) then
				return false;
			end
			local LauncherIceTrap = GetSpellInfo(82941)
			if enabled and ni.spell.available(LauncherIceTrap) and Cache.AOE then
				ni.spell.castat(LauncherIceTrap, "target")
				return true;
			end
		end,

		["Trap - Launcher"] = function()
			local enabled = GetSetting("IceTrap")
			if Cache.AOE
					and not ni.player.buff(spells.TrapLauncher.name)
					and (ni.spell.available(spells.TrapLauncher.name)
						and ni.spell.available(spells.ExplosiveTrap.name))
					and ni.spell.valid("target", spells.CobraShot.name, false, true)
					or not ni.player.buff(spells.TrapLauncher.name)
					and (ni.spell.available(spells.TrapLauncher.name)
						and ni.spell.available(spells.FreezingTrap.name) and IsLeftShiftKeyDown() and GetCurrentKeyBoardFocus() == nil and not Cache.PlayerCombat)
					and ni.spell.valid("focus", spells.CobraShot.name, false, true)
					or enabled
					and Cache.AOE
					and not ni.player.buff(spells.TrapLauncher.name)
					and (ni.spell.available(spells.TrapLauncher.name)
						and ni.spell.available(spells.IceTrap.name))
					and ni.spell.valid("target", spells.CobraShot.name, false, true) then
				ni.spell.cast(spells.TrapLauncher.name)
				return true;
			end
		end,
	};

	ni.bootstrap.profile("Cata_SV_Trojan", queue, abilities, OnLoad, OnUnLoad);
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
	ni.bootstrap.profile("Cata_SV_Trojan", queue, abilities);
end
;
