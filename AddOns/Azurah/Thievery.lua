local Azurah	= _G['Azurah'] -- grab addon table from global
local L			= Azurah:GetLocale()

-- UPVALUES --
local GetGameCameraInteractableActionInfo	= GetGameCameraInteractableActionInfo
local STR_LOOT_STEAL						= GetString(SI_LOOT_STEAL)
local STR_CONTAINER_STEAL					= GetString(SI_GAMECAMERAACTIONTYPE20)
local STR_PICKPOCKET						= GetString(SI_GAMECAMERAACTIONTYPE21)

local theftPreventAccidental, theftMakeSafer, theftCMakeSafer, theftPMakeSafer
local interactAction, interactIsOwned
local StartInteractionOrig
local isHidden

local function Azurah_StartInteraction(...)
	interactAction, _, _, interactIsOwned = GetGameCameraInteractableActionInfo()

	if (interactAction == STR_PICKPOCKET) then -- trying to pickpocket
		if (theftPMakeSafer and isHidden < 3) then -- if being safer and not hidden, block
			if Azurah.db.theftAnnounceBlock then CHAT_SYSTEM:AddMessage(L.TheftBlocked) end
			return true
		else
			return StartInteractionOrig(...)
		end
	elseif (interactIsOwned) then -- owned item
		if (interactAction == STR_LOOT_STEAL) then -- trying to steal a world item
			if (not theftPreventAccidental) then -- not interfering with world objects, proceed
				return StartInteractionOrig(...)
			elseif (theftMakeSafer and isHidden > 2) then -- being safe and are hidden, allow
				return StartInteractionOrig(...)
			else -- interfering with world objects and not allowing for 'safe' theft, block
				if Azurah.db.theftAnnounceBlock then CHAT_SYSTEM:AddMessage(L.TheftBlocked) end
				return true
			end
		elseif (interactAction == STR_CONTAINER_STEAL) then -- trying to steal from a chest
			if (isHidden < 3 and theftCMakeSafer) then -- not hiding and protection is on, block
				if Azurah.db.theftAnnounceBlock then CHAT_SYSTEM:AddMessage(L.TheftBlocked) end
				return true
			else
				return StartInteractionOrig(...) -- allow because we're not protecting regardless of stealth
			end
		end
	else
		return StartInteractionOrig(...) -- not pickpocketing or trying to steal, continue
	end
end

local function OnStealthStateChanged(evt, unit, stealthState)
	if (unit ~= 'player') then return end

	isHidden = stealthState
end


-- ------------------------
-- CONFIGURATION
-- ------------------------
function Azurah:ConfigureThievery()
	-- setup local refs to database entries
	theftPreventAccidental	= self.db.theftPreventAccidental
	theftMakeSafer			= self.db.theftMakeSafer
	theftCMakeSafer			= self.db.theftCMakeSafer
	theftPMakeSafer			= self.db.theftPMakeSafer

	if (theftPreventAccidental or theftCMakeSafer or theftPMakeSafer) then
		isHidden = GetUnitStealthState('player')

		EVENT_MANAGER:RegisterForEvent(self.name .. 'Thievery', EVENT_STEALTH_STATE_CHANGED, OnStealthStateChanged)

		if (not StartInteractionOrig) then
			StartInteractionOrig = FISHING_MANAGER.StartInteraction
		end

		FISHING_MANAGER.StartInteraction = Azurah_StartInteraction
	else
		EVENT_MANAGER:UnregisterForEvent(self.name .. 'Thievery', EVENT_STEALTH_STATE_CHANGED)

		if (StartInteractionOrig) then -- only unset if we set it in this session
			FISHING_MANAGER.StartInteraction = StartInteractionOrig
		end
	end
end
