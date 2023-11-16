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
	local spells = {
		ConjureManaGem = { id = 759, name = GetSpellInfo(759) },
		ConjureRefreshment = { id = 42955, name = GetSpellInfo(42955) },
		MoltenArmor = { id = 30482, name = GetSpellInfo(30482) },
		ArcaneBrilliance = { id = 1459, name = GetSpellInfo(1459) },
		Evocation = { id = 12051, name = GetSpellInfo(12051) },
		Pyroblast = { id = 11366, name = GetSpellInfo(11366) },
		Scorch = { id = 2948, name = GetSpellInfo(2948) },
		LivingBomb = { id = 44457, name = GetSpellInfo(44457) },
		MirrorImage = { id = 55342, name = GetSpellInfo(55342) },
		Combustion = { id = 11129, name = GetSpellInfo(11129) },
		Fireblast = { id = 2136, name = GetSpellInfo(2136) },
		Fireball = { id = 133, name = GetSpellInfo(133) },
		FlameOrb = { id = 82731, name = GetSpellInfo(82731) },
		Spellsteal = { id = 30449, name = GetSpellInfo(30449) },
		Berserking = { id = 26297, name = GetSpellInfo(26297) },
		Flamestrike = { id = 2120, name = GetSpellInfo(2120) },
		BlastWave = { id = 11113, name = GetSpellInfo(11113) },
		IceBlock = { id = 45438, name = GetSpellInfo(45438) },
		DragonsBreath = { id = 31661, name = GetSpellInfo(31661) },
		MageArmor = { id = 6117, name = GetSpellInfo(6117) },
	};

	local items = {
		settingsfile = "Cata_Fire_Trojan.json",
		{
			type = "title",
			text =
			">                          Mage - Fire PvE by |cFFFF0000Trojan                          |cFFFFFFFF<"
		},
		{ type = "separator" },
		{ type = "title",    text = "|cffFFFF00Mana Settings" },
		{
			type = "entry",
			text = "\124T" .. GetItemIcon(36799) .. ":26:26\124t Use Mana Gem < MP%",
			tooltip =
			"Use Mana Gem < MP%",
			enabled = true,
			value = 70,
			key =
			"ManaGem"
		},
		{
			type = "entry",
			text = "\124T" .. select(3, GetSpellInfo(12051)) .. ":26:26\124t Use Evocation < MP%",
			tooltip =
			"Use Evocation < MP%",
			enabled = true,
			value = 10,
			key =
			"Evocation"
		},
		{
			type = "entry",
			text = "\124T" .. select(3, GetSpellInfo(42955)) .. ":26:26\124t Eat Food < MP%",
			tooltip =
			"Eat Food < MP%",
			enabled = true,
			value = 20,
			key =
			"ConjureRefreshment"
		},
		{ type = "separator" },
		{ type = "title",    text = "|cffFFFF00Spell Settings" },
		{
			type = "entry",
			text = "\124T" .. select(3, GetSpellInfo(2948)) .. ":26:26\124t Use Scorch while moving",
			tooltip =
			"Use Scorch",
			enabled = true,
			key =
			"Scorch"
		},
		{
			type = "entry",
			text = "\124T" .. select(3, GetSpellInfo(82731)) .. ":26:26\124t Use Flame Orb",
			tooltip =
			"Use Flame Orb",
			enabled = true,
			key =
			"FlameOrb"
		},
		{
			type = "entry",
			text = "\124T" .. select(3, GetSpellInfo(45438)) .. ":26:26\124t Use Ice Block",
			tooltip =
			"Use Ice Block @ HP%",
			enabled = true,
			value = 10,
			key =
			"IceBlock"
		},
		{ type = "separator" },
		{ type = "title",    text = "|cffFFFF00Mechanic Settings" },
		{
			type = "entry",
			text = "\124T" .. select(3, GetSpellInfo(7849)) .. ":16:16\124t Do Boss Mechanics",
			tooltip = "Do Boss Mechanics",
			enabled = true,
			key = "Mechanics"
		},
		{
			type = "entry",
			text = "\124T" .. select(3, GetSpellInfo(30449)) .. ":26:26\124t Do Spellsteal",
			tooltip =
			"Do Spellsteal",
			enabled = true,
			key =
			"Spellsteal"
		},
		{
			type = "entry",
			text = "\124T" .. select(3, GetSpellInfo(55342)) .. ":26:26\124t Use Mirror Image",
			tooltip =
			"Use Mirror Image when you have the aggro from a mob",
			enabled = true,
			key =
			"MirrorImage"
		},
		{
			type = "entry",
			text = "\124T" .. select(3, GetSpellInfo(6603)) .. ":26:26\124t Do Auto Targeting",
			tooltip =
			"Stops auto Targeting when health below this",
			enabled = true,
			key =
			"AutoTargeting"
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
		{ type = "separator" },
		{ type = "title",    text = "|cffFFFF00Racials" },
		{
			type = "entry",
			text = "\124T" .. select(3, GetSpellInfo(26297)) .. ":26:26\124t Use Berserking",
			tooltip =
			"Use Berserking",
			enabled = true,
			key =
			"Berserking"
		},
	};

	local queue = {
		"Pause",
		"Cache",
		"Mechanics",
		"Targeting",
		"Ice Block",
		"Molten Armor",
		"Mage Armor",
		"Arcane Brilliance",
		"Conjure Mana Gem",
		"Mana Gem",
		"Conjure Refreshment",
		"Refreshment",
		"Evocation",
		"Spellsteal",
		"Berserking",
		"Items",
		"Mirror Image",
		"Flame Orb",
		"Combustion",
		"Living Bomb",
		"Pyroblast",
		"Fireblast",
		"Dragons Breath",
		"Blast Wave",
		"Flamestrike",
		"Scorch",
		"Fireball",
	};

	local flBosses = {
		Shannox = { id = 53691, encounter = 1205 },
		Rageface = { id = 53695, encounter = 1205 },
		Riplimb = { id = 53694, encounter = 1205 },
		Rhyolith = { id = 52558, encounter = 1204 },
		Bethtilac = { id = 52498, encounter = 1197 },
		Alysrazor = { id = 52530, encounter = 1206 },
		Baleroc = { id = 53494, encounter = 1200 },
		Majordomo = { id = 52571, encounter = 1185, cat = GetSpellInfo(98374) },
		Ragnaros = { id = 52409, encounter = 1203 },
	}

	local encounter = {
		id = 0,
		name = "",
		difficulty = 0,
		groupSize = 0,
	}

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

	local pyroNormal, pyroStreak = { [GetSpellInfo(11366)] = true }, { [GetSpellInfo(92315)] = true }
	local function CombatEventCatcher(event, ...)
		if event == "CHAT_MSG_RAID_WARNING" then
			local text = ...
			local lowercaseText = string.lower(text)
			if string.find(lowercaseText, "pull in 3")
			then
				if ni.spell.available(spells.Pyroblast.id)
					and UnitExists("target")
				then
					ni.spell.cast(spells.Pyroblast.name, "target")
					return true
				end
			end
		end
		if event == "UNIT_SPELLCAST_SUCCEEDED" then
			local unitID, spellName = ...
			if pyroNormal[spellName] or pyroStreak[spellName] then
				pyroTime = GetTime()
			end
		end
	end

	local function EncounterEventCatcher(event, ...)
		if event == "ENCOUNTER_START" then
			local encounterID, encounterName, difficultyID, groupSize = ...
			encounter.id = encounterID
			encounter.name = encounterName
			encounter.difficulty = difficultyID
			encounter.groupSize = groupSize
			ni.debug.print("Encounter started: " .. encounterName)
		elseif event == "ENCOUNTER_END" then
			local encounterID, encounterName, difficultyID, groupSize, success = ...
			encounter.id = 0
			encounter.name = ""
			encounter.difficulty = 0
			ni.debug.print("Encounter ended: " .. encounterName)
		end
	end

	local notfram = ni.utils.generaterandomname();
	local function OnLoad()
		ni.vars.debug = false
		-- register the events we want to use
		notfram = CreateFrame("frame", notfram)
		notfram:RegisterEvent("ENCOUNTER_START")
		notfram:RegisterEvent("ENCOUNTER_END")
		-- set the event handler
		notfram:SetScript("OnEvent", EncounterEventCatcher)
		-- register the combatlog event handler
		ni.combatlog.registerhandler("Cata_Fire_Trojan", CombatEventCatcher);
		-- add the gui frame
		if not ni.vars.stream then
			ni.GUI.AddFrame("Cata_Fire_Trojan", items);
		end
	end


	local function OnUnLoad()
		-- unregister the events
		notfram:UnregisterEvent("ENCOUNTER_START")
		notfram:UnregisterEvent("ENCOUNTER_END")
		-- unregister the handler
		ni.combatlog.unregisterhandler("Cata_Fire_Trojan");
		-- remove the gui frame
		if not ni.vars.stream then
			ni.GUI.DestroyFrame("Cata_Fire_Trojan");
		end
	end

	local abilities = {
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
				or ni.unit.buff("player", 66, "player") -- Invisibility --
				or ni.unit.buff("player", 32612, "player") -- Invisibility --
				or UnitIsFriend("player", "target")
				or UnitInVehicle("player")
			then
				return true;
			end
			ni.vars.debug = select(2, GetSetting("Debug"));
		end,

		["Cache"] = function()
			Cache = {
				moving = ni.player.ismoving(),
			}
		end,

		["Mechanics"] = function()
			local enabled = GetSetting("Mechanics")
			if enabled then
				-- Avoid sudden death on Ultraxion
				local fadingtime = select(7, ni.unit.debuff("player", 110070))
				if fadingtime and fadingtime - GetTime() < 1.5 then RunMacroText("/click ExtraActionButton1") end

				-- Avoid Hour of Twilight on Ultraxion, Delete next 3 lines if you are working as tank
				local channelSpell, _, _, _, _, endTime = UnitCastingInfo("boss1")
				if channelSpell == GetSpellInfo(109417) and endTime / 1000 - GetTime() < 1.1
				then
					RunMacroText("/click ExtraActionButton1")
				end

				-- Avoid sudden death on Madness
				local tentacledeath = select(7, ni.unit.debuff("player", 109597))
				if tentacledeath and tentacledeath - GetTime() < 1 then RunMacroText("/click ExtraActionButton1") end

				-- Shannox START
				-- if encounter.id == flBosses.Shannox.encounter then
				for i = 1, #ni.members do
					if ni.unit.debuffs(ni.members[i].unit, "99947||99948||100129") then
						TargetUnit(tostring(flBosses.Rageface.id))
					end
				end
				if ni.unit.id("target") == 53694 then -- riplimb

				end
				if ni.unit.id("target") == 53695 then -- rageface

				end
				-- end
				-- Shannox END
				-- Alysrazor START

				-- if encounter.id == flBosses.Alysrazor.encounter then
				if ni.unit.buff("player", 97128, "player") then
					Cache.moving = false
				else
					Cache.moving = ni.player.ismoving()
				end
				-- end

				-- Alyzrazor END	
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

		["Ice Block"] = function()
			local value, enabled = GetSetting("IceBlock")
			if not enabled then
				return false;
			end
			if ni.spell.available(spells.IceBlock.id)
				and ni.unit.hp("player") <= value then
				ni.spell.cast(spells.IceBlock.name)
				return true;
			end
		end,

		["Molten Armor"] = function()
			if ni.player.buff(spells.MoltenArmor.id) then
				return false;
			end
			if ni.spell.available(spells.MoltenArmor.id) and ni.player.power(0) > 10 then
				ni.spell.cast(spells.MoltenArmor.name)
				return true;
			end
		end,

		["Mage Armor"] = function()
			if ni.player.buff(spells.MageArmor.id) then
				return false;
			end
			if ni.spell.available(spells.MageArmor.id)
				and ni.player.power(0) <= 10
			then
				ni.spell.cast(spells.MageArmor.name)
				return true;
			end
		end,

		["Arcane Brilliance"] = function()
			if ni.spell.available(spells.ArcaneBrilliance.id) then
				for i = 1, #ni.members do
					if not ni.unit.buffs(ni.members[i].unit, "1459||61316") and ni.members[i]:range() then
						ni.spell.cast(spells.ArcaneBrilliance.name, ni.members[i].unit)
						return true
					end
				end
			end
		end,

		["Conjure Mana Gem"] = function()
			if Cache.moving
				or ni.player.incombat() then
				return false;
			end
			if not ni.player.hasitem(36799)
				and ni.spell.available(spells.ConjureManaGem.id) then
				ni.spell.cast(spells.ConjureManaGem.name)
				return true;
			end
		end,

		["Mana Gem"] = function()
			local value, enabled = GetSetting("ManaGem")
			if not enabled
				or not ni.player.incombat() then
				return false;
			end
			if ni.player.power(0) <= value
				and ni.player.hasitem(36799) -- Mana Sapphire --
				and ni.player.itemcd(36799) < 1 then -- Mana Sapphire --
				ni.player.useitem(36799)  -- Mana Sapphire --
				return true;
			end
		end,

		["Conjure Refreshment"] = function()
			if Cache.moving
				or ni.player.incombat() then
				return false;
			end
			if not ni.player.hasitem(65499)
				and ni.spell.available(spells.ConjureRefreshment.id)
				and not Cache.moving then
				ni.spell.cast(spells.ConjureRefreshment.name)
				return true;
			end
		end,

		["Refreshment"] = function()
			local value, enabled = GetSetting("ConjureRefreshment")
			if not enabled
				or ni.player.incombat() then
				return false;
			end
			if (ni.player.power(0) <= value or ni.player.hp(0) <= value)
				and ni.player.hasitem(65499) -- Mana Cookie --
				and not ni.player.buffs("87959||80169")
				and not Cache.moving then
				ni.player.useitem(65499) -- Mana Cookie --
				return true;
			end
		end,

		["Evocation"] = function()
			local value, enabled = GetSetting("Evocation")
			if not enabled
				or not ni.player.incombat() then
				return false;
			end
			if ni.player.power(0) <= value
				and ni.spell.available(spells.Evocation.id) then
				ni.spell.cast(spells.Evocation.name)
				return true;
			end
		end,

		["Spellsteal"] = function()
			local enabled = GetSetting("Spellsteal")
			if not enabled
				or not ni.player.incombat() then
				return false;
			end
			local stealBuffs =
			"43242||92965||93631||76634||88186||76307||31884||2825||32182||80353||1719||17||33763||96802||6940||102599||89542||11426||79735||77912";
			if ni.spell.available(spells.Spellsteal.id)
				and ni.unit.buffs("target", stealBuffs, "player") then
				ni.spell.cast(spells.Spellsteal.name, "target")
				return true;
			end
		end,

		["Berserking"] = function()
			local value, enabled = GetSetting("Berserking")
			if not enabled
				or not ni.player.incombat() then
				return false;
			end
			if ni.spell.available(spells.Berserking.id)
				and ni.unit.buffs("player", "80353||32182||2825") then
				ni.spell.cast(spells.Berserking.name)
				return true;
			end
		end,

		["Items"] = function()
			if ni.vars.combat.cd
				and UnitAffectingCombat("player") then
				if ni.player.slotcastable(10)
					and ni.player.slotcd(10) == 0 then
					ni.player.useinventoryitem(10)
				end
				if ni.player.slotcastable(13)
					and ni.player.slotcd(13) == 0 then
					ni.player.useinventoryitem(13)
				end
				if ni.player.slotcastable(14)
					and ni.player.slotcd(14) == 0 then
					ni.player.useinventoryitem(14)
				end
			end
		end,

		["Mirror Image"] = function()
			local _, enabled = GetSetting("MirrorImage")
			if not enabled
				or not ni.player.incombat() then
				return false;
			end
			if #ni.members <= 1 then
				return false;
			end
			if ni.unit.isboss("target")
				and ni.player.threat() >= 3
				and ni.spell.available(spells.MirrorImage.id)
				and not ni.members.inrange("player", 40) == nil then
				ni.spell.cast(spells.MirrorImage.name, "player")
				return true;
			end
		end,

		["Flame Orb"] = function()
			local _, enabled = GetSetting("FlameOrb")
			if not enabled
				or not ni.player.incombat() then
				return false;
			end
			if ni.spell.available(spells.FlameOrb.id) then
				ni.spell.cast(spells.FlameOrb.name, "target")
				return true;
			end
		end,

		["Combustion"] = function()
			if ni.vars.combat.cd
				and ni.unit.isboss("target")
				and UnitAffectingCombat("player")
				and ni.spell.available(spells.Combustion.id)
				and ni.unit.debuffs("target", "44457&&12654", "player") -- spread dots mage --
				and ni.unit.debuffs("target", "92315||11366", "player") -- Pyroblast! --
			then
				ni.spell.cast(spells.Combustion.name, "target")
				return true;
			end
		end,

		["Living Bomb"] = function()
			if ni.spell.available(spells.LivingBomb.id)
				and UnitAffectingCombat("player")
				and UnitExists("target")
				and ni.unit.debuff("target", 44457, "player") == nil -- Living Bomb --
			then
				ni.spell.cast(spells.LivingBomb.name, "target")
				return true;
			end
		end,

		["Pyroblast"] = function()
			if ni.spell.available(spells.Pyroblast.id)
				and UnitAffectingCombat("player")
				and ni.unit.buff("player", 48108, "player") -- Hot Streak --
				and UnitExists("target")
			then
				ni.spell.cast(spells.Pyroblast.name, "target")
				return true;
			end
			if not pyroTime or math.round((GetTime() - pyroTime), 0.01) > 2.5 then
				if not ni.unit.debuffs("target", "92315||11366", "player") -- Pyroblast! --
					and UnitAffectingCombat("player")
					and ni.spell.available(spells.Pyroblast.id)
					and UnitExists("target")
					and not Cache.moving
					and ni.unit.ttd("target") > 10 then
					ni.spell.cast(spells.Pyroblast.name, "target")
					return true;
				end
			end
		end,

		["Fireblast"] = function()
			if ni.vars.combat.aoe
				and ni.spell.available(spells.Fireblast.id)
				and UnitAffectingCombat("player")
				and ni.unit.debuff("target", 44457, "player") -- spead dots mage --
				and ni.unit.buff("player", 64343, "player") -- Impact --
			then
				ni.spell.cast(spells.Fireblast.name, "target")
				return true;
			end
		end,

		["Dragons Breath"] = function()
			if ni.spell.available(spells.DragonsBreath.id)
				and CheckInteractDistance("target", 3)
				and UnitAffectingCombat("player") then
				ni.spell.cast(spells.DragonsBreath.name, "target")
			end
		end,

		["Blast Wave"] = function()
			if ni.spell.available(spells.BlastWave.id)
				and ni.vars.combat.aoe
				and UnitAffectingCombat("player")
			then
				ni.spell.castat(spells.BlastWave.name, "mouse")
				return true
			end
			if ni.spell.available(spells.BlastWave.id)
				and UnitAffectingCombat("player")
				and (ni.unit.id("target") == 52447 or ni.unit.id("target") == 53695) -- spiderling -- 					
			then
				ni.spell.castat(spells.BlastWave.name, "target")
				return true
			end
		end,

		["Flamestrike"] = function()
			if ni.spell.available(spells.Flamestrike.id)
				and ni.vars.combat.aoe
				and UnitAffectingCombat("player")
			then
				ni.spell.castat(spells.Flamestrike.name, "mouse")
				return true
			end
		end,

		["Scorch"] = function()
			local _, enabled = GetSetting("Scorch")
			if ni.spell.available(spells.Scorch.id)
				and UnitAffectingCombat("player")
				and ni.unit.debuff("target", 22959)        -- Improved Scorch --
				and ni.unit.debuffremaining("target", 22959) < 3 then -- Improved Scorch --
				ni.spell.cast(spells.Scorch.name, "target")
				return true;
			end
			if enabled
				and Cache.moving
				and ni.spell.available(spells.Scorch.id)
				and not Cache.moving
				and UnitAffectingCombat("player") then
				ni.spell.cast(spells.Scorch.name, "target")
				return true;
			end
		end,

		["Fireball"] = function()
			if ni.spell.available(spells.Fireball.id)
				and UnitAffectingCombat("player")
			then
				ni.spell.cast(spells.Fireball.name, "target")
				return true;
			end
		end,

	};

	ni.bootstrap.profile("Cata_Fire_Trojan", queue, abilities, OnLoad, OnUnLoad);
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
	ni.bootstrap.profile("Cata_Fire_Trojan", queue, abilities);
end
;
