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
		AuraMastery = { id = 31821, name = GetSpellInfo(31821), icon = select(3, GetSpellInfo(31821)) },
		BeaconofLight = { id = 53563, name = GetSpellInfo(53563), icon = select(3, GetSpellInfo(53563)) },
		Cleanse = { id = 4987, name = GetSpellInfo(4987), icon = select(3, GetSpellInfo(4987)) },
		ConcentrationAura = { id = 19746, name = GetSpellInfo(19746), icon = select(3, GetSpellInfo(19746)) },
		Consecration = { id = 26573, name = GetSpellInfo(26573), icon = select(3, GetSpellInfo(26573)) },
		DivineFavor = { id = 31842, name = GetSpellInfo(31842), icon = select(3, GetSpellInfo(31842)) },
		DivineLight = { id = 82326, name = GetSpellInfo(82326), icon = select(3, GetSpellInfo(82326)) },
		DivinePlea = { id = 54428, name = GetSpellInfo(54428), icon = select(3, GetSpellInfo(54428)) },
		Exorcism = { id = 879, name = GetSpellInfo(879), icon = select(3, GetSpellInfo(879)) },
		FlashofLight = { id = 19750, name = GetSpellInfo(19750), icon = select(3, GetSpellInfo(19750)) },
		HolyLight = { id = 635, name = GetSpellInfo(635), icon = select(3, GetSpellInfo(635)) },
		HolyRadiance = { id = 82327, name = GetSpellInfo(82327), icon = select(3, GetSpellInfo(82327)) },
		HolyShock = { id = 20473, name = GetSpellInfo(20473), icon = select(3, GetSpellInfo(20473)) },
		HolyWrath = { id = 2812, name = GetSpellInfo(2812), icon = select(3, GetSpellInfo(2812)) },
		LayonHands = { id = 633, name = GetSpellInfo(633), icon = select(3, GetSpellInfo(633)) },
		LightofDawn = { id = 85222, name = GetSpellInfo(85222), icon = select(3, GetSpellInfo(85222)) },
		Meditation = { id = 95859, name = GetSpellInfo(95859), icon = select(3, GetSpellInfo(95859)) },
		Redemption = { id = 7328, name = GetSpellInfo(7328), icon = select(3, GetSpellInfo(7328)) },
		SealofInsight = { id = 20165, name = GetSpellInfo(20165), icon = select(3, GetSpellInfo(20165)) },
		TurnEvil = { id = 10326, name = GetSpellInfo(10326), icon = select(3, GetSpellInfo(10326)) },
		WalkintheLight = { id = 85102, name = GetSpellInfo(85102), icon = select(3, GetSpellInfo(85102)) },
		WordofGlory = { id = 85673, name = GetSpellInfo(85673), icon = select(3, GetSpellInfo(85673)) },
		JudgementsofthePure = { id = 53657, name = GetSpellInfo(53657), icon = select(3, GetSpellInfo(53657)) },
		InfusionOfLight = { id = 54149, name = GetSpellInfo(54149), icon = select(3, GetSpellInfo(54149)) },
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
		BlessingofMight = { id = 19740, name = GetSpellInfo(19740), icon = select(3, GetSpellInfo(19740)) },
		CrusaderAura = { id = 32223, name = GetSpellInfo(32223), icon = select(3, GetSpellInfo(32223)) },
		CrusaderStrike = { id = 35395, name = GetSpellInfo(35395), icon = select(3, GetSpellInfo(35395)) },
		HammerofWrath = { id = 24275, name = GetSpellInfo(24275), icon = select(3, GetSpellInfo(24275)) },
		Inquisition = { id = 84963, name = GetSpellInfo(84963), icon = select(3, GetSpellInfo(84963)) },
		Judgement = { id = 20271, name = GetSpellInfo(20271), icon = select(3, GetSpellInfo(20271)) },
		Rebuke = { id = 96231, name = GetSpellInfo(96231), icon = select(3, GetSpellInfo(96231)) },
		RetributionAura = { id = 7294, name = GetSpellInfo(7294), icon = select(3, GetSpellInfo(7294)) },
		SealofTruth = { id = 31801, name = GetSpellInfo(31801), icon = select(3, GetSpellInfo(31801)) },

	};

	local Truth, Insight, Righteousness, Kings, Might, Concentration, Resistance = "|cffFFFF33Truth", "|cffFF9900Insight",
		"|cff24E0FBRighteousness", "|cFF00008BKings", "|cFF00FFFFMight", "|cFF00FF00Concentration",
		"|cFF9933FFResistance"

	local enables = {
		["HolyLight"] = true,
		["LightofDawn"] = true,
		["HolyRadiance"] = true,
		["Cleanse"] = true,
		["DivinePlea"] = true,
		["HandofSalvation"] = true,
		["DivineShield"] = true,
	}
	local values = {
		["AvengingWrathHealth"] = 40,
		["HolyLightHealth"] = 92,
		["HolyLightOverheal"] = 104,
		["DivineLightHealth"] = 65,
		["DivineLightOverheal"] = 109,
		["DivineFavorHealth"] = 50,
		["DivineShieldHealth"] = 15,
		["DivineProtectionHealth"] = 30,
		["FlashofLightHealth"] = 25,
		["FlashofLightInfusion"] = 35,
		["FlashofLightOverheal"] = 98,
		["GoAKHealth"] = 40,
		["HandofSacrificeHealth"] = 20,
		["HolyRadianceRaidHealth"] = 86,
		["HolyRadiancePartyHealth"] = 80,
		["HolyRadianceRaidTargets"] = 4,
		["HolyRadiancePartyTargets"] = 3,
		["HolyShockHealth"] = 95,
		["WordofGloryHealth"] = 82,
		["LayonHandsHealth"] = 15,
		["DivinePlea"] = 75,
		["AutoTargeting"] = 50,
		["LightofDawnHealth"] = 80,
	}


	local menus = {
		["Seal"] = 1,
		["Blessing"] = 1,
		["Aura"] = 1,
	}

	local function GUICallback(key, item_type, value)
		if item_type == "menu" then
			menus[key] = value
		end
	end

	local items = {
		settingsfile = "Cata_Hpal_Trojan.json",
		callback = GUICallback,
		{
			type = "title",
			text =
			">                          Paladin - Heal PvE by |cFFFF0000Trojan                          |cFFFFFFFF<"
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
			enabled = enables["DivinePlea"],
			value = values["DivinePlea"],
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
			"Stops auto Targeting when health below this",
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
		{ type = "page",     number = 2,             text = "|cffFFFF00Heal Settings" },
		{ type = "separator" },
		{ type = "title",    text = "Spell Settings" },
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.HolyLight.icon .. ":18:18\124t Holy Light",
			tooltip = "Holy light target Health",
			enabled = enables["HolyLight"],
			value = values["HolyLightHealth"],
			key = "HolyLight"
		},
		{
			type = "entry",
			text = "\124T" .. spells.HolyLight.icon .. ":18:18\124t Holy Light (Overheal)",
			tooltip = "Holy light target Overheal Limit",
			value = values["HolyLightOverheal"],
			key = "HolyLightOverheal"
		},
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.DivineLight.icon .. ":18:18\124t Divine Light",
			tooltip = "Divine Light target Health",
			value = values["DivineLightHealth"],
			key = "DivineLight",
		},
		{
			type = "entry",
			text = "\124T" .. spells.DivineLight.icon .. ":18:18\124t Divine Light (Overheal)",
			tooltip = "Divine Light target Overheal Limit",
			value = values["DivineLightOverheal"],
			key = "DivineLightOverheal"
		},
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.FlashofLight.icon .. ":18:18\124t Flash of Light",
			tooltip = "Flash of Light target Health",
			value = values["FlashofLightHealth"],
			key = "FlashofLight",
		},
		{
			type = "entry",
			text = "\124T" .. spells.FlashofLight.icon .. ":18:18\124t Flash of Light (Infusion)",
			tooltip = "Flash of Light target Health while Infusion",
			value = values["FlashofLightInfusion"],
			key = "FlashofLightInfusion",
		},
		{
			type = "entry",
			text = "\124T" .. spells.FlashofLight.icon .. ":18:18\124t Flash of Light (Overheal)",
			tooltip = "Flash of Light target Overheal Limit",
			value = values["FlashofLightOverheal"],
			key = "FlashofLightOverheal"
		},
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.LightofDawn.icon .. ":18:18\124t Light of Dawn",
			tooltip = "Light of Dawn check",
			enabled = enables["LightofDawn"],
			key = "LightofDawn",
		},
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.HolyRadiance.icon .. ":18:18\124t Holy Radiance(raid)",
			tooltip = "Holy Radiance target health",
			enabled = enables["HolyRadiance"],
			value = values["HolyRadianceRaidHealth"],
			key = "HolyRadiance",
		},
		{
			type = "entry",
			text = "\124T" .. spells.HolyRadiance.icon .. ":18:18\124t Holy Radiance (Group)",
			tooltip = "Holy Radiance target health",
			value = values["HolyRadiancePartyHealth"],
			key = "HolyRadianceParty",
		},
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.HolyShock.icon .. ":18:18\124t Holy Shock",
			tooltip = "Holy Shock target Health",
			value = values["HolyShockHealth"],
			key = "HolyShock",
		},
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.WordofGlory.icon .. ":18:18\124t Word of Glory",
			tooltip = "Word of Glory target Health",
			value = values["WordofGloryHealth"],
			key = "WordofGlory",
		},
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.LayonHands.icon .. ":18:18\124t Lay on Hands",
			tooltip = "Lay on Hands target Health",
			value = values["LayonHandsHealth"],
			key = "LayonHands",
		},
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.Cleanse.icon .. ":18:18\124t Cleanse",
			tooltip = "Cleanse enable",
			enabled = enables["Cleanse"],
			key = "Cleanse",
		},
		{ type = "page",     number = 3,             text = "|cffFFFF00Defensive Settings" },
		{ type = "separator" },
		{ type = "title",    text = "Spell Settings" },
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.DivineShield.icon .. ":18:18\124t Divine Shield",
			tooltip = "Divine Shield Health",
			value = values["DivineShieldHealth"],
			enabled = enables["DivineShield"],
			key = "DivineShield",
		},
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.DivineProtection.icon .. ":18:18\124t Divine Protection",
			tooltip = "Divine Protection Health",
			value = values["DivineProtectionHealth"],
			key = "DivineProtection",
		},
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.AvengingWrath.icon .. ":18:18\124t Avenging Wrath",
			tooltip = "Avenging Wrath Health",
			value = values["AvengingWrathHealth"],
			key = "AvengingWrath",
		},
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.DivineFavor.icon .. ":18:18\124t Divine Favor",
			tooltip = "Divine Favor Health",
			value = values["DivineFavorHealth"],
			key = "DivineFavor",
		},
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.GuardianofAncientKings.icon .. ":18:18\124t Guardian of Ancient Kings",
			tooltip = "Guardian of Ancient Kings Health",
			value = values["GoAKHealth"],
			key = "GoAK",
		},
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.HandofSacrifice.icon .. ":18:18\124t Hand of Sacrifice",
			tooltip = "Hand of Sacrifice Health",
			value = values["HandofSacrificeHealth"],
			key = "HandofSacrifice",
		},
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. spells.HandofSalvation.icon .. ":18:18\124t Hand of Salvation",
			tooltip = "Hand of Salvation Health",
			enabled = enables["HandofSalvation"],
			key = "HandofSalvation",
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
		"HR Target Finder",
		"Aura",
		"Seal",
		"Blessings",
		"Beacon of Light",
		"Healthstone (Use)",
		"Divine Plea",
		"Preliminary Stop Casting",
		"Hand of Protection",
		"Judgement",
		"Lay on Hands",
		"Light of Dawn",
		"Word of Glory",
		"Cleanse (Priority)",
		"Divine Shield",
		"Avenging Wrath",
		"Use Castable Items",
		"Divine Favor",
		"GoAK",
		"Hand of Sacrifice",
		"Hand of Salvation",
		"Holy Radiance",
		"Holy Shock",
		"Divine Protection",
		"Flash of Light",
		"Divine Light",
		"Cleanse",
		"CrusaderStrike",
		"Holy Light",
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

	local function CombatEventCatcher(event, ...)
		-- combat event handler
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
		-- register the combatlog event handler
		ni.combatlog.registerhandler("Cata_Hpal_Trojan", CombatEventCatcher);
		-- add the gui frame
		if not ni.vars.stream then
			ni.GUI.AddFrame("Cata_Hpal_Trojan", items);
		end
	end


	local function OnUnLoad()
		-- unregister the handler
		ni.combatlog.unregisterhandler("Cata_Hpal_Trojan");
		-- remove the gui frame
		if not ni.vars.stream then
			ni.GUI.DestroyFrame("Cata_Hpal_Trojan");
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
			Cache.members = ni.members
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
				local TimerForEncounters
				HealPartyOnly = false
				HealAtFullHealth = false
				PreCastDivineLight = false
				UseFlashofLight = true
				if not TimerForEncounters then TimerForEncounters = GetTime() - 30 end

				if UnitIsDeadOrGhost("player") or not UnitExists("boss1") then
					InitMessage = nil
				end

				if UnitExists("boss1") then
					npcid = tonumber((UnitGUID("boss1")):sub(-12, -9), 16)

					-----------------------------
					-- Chimaeron
					-----------------------------
					if npcid == 43296 then
						if not InitMessage then
							ni.frames.floatingtext:message("Loading Chimaeron")
							InitMessage = 1
						end
						if ni.unit.hp("boss1") < 21 then
							ni.frames.floatingtext:message("Disabling for Mortality")
							ni.rotation.delay(25)
							return true
						end
						if not ni.unit.buff("boss1", 88872) then
							local members_below = ni.members.inrangebelow("player", 40, 25); --Returns a table of all the members within 10 yards of the player that are below 25% health
							if #members_below > 0 then
								table.sort(members_below, SortByHP)
							end
							Cache.members = members_below
							UseFlashofLight = false
							values["HolyLightHealth"] = 18
							values["HolyLightOverheal"] = 28
							values["DivineLightOverheal"] = 30
							values["DivineLightHealth"] = 12
							return true
						else
							Cache.members = ni.members
							if #Cache.members > 0 then
								table.sort(Cache.members, SortByHP)
							end
							return true
						end
					else
						Cache.members = ni.members.inrangebelow("player", 40, 100)
						if #Cache.members > 0 then
							table.sort(Cache.members, SortByHP)
						end
					end
					-----------------------------
					-- Yor'sahj
					-----------------------------
					if npcid == 55312 then -- Yor'sahj UnitID
						if not InitMessage then
							ni.frames.floatingtext:message("Loading Yor'Sahj")
							InitMessage = 1
						end
						enables["DivinePlea"] = false
						if (ni.unit.exists("boss2") or ni.unit.exists("boss3")) -- When Oozes are out
							and Cache.mana <= 80 then         -- And we have less than 80% Mana
							if GetTime() - TimerForEncounters >= 30 then
								TimerForEncounters = GetTime()
								ni.frames.floatingtext:message(
								"|cffFF33CCGet in Melee Range to regain Mana with Seal of Insight Procs!")
							end
						end
						if ni.unit.buff("boss1", 103628) then
							ni.frames.floatingtext:message("Disabling for Purple Buff")
							return true
						end

						-----------------------------
						-- Morchock
						-----------------------------	
					elseif npcid == 55265 then -- Morchok
						if not InitMessage then
							ni.frames.floatingtext:message("Loading Morchok")
							InitMessage = 1
						end
						if ni.unit.exists("boss2") then -- Kohcrom
							PreCastDivineLight = true
						end

						-----------------------------
						-- Warlord Zonozz
						-----------------------------	
					elseif npcid == 55308 then -- Zonozz
						if GetInstanceDifficulty() >= 3 then
							if not InitMessage then
								ni.frames.floatingtext:message("Loading Heroic Zon'ozz")
								InitMessage = 1
							end
							enables["HandofSalvation"] = false
							enables["Cleanse"] = false
						else
							if not InitMessage then
								ni.frames.floatingtext:message("Loading Zon'ozz")
								InitMessage = 1
							end
						end

						-----------------------------
						-- Ultraxion
						-----------------------------	
					elseif npcid == 55294 then -- Ultraxion
						if not InitMessage then
							ni.frames.floatingtext:message("Loading Ultraxion")
							InitMessage = 1
						end
						if ni.unit.buff("player", 105903) then
							values["HolyRadianceRaidHealth"] = 100
						end
						enabled["DivineShield"] = false

						-----------------------------
						-- Spine of Deathwing
						-----------------------------	
					elseif npcid == 53879 then -- Spine of Deathwing
						if not InitMessage then
							ni.frames.floatingtext:message("Loading Spine of Deathwing")
							InitMessage = 1
						end
						values[""] = 60
					end
				else
					enables["Cleanse"] = true
					enables["DivinePlea"] = true
					enables["HandofSalvation"] = true
				end

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
				if npcid == flBosses.Shannox.id then
					for i = 1, #Cache.members do
						if ni.unit.debuffs(Cache.members[i].unit, "99947||99948||100129") then
							TargetUnit(tostring(flBosses.Rageface.id))
						end
					end
					if ni.unit.id("target") == flBosses.Riplimb.id then -- riplimb

					end
					if ni.unit.id("target") == flBosses.Rageface.id then -- rageface

					end
				end
				-- Shannox END
			end
		end,

		["Targeting"] = function()
			local enabled = GetSetting("AutoTargeting")
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

		["HR Target Finder"] = function()
			if GetNumRaidMembers() > 0 then
				hrtargethealth = values["HolyRadianceRaidHealth"]
				hrsecondaryhealth = values["HolyRadianceRaidHealth"]
				hrrange = 13
				hrsecondarytargets = values["HolyRadianceRaidTargets"]
			else
				hrtargethealth = values["HolyRadiancePartyHealth"]
				hrsecondaryhealth = values["HolyRadiancePartyHealth"]
				hrrange = 10
				hrsecondarytargets = values["HolyRadiancePartyTargets"]
			end

			if not trojaninit then
				print("loading libraries")

				function trojanGetPlayerMapPosition(unit)
					local x, y = GetPlayerMapPosition(unit)
					return x, y
				end

				function NewScaleFactor(unit1, dist)
					local x1, y1 = trojanGetPlayerMapPosition(unit1)
					local x2, y2 = trojanGetPlayerMapPosition("player")
					local xx = x1 - x2
					local yy = y1 - y2
					sft = tostring(dist / sqrt(((xx) * (xx)) + (((yy) * 0.6666666666666) ^ 2)))
					return sft
				end

				function DistanceBetweenUnits(unit1, unit2)
					if unit2 == unit1 then return 0 end
					local x1, y1 = trojanGetPlayerMapPosition(unit1)
					local x2, y2 = trojanGetPlayerMapPosition(unit2)
					if x1 == 0 and y1 == 0 and x2 == 0 and y2 == 0 then return 0 end
					return (sqrt((((x2 - x1) * sf) ^ 2) + (((y2 - y1) * sf / 1.5) ^ 2)))
				end

				function IsInRange(u1, u2)
					local range = DistanceBetweenUnits(member[u1].name, member[u2].name)
					if range <= hrrange then
						return true
					end
				end

				function getDefHealth(unit)
					return (100 - member[unit].health)
				end

				function sortDefHealth(aUnit, anotherUnit)
					return getDefHealth(aUnit) > getDefHealth(anotherUnit)
				end

				function findGoodTarget()
					if table.maxn(hrtargets) ~= 0 and table.maxn(hrsecondary) >= hrsecondarytargets then
						table.sort(hrtargets, sortDefHealth)
						table.sort(hrsecondary, sortDefHealth)
						for x = 1, table.maxn(hrtargets) do
							local inrangecount = 0
							for y = 1, table.maxn(hrsecondary) do
								if IsInRange(hrtargets[x], hrsecondary[y]) then inrangecount = inrangecount + 1 end
								if inrangecount == hrsecondarytargets then return member[hrtargets[x]].name end
							end
						end
					end
				end

				trojaninit = true
			end

			local currentmap = GetMapInfo()
			local currentlevel = tostring(GetCurrentMapDungeonLevel()) or "0"
			local grp = "party"
			local mems = GetNumPartyMembers()
			if GetNumRaidMembers() > 0 then
				group = "raid"
				mems = GetNumRaidMembers()
			end


			if (sfm ~= currentmap) or (sfl ~= currentlevel) then
				sf = 6000
				sfm = currentmap
				sfl = currentlevel
			end

			for mmm = 1, mems do
				local checktarget = grp .. tostring(mmm)
				local range = DistanceBetweenUnits("player", checktarget)
				if (range > 28) and (CheckInteractDistance(checktarget, 1)) then
					sf = NewScaleFactor(checktarget, 28)
				end
				if (range > 11.11) and (CheckInteractDistance(checktarget, 2)) then
					sf = NewScaleFactor(checktarget, 11.11)
				end
				if (range > 9.9) and (CheckInteractDistance(checktarget, 3)) then
					sf = NewScaleFactor(checktarget, 9.9)
				end
				if (range > 40) and (UnitInRange(checktarget)) then
					sf = NewScaleFactor(checktarget, 40)
				end
			end

			hrtargets = {}
			hrsecondary = {}
			member = {}

			for i = 0, mems, 1 do
				member[i] = {}
				if i == 0 then member[i].name = "player" else member[i].name = grp .. tostring(i) end
				local memberin = UnitGetIncomingHeals(member[i].name) or 0
				member[i].health = 100 * (UnitHealth(member[i].name) + memberin) / UnitHealthMax(member[i].name)
				if not UnitIsDeadOrGhost(member[i].name) then
					if member[i].health < hrtargethealth
						and not (ni.unit.buff(member[i].name, 82327))
						and IsSpellInRange("Holy Radiance", member[i].name)
					then
						table.insert(hrtargets, i)
					end
					if member[i].health < hrsecondaryhealth then table.insert(hrsecondary, i) end
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
		end,

		["Seal"] = function()
			local s = menus["Seal"]
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

		["Beacon of Light"] = function()
			local mainTank, offTank = ni.tanks()
			if mainTank then
				if UnitExists(mainTank.unit)
					and not ni.unit.buff(mainTank.unit, spells.BeaconofLight.id) then
					if mainTank:valid(spells.BeaconofLight.id, false, true, true) then
						ni.spell.cast(spells.BeaconofLight.name, mainTank.unit)
						return true
					end
				elseif not UnitExists(mainTank.unit) then
					if not ni.unit.buff("player", spells.BeaconofLight.id) then
						ni.spell.cast(spells.BeaconofLight.name, "player")
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

		["Divine Plea"] = function()
			if enables["DivinePlea"] and ni.spell.available(spells.DivinePlea.id) then
				if Cache.mana < values["DivinePlea"]
					and not Cache.PlayerControled
					and (Cache.members[1].hp() > 60 or Cache.mana < 10)
				then
					ni.spell.cast(spells.DivinePlea.name)
					return true
				end
			end
		end,

		["Preliminary Stop Casting"] = function()
			local SpellInfo, _, _, _, _, endCast = UnitCastingInfo("player")
			local SI = { spells.HolyLight.id, spells.FlashofLight.id, spells.DivineLight.id }

			for i = 1, #SI do
				if SpellInfo == spells.HolyLight.name then
					if (Cache.members[1].hp() + UnitGetIncomingHeals(Cache.members[1].unit)) > values["HolyLightOverheal"] then
						ni.spell.stopcasting()
						return true
					end
				elseif SpellInfo == spells.FlashofLight.name then
					if (Cache.members[1].hp() + UnitGetIncomingHeals(Cache.members[1].unit)) > values["FlashofLightOverheal"] then
						ni.spell.stopcasting()
						return true
					end
				elseif SpellInfo == spells.DivineLight.name then
					if (Cache.members[1].hp() + UnitGetIncomingHeals(Cache.members[1].unit)) > values["DivineLightOverheal"] then
						ni.spell.stopcasting()
						return true
					end
				end
			end
			if SpellInfo == spells.HolyRadiance.name then
				if Cache.members.below(values["HolyRadianceRaidHealth"]) <= 2
					and Cache.mana < 60 then
					ni.spell.stopcasting()
					return true
				end
			end
		end,

		["Hand of Protection"] = function()
			if Cache.CD then
				if ni.spell.available(spells.HandofProtection.id)
					and not ni.spell.available(spells.LayonHands.id)
					and Cache.PlayerCombat then
					for i = 1, #Cache.members do
						if Cache.members[i]:istank() then
							if Cache.members[i].hp() <= values["LayonHandsHealth"]
								and not ni.unit.buff(Cache.members[i].unit, spells.HandofProtection.id) then
								if Cache.members[i]:valid(spells.HandofProtection.id, false, true, true) then
									ni.spell.cast(spells.HandofProtection.name, Cache.members[i].unit)
									return true
								end
							end
						end
					end
				end
			end
		end,

		["Judgement"] = function()
			local CCdebuff = { 118, 28272, 61305, 61721, 61780, 28271, 1499, 19503, 90337, 82676, 5782, 6770, 2094,
				49203,
				19386, 64044, 3355, 82691, 33395, 339 }
			for i = 1, #CCdebuff do
				if ni.unit.debuff("target", CCdebuff[i]) then
					return false
				end
			end
			if ni.spell.available(spells.Judgement.id)
				and ni.spell.valid("target", spells.Judgement.id)
				and Cache.PlayerCombat
				and not Cache.PlayerControled
				and not ni.player.buff(spells.JudgementsofthePure.id) then
				ni.spell.cast(spells.Judgement.name, "target")
				return true
			end
		end,

		["Lay on Hands"] = function()
			if Cache.CD then
				if ni.spell.available(spells.LayonHands.id)
					and Cache.PlayerCombat
					and not Cache.PlayerControled then
					for i = 1, #Cache.members do
						if Cache.members[i].hp() <= values["LayonHandsHealth"]
							and not ni.unit.buff(Cache.members[i].unit, spells.LayonHands.id) then
							ni.spell.cast(spells.LayonHands.name, Cache.members[i].unit)
							return true
						end
					end
				end
			end
		end,

		["Light of Dawn"] = function()
			local arroundMe = ni.members.inrangebelow("player", 30, 80)
			local count = 0
			if enables["LightofDawn"]
				and Cache.holypower >= 3
				and ni.spell.available(spells.LightofDawn.id)
				and #arroundMe > 0
				and not Cache.PlayerControled then
				if #arroundMe >= 2 then
					ni.spell.cast(spells.LightofDawn.name)
					return true
				end
			end
		end,

		["Word of Glory"] = function()
			if ni.spell.available(spells.WordofGlory.id)
				and Cache.holypower >= 3
				and not Cache.PlayerControled then
				for i = 1, #Cache.members do
					if Cache.members[i].hp() <= values["WordofGloryHealth"]
						and Cache.members[i]:valid(spells.WordofGlory.id, false, true, true) then
						ni.spell.cast(spells.WordofGlory.name, Cache.members[i].unit)
						return true
					end
				end
			end
		end,

		["Cleanse (Priority)"] = function()
			if enables["Cleanse"] then
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

		["Divine Shield"] = function()
			if Cache.CD then
				if enables["DivineShield"] then
					if ni.spell.available(spells.DivineShield.id)
						and ni.player.hp() <= values["DivineShieldHealth"]
						and Cache.PlayerCombat then
						ni.spell.cast(spells.DivineShield.name)
						return true
					end
				end
			end
		end,

		["Avenging Wrath"] = function()
			if Cache.CD then
				if ni.spell.available(spells.AvengingWrath.id)
					and not Cache.PlayerControled
					and Cache.PlayerCombat
					and Cache.members.below(values["AvengingWrathHealth"]) >= 2
					and not ni.unit.buff("player", 31842)
					and not ni.unit.buff("player", 86669) then
					ni.spell.cast(spells.AvengingWrath.name)
					return true
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

		["Divine Favor"] = function()
			if ni.spell.available(spells.DivineFavor.id)
				and not Cache.PlayerControled
				and Cache.PlayerCombat
				and Cache.members.below(values["DivineFavorHealth"]) >= 2
				and not ni.unit.buff("player", 31884)
				and not ni.unit.buff("player", 86669) then
				ni.spell.cast(spells.DivineFavor.name)
				return true
			end
		end,

		["GoAK"] = function()
			if Cache.CD then
				if ni.spell.available(spells.GuardianofAncientKings.id)
					and Cache.members[1].hp() < values["GoAKHealth"]
					and (Cache.PlayerCombat
						or UnitAffectingCombat(Cache.members[1].unit))
					and not Cache.PlayerControled
					and not ni.unit.buff("player", 31884)
					and not ni.unit.buff("player", 31842)
					and Cache.members[1]:range() then
					ni.spell.cast(spells.GuardianofAncientKings.name)
					return true
				end
			end
		end,

		["Hand of Sacrifice"] = function()
			if ni.spell.available(spells.HandofSacrifice.id)
				and values["HandofSacrificeHealth"] > Cache.members[1].hp()
				and Cache.members[1].unit ~= "player"
				and not Cache.PlayerControled then
				if Cache.members[1]:valid(spells.HandofSacrifice.id, false, true, true) then
					ni.spell.cast(spells.HandofSacrifice.name, Cache.members[1].unit)
					return true
				end
			end
		end,

		["Hand of Salvation"] = function()
			if Cache.CD then
				if enables["HandofSalvation"] then
					if ni.spell.available(spells.HandofSalvation.id)
						and ni.unit.threat(Cache.members[1].unit) == 3
						and not Cache.members[1]:istank()
						and Cache.members[1].unit ~= "player"
						and not Cache.PlayerControled then
						if Cache.members[1]:valid(spells.HandofSalvation.id, false, true, true) then
							ni.spell.cast(spells.HandofSalvation.name, Cache.members[1].unit)
							return true
						end
					end
				end
			end
		end,

		["Holy Radiance"] = function()
			if Cache.AOE then
				if enables["HolyRadiance"] then
					local _, _, _, cost = GetSpellInfo(82327)
					local mana = UnitPower("player")
					local spell = UnitCastingInfo("player")

					if mana > cost and spell ~= GetSpellInfo(82327)
						and not Cache.PlayerControled then
						local HRtarget = findGoodTarget()
						if HRtarget ~= nil then
							ni.debug.print("HR Target: " .. HRtarget)
							ni.spell.cast(spells.HolyRadiance.name, HRtarget)
							return true
						end
					end
				end
			end
		end,

		["Holy Shock"] = function()
			if ni.spell.available(spells.HolyShock.id) then
				if IsSpellInRange(spells.HolyShock.name, Cache.members[1].unit) then
					if Cache.members[1].hp() < values["HolyShockHealth"] then
						if Cache.members[1]:valid(spells.HolyShock.id, false, true, true) then
							ni.spell.cast(spells.HolyShock.name, Cache.members[1].unit)
							return true
						end
					end
				end
			end
		end,

		["Divine Protection"] = function()
			if ni.spell.available(spells.DivineProtection.id) then
				if ni.player.hp() < values["DivineProtectionHealth"]
					and Cache.PlayerCombat then
					ni.spell.cast(spells.DivineProtection.name)
					return true
				end
			end
		end,

		["Flash of Light"] = function()
			if UseFlashofLight then
				if ni.spell.available(spells.FlashofLight.id) and not Cache.PlayerControled then
					if not Cache.moving
						and Cache.members[1].hp() < values["FlashofLightHealth"] then
						if Cache.members[1]:valid(spells.FlashofLight.id, false, true, true) then
							ni.spell.cast(spells.FlashofLight.name, Cache.members[1].unit)
							return true
						end
					elseif Cache.members[1].hp() < values["FlashofLightInfusion"]
						and ni.player.buff(spells.InfusionOfLight.id) then
						if Cache.members[1]:valid(spells.FlashofLight.id, false, true, true) then
							ni.spell.cast(spells.FlashofLight.name, Cache.members[1].unit)
							return true
						end
					end
				end
			end
		end,

		["Divine Light"] = function()
			if ni.spell.available(spells.DivineLight.id) and not Cache.PlayerControled then
				if Cache.members[1].hp() < values["DivineLightHealth"]
					and not Cache.moving then
					if Cache.members[1]:valid(spells.DivineLight.id, false, true, true) then
						ni.spell.cast(spells.DivineLight.name, Cache.members[1].unit)
						return true
					end
				end
				if PreCastDivineLight
					and not Cache.moving then
					if Cache.members[1]:valid(spells.DivineLight.id, false, true, true) then
						ni.spell.cast(spells.DivineLight.name, Cache.members[1].unit)
						return true
					end
				end
			end
		end,

		["Cleanse"] = function()
			if ni.spell.available(spells.Cleanse.id) and not Cache.PlayerControled then
				if Cache.members[1].hp() > 80 then
					for i = 1, #Cache.members do
						if ni.healing.candispel(Cache.members[i].unit)
							and not DontDispel(Cache.members[i].unit) then
							if Cache.members[i]:valid(spells.Cleanse.id, false, true, true) then
								ni.spell.cast(spells.Cleanse.name, Cache.members[i].unit)
								return true
							end
						end
					end
				end
			end
		end,

		["CrusaderStrike"] = function()
			if ni.spell.available(spells.CrusaderStrike.id) and not Cache.PlayerControled then
				if ni.spell.valid("target", spells.CrusaderStrike.id)
					and Cache.PlayerCombat
					and not Cache.PlayerControled
					and Cache.holypower < 3 then
					ni.spell.cast(spells.CrusaderStrike.name, "target")
					return true
				end
			end
		end,

		["Holy Light"] = function()
			if enables["HolyLight"] then
				if ni.spell.available(spells.HolyLight.id) and not Cache.PlayerControled then
					if IsSpellInRange(spells.HolyLight.name, Cache.members[1].unit) then
						if Cache.members[1].hp() < values["HolyLightHealth"]
							and not Cache.moving then
							if Cache.members[1]:valid(spells.HolyLight.id, false, true, true) then
								ni.spell.cast(spells.HolyLight.name, Cache.members[1].unit)
								return true
							end
						end
					end
				end
			end
		end,
	};

	ni.bootstrap.profile("Cata_Hpal_Trojan", queue, abilities, OnLoad, OnUnLoad);
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
	ni.bootstrap.profile("Cata_Hpal_Trojan", queue, abilities);
end
;
