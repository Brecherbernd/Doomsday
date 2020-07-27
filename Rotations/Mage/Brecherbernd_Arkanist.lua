local queue = {
	"Window",
	"Arcane Brilliance",
	"Conjure Mana Gem",
	"Mage / Frost Armor",
	"Pause",
	"Auto Target",
  	"Ice Floes",
  	"Rune of Power",
  	"Mirror Image",
	"Living Bomb",
	"Arcane Missiles",
	"Arcane Barrage",
	"Arcane Blast"
};

local runeofpower = GetSpellInfo(116011)
local arcanebrilliance = GetSpellInfo(1459)
local livingbomb = GetSpellInfo(44457)
local arcanemissiles = GetSpellInfo(5143)
local arcanebarrage = GetSpellInfo(44425)
local arcaneblast = GetSpellInfo(30451)
local icefloes = GetSpellInfo(108839)
local mirrorimage = GetSpellInfo(55342)
local magearmor = GetSpellInfo(6117)
local frostarmor = GetSpellInfo(7302)
local managem = GetSpellInfo(759)
local lastcast = 0

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

["Arcane Brilliance"] = function()
		if ni.spell.available(arcanebrilliance) then
			local how = ni.player.buffremaining(arcanebrilliance)
			if how <= 1 then
				ni.spell.cast(arcanebrilliance)
				return true;
			end
		end
	end,	

["Conjure Mana Gem"] = function()
		if not ni.player.hasitem(36799)
		 and not ni.player.ismoving()
		 and not UnitAffectingCombat("player")
		 and IsUsableSpell(GetSpellInfo(759))
		 and ni.spell.available(759) then
			ni.spell.cast(759)
			return true
		end
	end,

["Mage / Frost Armor"] = function()
    if ni.spell.available(magearmor) 
      and not ni.unit.buff("player", 7302,"player") 
      and not ni.unit.buff("player", 6117, "player") then
      ni.spell.cast(magearmor, "player")
      return true;
    end  
  end,

["Ice Floes"] = function()
		if ni.spell.available(icefloes)
      and ni.unit.ismoving("player") 
      and not ni.unit.buff("player", 108839, "player") then
			ni.spell.cast(icefloes, "player")
			return true;
		end
	end,	
  
["Rune of Power"] = function()
      if ni.spell.available(runeofpower)
      and not ni.unit.buff("player", 116014, "player") 
      and not ni.unit.ismoving("player")
      and GetTime() - lastcast > 4
			then lastcast = GetTime()
			ni.spell.castat(runeofpower, "player")
			return true;
		end
	end,

["Mirror Image"] = function()
    if ni.spell.available(mirrorimage) 
      and not ni.unit.ischanneling("player") then
		   ni.spell.cast(mirrorimage, "target")
		   return true
	   end
   end,	  

["Living Bomb"] = function()
		if ni.spell.available(livingbomb)
		and ni.unit.debuffremaining("target", "44461", "player") <= 2 then
			ni.spell.cast(livingbomb, "target")
			return true
		end
	end,
	
["Arcane Missiles"] = function()
	local arcanecharge, _, _, arcanecharge_stacks = ni.player.debuff(114664)
		if arcanecharge_stacks == 4
      and ni.unit.buff("player", "79683") 
      and not ni.unit.ischanneling("player") then
			ni.spell.cast(arcanemissiles, "target")
			return true
		end
	end,

["Arcane Barrage"] = function()
	local arcanecharge, _, _, arcanecharge_stacks = ni.player.debuff(114664)
    if arcanecharge_stacks == 4 
    and not ni.unit.ischanneling("player") then
			ni.spell.cast(arcanebarrage, "target")
			return true
		end
	end,
-- T16 Bonus needs to be implemented  

["Arcane Blast"] = function()
    if ni.spell.available(arcaneblast) 
      and not ni.unit.ischanneling("player") then
		   ni.spell.cast(arcaneblast, "target")
		   return true
	   end
   end,	
	
["Window"] = function()
		if not popup_shown then
		 ni.debug.popup("Arkanist by Brecherbernd", 
		 "Welcome to the Arkanist, this profile is still in developement! \nWrite me in discord if you have any suggestions!\n\nSuggested Talents: 313222\n\n\nCredits to DarhangeR, Nemo, Bulletin and Scott")	
		popup_shown = true;
		end 
	end,
};
ni.bootstrap.rotation("Brecherbernd_Arkanist", queue, abilities)