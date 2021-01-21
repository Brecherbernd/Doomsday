local lightningbolt = GetSpellInfo(403)
local primalstrike = GetSpellInfo(73899)
local earthshock = GetSpellInfo(8042)
local flametounge = GetSpellInfo(8024)
local lightningshield = GetSpellInfo(324)
local lavalash = GetSpellInfo(60103)
local windfury = GetSpellInfo(8232)
local flameshock = GetSpellInfo(8050)
local healingsurge = GetSpellInfo(8004)
local ghostwolf = GetSpellInfo(2645)
local lastcast = 0

local items = {
	settingsfile = "Brecherbernd_EnhancingWisdom.json",
	{ type = "title", text = "Ehancing Wisdom by |cff0070DEBrecherbernd" },
	{ type = "separator" },
	{ type = "page", number = 1, text = "|cffFFFF00Main Settings" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..select(3, GetSpellInfo(403))..":26:26\124t Lightning Bolt", tooltip = "Use Lightning Bolt", enabled = true, key = "lightningbolt" },
	{ type = "entry", text = "\124T"..select(3, GetSpellInfo(2645))..":26:26\124t Ghostwolf", tooltip = "Use Ghostwolf when moving", enabled = true, value = 1.5, key = "ghostwolf" },
	{ type = "separator" },
	{ type = "title", text = "Choose your desired Armor PLACEHOLDER" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..select(3, GetSpellInfo(7302))..":26:26\124t Frost Armor PLACEHOLDER", tooltip = "Frost Armor", enabled = true, key = "frostarmor" },
	{ type = "entry", text = "\124T"..select(3, GetSpellInfo(6117))..":26:26\124t Mage Armor PLACEHOLDER", tooltip = "Mage Armor", enabled = true, key = "magearmor" },
	-------------------
	{ type = "page", number = 2, text = "|cffFFFF00Utility" },
	{ type = "separator" },
	{ type = "entry", text = "\124T"..select(3, GetSpellInfo(8004))..":26:26\124t Healing Surge < HP%", tooltip = "Healing Surge", enabled = true, value = 50, key = "Healing Surge" },
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
	ni.GUI.AddFrame("Brecherbernd_EnhancingWisdom", items);
end
local function OnUnLoad()  
	ni.GUI.DestroyFrame("Brecherbernd_EnhancingWisdom");
end	

local queue ={
	"Enchant Weapon",
	"Lightning Shield",
	"Healing Surge",
	"Ghost Wolf",
	"Pause",
	"Auto Target",
	"Primal Strike",
	"Flame Shock",
	"Lava Lash",
	"Earth Shock",
	"Lightning Bolt"
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
			AttackTarget();
		end
	end,

["Healing Surge"] = function()
		local value, enabled = GetSetting("Healing Surge")
				 if enabled
				 and ni.unit.hp("player") <= value 
				 and GetTime() - lastcast > 2
				 then lastcast = GetTime()
					ni.spell.cast(healingsurge)
					return true;	
				end 
			end,	

["Ghost Wolf"] = function()
		local affectingCombat = UnitAffectingCombat("player");    
		local value, enabled = GetSetting("ghostwolf")
				if enabled
				and not affectingCombat
				and not ni.unit.ismounted("player")
				and ni.player.movingfor(value * 15)
				and not ni.player.buff(ghostwolf) then
					ni.spell.cast(ghostwolf)
					return true;    
				end 
			end,

["Enchant Weapon"] = function()
		local mh, _, _, oh = GetWeaponEnchantInfo()
		if mh == nil 
		 and ni.spell.available(flametounge) then
			ni.spell.cast(flametounge)
			return true
		end
		if oh == nil
		 and ni.spell.available(flametounge) then
			ni.spell.cast(flametounge)
			return true
		end
	end,
	
["Lightning Shield"] = function()
		if ni.spell.available(lightningshield)
		and not ni.player.buff(lightningshield)
		then ni.spell.cast(lightningshield, "player")
            return true
         end
    end,

["Primal Strike"] = function()
		if ni.spell.available(primalstrike)
		and ni.spell.valid("target", primalstrike)
		then ni.spell.cast(primalstrike, "target")
            return true
         end
	end,

["Flame Shock"] = function()
		if ni.spell.available(flameshock)
		and ni.spell.valid("target", flameshock)
		and not ni.unit.debuff("target", 8050)
            then ni.spell.cast(flameshock, "target")
            return true
         end
    end,

["Lava Lash"] = function()
		if ni.spell.available(lavalash)
		and ni.spell.valid("target", lavalash)
		then ni.spell.cast(lavalash, "target")
            return true
         end
	end,
	
["Earth Shock"] = function()
		if ni.spell.available(earthshock)
		and ni.spell.valid("target", earthshock)
            then ni.spell.cast(earthshock, "target")
            return true
         end
    end,

["Lightning Bolt"] = function()
	local value, enabled = GetSetting("Lightning Bolt")
		if enabled
		and ni.spell.available(lightningbolt)
            then ni.spell.cast(lightningbolt, "target")
            return true
        end
    end,
}

ni.bootstrap.profile("Brecherbernd_EnhancingWisdom", queue, abilities, OnLoad, OnUnLoad);	