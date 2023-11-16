-----------------------------------------------
--------------- Licensing System --------------
-----------------------------------------------
local spell = {};
local discord = "_trojan"
local dir = ni.functions.getbasefolder();
-- Generate a unique identifier based on system information
local uniqueIdentifier = string.format("%04x", math.random(0, 0xFFFF))
licensing = {}
-- Your licensing algorithm to generate a license key based on the unique identifier
local function generateLicenseKey(identifier)
	local fixedPart = discord
	return fixedPart .. "-" .. identifier
end

-- Generate a license key
local licenseKey = generateLicenseKey(uniqueIdentifier)
local filepath = dir .. "license.key"
local content = ni.functions.loadcontent(filepath)

if content == nil then
	ni.functions.savecontent(filepath, licenseKey)
	content = licenseKey
else
	licenseKey = content
end
-- Check if a provided license key is valid
--local function isLicenseValid(providedKey)
--	local expectedKey = content
--	return providedKey == expectedKey
--end
--
--local providedKey = licenseKey
--licensing.licensed = function()
--	if isLicenseValid(providedKey) then
--		return true
--	else
--		ni.frames.floatingtext:message("Invalid License! Please Contact Trojan with the key in your License.key file.")
--		return false
--	end
--end;
--
--return licensing;

local WebCode, WebResponse = "", 0;
local keyCode, keyResponse = "", 0;
while keyCode ~= tonumber("200") do
	keyResponse = keyResponse + 1
	ni.functions.webrequest("https://svenbledt.github.io/NiHub_Trojan/licenses/" .. discord .. ".json", nil, false,
		function(code, body)
			keyCode = code
			if code == tonumber("200") then
				ni.keytable = ni.utils.json.decode(body);
			end
		end)
	if keyResponse == 12 then
		if (GetLocale() == "deDE") then
			message("\n\nDer Server antwortet nicht!");
		else
			message("\n\nTime server not responding!");
		end
		break
	end
end;
while WebCode ~= tonumber("200") do
	WebResponse = WebResponse + 1
	ni.functions.webrequest("https://www.timeapi.io/api/Time/current/zone?timeZone=Europe/Berlin", nil, false,
		function(code, body)
			WebCode = code
			if code == tonumber("200") then
				ni.elitetable = ni.utils.json.decode(body);
			end
		end)
	if WebResponse == 12 then
		if (GetLocale() == "deDE") then
			message("\n\nDer Server antwortet nicht!");
		else
			message("\n\nTime server not responding!");
		end
		break
	end
end;
local elite, key = ni.elitetable, ni.keytable;
local ServerY, ServenM, ServerD = key["year"], key["month"], key["day"];           -- check expiration date
local y1, m2, d3, h4 = elite["year"], elite["month"], elite["day"], elite["hour"]; --- We're not touching anything.
spell.getosdate = function()
	local servercompare = { year = y1, month = m2, day = d3, hour = h4, min = 00, sec = 00 }
	local getpcdate = time(servercompare)
	return getpcdate
end;
spell.getendtime = function()
	local KeyExpiration = { year = ServerY, month = ServenM, day = ServerD, hour = 00, min = 00, sec = 00 }
	local KeyDate = time(KeyExpiration)
	return KeyDate
end;
spell.calculatetime = function()
	local function Calculate(time)
		local day = floor(time / 86400)
		local hour = floor(mod(time, 86400) / 3600)
		if (GetLocale() == "deDE") then
			return format("|cFFFFFFFF%d Tage : %02d Stunden", day, hour)
		else
			return format("|cFFFFFFFF%d days : %02d hours", day, hour)
		end
	end;
	local TimesLeft = spell.getendtime() - spell.getosdate()
	local TimeDifference = Calculate(TimesLeft)
	return TimeDifference
end;
local backdrop = {
	bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
	edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
	tile = true,
	tileSize = 14,
	edgeSize = 26,
	insets = { left = 3, right = 3, top = 3, bottom = 3 }
};
local escmenuframe = CreateFrame("frame", nil, GameMenuFrame);
escmenuframe:SetPoint("BOTTOM", 0, -50)
escmenuframe:SetFrameStrata("BACKGROUND");
escmenuframe:SetWidth(194);
escmenuframe:SetHeight(50);
escmenuframe:SetBackdrop(backdrop);
escmenuframe:SetBackdropColor(0, 0, 0, 1);
local timerframenumbers = CreateFrame("Button", "LicenseButton", GameMenuFrame, "UIPanelButtonTemplate")
timerframenumbers:SetHeight(30);
timerframenumbers:SetWidth(170);
timerframenumbers:ClearAllPoints();
timerframenumbers:SetPoint("BOTTOM", 0, -40);
local ONUPDATE_INTERVAL = 0.1
local TimeSinceLastUpdate = 0
timerframenumbers:SetScript("OnUpdate", function(self, elapsed)
	TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed
	if TimeSinceLastUpdate >= ONUPDATE_INTERVAL then
		TimeSinceLastUpdate = 0
		timerframenumbers:SetText(spell.calculatetime())
	end
	if spell.getosdate() >= spell.getendtime() then
		if (GetLocale() == "deDE") then
			timerframenumbers:SetText("Die Zeit ist um!")
		else
			timerframenumbers:SetText("Time is up!")
		end
	end
end)
local expectedKey = key["key"]
local providedKey = content
licensing.licensed = function()
	if expectedKey == providedKey then
		if spell.getosdate() >= spell.getendtime() then
			if (GetLocale() == "deDE") then
				message("\nIhr Abonnement ist abgelaufen. Bitte wenden Sie sich an Trojan!|r!")
				return false
			else
				message("\nYou have run out of subscription contact Trojan|r!")
				return false;
			end
			ni.functions.open("https://discord.com/users/209319089930240004")
		else
			return true;
		end
	else
		if (GetLocale() == "deDE") then
			message(
				"\n\nUngültiger Lizenzschlüssel! Bitte wenden Sie sich an Trojan mit dem Schlüssel in Ihrer License.key-Datei.")
			return false;
		else
			message("\n\nInvalid License! Please Contact Trojan with the key in your License.key file.")
			return false;
		end
		ni.functions.open("https://discord.com/users/209319089930240004")
	end
end;

return licensing;
