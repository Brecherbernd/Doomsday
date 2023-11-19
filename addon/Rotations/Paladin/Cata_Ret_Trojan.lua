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
local AntiAFKTime = 0
local KnowEngineer = ni.player.getskillinfo(GetSpellInfo(4036)) > 500 or false;
local Cache = {}
-- local licensed = licensing.licensed()
if cata
-- and licensed 
then
	local spells = {
		--Holy icon = select(2, GetSpellTabInfo(2))
		Cleanse = { id = 4987, name = GetSpellInfo(4987), icon = select(3, GetSpellInfo(4987)) },
		ConcentrationAura = { id = 19746, name = GetSpellInfo(19746), icon = select(3, GetSpellInfo(19746)) },
		Consecration = { id = 26573, name = GetSpellInfo(26573), icon = select(3, GetSpellInfo(26573)) },
		DivineLight = { id = 82326, name = GetSpellInfo(82326), icon = select(3, GetSpellInfo(82326)) },
		DivinePlea = { id = 54428, name = GetSpellInfo(54428), icon = select(3, GetSpellInfo(54428)) },
		Exorcism = { id = 879, name = GetSpellInfo(879), icon = select(3, GetSpellInfo(879)) },
		FlashofLight = { id = 19750, name = GetSpellInfo(19750), icon = select(3, GetSpellInfo(19750)) },
		HolyLight = { id = 635, name = GetSpellInfo(635), icon = select(3, GetSpellInfo(635)) },
		HolyRadiance = { id = 82327, name = GetSpellInfo(82327), icon = select(3, GetSpellInfo(82327)) },
		HolyWrath = { id = 2812, name = GetSpellInfo(2812), icon = select(3, GetSpellInfo(2812)) },
		LayonHands = { id = 633, name = GetSpellInfo(633), icon = select(3, GetSpellInfo(633)) },
		Redemption = { id = 7328, name = GetSpellInfo(7328), icon = select(3, GetSpellInfo(7328)) },
		SealofInsight = { id = 20165, name = GetSpellInfo(20165), icon = select(3, GetSpellInfo(20165)) },
		TurnEvil = { id = 10326, name = GetSpellInfo(10326), icon = select(3, GetSpellInfo(10326)) },
		WordofGlory = { id = 85673, name = GetSpellInfo(85673), icon = select(3, GetSpellInfo(85673)) },
		JudgementsofthePure = { id = 53657, name = GetSpellInfo(53657), icon = select(3, GetSpellInfo(53657)) },
		--Protection icon = select(2, GetSpellTabInfo(3))
		BlessingofKings = { id = 20217, name = GetSpellInfo(20217), icon = select(3, GetSpellInfo(20217)) },
		DevotionAura = { id = 465, name = GetSpellInfo(465), icon = select(3, GetSpellInfo(465)) },
		DivineProtection = { id = 498, name = GetSpellInfo(498), icon = select(3, GetSpellInfo(498)) },
		DivineShield = { id = 642, name = GetSpellInfo(642), icon = select(3, GetSpellInfo(642)) },
		GuardianofAncientKings = { id = 86150, name = GetSpellInfo(86150), icon = select(3, GetSpellInfo(86150)) },
		HammerofJustice = { id = 853, name = GetSpellInfo(853), icon = select(3, GetSpellInfo(853)) },
		HandofFreedom = { id = 1044, name = GetSpellInfo(1044), icon = select(3, GetSpellInfo(1044)) },
		HandofProtection = { id = 1022, name = GetSpellInfo(1022), icon = select(3, GetSpellInfo(1022)) },
		HandofReckoning = { id = 62124, name = GetSpellInfo(62124), icon = select(3, GetSpellInfo(62124)) },
		HandofSacrifice = { id = 6940, name = GetSpellInfo(6940), icon = select(3, GetSpellInfo(6940)) },
		HandofSalvation = { id = 1038, name = GetSpellInfo(1038), icon = select(3, GetSpellInfo(1038)) },
		Parry = { id = 82242, name = GetSpellInfo(82242), icon = select(3, GetSpellInfo(82242)) },
		ResistanceAura = { id = 19891, name = GetSpellInfo(19891), icon = select(3, GetSpellInfo(19891)) },
		RighteousDefense = { id = 31789, name = GetSpellInfo(31789), icon = select(3, GetSpellInfo(31789)) },
		RighteousFury = { id = 25780, name = GetSpellInfo(25780), icon = select(3, GetSpellInfo(25780)) },
		SealofJustice = { id = 20164, name = GetSpellInfo(20164), icon = select(3, GetSpellInfo(20164)) },
		SealofRighteousness = { id = 20154, name = GetSpellInfo(20154), icon = select(3, GetSpellInfo(20154)) },
		--Retribution icon = select(2, GetSpellTabInfo(4))
		AvengingWrath = { id = 31884, name = GetSpellInfo(31884), icon = select(3, GetSpellInfo(31884)) },
		ArtofWar = { id = 87138, name = GetSpellInfo(87138), icon = select(3, GetSpellInfo(87138)) },
		BlessingofMight = { id = 19740, name = GetSpellInfo(19740), icon = select(3, GetSpellInfo(19740)) },
		CrusaderAura = { id = 32223, name = GetSpellInfo(32223), icon = select(3, GetSpellInfo(32223)) },
		CrusaderStrike = { id = 35395, name = GetSpellInfo(35395), icon = select(3, GetSpellInfo(35395)) },
		DivineStorm = { id = 53385, name = GetSpellInfo(53385), icon = select(3, GetSpellInfo(53385)) },
		DivinePurpose = { id = 90174, mame = GetSpellInfo(90174), icon = select(3, GetSpellInfo(90174)) },
		HammerofWrath = { id = 24275, name = GetSpellInfo(24275), icon = select(3, GetSpellInfo(24275)) },
		Inquisition = { id = 84963, name = GetSpellInfo(84963), icon = select(3, GetSpellInfo(84963)) },
		Judgement = { id = 20271, name = GetSpellInfo(20271), icon = select(3, GetSpellInfo(20271)) },
		JudgementsoftheBold = { id = 89901, name = GetSpellInfo(89901), icon = select(3, GetSpellInfo(89901)) },
		Rebuke = { id = 96231, name = GetSpellInfo(96231), icon = select(3, GetSpellInfo(96231)) },
		Repentance = { id = 20066, name = GetSpellInfo(20066), icon = select(3, GetSpellInfo(20066)) },
		RetributionAura = { id = 7294, name = GetSpellInfo(7294), icon = select(3, GetSpellInfo(7294)) },
		SealofTruth = { id = 31801, name = GetSpellInfo(31801), icon = select(3, GetSpellInfo(31801)) },
		SheathofLight = { id = 53503, name = GetSpellInfo(53503), icon = select(3, GetSpellInfo(53503)) },
		TemplarsVerdict = { id = 85256, name = GetSpellInfo(85256), icon = select(3, GetSpellInfo(85256)) },
		TwoHandedWeaponSpecialization = { id = 20113, name = GetSpellInfo(20113), icon = select(3, GetSpellInfo(20113)) },
		Zealotry = { id = 85696, name = GetSpellInfo(85696), icon = select(3, GetSpellInfo(85696)) },
	};

	local Truth, Insight, Righteousness, Kings, Might, Concentration, Resistance, Retribution = "|cffFFFF33Truth",
			"|cffFF9900Insight",
			"|cff24E0FBRighteousness", "|cFF00008BKings", "|cFF00FFFFMight", "|cFF00FF00Concentration",
			"|cFF9933FFResistance",
			"|cFFFF0000Retribution"

	local menus = {
		["Seal"] = 1,
		["Blessing"] = 2,
		["Aura"] = 3,
	}

	local function GUICallback(key, item_type, value)
		if item_type == "menu" then
			menus[key] = value
		end
	end

	local items = {
		settingsfile = "Cata_Ret_Trojan.json",
		callback = GUICallback,
		{
			type = "title",
			text =
			">                          Paladin - Ret PvE by |cFFFF0000Trojan | Edit by Brecherbernd                   |cFFFFFFFF<"
		},
		{ type = "separator" },
		{ type = "page",     number = 1,             text = "|cffFFFF00Main Settings" },
		{ type = "separator" },
		{ type = "title",    text = "Seal Selection" },
		{ type = "separator" },
		{
			type = "dropdown",
			menu = {
				{
					selected = (menus["Seal"] == 1),
					value = 1,
					text = "\124T" .. spells.SealofInsight.icon .. ":15:15\124t " .. Insight
				},
				{
					selected = (menus["Seal"] == 2),
					value = 2,
					text = "\124T" .. spells.SealofTruth.icon .. ":15:15\124t " .. Truth
				},
				{
					selected = (menus["Seal"] == 3),
					value = 3,
					text = "\124T" .. spells.SealofRighteousness.icon .. ":15:15\124t " .. Righteousness
				}
			},
			key = "Seal"
		},
		{ type = "separator" },
		{ type = "title",    text = "Blessing Selection" },
		{ type = "separator" },
		{
			type = "dropdown",
			menu = {
				{
					selected = (menus["Blessing"] == 1),
					value = 1,
					text = "\124T" .. spells.BlessingofKings.icon .. ":15:15\124t " .. Kings
				},
				{
					selected = (menus["Blessing"] == 2),
					value = 2,
					text = "\124T" .. spells.BlessingofMight.icon .. ":15:15\124t " .. Might
				}
			},
			key = "Blessing"
		},
		{ type = "separator" },
		{ type = "title",    text = "Aura Selection" },
		{ type = "separator" },
		{
			type = "dropdown",
			menu = {
				{
					selected = (menus["Aura"] == 1),
					value = 1,
					text = "\124T" .. spells.ConcentrationAura.icon .. ":15:15\124t " .. Concentration
				},
				{
					selected = (menus["Aura"] == 2),
					value = 2,
					text = "\124T" .. spells.ResistanceAura.icon .. ":15:15\124t " .. Resistance
				},
				{
					selected = (menus["Aura"] == 3),
					value = 3,
					text = "\124T" .. spells.RetributionAura.icon .. ":15:15\124t " .. Retribution
				}
			},
			key = "Aura"
		},
		{ type = "separator" },
		{ type = "title",    text = "|cffFFFF00Mana Settings" },
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.DivinePlea.icon .. ":18:18\124t Divine Plea < MP%",
			tooltip =
			"Use Divine Plea < MP%",
			enabled = true,
			value = 75,
			key = "DivinePlea"
		},
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
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.Cleanse.icon .. ":18:18\124t Cleanse",
			tooltip = "Cleanse enable",
			enabled = true,
			key = "Cleanse",
		},
		{ type = "page",     number = 2,             text = "|cffFFFF00Defensive Settings" },
		{ type = "separator" },
		{ type = "title",    text = "Spell Settings" },
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.DivineShield.icon .. ":18:18\124t Divine Shield",
			tooltip = "Divine Shield Health",
			value = 15,
			enabled = true,
			key = "DivineShield",
		},
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.DivineProtection.icon .. ":18:18\124t Divine Protection",
			tooltip = "Divine Protection Health",
			value = 30,
			key = "DivineProtection",
		},
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.LayonHands.icon .. ":18:18\124t Lay on Hands < HP%",
			tooltip = "Use Lay on Hands < HP%",
			enabled = true,
			value = 20,
			key = "LayonHands"
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
		"Pause",
		"Cache",
		"Mechanics",
		"Targeting",
		"Aura",
		"Seal",
		"Blessings",
		"Healthstone (Use)",
		"Lay on Hands",
		"Divine Shield",
		"Divine Protection",
		"GoAK",
		"AvengingWrath",
		"Zealotry",
		"Use Castable Items",
		"Hammer of Wrath (OOR)",
		"Judgement (OOR)",
		"Judgement no JotP",
		"Divine Storm",
		"Cleanse(Priority)",
		"CrusaderStrike",
		"Judgement no Zealotry",
		"Inquisition",
		"TemplarsVerdict",
		"Exorcism",
		"Hammer of Wrath",
		"Judgement (Zealotry)",
		"Wait",
		"Holy Wrath",
		"Consecration",
		"Divine Plea",
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

	local inquisition, GOAK = { [GetSpellInfo(84963)] = true }, { [GetSpellInfo(86150)] = true }
	local function CombatEventCatcher(event, ...)
		if event == "UNIT_SPELLCAST_SUCCEEDED" then
			local unitID, spellName = ...
			if inquisition[spellName] then
				inquisitionEndTime = GetTime()
			end
			if GOAK[spellName] then
				GOAKStartTime = GetTime()
			end
		end
	end

	-- Dont dispel START
	function DontDispel(t)
		local buff            = { 96328, 96325, 96326, 86788, 30108, 34914, 109325, 106200 }
		local DontDispelCheck = false
		for i = 1, #buff do
			if ni.unit.debuff(t, buff[i]) then
				if ni.unit.debuff(t, 87100) then
					return false
				elseif ni.unit.debuff(t, 31117) then
					return false
				elseif ni.unit.debuff(t, 109325) then
					if ni.unit.debuff(t, 110317) then
						return false
					end
				end
				DontDispelCheck = true
			end
		end
		return DontDispelCheck
	end

	-- Dont dispel END

	-- Checking prio dispel start
	function DangerousMagic(t)
		local buff = { 5782, 118, 122, 339, 1499, 6358, 605, 20066, 853, 5484, 71757, 104601, 107629, 99567,
			31117,
			110317, 103363, 87100, 106199 }
		for i = 1, #buff do
			if ni.unit.debuff(t, buff[i]) then
				return true
			end
		end
	end

	-- checking prio dispel end

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
		ni.combatlog.registerhandler("Cata_Ret_Trojan", CombatEventCatcher);
		-- add the gui frame
		if not ni.vars.stream then
			ni.GUI.AddFrame("Cata_Ret_Trojan", items);
		end
	end


	local function OnUnLoad()
		-- unregister the handler
		ni.combatlog.unregisterhandler("Cata_Ret_Trojan");
		-- remove the gui frame
		if not ni.vars.stream then
			ni.GUI.DestroyFrame("Cata_Ret_Trojan");
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
			Cache.members = ni.members or {}
			if #Cache.members > 0 then
				table.sort(Cache.members, SortByHP)
			end
			Cache.holypower = ni.player.powerraw("holy") or 0
			Cache.mana = ni.player.power(0) or 0
			Cache.rawmana = ni.player.powerraw(0) or 0
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
						or ni.unit.isimmune("target") then
					local enemies = ni.player.enemiesinrange(15);
					for i = 1, #enemies do
						local tar = enemies[i].guid;
						if enemies[i].distance <= 15
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

		["Aura"] = function()
			local a = menus["Aura"]
			if a == 1 and ni.spell.available(spells.ConcentrationAura.id) and not ni.player.buff(spells.ConcentrationAura.id) then
				ni.spell.cast(spells.ConcentrationAura.name)
				return true
			end
			if a == 2 and ni.spell.available(spells.ResistanceAura.id) and not ni.player.buff(spells.ResistanceAura.id) then
				ni.spell.cast(spells.ResistanceAura.name)
				return true
			end
			if a == 3 and ni.spell.available(spells.RetributionAura.id) and not ni.player.buff(spells.RetributionAura.id) then
				ni.spell.cast(spells.RetributionAura.name)
				return true
			end
		end,

		["Seal"] = function()
			local s = menus["Seal"]
			if Cache.AOE then
				if ni.spell.available(spells.SealofTruth.id) and not ni.player.buff(spells.SealofTruth.id) then
					ni.spell.cast(spells.SealofTruth.id)
					return true
				end
			else
				if s == 1 and ni.spell.available(spells.SealofInsight.id) and not ni.player.buff(spells.SealofInsight.id) then
					ni.spell.cast(spells.SealofInsight.name)
					return true
				end
				if s == 2 and ni.spell.available(spells.SealofTruth.id) and not ni.player.buff(spells.SealofTruth.id) then
					ni.spell.cast(spells.SealofTruth.name)
					return true
				end
				if s == 3 and ni.spell.available(spells.SealofRighteousness.id) and not ni.player.buff(spells.SealofRighteousness.id) then
					ni.spell.cast(spells.SealofRighteousness.name)
					return true
				end
			end
		end,

		["Blessings"] = function()
			local b = menus["Blessing"]
			if b == 1 and ni.spell.available(spells.BlessingofKings.id) then
				for i = 1, #Cache.members do
					if not ni.unit.buff(Cache.members[i].unit, spells.BlessingofKings.id)
							and Cache.members[i]:valid(spells.BlessingofKings.id, false, true, true)
							and not UnitIsDeadOrGhost(Cache.members[i].unit) then
						ni.spell.cast(spells.BlessingofKings.name, Cache.members[i].unit)
						return true
					end
				end
			end
			if b == 2 and ni.spell.available(spells.BlessingofMight.id) then
				for i = 1, #Cache.members do
					if not ni.unit.buff(Cache.members[i].unit, spells.BlessingofMight.id)
							and Cache.members[i]:valid(spells.BlessingofMight.id, false, true, true)
							and not UnitIsDeadOrGhost(Cache.members[i].unit) then
						ni.spell.cast(spells.BlessingofMight.name, Cache.members[i].unit)
						return true
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

		["Lay on Hands"] = function()
			local value, enabled = GetSetting("LayonHands")
			if enabled and ni.spell.available(spells.LayonHands.id)
					and Cache.PlayerCombat
					and not Cache.PlayerControled then
				for i = 1, #Cache.members do
					if Cache.members[i].hp() <= value
							and not ni.unit.buff(Cache.members[i].unit, spells.LayonHands.id) then
						ni.spell.cast(spells.LayonHands.name, Cache.members[i].unit)
						return true
					end
				end
			end
		end,

		["Divine Shield"] = function()
			local value, enabled = GetSetting("DivineShield")
			if enabled then
				if ni.spell.available(spells.DivineShield.id)
						and ni.player.hp() <= value
						and Cache.PlayerCombat then
					ni.spell.cast(spells.DivineShield.name)
					return true
				end
			end
		end,

		["Divine Protection"] = function()
			local value = GetSetting("DivineProtection")
			if ni.spell.available(spells.DivineProtection.id) then
				if ni.player.hp() < value
						and Cache.PlayerCombat then
					ni.spell.cast(spells.DivineProtection.name)
					return true
				end
			end
		end,

		["GoAK"] = function()
			if ni.vars.combat.cd then
				if ni.spell.available(spells.GuardianofAncientKings.id)
						and Cache.PlayerCombat
						and not Cache.PlayerControled then
					ni.spell.cast(spells.GuardianofAncientKings.name)
					return true
				end
			end
		end,

		["AvengingWrath"] = function()
			if ni.vars.combat.cd then
				if ni.spell.available(spells.AvengingWrath.id) then
					if GOAKStartTime and (math.round((GetTime() - GOAKStartTime), 0.01) >= 10 and math.round((GetTime() - GOAKStartTime), 0.01) < 300) then
						if Cache.PlayerCombat
								and not Cache.PlayerControled then
							ni.spell.cast(spells.AvengingWrath.name)
							return true
						end
					end
				end
			end
		end,

		["Zealotry"] = function()
			if ni.vars.combat.cd then
				if ni.spell.available(spells.Zealotry.id) then
					if GOAKStartTime and (math.round((GetTime() - GOAKStartTime), 0.01) >= 10 and math.round((GetTime() - GOAKStartTime), 0.01) < 300) then
						if Cache.PlayerCombat
								and not Cache.PlayerControled then
							ni.spell.cast(spells.Zealotry.name)
							return true
						end
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

		["Hammer of Wrath (OOR)"] = function()
			if not Cache.AOE then
				if ni.spell.available(spells.HammerofWrath.id) then
					if not ni.spell.valid("target", spells.CrusaderStrike.id, true, true, false)
							and Cache.PlayerCombat
							and not Cache.PlayerControled
							and ni.spell.valid("target", spells.HammerofWrath.id, true, true, false) then
						ni.spell.cast(spells.HammerofWrath.name, "target")
						return true
					end
				end
			end
		end,

		["Judgement (OOR)"] = function()
			if not Cache.AOE then
				if ni.spell.available(spells.Judgement.id) and not ni.spell.available(spells.HammerofWrath.id) then
					if ni.spell.valid("target", spells.Judgement.id, false, true, false)
							and Cache.PlayerCombat
							and not Cache.PlayerControled then
						ni.spell.cast(spells.Judgement.name, "target")
						return true
					end
				end
			end
		end,

		["Judgement no JotP"] = function()
			if ni.spell.available(spells.Judgement.id) then
				if ni.spell.valid("target", spells.Judgement.id, false, true, false)
						and Cache.PlayerCombat
						and not Cache.PlayerControled
						and not ni.player.buff(spells.JudgementsofthePure.id) then
					ni.spell.cast(spells.Judgement.name, "target")
					return true
				end
			end
		end,

		["Divine Storm"] = function()
			if Cache.AOE then
				if ni.spell.available(spells.DivineStorm.id) then
					if Cache.PlayerCombat
							and ni.unit.inmelee("player", "target")
							and not Cache.PlayerControled
							and Cache.holypower < 3 then
						ni.spell.cast(spells.DivineStorm.name)
						return true
					end
				end
			end
		end,

		["Cleanse (Priority)"] = function()
			local enabled = GetSetting("Cleanse")
			if enabled then
				if ni.spell.available(spells.Cleanse.id)
						and not Cache.PlayerControled then
					if Cache.members[1].hp() > 50 then
						for i = 1, #Cache.members do
							if ni.healing.candispel(Cache.members[i].unit)
									and not DontDispel(Cache.members[i].unit)
									and DangerousMagic(Cache.members[i].unit) then
								if Cache.members[i]:valid(spells.Cleanse.id, false, true, true) then
									ni.spell.cast(spells.Cleanse.name, Cache.members[i].unit)
									return true
								end
							end
						end
					end
				end
			end
		end,

		["CrusaderStrike"] = function()
			if not Cache.AOE then
				if ni.spell.available(spells.CrusaderStrike.id) then
					if ni.spell.valid("target", spells.CrusaderStrike.id)
							and Cache.holypower < 3
							and not Cache.PlayerControled
							and Cache.PlayerCombat then
						ni.spell.cast(spells.CrusaderStrike.name, "target")
						return true
					end
				end
			end
		end,

		["Judgement no Zealotry"] = function()
			if ni.spell.available(spells.Judgement.id) then
				if ni.spell.valid("target", spells.Judgement.id, false, true, false)
						and Cache.PlayerCombat
						and Cache.holypower < 3
						and not Cache.PlayerControled
						and not ni.player.buff(spells.Zealotry.id) then
					ni.spell.cast(spells.Judgement.name, "target")
					return true
				end
			end
		end,

		["Inquisition"] = function()
			local divinePurpose = ni.unit.buff("player", spells.DivinePurpose.id)
			if ni.spell.available(spells.Inquisition.id) then
				if not inquisitionEndTime or math.round((GetTime() - inquisitionEndTime), 0.01) > 25 then
					if (Cache.holypower >= 3 or divinePurpose)
							and not Cache.PlayerControled then
						ni.spell.cast(spells.Inquisition.name)
						return true
					end
				end
			end
		end,

		["TemplarsVerdict"] = function()
			local divinePurpose = ni.unit.buff("player", spells.DivinePurpose.id)
			if ni.spell.available(spells.TemplarsVerdict.id) then
				if ni.spell.valid("target", spells.TemplarsVerdict.id)
						and (Cache.holypower >= 3 or divinePurpose)
						and not Cache.PlayerControled
						and Cache.PlayerCombat then
					ni.spell.cast(spells.TemplarsVerdict.name, "target")
					return true
				end
			end
		end,

		["Exorcism"] = function()
			if ni.spell.available(spells.Exorcism.id) then
				if ni.spell.valid("target", spells.Exorcism.id, true, true, false)
						and not Cache.PlayerControled
						and Cache.PlayerCombat
						and ni.player.buff(spells.ArtofWar.id) then
					ni.spell.cast(spells.Exorcism.name, "target")
					return true
				end
			end
		end,

		["Hammer of Wrath"] = function()
			if ni.spell.available(spells.HammerofWrath.id) then
				if ni.player.buff(spells.AvengingWrath.id) or ni.unit.hp("target") <= 20 then
					if ni.spell.valid("target", spells.HammerofWrath.id, true, true, false)
							and not Cache.PlayerControled
							and Cache.PlayerCombat then
						ni.spell.cast(spells.HammerofWrath.name, "target")
						return true
					end
				end
			end
		end,

		["Judgement (Zealotry)"] = function()
			if ni.spell.available(spells.Judgement.id) then
				if ni.spell.valid("target", spells.Judgement.id, false, true, false)
						and Cache.PlayerCombat
						and Cache.holypower < 3
						and not Cache.PlayerControled
						and ni.player.buff(spells.Zealotry.id) then
					ni.spell.cast(spells.Judgement.name, "target")
					return true
				end
			end
		end,

		["Wait"] = function()
			local crusaderStrikeStart, crusaderStrikeDuration = GetSpellCooldown(35395)
			local crusaderStrikeCD = crusaderStrikeStart - GetTime() + crusaderStrikeDuration
			local gcdStartTime, gcdDuration = GetSpellCooldown(61304)
			local gcdTimeLeft = gcdStartTime + gcdDuration - GetTime()
			if gcdTimeLeft < 0 then
				gcdTimeLeft = 0
			end
			crusaderStrikeCD = crusaderStrikeCD - gcdTimeLeft
			if crusaderStrikeCD < 0 then
				crusaderStrikeCD = 0
			end
			if crusaderStrikeCD < 0.2 and crusaderStrikeCD > 0 then
				ni.rotation.delay(crusaderStrikeCD);
				return true
			end
		end,

		["Holy Wrath"] = function()
			if ni.spell.available(spells.HolyWrath.id) then
				if ni.unit.inmelee("player", "target")
						and not Cache.PlayerControled
						and Cache.PlayerCombat then
					ni.spell.cast(spells.HolyWrath.name)
					return true
				end
			end
		end,

		["Consecration"] = function()
			if ni.spell.available(spells.Consecration.id) then
				if not Cache.moving
						and Cache.rawmana > 16000
						and not Cache.PlayerControled
						and Cache.PlayerCombat
						and ni.unit.inmelee("player", "target") then
					ni.spell.cast(spells.Consecration.name)
					return true
				end
			end
		end,

		["Divine Plea"] = function()
			local value, enabled = GetSetting("DivinePlea")
			if enabled and ni.spell.available(spells.DivinePlea.id) then
				if Cache.mana < value
						and not Cache.PlayerControled
						and (Cache.members[1].hp() > 60 or Cache.mana < 10)
				then
					ni.spell.cast(spells.DivinePlea.name)
					return true
				end
			end
		end,

	};

	ni.bootstrap.profile("Cata_Ret_Trojan", queue, abilities, OnLoad, OnUnLoad);
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
	ni.bootstrap.profile("Cata_Ret_Trojan", queue, abilities);
end
;
