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
local Cache = {}
-- local licensed = licensing.licensed()
if cata
-- and licensed
then
	local spells = {
		--Blood icon = select(2, GetSpellTabInfo(2))
		BloodBoil = { id = 48721, name = GetSpellInfo(48721), icon = select(3, GetSpellInfo(48721)) },
		BloodPresence = { id = 48263, name = GetSpellInfo(48263), icon = select(3, GetSpellInfo(48263)) },
		BloodStrike = { id = 45902, name = GetSpellInfo(45902), icon = select(3, GetSpellInfo(45902)) },
		BloodTap = { id = 45529, name = GetSpellInfo(45529), icon = select(3, GetSpellInfo(45529)) },
		DarkCommand = { id = 56222, name = GetSpellInfo(56222), icon = select(3, GetSpellInfo(56222)) },
		DarkSimulacrum = { id = 77606, name = GetSpellInfo(77606), icon = select(3, GetSpellInfo(77606)) },
		DeathPact = { id = 48743, name = GetSpellInfo(48743), icon = select(3, GetSpellInfo(48743)) },
		DeathStrike = { id = 49998, name = GetSpellInfo(49998), icon = select(3, GetSpellInfo(49998)) },
		Parry = { id = 82246, name = GetSpellInfo(82246), icon = select(3, GetSpellInfo(82246)) },
		Pestilence = { id = 50842, name = GetSpellInfo(50842), icon = select(3, GetSpellInfo(50842)) },
		Strangulate = { id = 47476, name = GetSpellInfo(47476), icon = select(3, GetSpellInfo(47476)) },
		--Frost icon = select(2, GetSpellTabInfo(3))
		ChainsofIce = { id = 45524, name = GetSpellInfo(45524), icon = select(3, GetSpellInfo(45524)) },
		EmpowerRuneWeapon = { id = 47568, name = GetSpellInfo(47568), icon = select(3, GetSpellInfo(47568)) },
		FesteringStrike = { id = 85948, name = GetSpellInfo(85948), icon = select(3, GetSpellInfo(85948)) },
		FrostFever = { id = 59921, name = GetSpellInfo(59921), icon = select(3, GetSpellInfo(59921)) },
		FrostFeverDebuff = { id = 55095, name = GetSpellInfo(55095), icon = select(3, GetSpellInfo(55095)) },
		FrostPresence = { id = 48266, name = GetSpellInfo(48266), icon = select(3, GetSpellInfo(48266)) },
		HornofWinter = { id = 57330, name = GetSpellInfo(57330), icon = select(3, GetSpellInfo(57330)) },
		IceboundFortitude = { id = 48792, name = GetSpellInfo(48792), icon = select(3, GetSpellInfo(48792)) },
		IcyTouch = { id = 45477, name = GetSpellInfo(45477), icon = select(3, GetSpellInfo(45477)) },
		MindFreeze = { id = 47528, name = GetSpellInfo(47528), icon = select(3, GetSpellInfo(47528)) },
		Obliterate = { id = 49020, name = GetSpellInfo(49020), icon = select(3, GetSpellInfo(49020)) },
		PathofFrost = { id = 3714, name = GetSpellInfo(3714), icon = select(3, GetSpellInfo(3714)) },
		RuneStrike = { id = 56815, name = GetSpellInfo(56815), icon = select(3, GetSpellInfo(56815)) },
		RunicEmpowerment = { id = 81229, name = GetSpellInfo(81229), icon = select(3, GetSpellInfo(81229)) },
		RunicFocus = { id = 61455, name = GetSpellInfo(61455), icon = select(3, GetSpellInfo(61455)) },
		--Unholy icon = select(2, GetSpellTabInfo(4))
		AntiMagicShell = { id = 48707, name = GetSpellInfo(48707), icon = select(3, GetSpellInfo(48707)) },
		AntiMagicZone = { id = 51052, name = GetSpellInfo(51052), icon = select(3, GetSpellInfo(51052)) },
		ArmyoftheDead = { id = 42650, name = GetSpellInfo(42650), icon = select(3, GetSpellInfo(42650)) },
		BloodPlague = { id = 59879, name = GetSpellInfo(59879), icon = select(3, GetSpellInfo(59879)) },
		BloodPlagueDebuff = { id = 55078, name = GetSpellInfo(55078), icon = select(3, GetSpellInfo(55078)) },
		DarkTransformation = { id = 63560, name = GetSpellInfo(63560), icon = select(3, GetSpellInfo(63560)) },
		DeathandDecay = { id = 43265, name = GetSpellInfo(43265), icon = select(3, GetSpellInfo(43265)) },
		DeathCoil = { id = 47541, name = GetSpellInfo(47541), icon = select(3, GetSpellInfo(47541)) },
		DeathGate = { id = 50977, name = GetSpellInfo(50977), icon = select(3, GetSpellInfo(50977)) },
		DeathGrip = { id = 49576, name = GetSpellInfo(49576), icon = select(3, GetSpellInfo(49576)) },
		MasterofGhouls = { id = 52143, name = GetSpellInfo(52143), icon = select(3, GetSpellInfo(52143)) },
		NecroticStrike = { id = 73975, name = GetSpellInfo(73975), icon = select(3, GetSpellInfo(73975)) },
		Outbreak = { id = 77575, name = GetSpellInfo(77575), icon = select(3, GetSpellInfo(77575)) },
		PlagueStrike = { id = 45462, name = GetSpellInfo(45462), icon = select(3, GetSpellInfo(45462)) },
		RaiseAlly = { id = 61999, name = GetSpellInfo(61999), icon = select(3, GetSpellInfo(61999)) },
		RaiseDead = { id = 46584, name = GetSpellInfo(46584), icon = select(3, GetSpellInfo(46584)) },
		Reaping = { id = 56835, name = GetSpellInfo(56835), icon = select(3, GetSpellInfo(56835)) },
		ScourgeStrike = { id = 55090, name = GetSpellInfo(55090), icon = select(3, GetSpellInfo(55090)) },
		SummonGargoyle = { id = 49206, name = GetSpellInfo(49206), icon = select(3, GetSpellInfo(49206)) },
		UnholyFrenzy = { id = 49016, name = GetSpellInfo(49016), icon = select(3, GetSpellInfo(49016)) },
		UnholyMight = { id = 91107, name = GetSpellInfo(91107), icon = select(3, GetSpellInfo(91107)) },
		UnholyPresence = { id = 48265, name = GetSpellInfo(48265), icon = select(3, GetSpellInfo(48265)) },
	};

	local items = {
		settingsfile = "Cata_Unholy_Trojan.json",
		{
			type = "title",
			text =
			">                          Deathknight - Unholy PvE by |cFFFF0000Trojan                          |cFFFFFFFF<"
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
			text = "\124T" .. select(3, GetSpellInfo(48707)) .. ":18:18\124t Anti Magic Shell",
			tooltip = "Anti Magic Shell HP",
			enabled = true,
			value = 35,
			key = "AntiMagicShell"
		},
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. select(3, GetSpellInfo(51052)) .. ":18:18\124t Anti Magic Zone",
			tooltip = "Anti Magic Zone HP",
			enabled = true,
			value = 50,
			key = "AntiMagicZone"
		},
		{ type = "separator" },
		{
			type = "entry",
			text = "\124T" .. select(3, GetSpellInfo(48792)) .. ":18:18\124t Icebound Fortitude",
			tooltip = "Icebound Fortitude HP",
			enabled = true,
			value = 35,
			key = "IceboundFortitude"
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
		"PetAttack",
		"Presence",
		"Healthstone (Use)",
		"Raise Ally",
		"Raise Dead",
		"Horn of Winter",
		"Anti-Magic Shell",
		"Icebound Fortitude",
		"Anti-Magic Zone",
		"Debuff Handler",
		"Pestilence",
		"Unholy Frenzy",
		"Summon Gargoyle",
		"Dark Transformation",
		"Death Coil (Proc)",
		"Empower Rune Weapon",
		"Death and Decay",
		"Blood Boil",
		"Festering Strike",
		"Scourge Strike",
		"Death Coil",
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

	-- Death Rune on CD Check
	DeathRuneCD = nil
	function DeathRuneCD()
		local DRunesOnCD = 0
		local DRunesOffCD = 0
		for i = 1, 4 do
			if GetRuneType(i) == 4 and select(3, GetRuneCooldown(i)) == false then
				DRunesOnCD = DRunesOnCD + 1
			elseif GetRuneType(i) == 4 and select(3, GetRuneCooldown(i)) == true then
				DRunesOffCD = DRunesOffCD + 1
			end
		end

		return DRunesOnCD, DRunesOffCD
	end

	-- Death Rune checker.
	DeathRuneCheck = nil
	function DeathRuneCheck()
		local numDeathRunes = 0
		for i = 1, 6 do
			if GetRuneType(i) == 4 then
				numDeathRunes = numDeathRunes + 1
			end
		end

		return numDeathRunes
	end

	function math.sign(v)
		return (v >= 0 and 1) or -1
	end

	function math.round(v, bracket)
		bracket = bracket or 1
		return math.floor(v / bracket + math.sign(v) * 0.5) * bracket
	end

	local pestilence = { [GetSpellInfo(50842)] = true }
	local function CombatEventCatcher(event, ...)
		if event == "UNIT_SPELLCAST_SUCCEEDED" then
			local unitID, spellName = ...
			if pestilence[spellName] then
				pestilenceTimer = GetTime()
			end
		end
	end

	local function SortByHP(x, y)
		return x.hp() < y.hp()
	end

	local function OnLoad()
		-- debug mode
		ni.vars.debug = false
		-- register the combatlog event handler
		ni.combatlog.registerhandler("Cata_Unholy_Trojan", CombatEventCatcher);
		-- add the gui frame
		if not ni.vars.stream then
			ni.GUI.AddFrame("Cata_Unholy_Trojan", items);
		end
	end


	local function OnUnLoad()
		-- unregister the handler
		ni.combatlog.unregisterhandler("Cata_Unholy_Trojan");
		-- remove the gui frame
		if not ni.vars.stream then
			ni.GUI.DestroyFrame("Cata_Unholy_Trojan");
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
			Cache.runicpower = UnitPower("player") or 0
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

		["Presence"] = function()
			if Cache.AOE then
				if ni.spell.available(spells.FrostPresence.id) then
					if not ni.player.buff(spells.FrostPresence.id)
						and not Cache.PlayerControled then
						ni.spell.cast(spells.FrostPresence.name)
						return true;
					end
				end
			else
				if ni.spell.available(spells.UnholyPresence.id) then
					if not ni.player.buff(spells.UnholyPresence.id)
						and not Cache.PlayerControled then
						ni.spell.cast(spells.UnholyPresence.name)
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

		["Raise Ally"] = function()
			if ni.spell.available(spells.RaiseAlly.id) then
				if Cache.PlayerCombat
					and not Cache.PlayerControled then
					for i = 1, #Cache.members do
						if UnitIsCorpse(Cache.members[i].unit)
							and Cache.members[i]:valid(spells.RaiseAlly.id, false, true, true)
							and (Cache.members[i]:istank() or Cache.members[i]:ishealer()) then
							ni.spell.cast(spells.RaiseAlly.name, Cache.members[i].unit)
							return true;
						end
					end
				end
			end
		end,

		["Raise Dead"] = function()
			if ni.spell.available(spells.RaiseDead.id) then
				if not ni.unit.exists("pet")
					and not Cache.PlayerControled then
					ni.spell.cast(spells.RaiseDead.name)
					return true;
				end
			end
		end,

		["Horn of Winter"] = function()
			if ni.spell.available(spells.HornofWinter.id) then
				if not ni.unit.buff("player", spells.HornofWinter.id)
					and ni.unit.buffremaining("player", spells.HornofWinter.id) < 3
					and not Cache.PlayerControled then
					ni.spell.cast(spells.HornofWinter.name)
					return true;
				end
			end
		end,

		-- anti magic shell logic
		["Anti-Magic Shell"] = function()
			local value, enabled = GetSetting("AntiMagicShell")
			if not enabled then
				return false;
			end
			if ni.spell.available(spells.AntiMagicShell.id) then
				if Cache.PlayerCombat
					and not Cache.PlayerControled
					and ni.player.hp() <= value then
					ni.spell.cast(spells.AntiMagicShell.name)
					return true;
				end
			end
		end,

		-- icebound fortitude logic
		["Icebound Fortitude"] = function()
			local value, enabled = GetSetting("IceboundFortitude")
			if not enabled then
				return false;
			end
			if ni.spell.available(spells.IceboundFortitude.id) then
				if Cache.PlayerCombat
					and not Cache.PlayerControled
					and ni.player.hp() <= value then
					ni.spell.cast(spells.IceboundFortitude.name)
					return true;
				end
			end
		end,

		-- anti magic zone logic
		["Anti-Magic Zone"] = function()
			local value, enabled = GetSetting("AntiMagicZone")
			local members_below = ni.members.inrangebelow("player", 10, value);
			if not enabled then
				return false;
			end
			if ni.spell.available(spells.AntiMagicZone.id) then
				if Cache.PlayerCombat
					and not Cache.moving
					and not Cache.PlayerControled
					and #members_below >= 4 then
					ni.spell.cast(spells.AntiMagicZone.name)
					return true;
				end
			end
		end,

		["Debuff Handler"] = function()
			if IsSpellKnown(spells.Outbreak.id) then
				if not ni.spell.available(spells.Outbreak.id) then
					if ni.unit.debuff("target", spells.FrostFeverDebuff.id, "player")
						and ni.unit.debuffremaining("target", spells.FrostFeverDebuff.id, "player") < 3
						and ni.spell.valid("target", spells.IcyTouch.id, true, true, false)
						and not Cache.PlayerControled
						and Cache.PlayerCombat then
						ni.spell.cast(spells.IcyTouch.name, "target")
						return true;
					else
						if not ni.unit.debuff("target", spells.FrostFeverDebuff.id, "player")
							and ni.spell.valid("target", spells.IcyTouch.id, true, true, false)
							and not Cache.PlayerControled
							and Cache.PlayerCombat then
							ni.spell.cast(spells.IcyTouch.name, "target")
							return true;
						end
					end
					if ni.unit.debuff("target", spells.BloodPlagueDebuff.id, "player")
						and ni.unit.debuffremaining("target", spells.BloodPlagueDebuff.id, "player") < 3
						and ni.spell.valid("target", spells.PlagueStrike.id, true, true, false)
						and not Cache.PlayerControled
						and Cache.PlayerCombat then
						ni.spell.cast(spells.PlagueStrike.name, "target")
						return true;
					else
						if not ni.unit.debuff("target", spells.BloodPlagueDebuff.id, "player")
							and ni.spell.valid("target", spells.PlagueStrike.id, true, true, false)
							and not Cache.PlayerControled
							and Cache.PlayerCombat then
							ni.spell.cast(spells.PlagueStrike.name, "target")
							return true;
						end
					end
				else
					if not ni.unit.debuff("target", spells.FrostFeverDebuff.id, "player")
						or not ni.unit.debuff("target", spells.BloodPlagueDebuff.id, "player") then
						if ni.spell.valid("target", spells.Outbreak.id, true, true, false)
							and not Cache.PlayerControled
							and Cache.PlayerCombat then
							ni.spell.cast(spells.Outbreak.name, "target")
							return true;
						end
					else
						if (ni.unit.debuff("target", spells.FrostFeverDebuff.id, "player") and ni.unit.debuffremaining("target", spells.FrostFeverDebuff.id, "player") < 3)
							or (ni.unit.debuff("target", spells.BloodPlagueDebuff.id, "player") and ni.unit.debuffremaining("target", spells.BloodPlagueDebuff.id, "player") < 3) then
							if ni.spell.valid("target", spells.Outbreak.id, true, true, false)
								and not Cache.PlayerControled
								and Cache.PlayerCombat then
								ni.spell.cast(spells.Outbreak.name, "target")
								return true;
							end
						end
					end
				end
			end
		end,

		["Pestilence"] = function()
			if ni.spell.available(spells.Pestilence.id) then
				if #Cache.targets >= 2
					and ni.spell.valid("target", spells.Pestilence.id, true, true, false)
					and not Cache.PlayerControled
					and Cache.PlayerCombat then
					if not pestilenceTimer or math.round((GetTime() - pestilenceTimer), 0.01) >= 30 then
						ni.spell.cast(spells.Pestilence.name, "target")
						return true;
					end
				end
			end
		end,

		["Unholy Frenzy"] = function()
			if ni.spell.available(spells.UnholyFrenzy.id) then
				if (not ni.unit.buff("player", 2825)
						or not ni.unit.buff("player", 32182)
						or not ni.unit.buff("player", 80353)
						or not ni.unit.buff("player", 90355))
					and not Cache.PlayerControled
					and Cache.PlayerCombat then
					if ni.unit.buff("player", 53365) and ni.unit.buffremaining("player", 53365) > 10 then
						ni.spell.cast(spells.UnholyFrenzy.name)
						return true;
					end
				end
			end
		end,

		["Summon Gargoyle"] = function()
			if Cache.CD or ni.unit.isboss("target") then
				if ni.spell.available(spells.SummonGargoyle.id) then
					if (ni.unit.buff("player", 2825)
							or ni.unit.buff("player", 32182)
							or ni.unit.buff("player", 80353)
							or ni.unit.buff("player", 90355)
							or ni.unit.buff("player", 49016))
						and not Cache.PlayerControled
						and Cache.PlayerCombat
						and Cache.runicpower >= 60 then
						ni.spell.cast(spells.SummonGargoyle.name, "target")
						return true;
					end
				end
			end
		end,

		["Dark Transformation"] = function()
			if ni.spell.available(spells.DarkTransformation.id) then
				local stacksShadowInfusion = select(4, ni.unit.buff("pet", 91342))
				if Cache.PlayerCombat
					and not Cache.PlayerControled
					and ni.unit.los("player", "pet") then
					if stacksShadowInfusion == 5 then
						local ur1 = select(3, GetRuneCooldown(5))
						local ur2 = select(3, GetRuneCooldown(6))
						local DeathRuneCD = DeathRuneCD
						if select(2, DeathRuneCD()) == 0 and not ur1 and not ur2 then
							ni.spell.cast(spells.DarkTransformation.name)
							return true;
						end
					end
				end
			end
		end,

		["Death Coil (Proc)"] = function()
			if ni.spell.available(spells.DeathCoil.id) then
				if ni.spell.valid("target", spells.DeathCoil.id, true, true, false)
					and not Cache.PlayerControled
					and Cache.PlayerCombat then
					if ni.unit.buff("player", 81340) then
						ni.spell.cast(spells.DeathCoil.name, "target")
						return true;
					end
				end
			end
		end,

		["Empower Rune Weapon"] = function()
			if ni.spell.available(spells.EmpowerRuneWeapon.id) then
				local RunesOnCD = 0
				if not ni.unit.buff("player", 51460)
					and select(2, GetSpellCooldown(47568)) == 0
					and Cache.runicpower < 40
					and UnitExists("target")
					and Cache.PlayerCombat
					and not Cache.PlayerControled
					and (UnitLevel("target") == -1 or ni.unit.isboss("target")) then
					local GetRuneCooldown = GetRuneCooldown
					for i = 1, 6 do
						if not select(3, GetRuneCooldown(i)) then RunesOnCD = RunesOnCD + 1 end
					end
					if RunesOnCD == 6 then
						ni.spell.cast(spells.EmpowerRuneWeapon.name)
						return true
					end
				end
			end
		end,

		["Death and Decay"] = function()
			if ni.spell.available(spells.DeathandDecay.id) then
				if ni.unit.exists("target") then
					local UnitID = tonumber((UnitGUID("target")):sub(-12, -9), 16)
					if UnitID == 55294 then
						return false
					else
						if IsSpellInRange(spells.IcyTouch.name, "target") == 1
							and not Cache.PlayerControled
							and Cache.PlayerCombat
							and #Cache.targets >= 2 then
							ni.spell.castat(spells.DeathandDecay.name, "target")
							return true;
						end
					end
				end
			end
		end,

		["Blood Boil"] = function()
			if #Cache.targets >= 2 then
				local bloodoffcd, bloodoncd = ni.rune.bloodrunecd()
				local frostoffcd, frostoncd = ni.rune.frostrunecd()
				if frostoffcd == 2 and bloodoffcd == 2 then
					if ni.spell.available(spells.BloodBoil.id)
						and Cache.PlayerCombat
						and not Cache.PlayerControled then
						ni.spell.cast(spells.BloodBoil.name)
						return true;
					end
				end
			end
		end,

		["Festering Strike"] = function()
			if ni.spell.available(spells.FesteringStrike.id) then
				local dbBP = ni.unit.debuff("target", 55078, "player")
				local dbFF = ni.unit.debuff("target", 55095, "player")
				local recastFF = false
				local recastBP = false
				local DeathRuneCD = DeathRuneCD

				if ni.spell.valid("target", spells.FesteringStrike.id, true, true, false)
					and not Cache.PlayerControled
					and Cache.PlayerCombat then
					if select(2, DeathRuneCD()) == 0 then
						ni.spell.cast(spells.FesteringStrike.name, "target")
						return true
					elseif dbBP then
						if ni.unit.debuffremaining("target", 55078, "player") < 3 then
							recastBP = true
						end
					else
						recastBP = true
					end
					if dbFF then
						if ni.unit.debuffremaining("target", 55095, "player") < 3 then
							recastFF = true
						end
					else
						recastFF = true
					end
				end

				-- Cast Festering Strike if either Disease is getting low, and Outbreak is on Cooldown.
				if recastFF or recastBP and not ni.spell.available(spells.Outbreak.id) then
					ni.spell.cast(spells.FesteringStrike.name, "target")
					return true
				end
			end
		end,

		["Scourge Strike"] = function()
			if ni.spell.available(spells.ScourgeStrike.id) then
				if ni.spell.valid("target", spells.ScourgeStrike.id, true, true, false)
					and not Cache.PlayerControled
					and Cache.PlayerCombat then
					local ur1 = select(3, GetRuneCooldown(5))
					local ur2 = select(3, GetRuneCooldown(6))
					local DeathRuneCD = DeathRuneCD
					if select(2, DeathRuneCD()) == 0 and not ur1 and not ur2 and ni.spell.available(spells.BloodTap.id) then
						ni.spell.cast(spells.BloodTap.name)
						return true
					else
						ni.spell.cast(spells.ScourgeStrike.name, "target")
						return true;
					end
				end
			end
		end,
		["Death Coil"] = function()
			local _, _, _, _, RPM = GetTalentInfo(2, 1)
			if RPM == 1 then
				CoilCap = 80
			elseif RPM == 2 then
				CoilCap = 90
			elseif RPM == 3 then
				CoilCap = 100
			else
				CoilCap = 70
			end
			if ni.spell.available(spells.DeathCoil.id) then
				if ni.spell.valid("target", spells.DeathCoil.id, true, true, false)
					and Cache.PlayerCombat
					and not Cache.PlayerControled
					and Cache.runicpower >= 40 then
					if Cache.runicpower > CoilCap then
						ni.spell.cast(spells.DeathCoil.name, "target")
						return true;
					end
					if ni.unit.buff("pet", 91342) then
						if select(4, ni.unit.buff("pet", 91342)) > 4 then
							if select(7, ni.unit.buff("pet", 91342)) - GetTime() < 10 then
								ni.spell.cast(spells.DeathCoil.name, "target")
								return true;
							end
						else
							ni.spell.cast(spells.DeathCoil.name, "target")
							return true;
						end
					elseif not ni.unit.buff("pet", 63560) and not ni.unit.buff("pet", 91342) then
						ni.spell.cast(spells.DeathCoil.name, "target")
						return true;
					end
				end
			end
		end,
	};

	ni.bootstrap.profile("Cata_Unholy_Trojan", queue, abilities, OnLoad, OnUnLoad);
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
	ni.bootstrap.profile("Cata_Unholy_Trojan", queue, abilities);
end
;
