--[[----------------------------------------------------------
	Azurah - Interface Enhanced
	----------------------------------------------------------
	* An addon designed to allow for user customization of the
	* stock interface with optional components to provide
	* additional information while maintaining the stock feel.
	*
	* Authors:
	* Kith, Garkin, Phinix, Sounomi
	*
	*
]]--
local Azurah		= _G['Azurah'] -- grab addon table from global
local L				= Azurah:GetLocale()

Azurah.name			= 'Azurah'
Azurah.slash		= '/azurah'
Azurah.version		= '2.4.24'
Azurah.versionDB	= 2

Azurah.movers		= {}
Azurah.snapToGrid	= true
Azurah.uiUnlocked	= false


-- ------------------------
-- ADDON INITIALIZATION
-- ------------------------
function Azurah.OnInitialize(code, addon)
	if (addon ~= Azurah.name) then return end

	local self = Azurah

	EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_ADD_ON_LOADED)
	SLASH_COMMANDS[self.slash] = self.SlashCommand

	self.db = ZO_SavedVars:NewAccountWide('AzurahDB', self.versionDB, nil, self:GetDefaults())

	if (not self.db.useAccountWide) then -- not using global settings, generate (or load) character specific settings
		self.db = ZO_SavedVars:New('AzurahDB', self.versionDB, nil, self:GetDefaults())
	end

	ZO_PreHook(ACTIVITY_TRACKER, "Update", self.OnActivityTrackerUpdate)
	ZO_PreHook(READY_CHECK_TRACKER, "Update", self.OnReadyCheckTrackerUpdate)

	if WYK_FullImmersion then -- prevent Wykkyd compass from getting out of sync on alt-tab (Phinix)
		local hudScene = SCENE_MANAGER:GetScene("hud")
		hudScene:RegisterCallback("StateChange", function(oldState, newState)
			if newState == SCENE_SHOWN then
				CompassLoad()
			end
		end)
	end

	self:InitializeSettings()

	EVENT_MANAGER:RegisterForEvent(Azurah.name, EVENT_GAMEPAD_PREFERRED_MODE_CHANGED, self.OnPreferredModeChanged)
end

function Azurah.OnPlayerActivated()
	EVENT_MANAGER:UnregisterForEvent(Azurah.name, EVENT_PLAYER_ACTIVATED)

	Azurah:InitializePlayer()				-- Player.lua
	Azurah:InitializeTarget()				-- Target.lua
	Azurah:InitializeBossbar()				-- Bossbar.lua
	Azurah:InitializeActionBar()			-- ActionBar.lua
	Azurah:InitializeExperienceBar()		-- ExperienceBar.lua
	Azurah:InitializeUnlock()				-- Unlock.lua
	Azurah:InitializeBagWatcher()			-- BagWatcher.lua
	Azurah:InitializeWerewolf()				-- Werewolf.lua
	Azurah:ConfigureThievery()				-- Thievery.lua
end

function Azurah.OnPreferredModeChanged(evt, gamepadPreferred)
	if (Azurah.uiUnlocked) then
		Azurah:LockUI()
	end

	Azurah:InitializeUnlock()
	Azurah:ConfigureTargetModeChanged()
	Azurah:ConfigureActionBarElements()
	Azurah:ConfigureExperienceBarOverlay()

	if (gamepadPreferred) then
		Azurah:ConfigureBagWatcherGamepad()
	else
		Azurah:ConfigureBagWatcherKeyboard()
	end

	-- option to reloadui on keyboard/gamepad mode change (Phinix)
	if Azurah.db.modeChangeReload then
		ReloadUI()
	end

end

function Azurah.OnActivityTrackerUpdate()
	if Azurah.db.actTrackerDisable then
		ACTIVITY_TRACKER.headerLabel:SetHidden(true)
		ACTIVITY_TRACKER.subLabel:SetHidden(true)
		ACTIVITY_TRACKER.activityType = nil

		return true
	end
end

function Azurah.OnReadyCheckTrackerUpdate()
	if Azurah.db.actTrackerDisable then
		READY_CHECK_TRACKER.iconsContainer:SetHidden(true)
		READY_CHECK_TRACKER.countLabel:SetHidden(true)

		return true
	end
end

function Azurah.SlashCommand(text)
	local uiUnlocked = Azurah.uiUnlocked
	if (text == 'save') then
		if (uiUnlocked) then
			Azurah:LockUI(1)
		end
	elseif (text == 'undo') then
		if (uiUnlocked) then
			Azurah:LockUI(2)
		end
	elseif (text == 'exit') then
		if (uiUnlocked) then
			Azurah:LockUI(3)
		end
	elseif (text == 'unlock') then
		if (not uiUnlocked) then
			Azurah:UnlockUI()
		end
	else
		CHAT_SYSTEM:AddMessage(L.Usage)
	end
