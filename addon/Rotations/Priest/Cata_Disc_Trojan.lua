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
		-- DPS Spells
		Smite = { id = 585, name = GetSpellInfo(585), icon = select(3, GetSpellInfo(585)) },
		ShadowWordPain = { id = 589, name = GetSpellInfo(589), icon = select(3, GetSpellInfo(589)) },
		-- Heal Spells
		FlashHeal = { id = 2061, name = GetSpellInfo(2061), icon = select(3, GetSpellInfo(2061)) },
		-- Defentisve Spells
		PowerWordShield = { id = 17, name = GetSpellInfo(17), icon = select(3, GetSpellInfo(17)) },
		-- Racial
		Berserking = { id = 26297, name = GetSpellInfo(26297), icon = select(3, GetSpellInfo(26297)) },
		-- Debuffs
		WeakenedSoul = { id = 6788, name = GetSpellInfo(6788), icon = select(3, GetSpellInfo(6788)) },
		-- Buffs
		InnerFire = { id = 588, name = GetSpellInfo(588), icon = select(3, GetSpellInfo(588)) },
	};

	local items = {
		settingsfile = "Cata_Disc_Trojan.json",
		{
			type = "title",
			text =
			">                          Priest - Discipline PvE by |cFFFF0000Trojan                          |cFFFFFFFF<"
		},
		{ type = "separator" },
		{ type = "page",     number = 1, text = "|cffFFFF00Main Settings" },
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
		{ type = "page",     number = 2,          text = "|cffFFFF00Heal Settings" },
		{ type = "separator" },
		{ type = "title",    text = "Heal Spells" },
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.FlashHeal.icon .. ":18:18\124t Flash Heal",
			tooltip = "Use Flash Heal on Players below |cff00D700HP|r",
			enabled = true,
			value = 85,
			min = 0,
			max = 100,
			step = 1,
			key = "FlashHeal"
		},
		{ type = "page",     number = 3,         text = "|cffFFFF00DPS Settings" },
		{ type = "separator" },
		{ type = "title",    text = "DMG Spells" },
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.Smite.icon .. ":18:18\124t Smite",
			tooltip = "Use Smite in your Rotation",
			enabled = true,
			key = "Smite"
		},
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.ShadowWordPain.icon .. ":18:18\124t Shadow Word: Pain",
			tooltip = "Use Shadow Word: Pain in your Rotation",
			enabled = true,
			key = "ShadowWordPain"
		},
		{ type = "page",     number = 4,                        text = "|cffFFFF00Defensive Settings" },
		{ type = "separator" },
		{ type = "title",    text = "Spell Settings" },
		{ type = "separator" },
		{ type = "title",    text = "Class Specific Defensives" },
		{
			type = "entry",
			text = "\124T" .. spells.PowerWordShield.icon .. ":18:18\124t Power Word: Shield Tanks",
			tooltip = "Use Power Word: Shield on Tanks below |cff00D700HP|r",
			enabled = true,
			value = 99,
			min = 0,
			max = 100,
			step = 1,
			key = "PowerWordShieldTanks"
		},
		{
			type = "entry",
			text = "\124T" .. spells.PowerWordShield.icon .. ":18:18\124t Power Word: Shield",
			tooltip = "Use Power Word: Shield on Players below |cff00D700HP|r",
			enabled = true,
			value = 30,
			min = 0,
			max = 100,
			step = 1,
			key = "PowerWordShield"
		},
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

	};

	local queue = {
		"Information",
		"Pause",
		"Cache",
		"Mechanics",
		"Targeting",
		"Healthstone (Use)",
		"Use Castable Items",
		"Racial (Use)",
		"Buff - InnerFire",
		"Def - PowerWordShieldTanks",
		"Def - PowerWordShield",
		"Heal - Flash Heal",
		"DPS - ShadowWordPain",
		"DPS - Smite",
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
		ni.combatlog.registerhandler("Cata_Disc_Trojan", CombatEventCatcher);
		-- add the gui frame
		if not ni.vars.stream then
			ni.GUI.AddFrame("Cata_Disc_Trojan", items);
		end
	end


	local function OnUnLoad()
		-- unregister the handler
		ni.combatlog.unregisterhandler("Cata_Disc_Trojan");
		-- remove the gui frame
		if not ni.vars.stream then
			ni.GUI.DestroyFrame("Cata_Disc_Trojan");
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
				print("|cffFFFF00 |        Disc Priest PvE by |cFFFF0000Trojan |cffFFFF00loaded.           | |r")
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
				or ni.unit.isimmune("target")
				or UnitInVehicle("player")
			then
				return true;
			end
			ni.vars.debug = select(2, GetSetting("Debug"));
		end,


		["Cache"] = function()
			-- Anti AFK
			if GetTime() - AntiAFKTime > 80 then
				ni.utils.resetlasthardwareaction();
				AntiAFKTime = GetTime();
			end

			-- Player info
			Cache.PlayerMana = UnitPower("player") or 0
			Cache.PlayerHP = 100 * UnitHealth("player") / UnitHealthMax("player")
			Cache.PlayerCombat = ni.player.incombat() or false;
			Cache.PlayerThreat = UnitThreatSituation("player", "target")
			Cache.PlayerLevel = UnitLevel("player") or 0
			Cache.PlayerPet = ni.unit.exists("pet") or false

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
					-- some functions for this CR
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
					or ni.unit.debuff("target", 19386)
					or ni.unit.debuff("target", 3355) then
					local enemies = ni.player.enemiesinrange(40);
					for i = 1, #enemies do
						local tar = enemies[i].guid;
						if enemies[i].distance <= 40
							and not ni.unit.istotem(tar)
							and ni.player.isfacing(tar)
							and not ni.unit.debuff(tar, 3355)
							and not ni.unit.debuff(tar, 19386)
							and not ni.unit.isimmune(tar) then
							ni.player.target(tar)
							ni.spell.cast(GetSpellInfo(6603), tar)
							return true;
						end
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

		["DPS - Smite"] = function()
			local _, enabled = GetSetting("Smite");
			if enabled and ni.spell.available(spells.Smite.id) then
				if not Cache.PlayerControled
					and Cache.PlayerCombat
					and ni.spell.valid("target", spells.Smite.id, true, true, false) then
					ni.spell.cast(spells.Smite.name, "target")
					return true;
				end
			end
		end,

		["DPS - ShadowWordPain"] = function()
			local _, enabled = GetSetting("ShadowWordPain");
			if enabled and ni.spell.available(spells.ShadowWordPain.id) then
				if not Cache.PlayerControled
					and Cache.PlayerCombat
					and ni.spell.valid("target", spells.ShadowWordPain.id, false, true, false)
					and not ni.unit.debuff("target", spells.ShadowWordPain.id, "player") then
					ni.spell.cast(spells.ShadowWordPain.name, "target")
					return true;
				end
			end
		end,
		["Def - PowerWordShield"] = function()
			local value, enabled = GetSetting("PowerWordShield");
			if enabled and ni.spell.available(spells.PowerWordShield.id) then
				if not Cache.PlayerControled
					and Cache.PlayerCombat then
					for i = 1, #Cache.members do
						if Cache.members[i].hp() <= value
							and Cache.members[i]:valid(spells.PowerWordShield.id, false, true, true)
							and not ni.unit.buff(Cache.members[i].unit, spells.PowerWordShield.id)
							and not ni.unit.debuff(Cache.members[i].unit, spells.WeakenedSoul.id) then
							ni.spell.cast(spells.PowerWordShield.name, Cache.members[i].unit)
							return true;
						end
					end
				end
			end
		end,

		["Def - PowerWordShieldTanks"] = function()
			local value, enabled = GetSetting("PowerWordShieldTanks");
			if enabled and ni.spell.available(spells.PowerWordShield.id) then
				if not Cache.PlayerControled
					and Cache.PlayerCombat then
					for i = 1, #Cache.members do
						if Cache.members[i].hp() <= value
							and (Cache.members[i]:istank() or Cache.members[i].role == "TANK")
							and Cache.members[i]:valid(spells.PowerWordShield.id, false, true, true)
							and not ni.unit.buff(Cache.members[i].unit, spells.PowerWordShield.id)
							and not ni.unit.debuff(Cache.members[i].unit, spells.WeakenedSoul.id) then
							ni.spell.cast(spells.PowerWordShield.name, Cache.members[i].unit)
							return true;
						end
					end
				end
			end
		end,

		["Heal - Flash Heal"] = function()
			local value, enabled = GetSetting("FlashHeal");
			if enabled and ni.spell.available(spells.FlashHeal.id) then
				if not Cache.PlayerControled
					and Cache.PlayerCombat then
					for i = 1, #Cache.members do
						if Cache.members[i].hp() <= value
							and Cache.members[i]:valid(spells.FlashHeal.id, false, true, true) then
							ni.spell.cast(spells.FlashHeal.name, Cache.members[i].unit)
							return true;
						end
					end
				end
			end
		end,

		["Buff - InnerFire"] = function()
			if ni.spell.available(spells.InnerFire.id) then
				if not Cache.PlayerControled
					and not ni.unit.buff("player", spells.InnerFire.id) then
					ni.spell.cast(spells.InnerFire.name)
					return true;
				end
			end
		end,
	};

	ni.bootstrap.profile("Cata_Disc_Trojan", queue, abilities, OnLoad, OnUnLoad);
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
	ni.bootstrap.profile("Cata_Disc_Trojan", queue, abilities);
end
;