end


-- ------------------------
-- OVERLAY BASE
-- ------------------------
local strformat			= string.format
local strgsub			= string.gsub
local captureStr		= '%1' .. L.ThousandsSeparator .. '%2'
local k

local function comma_value(amount)
	while (true) do
		amount, k = strgsub(amount, '^(-?%d+)(%d%d%d)', captureStr)

		if (k == 0) then
			break
		end
	end

	return amount
end

Azurah.overlayFuncs = {
	[1] = function(current, max, effMax, shield)
		return '' -- dummy, returns an empty string
	end,
	-- standard overlays
	[2] = function(current, max, effMax, shield)
		effMax = effMax > 0 and effMax or 1 -- ensure we don't do a divide by 0
		if shield and shield > 0 then
			return strformat('%d + %d / %d (%d%%)', current, shield, effMax, (current / effMax) * 100)
		else
			return strformat('%d / %d (%d%%)', current, effMax, (current / effMax) * 100)
		end
	end,
	[3] = function(current, max, effMax, shield)
		if shield and shield > 0 then
			return strformat('%d + %d / %d', current, shield, effMax)
		else
			return strformat('%d / %d', current, effMax)
		end
	end,
	[4] = function(current, max, effMax, shield)
		effMax = effMax > 0 and effMax or 1 -- ensure we don't do a divide by 0
		if shield and shield > 0 then
			return strformat('%d + %d (%d%%)', current, shield, (current / effMax) * 100)
		else
			return strformat('%d (%d%%)', current, (current / effMax) * 100)
		end
	end,
	[5] = function(current, max, effMax, shield)
		if shield and shield > 0 then
			return strformat('%d + %d', current, shield)
		else
			return strformat('%d', current)
		end
	end,
	[6] = function(current, max, effMax)
		effMax = effMax > 0 and effMax or 1 -- ensure we don't do a divide by 0
		return strformat('%d%%', (current / effMax) * 100)
	end,
	-- comma-seperated overlays
	[12] = function(current, max, effMax, shield)
		effMax = effMax > 0 and effMax or 1 -- ensure we don't do a divide by 0
		if shield and shield > 0 then
			return strformat('%s + %s / %s (%d%%)', comma_value(current), comma_value(shield), comma_value(effMax), (current / effMax) * 100)
		else
			return strformat('%s / %s (%d%%)', comma_value(current), comma_value(effMax), (current / effMax) * 100)
		end
	end,
	[13] = function(current, max, effMax, shield)
		if shield and shield > 0 then
			return strformat('%s + %s / %s', comma_value(current), comma_value(shield), comma_value(effMax))
		else
			return strformat('%s / %s', comma_value(current), comma_value(effMax))
		end
	end,
	[14] = function(current, max, effMax, shield)
		effMax = effMax > 0 and effMax or 1 -- ensure we don't do a divide by 0
		if shield and shield > 0 then
			return strformat('%s + %s (%d%%)', comma_value(current), comma_value(shield), (current / effMax) * 100)
		else
			return strformat('%s (%d%%)', comma_value(current), (current / effMax) * 100)
		end
	end,
	[15] = function(current, max, effMax, shield)
		if shield and shield > 0 then
			return strformat('%s + %s', comma_value(current), comma_value(shield))
		else
			return strformat('%s', comma_value(current))
		end
	end,
	[16] = function(current, max, effMax)
		effMax = effMax > 0 and effMax or 1 -- ensure we don't do a divide by 0
		return strformat('%d%%', (current / effMax) * 100)
	end
}

function Azurah:CreateOverlay(parent, rel, relPoint, x, y, width, height, vAlign, hAlign)
	local o = WINDOW_MANAGER:CreateControl(nil, parent, CT_LABEL)
	o:SetResizeToFitDescendents(true)
	o:SetInheritScale(false)
	o:SetDrawTier(DT_HIGH)
	o:SetDrawLayer(DL_OVERLAY)
	o:SetAnchor(rel, parent, relPoint, x, y)
	o:SetHorizontalAlignment(hAlign or TEXT_ALIGN_CENTER)
	o:SetVerticalAlignment(vAlign or TEXT_ALIGN_CENTER)

	return o
end


EVENT_MANAGER:RegisterForEvent(Azurah.name, EVENT_ADD_ON_LOADED,	Azurah.OnInitialize)
EVENT_MANAGER:RegisterForEvent(Azurah.name, EVENT_PLAYER_ACTIVATED,	Azurah.OnPlayerActivated)
