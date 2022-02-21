local Srendarr		= _G['Srendarr'] -- grab addon table from global
local L				= Srendarr:GetLocale()

-- CONSTS --
local ABILITY_TYPE_CHANGEAPPEARANCE	= ABILITY_TYPE_CHANGEAPPEARANCE
local ABILITY_TYPE_AREAEFFECT		= ABILITY_TYPE_AREAEFFECT
local ABILITY_TYPE_NONE 			= ABILITY_TYPE_NONE
local BUFF_EFFECT_TYPE_BUFF			= BUFF_EFFECT_TYPE_BUFF
local BUFF_EFFECT_TYPE_DEBUFF		= BUFF_EFFECT_TYPE_DEBUFF
local GROUP_PLAYER_SHORT			= Srendarr.GROUP_PLAYER_SHORT
local GROUP_PLAYER_LONG				= Srendarr.GROUP_PLAYER_LONG
local GROUP_PLAYER_TOGGLED			= Srendarr.GROUP_PLAYER_TOGGLED
local GROUP_PLAYER_PASSIVE			= Srendarr.GROUP_PLAYER_PASSIVE
local GROUP_PLAYER_DEBUFF			= Srendarr.GROUP_PLAYER_DEBUFF
local GROUP_PLAYER_GROUND			= Srendarr.GROUP_PLAYER_GROUND
local GROUP_PLAYER_MAJOR			= Srendarr.GROUP_PLAYER_MAJOR
local GROUP_PLAYER_MINOR			= Srendarr.GROUP_PLAYER_MINOR
local GROUP_PLAYER_ENCHANT			= Srendarr.GROUP_PLAYER_ENCHANT
local GROUP_TARGET_BUFF				= Srendarr.GROUP_TARGET_BUFF
local GROUP_TARGET_DEBUFF			= Srendarr.GROUP_TARGET_DEBUFF
local GROUP_PROMINENT				= Srendarr.GROUP_PROMINENT
local GROUP_PROMINENT2				= Srendarr.GROUP_PROMINENT2
local GROUP_PROMDEBUFFS				= Srendarr.GROUP_PROMDEBUFFS
local GROUP_PROMDEBUFFS2			= Srendarr.GROUP_PROMDEBUFFS2
local GROUP_CDTRACKER				= Srendarr.GROUP_CDTRACKER
local AURA_TYPE_TIMED				= Srendarr.AURA_TYPE_TIMED
local AURA_TYPE_TOGGLED				= Srendarr.AURA_TYPE_TOGGLED
local AURA_TYPE_PASSIVE				= Srendarr.AURA_TYPE_PASSIVE
local DEBUFF_TYPE_PASSIVE			= Srendarr.DEBUFF_TYPE_PASSIVE
local DEBUFF_TYPE_TIMED				= Srendarr.DEBUFF_TYPE_TIMED

-- UPVALUES --
local GetGameTimeMillis				= GetGameTimeMilliseconds
local IsToggledAura					= Srendarr.IsToggledAura
local IsMajorEffect					= Srendarr.IsMajorEffect	-- technically only used for major|minor buffs on the player, major|minor debuffs
local IsMinorEffect					= Srendarr.IsMinorEffect	-- are filtered to the debuff grouping before being checked for
local IsEnchantProc					= Srendarr.IsEnchantProc
local IsAlternateAura				= Srendarr.IsAlternateAura
local auraLookup					= Srendarr.auraLookup
local filteredAuras					= Srendarr.filteredAuras
local GetAbilityName				= GetAbilityName
local ZOSName						= function (abilityID) return zo_strformat("<<t:1>>", GetAbilityName(abilityID)) end
local trackTargets					= {}
local prominentAuras				= {}
local prominentAuras2				= {}
local prominentDebuffs				= {}
local prominentDebuffs2				= {}
local groupBuffs					= {}
local groupDebuffs					= {}
local displayFrameRef				= {}
local debugAuras					= {}
local prominentIDs					= {}
local playerName					= zo_strformat("<<t:1>>", GetUnitName('player'))
local shortBuffThreshold, passiveEffectsAsPassive, filterDisguisesOnPlayer, filterDisguisesOnTarget
local Srendarr_APIVersion = GetAPIVersion()


-- ------------------------
-- HELPER FUNCTIONS
-- ------------------------
local displayFrameFake = {
	['AddAuraToDisplay'] = function()
 		-- do nothing : used to make the AuraHandler code more manageable, redirects unwanted auras to nil
	end,
}


-- ------------------------
-- AURA HANDLER
-- ------------------------
local function AuraHandler(flagBurst, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, castByPlayer, stacks, isCooldown)
	local groupBuffBlacklist = Srendarr.db.filtersGroup.groupBuffBlacklist
	local groupDebuffBlacklist = Srendarr.db.filtersGroup.groupDebuffBlacklist
	local groupBuffsEnabled = Srendarr.db.filtersGroup.groupBuffsEnabled
	local groupDebuffsEnabled = Srendarr.db.filtersGroup.groupDebuffsEnabled
	local IsGroupUnit = Srendarr.IsGroupUnit(unitTag)
	local abilityCooldowns = Srendarr.abilityCooldowns
	local specialNames = Srendarr.specialNames
	local alteredAuraIcons = Srendarr.alteredAuraIcons
	local groupUnits = Srendarr.groupUnits
	local nStacks = (stacks ~= nil) and stacks or 0
	local minTime = Srendarr.MIN_TIMER

	local isProminent = (prominentIDs[abilityId] ~= nil) and true or false
	local isFiltered = false

	-- Send proc to cooldown tracker separate from ability tracking (Phinix)
	if (isCooldown) then
		local cdID = abilityId+4000000

		if (castByPlayer == 1) then -- only track player's proc cooldowns to avoid giant mess (Phinix)
			if Srendarr.db.auraGroups[GROUP_CDTRACKER] ~= 0 then -- only process if frame is actually assigned/shown (Phinix)
				if filteredAuras['player'] ~= nil then
					if not filteredAuras['player'][cdID] then -- allows blacklisting individual set cooldowns by the displayed ID (offset by 4000000) (Phinix)
						displayFrameRef[GROUP_CDTRACKER]:AddAuraToDisplay(flagBurst, GROUP_CDTRACKER, AURA_TYPE_TIMED, auraName..' '..L.Group_Cooldown, 'player', start, start+abilityCooldowns[abilityId].cooldown, icon, effectType, abilityType, cdID, nStacks)
					end
				end
			end
		end
		if (not abilityCooldowns[abilityId].hasTimer) then return end -- avoid sending non-timer procs to handler (Phinix)
		if specialNames[abilityId] ~= nil then auraName = specialNames[abilityId].name end -- Revert cooldown proc timer name to default buff name if ID added to specialNames (Phinix)
		if alteredAuraIcons[abilityId] ~= nil then icon = alteredAuraIcons[abilityId] end -- Change cooldown proc timer icon separate from the cooldown tracker icon (Phinix)
		if unitTag == 'reticleover' then effectType = BUFF_EFFECT_TYPE_DEBUFF end -- if timed effect is on target switch to debuff (Phinix)
	end

	if (start ~= finish and (finish - start) < minTime) then return end -- abort showing any timed auras with a duration of < minTime seconds

	-- Global Blacklist
	if filteredAuras[unitTag] ~= nil then -- set filter state to abort quickly later if blacklisted and not a prominent aura
		if (filteredAuras[unitTag][abilityId]) then isFiltered = true if not isProminent or (Srendarr.alwaysIgnore[abilityId]) then return end end -- abort immediately if this is an ability we've filtered and not whitelisted
	end

	-- Aura exists, update its data (assume would not exist unless passed filters earlier)
	if (auraLookup[unitTag][abilityId]) then
		if IsGroupUnit then
			if Srendarr.GroupEnabled then auraLookup[unitTag][abilityId]:Update(start, finish, nStacks) else return end
		else
			auraLookup[unitTag][abilityId]:Update(start, finish, nStacks)
		end
		return
	end

	if (isProminent) then -- Prominent aura detected, assign to appropriate window
		if (prominentAuras[abilityId]) then
			if (unitTag ~= 'reticleover' and not IsGroupUnit) then
				if (Srendarr.db.auraGroups[GROUP_PROMINENT] ~= 0 and effectType ~= BUFF_EFFECT_TYPE_DEBUFF) then -- ignore debuff whitelist entries
					displayFrameRef[GROUP_PROMINENT]:AddAuraToDisplay(flagBurst, GROUP_PROMINENT, (start == finish) and AURA_TYPE_PASSIVE or AURA_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
					return -- allow prominent buffs to go to normal frames if prominent 1 not assigned to a window (Phinix)
				end
			end
		elseif (prominentAuras2[abilityId]) then
			if (unitTag ~= 'reticleover' and not IsGroupUnit) then
				if (Srendarr.db.auraGroups[GROUP_PROMINENT2] ~= 0 and effectType ~= BUFF_EFFECT_TYPE_DEBUFF) then -- ignore debuff whitelist entries
					displayFrameRef[GROUP_PROMINENT2]:AddAuraToDisplay(flagBurst, GROUP_PROMINENT2, (start == finish) and AURA_TYPE_PASSIVE or AURA_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
					return -- allow prominent buffs to go to normal frames if prominent 2 not assigned to a window (Phinix)
				end
			end
		end
		if (prominentDebuffs[abilityId]) then
			if (unitTag == 'reticleover' and not IsGroupUnit) then
				if (Srendarr.db.auraGroups[GROUP_PROMDEBUFFS] ~= 0 and effectType == BUFF_EFFECT_TYPE_DEBUFF) then -- ignore non-debuff whitelist entries
					displayFrameRef[GROUP_PROMDEBUFFS]:AddAuraToDisplay(flagBurst, GROUP_PROMDEBUFFS, (start == finish) and DEBUFF_TYPE_PASSIVE or DEBUFF_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
					return -- allow prominent debuffs to go to normal frames if prominent not assigned to a window (Phinix)
				end
			end
		elseif (prominentDebuffs2[abilityId]) then
			if (unitTag == 'reticleover' and not IsGroupUnit) then
				if (Srendarr.db.auraGroups[GROUP_PROMDEBUFFS2] ~= 0 and effectType == BUFF_EFFECT_TYPE_DEBUFF) then -- ignore non-debuff whitelist entries
					displayFrameRef[GROUP_PROMDEBUFFS2]:AddAuraToDisplay(flagBurst, GROUP_PROMDEBUFFS2, (start == finish) and DEBUFF_TYPE_PASSIVE or DEBUFF_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
					return -- allow prominent debuffs to go to normal frames if prominent not assigned to a window (Phinix)
				end
			end
		end
		if isFiltered then return end -- if ability is blacklisted and set to a prominent group that isn't assigned or applicable, treat as blacklisted (Phinix)
	end

	if (unitTag == 'reticleover') then -- new aura on target
		if (effectType == BUFF_EFFECT_TYPE_DEBUFF) then
			-- debuff on target, check for it being a passive (not sure they can be, but just to be sure as things break with a 'timed' passive)
			displayFrameRef[GROUP_TARGET_DEBUFF]:AddAuraToDisplay(flagBurst, GROUP_TARGET_DEBUFF, (start == finish) and DEBUFF_TYPE_PASSIVE or DEBUFF_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
		else
			-- buff on target, sort as passive, toggle or timed and add
			if (filterDisguisesOnTarget and abilityType == ABILITY_TYPE_CHANGEAPPEARANCE) then return end -- is a disguise and they are filtered
	
			if (start == finish) then -- toggled or passive
				displayFrameRef[GROUP_TARGET_BUFF]:AddAuraToDisplay(flagBurst, GROUP_TARGET_BUFF, (IsToggledAura(abilityId)) and AURA_TYPE_TOGGLED or AURA_TYPE_PASSIVE, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
			else -- timed buff
				displayFrameRef[GROUP_TARGET_BUFF]:AddAuraToDisplay(flagBurst, GROUP_TARGET_BUFF, AURA_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
			end
		end
	elseif (unitTag == 'player') then -- new aura on player
		if (effectType == BUFF_EFFECT_TYPE_DEBUFF) then
			-- debuff on player, check for it being a passive (not sure they can be, but just to be sure as things break with a 'timed' passive)
			displayFrameRef[GROUP_PLAYER_DEBUFF]:AddAuraToDisplay(flagBurst, GROUP_PLAYER_DEBUFF, (start == finish) and DEBUFF_TYPE_PASSIVE or DEBUFF_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
		else
			-- buff on player, sort as passive, toggled or timed and add
			if (filterDisguisesOnPlayer and abilityType == ABILITY_TYPE_CHANGEAPPEARANCE) then return end -- is a disguise and they are filtered
	
			if (start == finish) then -- toggled or passive
				if (IsMajorEffect(abilityId) and not passiveEffectsAsPassive) then -- major buff on player
					displayFrameRef[GROUP_PLAYER_MAJOR]:AddAuraToDisplay(flagBurst, GROUP_PLAYER_MAJOR, AURA_TYPE_PASSIVE, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
				elseif (IsMinorEffect(abilityId) and not passiveEffectsAsPassive) then -- minor buff on player
					displayFrameRef[GROUP_PLAYER_MINOR]:AddAuraToDisplay(flagBurst, GROUP_PLAYER_MINOR, AURA_TYPE_PASSIVE, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
				elseif (IsToggledAura(abilityId)) then -- toggled
					displayFrameRef[GROUP_PLAYER_TOGGLED]:AddAuraToDisplay(flagBurst, GROUP_PLAYER_TOGGLED, AURA_TYPE_TOGGLED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
				else -- passive, including passive major and minor effects, not seperated out before
					displayFrameRef[GROUP_PLAYER_PASSIVE]:AddAuraToDisplay(flagBurst, GROUP_PLAYER_PASSIVE, AURA_TYPE_PASSIVE, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
				end
			else -- timed buff
				if (IsEnchantProc(abilityId)) then -- enchant proc on player
					displayFrameRef[GROUP_PLAYER_ENCHANT]:AddAuraToDisplay(flagBurst, GROUP_PLAYER_ENCHANT, AURA_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
				elseif (IsMajorEffect(abilityId)) then -- major buff on player
					displayFrameRef[GROUP_PLAYER_MAJOR]:AddAuraToDisplay(flagBurst, GROUP_PLAYER_MAJOR, AURA_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
				elseif (IsMinorEffect(abilityId)) then -- minor buff on player
					displayFrameRef[GROUP_PLAYER_MINOR]:AddAuraToDisplay(flagBurst, GROUP_PLAYER_MINOR, AURA_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
				elseif ((finish - start) > shortBuffThreshold) then -- is considered a long duration buff
					displayFrameRef[GROUP_PLAYER_LONG]:AddAuraToDisplay(flagBurst, GROUP_PLAYER_LONG, AURA_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
				else
					displayFrameRef[GROUP_PLAYER_SHORT]:AddAuraToDisplay(flagBurst, GROUP_PLAYER_SHORT, AURA_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
				end
			end
		end
	elseif IsGroupUnit and groupUnits[unitTag] and Srendarr.GroupEnabled then -- new group aura detected, assign to appropriate window
		if (effectType == BUFF_EFFECT_TYPE_DEBUFF) and groupDebuffsEnabled then
			local groupDebuff = (groupDebuffs[abilityId] ~= nil) and true or false 
			if (not groupDebuffBlacklist and groupDebuff) or (groupDebuffBlacklist and not groupDebuff) then
				local groupDebuffDuration = Srendarr.db.filtersGroup.groupDebuffDuration
				local groupDebuffThreshold = Srendarr.db.filtersGroup.groupDebuffThreshold
				local duration = finish - start
				if (not groupDebuffDuration or duration <= groupDebuffThreshold) then -- filter group debuffs by duration
					local groupFrame = groupUnits[unitTag].index + 24
					displayFrameRef[groupFrame]:AddAuraToDisplay(flagBurst, groupFrame, AURA_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
				end
			end
		elseif (effectType == BUFF_EFFECT_TYPE_BUFF) and groupBuffsEnabled then

			if Srendarr.db.filtersGroup.groupBuffOnlyPlayer and castByPlayer ~= 31 then return end -- only show player-sourced group buffs when enabled (Phinix)

			local groupBuff = (groupBuffs[abilityId] ~= nil) and true or false 
			if (not groupBuffBlacklist and groupBuff) or (groupBuffBlacklist and not groupBuff) then
				local groupBuffDuration = Srendarr.db.filtersGroup.groupBuffDuration
				local groupBuffThreshold = Srendarr.db.filtersGroup.groupBuffThreshold
				local duration = finish - start
				if (not groupBuffDuration or duration <= groupBuffThreshold) then -- filter group buffs by duration
					local groupFrame = groupUnits[unitTag].index
					displayFrameRef[groupFrame]:AddAuraToDisplay(flagBurst, groupFrame, AURA_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
				end
			end
		end
	elseif (unitTag == 'groundaoe') then -- new ground aoe cast by player (assume always timed)
		displayFrameRef[GROUP_PLAYER_GROUND]:AddAuraToDisplay(flagBurst, GROUP_PLAYER_GROUND, AURA_TYPE_TIMED, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, nStacks)
	end
	return
end

Srendarr.PassToAuraHandler = function(flagBurst, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, castByPlayer, stacks)
	AuraHandler(flagBurst, auraName, unitTag, start, finish, icon, effectType, abilityType, abilityId, castByPlayer, stacks)
	return
end

function Srendarr:ConfigureAuraHandler()
	for group, frameNum in pairs(self.db.auraGroups) do
		-- if a group is set to hidden, auras will be sent to a fake frame that does nothing (simplifies things)
		displayFrameRef[group] = (frameNum > 0) and self.displayFrames[frameNum] or displayFrameFake
	end

	shortBuffThreshold		= self.db.shortBuffThreshold
	passiveEffectsAsPassive	= self.db.passiveEffectsAsPassive
	filterDisguisesOnPlayer	= self.db.filtersPlayer.disguise
	filterDisguisesOnTarget	= self.db.filtersTarget.disguise

	for id in pairs(prominentAuras) do
		prominentAuras[id] = nil -- clean out prominent 1 auras list
	end

	for id in pairs(prominentAuras2) do
		prominentAuras2[id] = nil -- clean out prominent 2 auras list
	end

	for id in pairs(prominentDebuffs) do
		prominentDebuffs[id] = nil -- clean out prominent 1 debuff list
	end

	for id in pairs(prominentDebuffs2) do
		prominentDebuffs2[id] = nil -- clean out prominent 2 debuff list
	end

	for id in pairs(groupBuffs) do
		groupBuffs[id] = nil -- clean out group auras list
	end

	for id in pairs(groupDebuffs) do
		groupDebuffs[id] = nil -- clean out group auras list
	end

	for _, abilityIds in pairs(self.db.prominentWhitelist) do
		for id in pairs(abilityIds) do
			prominentAuras[id] = true -- populate prominent 1 list from saved database
			prominentIDs[id] = true
		end
	end

	for _, abilityIds in pairs(self.db.prominentWhitelist2) do
		for id in pairs(abilityIds) do
			prominentAuras2[id] = true -- populate prominent 2 list from saved database
			prominentIDs[id] = true
		end
	end

	for _, abilityIds in pairs(self.db.debuffWhitelist) do
		for id in pairs(abilityIds) do
			prominentDebuffs[id] = true -- populate debuff list from saved database
			prominentIDs[id] = true
		end
	end

	for _, abilityIds in pairs(self.db.debuffWhitelist2) do
		for id in pairs(abilityIds) do
			prominentDebuffs2[id] = true -- populate debuff list from saved database
			prominentIDs[id] = true
		end
	end

	for _, abilityIds in pairs(self.db.groupBuffWhitelist) do
		for id in pairs(abilityIds) do
			groupBuffs[id] = true -- populate group list from saved database
			prominentIDs[id] = true
		end
	end

	for _, abilityIds in pairs(self.db.groupDebuffWhitelist) do
		for id in pairs(abilityIds) do
			groupDebuffs[id] = true -- populate group list from saved database
			prominentIDs[id] = true
		end
	end
end


-- ------------------------
-- EVENT: EVENT_PLAYER_ACTIVATED, EVENT_PLAYER_ALIVE
do ------------------------
    local GetNumBuffs       	= GetNumBuffs
    local GetUnitBuffInfo   	= GetUnitBuffInfo
    local NUM_DISPLAY_FRAMES	= Srendarr.NUM_DISPLAY_FRAMES
	local auraLookup			= Srendarr.auraLookup
	local alternateAura			= Srendarr.alternateAura

	local function CheckGroupFunction()
		Srendarr.GroupEnabled = true

		-- JoGroup uses custom sorting which is currently not supported
		if JoGroup then
			Srendarr.GroupEnabled = false
		end

		-- Initialize group buff support if passes above checks
		if Srendarr.GroupEnabled then
			Srendarr.OnGroupChanged()
		end
	end

	Srendarr.OnPlayerActivatedAlive = function(keepAuras, guiShown)
		local activeAuras = {}
		local sourceCast
		local numAuras
		local auraName, start, finish, icon, effectType, abilityType, abilityId, castByPlayer

		if not keepAuras and not guiShown then -- don't clear out auras when simply re-showing due to leaving menus (Phinix)
			for _, auras in pairs(auraLookup) do -- iterate all aura lookups
				for _, aura in pairs(auras) do -- iterate all auras for each lookup
					aura:Release(true)
				end
			end
		end

		numAuras = GetNumBuffs('player')

		if numAuras > 0 then -- player has auras, scan and send to handle
			for i = 1, numAuras do
				auraName, start, finish, _, stacks, icon, _, effectType, abilityType, _, abilityId, _, castByPlayer = GetUnitBuffInfo('player', i)
				sourceCast = (castByPlayer) and 1 or 2

				table.insert(activeAuras, abilityId, true)

				if Srendarr.db.consolidateEnabled == true then -- Handles multi-aura passive abilities like Restoring Aura
					if (IsAlternateAura(abilityId)) then -- Consolidate multi-aura passive abilities
						AuraHandler(true, alternateAura[abilityId].altName, 'player', start, finish, icon, effectType, abilityType, abilityId, sourceCast, stacks)
					else
						AuraHandler(true, auraName, 'player', start, finish, icon, effectType, abilityType, abilityId, sourceCast, stacks)
					end
				else
					AuraHandler(true, auraName, 'player', start, finish, icon, effectType, abilityType, abilityId, sourceCast, stacks)
				end
			end
		end

		for k, v in pairs(auraLookup['player']) do -- remove any stuck passive auras (things like empowered fetcherflies that don't send end events when zoning)
			if not activeAuras[k] and v.start == v.finish then
				v:Release()
			end
		end

		for k, v in pairs(auraLookup['reticleover']) do -- clear target auras which no longer get end events when zoning
			v:Release()
		end

		for x = 1, NUM_DISPLAY_FRAMES do
			Srendarr.displayFrames[x]:UpdateDisplay() -- update the display for all frames
		end

		zo_callLater(CheckGroupFunction, 1000)

		Srendarr:ConfigureOnCombatState()

		activeAuras = {}
	end
end


-- ------------------------
-- EVENT: EVENT_PLAYER_DEAD
do ------------------------
    local NUM_DISPLAY_FRAMES	= Srendarr.NUM_DISPLAY_FRAMES
    local auraLookup			= Srendarr.auraLookup

	Srendarr.OnPlayerDead = function()
		for _, auras in pairs(auraLookup) do -- iterate all aura lookups
			for _, aura in pairs(auras) do -- iterate all auras for each lookup
				aura:Release(true)
			end
		end

		for x = 1, NUM_DISPLAY_FRAMES do
			Srendarr.displayFrames[x]:UpdateDisplay() -- update the display for all frames
		end
	end
end


-- ------------------------
-- EVENT: EVENT_PLAYER_COMBAT_STATE
do -----------------------
    local NUM_DISPLAY_FRAMES	= Srendarr.NUM_DISPLAY_FRAMES
    local displayFramesScene	= Srendarr.displayFramesScene
	local displayFrames			= Srendarr.displayFrames

	local function cShow(frame)
		if not Srendarr.uiHidden then
			if frame ~= nil then
				if displayFrames[frame] ~= nil and displayFramesScene[frame] ~= nil then
					displayFramesScene[frame]:SetHiddenForReason('combatstate', false)
					displayFrames[frame]:SetHidden(false)
				end
			else
				for x = 1, NUM_DISPLAY_FRAMES do
					if displayFrames[x] ~= nil and displayFramesScene[x] ~= nil then
						displayFramesScene[x]:SetHiddenForReason('combatstate', false)
						displayFrames[x]:SetHidden(false)
					end
				end
			end
		end
	end

	local function OnCombatState(e, inCombat)
		if not Srendarr.uiHidden then
			if (inCombat) or (Srendarr.SampleAurasActive) then
				cShow()
			else
				if (Srendarr.db.combatDisplayOnly) then
					local checkPassives = Srendarr.db.auraGroups[GROUP_PLAYER_PASSIVE]
					local combatAlwaysPassives = Srendarr.db.combatAlwaysPassives
					for x = 1, NUM_DISPLAY_FRAMES do
						if displayFrames[x] ~= nil and displayFramesScene[x] ~= nil then
							if (not combatAlwaysPassives) or ((combatAlwaysPassives) and (x ~= checkPassives)) then
								displayFramesScene[x]:SetHiddenForReason('combatstate', true)
								displayFrames[x]:SetHidden(true)
							else
								cShow(x)
							end
						end
					end
				else
					cShow()
				end
			end
		end
	end

	function Srendarr:ConfigureOnCombatState()
		if (self.db.combatDisplayOnly) then
			EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_COMBAT_STATE, OnCombatState)

			OnCombatState(nil, IsUnitInCombat('player')) -- force an update
		else
			EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_PLAYER_COMBAT_STATE)

			cShow()
		end
	end
end


-- ------------------------
-- EVENT: EVENT_CAMPAIGN_STATE_INITIALIZED, EVENT_CURRENT_CAMPAIGN_CHANGED, EVENT_BATTLEGROUND_STATE_CHANGED
do ------------------------
	local checkPVP = true
	local function CampaignStateLoop(pass) -- handle internal game delay in registering addon events after PVP campaign state changes (Phinix)
		if (checkPVP) then
			checkPVP = false
			if pass < Srendarr.db.numChecksPVP then
				if (SCENE_MANAGER:IsShowing('hudui')) or (SCENE_MANAGER:IsShowing('hud')) then
					pass = pass + 1
				end
				zo_callLater(function() Srendarr.OnPlayerActivatedAlive() end, 1000 + GetLatency())
				zo_callLater(function() checkPVP = true CampaignStateLoop(pass) end, 1000 + GetLatency())
			else
				checkPVP = true
			end
		end
	end
	EVENT_MANAGER:RegisterForEvent("Srendarr", EVENT_CAMPAIGN_STATE_INITIALIZED, function() CampaignStateLoop(0) end)
	EVENT_MANAGER:RegisterForEvent("Srendarr", EVENT_CURRENT_CAMPAIGN_CHANGED, function() CampaignStateLoop(0) end)
	EVENT_MANAGER:RegisterForEvent("Srendarr", EVENT_BATTLEGROUND_STATE_CHANGED, function() CampaignStateLoop(0) end)
end


-- ------------------------
-- EVENT: EVENT_ACTION_SLOT_ABILITY_USED
do ------------------------
	local GetGameTimeMillis		= GetGameTimeMilliseconds
	local GetLatency			= GetLatency
	local slotData				= Srendarr.slotData
	local fakeAuras				= Srendarr.fakeAuras


	Srendarr.OnActionSlotAbilityUsed = function(e, slotID)
		local slotAbilityName, currentTime
		local abilityOffset
	
		if (slotID < 3 or slotID > 8) then return end -- abort if not a main ability (or ultimate)

		slotAbilityName = slotData[slotID].abilityName

		if fakeAuras[slotAbilityName] == nil then return end -- no fake aura needed for this ability (majority case)

		local slotAbility = fakeAuras[slotAbilityName].abilityID
  		currentTime = GetGameTimeMillis() / 1000

		abilityOffset = (slotAbility ~= nil) and slotAbility or 0

		AuraHandler(
			false,
			slotAbilityName,
			fakeAuras[slotAbilityName].unitTag,
			currentTime,
			currentTime + fakeAuras[slotAbilityName].duration + (GetLatency() / 1000), -- + cooldown? GetSlotCooldownInfo(slotID)
			slotData[slotID].abilityIcon,
			BUFF_EFFECT_TYPE_BUFF,
			ABILITY_TYPE_NONE,
			abilityOffset,
			3
		)
	end

	function Srendarr:ConfigureOnActionSlotAbilityUsed()
		EVENT_MANAGER:RegisterForEvent(self.name, EVENT_ACTION_SLOT_ABILITY_USED,	Srendarr.OnActionSlotAbilityUsed)
	end
end


-- ------------------------
-- EVENT: EVENT_RETICLE_TARGET_CHANGED
do ------------------------
    local GetNumBuffs      				= GetNumBuffs
    local GetUnitBuffInfo  				= GetUnitBuffInfo
    local DoesUnitExist    				= DoesUnitExist
    local IsUnitDead					= IsUnitDead

	local alternateAura					= Srendarr.alternateAura
	local specialNames					= Srendarr.specialNames
	local fakeTargetDebuffs				= Srendarr.fakeTargetDebuffs
	local abilityCooldowns				= Srendarr.abilityCooldowns
	local debuffAuras					= Srendarr.debuffAuras
	local alteredAuraData				= Srendarr.alteredAuraData
	local fakeAuras						= Srendarr.fakeAuras
	local auraLookupReticle				= Srendarr.auraLookup['reticleover'] -- local ref for speed, this functions expensive
	local targetDisplayFrame1			= false -- local refs to frames displaying target auras (if any)
	local targetDisplayFrame2			= false -- local refs to frames displaying target auras (if any)
	local targetDisplayFrame3			= false -- local refs to frames displaying target auras (if any)
	local targetDisplayFrame4			= false -- local refs to frames displaying target auras (if any)
	local hideOnDead					= false

	local function OnTargetChanged()
		local currentTime
		local numAuras
		local debuffSwitch
		local auraName, start, finish, icon, effectType, abilityType, abilityId, castByPlayer
		local onlyPlayerDebuffs			= Srendarr.db.filtersTarget.onlyPlayerDebuffs
		local onlyPromPlayerDebuffs		= Srendarr.db.filtersGroup.onlyPromPlayerDebuffs
		local onlyPromPlayerDebuffs2	= Srendarr.db.filtersGroup.onlyPromPlayerDebuffs2
		local targetBuff				= Srendarr.db.auraGroups[Srendarr.GROUP_TARGET_BUFF]
		local targetDebuff				= Srendarr.db.auraGroups[Srendarr.GROUP_TARGET_DEBUFF]
		local promDebuff1				= Srendarr.db.auraGroups[Srendarr.GROUP_PROMDEBUFFS]
		local promDebuff2				= Srendarr.db.auraGroups[Srendarr.GROUP_PROMDEBUFFS2]
		targetDisplayFrame1 			= (targetBuff ~= 0) and Srendarr.displayFrames[targetBuff] or false
		targetDisplayFrame2 			= (targetDebuff ~= 0) and Srendarr.displayFrames[targetDebuff] or false
		targetDisplayFrame3 			= (promDebuff1 ~= 0) and Srendarr.displayFrames[promDebuff1] or false
		targetDisplayFrame4 			= (promDebuff2 ~= 0) and Srendarr.displayFrames[promDebuff2] or false

		for _, aura in pairs(auraLookupReticle) do
			aura:Release(true) -- old auras cleaned out
		end

		if (DoesUnitExist('reticleover') and not (hideOnDead and IsUnitDead('reticleover'))) then -- have a target, scan for auras
			local unitName = zo_strformat("<<t:1>>",GetUnitName('reticleover'))

			local function ActiveFakes() -- check for active fake debuffs (Phinix)
				local total = 0
				for k,v in pairs(fakeTargetDebuffs) do
					currentTime = GetGameTimeMillis() / 1000
					if trackTargets[k] ~= nil and trackTargets[k][unitName] ~= nil then
						if trackTargets[k][unitName] < currentTime then
							trackTargets[k][unitName] = nil -- clear expired targets from cache
						else
							total = total + 1
						end
					end
				end
				return total
			end

			numAuras = GetNumBuffs('reticleover') + ActiveFakes()

			if (numAuras > 0) then -- target has auras, scan and send to handler
				for k,v in pairs(fakeTargetDebuffs) do -- reassign still-existing fake debuffs on target (Phinix)
					currentTime = GetGameTimeMillis() / 1000
					if trackTargets[k] ~= nil and trackTargets[k][unitName] ~= nil then
						if trackTargets[k][unitName] > currentTime then
							AuraHandler(
								false,
								(specialNames[k] ~= nil) and specialNames[k].name or ZOSName(k),
								'reticleover',
								currentTime,
								trackTargets[k][unitName],
								fakeTargetDebuffs[k].icon,
								BUFF_EFFECT_TYPE_DEBUFF,
								ABILITY_TYPE_NONE,
								k,
								0
							)
						end
					end
				end

				for i = 1, numAuras do
					auraName, start, finish, _, stacks, icon, _, effectType, abilityType, _, abilityId, _, castByPlayer = GetUnitBuffInfo('reticleover', i)

					debuffSwitch = (debuffAuras[abilityId]) and BUFF_EFFECT_TYPE_DEBUFF or effectType -- fix for debuffs game tracks as buffs (Phinix)

					local function ProcessAura()
						local sourceCast = (castByPlayer) and 1 or 2
						local unitTag = 'reticleover'

						if (fakeAuras[ZOSName(abilityId)] ~= nil and alteredAuraData[abilityId] == nil) then
							unitTag = fakeAuras[ZOSName(abilityId)].unitTag
						end

						if abilityCooldowns[abilityId] ~= nil then -- keep cooldown tracking custom icon if applicable (Phinix)
							icon = (abilityCooldowns[abilityId].altIcon ~= nil) and abilityCooldowns[abilityId].altIcon or icon
						end

						if filteredAuras[unitTag][abilityId] == nil then
							if (Srendarr.db.consolidateEnabled == true and IsAlternateAura(abilityId) == true) then -- handles multi-aura passive abilities like restoring aura (Phinix)
								AuraHandler(true, alternateAura[abilityId].altName, unitTag, start, finish, icon, debuffSwitch, abilityType, abilityId, sourceCast, stacks)
							else
								AuraHandler(true, (specialNames[abilityId] ~= nil) and specialNames[abilityId].name or auraName, unitTag, start, finish, icon, debuffSwitch, abilityType, abilityId, sourceCast, stacks)
							end
						end
					end

					-- options to only show player's debuffs on target (Phinix)
					if alteredAuraData[abilityId] == nil or alteredAuraData[abilityId].unitTag == 'reticleover' then -- ignore swapped unitTag unless set to 'reticleover' to avoid duplicates (Phinix)
						if castByPlayer or (debuffSwitch ~= BUFF_EFFECT_TYPE_DEBUFF) then -- always process target buffs or debuffs cast by player
							ProcessAura()
						elseif (prominentDebuffs[abilityId] and (Srendarr.db.auraGroups[GROUP_PROMDEBUFFS] ~= 0 and not onlyPromPlayerDebuffs)) then -- process non-player prominent 1 debuffs if used and not set to only show player's debuffs
							ProcessAura()
						elseif (prominentDebuffs2[abilityId] and (Srendarr.db.auraGroups[GROUP_PROMDEBUFFS2] ~= 0 and not onlyPromPlayerDebuffs2)) then -- process non-player prominent 2 debuffs if used and not set to only show player's debuffs
							ProcessAura()
						elseif (Srendarr.db.auraGroups[GROUP_TARGET_DEBUFF] ~= 0 and not onlyPlayerDebuffs) then -- process non-player debuffs if not assigned to prominent 1 or 2 and not set to only show player's debuffs
							ProcessAura()
						end
					end
				end
			end
		end

		-- no matter what, update the display of the 1-4 frames displaying targets auras
		if (targetDisplayFrame1) then targetDisplayFrame1:UpdateDisplay() end
		if (targetDisplayFrame2) then targetDisplayFrame2:UpdateDisplay() end
		if (targetDisplayFrame3) then targetDisplayFrame3:UpdateDisplay() end
		if (targetDisplayFrame4) then targetDisplayFrame4:UpdateDisplay() end
	end

	function Srendarr:ConfigureOnTargetChanged()
		-- figure out which frames currently display target auras
		local targetBuff	= self.db.auraGroups[Srendarr.GROUP_TARGET_BUFF]
		local targetDebuff	= self.db.auraGroups[Srendarr.GROUP_TARGET_DEBUFF]
		local promDebuff1	= self.db.auraGroups[Srendarr.GROUP_PROMDEBUFFS]
		local promDebuff2	= self.db.auraGroups[Srendarr.GROUP_PROMDEBUFFS2]
		targetDisplayFrame1 = (targetBuff ~= 0) and self.displayFrames[targetBuff] or false
		targetDisplayFrame2 = (targetDebuff ~= 0) and self.displayFrames[targetDebuff] or false
		targetDisplayFrame3 = (promDebuff1 ~= 0) and self.displayFrames[promDebuff1] or false
		targetDisplayFrame4 = (promDebuff2 ~= 0) and self.displayFrames[promDebuff2] or false

		hideOnDead			= self.db.hideOnDeadTargets -- set whether to show auras on dead targets

		if (targetDisplayFrame1 or targetDisplayFrame2 or targetDisplayFrame3 or targetDisplayFrame4) then -- event configured and needed, start tracking
			EVENT_MANAGER:RegisterForEvent(self.name, EVENT_RETICLE_TARGET_CHANGED,	OnTargetChanged)
		else -- not needed (not displaying any target auras)
			EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_RETICLE_TARGET_CHANGED)
		end
	end

	Srendarr.OnTargetChanged = OnTargetChanged
end


-- ------------------------
-- EVENT: EVENT_EFFECT_CHANGED
do ------------------------
	local EFFECT_RESULT_FADED			= EFFECT_RESULT_FADED
	local GetAbilityDescription			= GetAbilityDescription
	local crystalFragmentsPassive		= Srendarr.crystalFragmentsPassive -- special case for tracking fragments proc
	local fakeAuras						= Srendarr.fakeAuras
	local alternateAura					= Srendarr.alternateAura
	local debuffAuras					= Srendarr.debuffAuras
	local alteredAuraData				= Srendarr.alteredAuraData
	local specialNames					= Srendarr.specialNames
	local catchTriggers					= Srendarr.catchTriggers
	local abilityCooldowns				= Srendarr.abilityCooldowns
	local sampleAuraData				= Srendarr.sampleAuraData
	local auraLookup					= Srendarr.auraLookup
	local IsGroupUnit					= Srendarr.IsGroupUnit
	local refreshAuras					= Srendarr.refreshAuras

	Srendarr.OnEffectChanged = function(e, change, slot, auraName, unitTag, start, finish, stack, icon, buffType, effectType, abilityType, statusType, unitName, unitId, abilityId, sourceType)
		local debuffSwitch
		local altDuration
		local fadedAura
		local sourceCast
		local nStacks
		local unitTagt
		local altAura, startA, finishA, effectTypeA, abilityTypeA

		if not abilityId then return end -- safety check
		if abilityCooldowns[abilityId] and abilityCooldowns[abilityId].cdE == 1 then return end -- avoid duplicating cooldown abilities tracked through combat events (Phinix)

		-- check if the aura is on either the player or a group member, or a target or ground aoe -- the description check filters a lot of extra auras attached to many ground effects
		if (unitTag == 'player' or unitTag == 'reticleover' or IsGroupUnit(unitTag)) then
			unitTagt = unitTag
		elseif (abilityType == ABILITY_TYPE_AREAEFFECT and (GetAbilityDescription(abilityId) ~= '' or sampleAuraData[abilityId] ~= nil or abilityId == Srendarr.castBarID)) then
			unitTagt = 'groundaoe'
		else
			unitTagt = nil
		end

		if alteredAuraData[abilityId] and alteredAuraData[abilityId].unitTag ~= nil then -- swap unitTag to match aura behavior (Phinix)
			unitTagt = alteredAuraData[abilityId].unitTag
		end
		if not unitTagt then return end -- don't care about this unit and isn't a ground aoe, abort

		-- possible sourceType values:
		--	COMBAT_UNIT_TYPE_NONE			= 0
		--	COMBAT_UNIT_TYPE_PLAYER			= 1
		--	COMBAT_UNIT_TYPE_PLAYER_PET		= 2
		--	COMBAT_UNIT_TYPE_GROUP			= 3
		--	COMBAT_UNIT_TYPE_TARGET_DUMMY	= 4
		--	COMBAT_UNIT_TYPE_OTHER			= 5

		if specialNames[abilityId] ~= nil then auraName = specialNames[abilityId].name end -- handle renaming auras as required (Phinix)
		debuffSwitch = (debuffAuras[abilityId]) and BUFF_EFFECT_TYPE_DEBUFF or effectType -- fix for debuffs game tracks as buffs (Phinix)

		sourceCast = (sourceType == 1 or sourceType == 2) and 1 or 2 -- separate into player cast, not player cast, and group cast for easy offset grouping (Phinix)
		if IsGroupUnit(unitTagt) then sourceCast = (sourceCast == 1) and 31 or 32 end -- differentiate group auras for later filtering (Phinix)
		if (unitTagt == 'groundaoe' and sourceCast ~= 1) then return end -- only track AOE created by the player

		if unitTagt == 'reticleover' then -- option to only show player's debuffs on target (Phinix)
			if (debuffSwitch == BUFF_EFFECT_TYPE_DEBUFF and sourceCast ~= 1) then
				if (prominentDebuffs[abilityId]) then
					if (Srendarr.db.auraGroups[GROUP_PROMDEBUFFS] == 0 or Srendarr.db.filtersGroup.onlyPromPlayerDebuffs) then
						return
					end
				elseif (prominentDebuffs2[abilityId]) then
					if (Srendarr.db.auraGroups[GROUP_PROMDEBUFFS2] == 0 or Srendarr.db.filtersGroup.onlyPromPlayerDebuffs2) then
						return
					end
				elseif Srendarr.db.filtersTarget.onlyPlayerDebuffs then
					return
				end
			end
		end

		if change == EFFECT_RESULT_FADED then -- aura has faded
			fadedAura = auraLookup[unitTagt][abilityId]
			if fadedAura ~= nil and alteredAuraData[abilityId] == nil then -- aura exists, tell it to expire if timed, or aaa otherwise

				if (fadedAura.auraType == AURA_TYPE_TIMED) or (fadedAura.auraType == DEBUFF_TYPE_TIMED) then
					if fadedAura.abilityType == ABILITY_TYPE_AREAEFFECT then return end -- gtaoes expire internally (repeated casting, only one timer)
					fadedAura:SetExpired()
				else
					fadedAura:Release()
				end
			end

			if (abilityId == crystalFragmentsPassive and sourceType == 1) then -- special case for tracking fragments proc
				Srendarr:OnCrystalFragmentsProc(false)
			end
		else -- aura has been gained or changed, dispatch to handler

			if (sourceType == 1 and fakeAuras[ZOSName(abilityId)] ~= nil and alteredAuraData[abilityId] == nil) then return end -- ignore game default tracking of player bar abilities we've modified (Phinix)

			altDuration = (alteredAuraData[abilityId] ~= nil and alteredAuraData[abilityId].duration ~= nil) and start + alteredAuraData[abilityId].duration or finish -- fix rare cases game reports wrong duration for an aura (Phinix)
			nStacks = (stack ~= nil) and stack or 0 -- used to add stacks to name of auras that have them (Phinix)

			if unitTagt == 'player' and catchTriggers[abilityId] ~= nil then -- fix game sending wrong stack building event for some morphs (Phinix)
				if auraLookup[unitTagt][catchTriggers[abilityId]] then
					altAura = catchTriggers[abilityId]
					startA = auraLookup[unitTagt][altAura].start
					finishA = auraLookup[unitTagt][altAura].finish
					effectTypeA = auraLookup[unitTagt][altAura].effectType
					abilityTypeA = auraLookup[unitTagt][altAura].abilityType
					AuraHandler(false, auraName, unitTagt, startA, finishA, icon, effectTypeA, abilityTypeA, altAura, sourceCast, nStacks)
					return
				end
			end

			if change == EFFECT_RESULT_GAINED then -- handle cooldowns that proc on the player with a game-tracked event here instead of EVENT_COMBAT_EVENT to avoid desyncs (Phinix)
			--	d(abilityId) -- for debugging triggers for cooldown procs
				if abilityCooldowns[abilityId] then
					local equippedSets = Srendarr.equippedSets
					if equippedSets[abilityCooldowns[abilityId].s1] or equippedSets[abilityCooldowns[abilityId].s2] then -- only look at cooldown status for sets you actually have equipped (Phinix)
						local cdID = abilityId+4000000
						if (auraLookup['player'][cdID]) then -- release cooldown if present to avoid desync (Phinix)
							auraLookup['player'][cdID]:Release()
						end
						local aName = (abilityCooldowns[abilityId].altName ~= nil) and abilityCooldowns[abilityId].altName or auraName
						local dbTime = (abilityCooldowns[abilityId].altDuration ~= nil) and abilityCooldowns[abilityId].altDuration or GetAbilityDuration(abilityId) / 1000
						local dbTag = (abilityCooldowns[abilityId].unitTag ~= nil) and abilityCooldowns[abilityId].unitTag or unitTagt
						local dbIcon = (abilityCooldowns[abilityId].altIcon ~= nil) and abilityCooldowns[abilityId].altIcon or GetAbilityIcon(abilityId)
						local currentTime = GetGameTimeMillis() / 1000
						if dbTime == 0 then -- use duration 0 to indicate this is a toggle/passive not timer
							stopTime = currentTime
						else
							stopTime = currentTime + dbTime + (GetLatency() / 1000)
						end
						AuraHandler(
							false,
							zo_strformat("<<t:1>>",aName),
							dbTag,
							currentTime,
							stopTime,
							dbIcon,
							BUFF_EFFECT_TYPE_BUFF,
							ABILITY_TYPE_NONE,
							abilityId,
							1,
							nStacks,
							true
						)
						return
					end
				end
			end

			if refreshAuras[abilityId] then -- special cases where a variable duration aura needs to have its values populated manually using GetUnitBuffInfo (Phinix)
				local tName, tStart, tFinish, tStacks, tIcon, tEffectType, tAbilityType, tAbilityId, tCastByPlayer
				local numAuras = GetNumBuffs('player')
				if numAuras > 0 then -- player has auras, scan and send to handle
					for i = 1, numAuras do
						tName, tStart, tFinish, _, tStacks, tIcon, _, tEffectType, tAbilityType, _, tAbilityId, _, tCastByPlayer = GetUnitBuffInfo('player', i)
						if tAbilityId == abilityId then
							if auraLookup['player'][tAbilityId] then auraLookup['player'][tAbilityId]:Release() end
							local tSourceCast = (tCastByPlayer) and 1 or 2
							if Srendarr.db.consolidateEnabled == true then -- Handles multi-aura passive abilities like Restoring Aura
								if (IsAlternateAura(tAbilityId)) then -- Consolidate multi-aura passive abilities
									AuraHandler(false, alternateAura[tAbilityId].altName, 'player', tStart, tFinish, tIcon, tEffectType, tAbilityType, tAbilityId, tSourceCast, tStacks)
								else
									AuraHandler(false, tName, 'player', tStart, tFinish, tIcon, tEffectType, tAbilityType, tAbilityId, tSourceCast, tStacks)
								end
							else
								AuraHandler(false, tName, 'player', tStart, tFinish, tIcon, tEffectType, tAbilityType, tAbilityId, tSourceCast, tStacks)
							end
							return
						end
					end
				end
			end

			if (Srendarr.db.consolidateEnabled and IsAlternateAura(abilityId)) then -- handles multi-aura passive abilities like Restoring Aura (Phinix)
				AuraHandler(false, alternateAura[abilityId].altName, unitTagt, start, altDuration, icon, debuffSwitch, abilityType, abilityId, sourceCast, nStacks)
			else
				AuraHandler(false, auraName, unitTagt, start, altDuration, icon, debuffSwitch, abilityType, abilityId, sourceCast, nStacks)
			end

			if (abilityId == crystalFragmentsPassive and sourceType == 1 and not Srendarr.crystalFragmentsProc) then -- special case for tracking fragments proc
				Srendarr:OnCrystalFragmentsProc(true)
			end
		end
	end
end


-- ------------------------
-- EVENT: EVENT_COMBAT_EVENT
do ------------------------
	local TYPE_ENCHANT				= Srendarr.TYPE_ENCHANT
	local TYPE_SPECIAL				= Srendarr.TYPE_SPECIAL
	local TYPE_COOLDOWN				= Srendarr.TYPE_COOLDOWN
	local TYPE_RELEASE				= Srendarr.TYPE_RELEASE
	local TYPE_TARGET_DEBUFF		= Srendarr.TYPE_TARGET_DEBUFF
	local TYPE_TARGET_AURA			= Srendarr.TYPE_TARGET_AURA
	local GetGameTimeMillis			= GetGameTimeMilliseconds
	local GetLatency				= GetLatency
	local enchantProcs				= Srendarr.enchantProcs
	local specialProcs				= Srendarr.specialProcs
	local specialNames				= Srendarr.specialNames
	local releaseTriggers			= Srendarr.releaseTriggers
	local fakeTargetDebuffs			= Srendarr.fakeTargetDebuffs
	local stackingAuras				= Srendarr.stackingAuras
	local abilityCooldowns			= Srendarr.abilityCooldowns
	local auraLookup				= Srendarr.auraLookup

	local function EventToChat(e, result, isError, aName, aGraphic, aActionSlotType, sName, sType, tName, tType, hitValue, pType, dType, elog, sUnitId, tUnitId, abilityId)
		if (aName ~= "" and aName ~= nil) or Srendarr.db.showNoNames then
			if Srendarr.db.onlyPlayerDebug and sName ~= playerName then return end
			if sName == playerName then sName = "Player" end
			if tName == playerName then tName = "Player" end
			if not Srendarr.db.disableSpamControl and debugAuras[abilityId] ~= "ignore" then debugAuras[abilityId] = "flood" end
			if not Srendarr.db.showVerboseDebug then
				d(tostring(abilityId)..": "..aName.." --> [S] "..sName.."  [T] "..tName.." - "..tostring(result))
			else
				d(aName.." ("..tostring(abilityId)..")")
				d("event: "..e.." || result: "..result.." || isError: "..tostring(isError).." || aName: "..aName.." || aGraphic: "..tostring(aGraphic).." || aActionSlotType: "..tostring(aActionSlotType).." || sName: "..sName.." || sType: "..tostring(sType).." || tName: "..tName.." || tType: "..tostring(tType).." || hitValue: "..tostring(hitValue).." || pType: "..tostring(pType).." || dType: "..tostring(dType).." || log: "..tostring(elog).." || sUnitId: "..tostring(sUnitId).." || tUnitId: "..tostring(tUnitId).." || abilityId: "..tostring(abilityId))
				d("Icon: "..GetAbilityIcon(abilityId))
				d("=========================================================")
			end
		end
	end

	local function ProcessEvent(aName, sName, sType, tName, abilityId, eType, isCooldown) -- (Phinix)
		local targetName
		local sourceCast
		local currentTime
		local stopTime
		local dbTime
		local dbTag
		local dbIcon
		local expired

		if eType == TYPE_ENCHANT then -- enchantProcs[abilityId] ~= nil
			dbTime = enchantProcs[abilityId].duration
			dbTag = enchantProcs[abilityId].unitTag
			dbIcon = enchantProcs[abilityId].icon
		elseif eType == TYPE_SPECIAL then -- specialProcs[abilityId] ~= nil
			dbTime = (specialProcs[abilityId].altDuration ~= nil) and specialProcs[abilityId].altDuration or GetAbilityDuration(abilityId) / 1000
			dbTag = specialProcs[abilityId].unitTag
			dbIcon = (specialProcs[abilityId].altIcon ~= nil) and specialProcs[abilityId].altIcon or GetAbilityIcon(abilityId)
			aName = (specialProcs[abilityId].altName ~= nil) and specialProcs[abilityId].altName or aName
			if dbTag == 'reticleover' then eType = TYPE_TARGET_AURA end
		elseif eType == TYPE_COOLDOWN then -- abilityCooldowns[abilityId] ~= nil
			dbTime = (abilityCooldowns[abilityId].altDuration ~= nil) and abilityCooldowns[abilityId].altDuration or GetAbilityDuration(abilityId) / 1000
			dbTag = abilityCooldowns[abilityId].unitTag
			dbIcon = (abilityCooldowns[abilityId].altIcon ~= nil) and abilityCooldowns[abilityId].altIcon or GetAbilityIcon(abilityId)
			aName = (abilityCooldowns[abilityId].altName ~= nil) and abilityCooldowns[abilityId].altName or aName
		elseif eType == TYPE_TARGET_DEBUFF then
			dbIcon = fakeTargetDebuffs[abilityId].icon
			dbTime = fakeTargetDebuffs[abilityId].duration
		end

		if eType == TYPE_RELEASE then -- release event for tracked proc so remove aura (releaseTriggers[abilityId] ~= nil)
			local releaseOffset = releaseTriggers[abilityId].release

			-- Catch stack building aura reset events (Phinix)
			if stackingAuras[releaseOffset] and auraLookup['player'][releaseOffset] then
				auraLookup['player'][releaseOffset]:Update(start, finish, stackingAuras[releaseOffset].start, true)
				return
			end

			local aTypes = {'player', 'groundaoe', 'reticleover'} -- Handle release events for multiple unit tag types (at least one set -Essence Thief
			for _, aType in pairs(aTypes) do -- has a mechanic that requires 'groundaoe' to allow cancelling the spawned effect timer early when collecting the pool.) (Phinix)
				if auraLookup[aType][releaseOffset] then expired = auraLookup[aType][releaseOffset] if expired ~= nil then expired:Release() end end
			end

		elseif eType == TYPE_SPECIAL and sName == "" and specialProcs[abilityId].bar then -- tracked ability removed from bar so remove aura (specialProcs[abilityId] ~= nil)
			expired = auraLookup['player'][abilityId]
			if expired ~= nil then expired:Release() end

	-- adding a custom "invisible proc" aura (meaning an aura that doesn't show on the character sheet)

		elseif eType == TYPE_TARGET_AURA or eType == TYPE_TARGET_DEBUFF then -- new invisible debuff
			if sName ~= "" then
				if tName == "" then return end
				currentTime = GetGameTimeMillis() / 1000
				stopTime = currentTime + dbTime + (GetLatency() / 1000)

				if tName == playerName then
					sourceCast = 2
					targetName = 'player'
				else
					if sType ~= 1 and sName ~= playerName then return end -- only show player's fake debuffs on the target 
					-- same additional check needed for player-only auras, for the reasons described below. (Phinix)
					sourceCast = 1
					targetName = 'reticleover'
					trackTargets[abilityId] = trackTargets[abilityId] or {}
					trackTargets[abilityId] [tName] = stopTime -- simply unit name tracking, more is not possible
				end

				AuraHandler(
					false,
					zo_strformat("<<t:1>>",aName),
					targetName,
					currentTime,
					stopTime,
					dbIcon,
					BUFF_EFFECT_TYPE_DEBUFF,
					ABILITY_TYPE_NONE,
					abilityId,
					sourceCast,
					nil,
					isCooldown
				)
			end
		else -- New invisible proc on the player
			if sType ~= 1 and tName ~= playerName then return end -- only show player's fake buffs
		-- game seems to report wrong values for sets like Whitestrake so additional ~= playerName check needed to prevent seeing other's effects (Phinix)
		-- playerName is populated and formatted once when Srendarr is loaded and re-used thereafter so there should be negligible performance impact.

			currentTime = GetGameTimeMillis() / 1000
			if dbTime == 0 then -- use duration 0 to indicate this is a toggle/passive not timer
				stopTime = currentTime
			else
				stopTime = currentTime + dbTime + (GetLatency() / 1000)
			end

			if (isCooldown) then -- avoid duplicates and desyncs (Phinix)
				local cdID = abilityId+4000000
				if (auraLookup['player'][cdID]) then
					auraLookup['player'][cdID]:Release()
				end
			end

			AuraHandler(
				false,
				zo_strformat("<<t:1>>",aName),
				dbTag,
				currentTime,
				stopTime,
				dbIcon,
				BUFF_EFFECT_TYPE_BUFF,
				ABILITY_TYPE_NONE,
				abilityId,
				1,
				nil,
				isCooldown
			)
		end
	end

	Srendarr.CombatDebug = function(e, result, isError, aName, aGraphic, aActionSlotType, sName, sType, tName, tType, hitValue, pType, dType, elog, sUnitId, tUnitId, abilityId)
	-- Debug mode for tracking new auras. Type /sdbclear or reloadui to reset (Phinix)
		if Srendarr.db.disableSpamControl == true and Srendarr.db.manualDebug == false then
			EventToChat(e, result, isError, zo_strformat("<<t:1>>",aName), aGraphic, aActionSlotType, zo_strformat("<<t:1>>",sName), sType, tName, zo_strformat("<<t:1>>",tType), hitValue, pType, dType, elog, sUnitId, tUnitId, abilityId)
		else
			if debugAuras[abilityId] ~= "flood" then
				EventToChat(e, result, isError, zo_strformat("<<t:1>>",aName), aGraphic, aActionSlotType, zo_strformat("<<t:1>>",sName), sType, zo_strformat("<<t:1>>",tName), tType, hitValue, pType, dType, elog, sUnitId, tUnitId, abilityId)
			end
		end
	end

	Srendarr.OnCombatEvent = function(e, result, isError, aName, aGraphic, aActionSlotType, sName, sType, tName, tType, hitValue, pType, dType, elog, sUnitId, tUnitId, abilityId)
		local equippedSets = Srendarr.equippedSets
		local validResults = {
			[ACTION_RESULT_EFFECT_GAINED] = true,
			[ACTION_RESULT_EFFECT_GAINED_DURATION] = true,
			[ACTION_RESULT_POWER_ENERGIZE] = true,
			[ACTION_RESULT_HEAL] = true,
			[ACTION_RESULT_CRITICAL_HEAL] = true,
			[ACTION_RESULT_DAMAGE] = true,
			[ACTION_RESULT_CRITICAL_DAMAGE] = true,
		}

	-- Special database for name-swapping custom auras the game doesn't track or name correctly (Phinix)
		if specialNames[abilityId] ~= nil then aName = specialNames[abilityId].name end
		sName = zo_strformat("<<t:1>>",sName)
		tName = zo_strformat("<<t:1>>",tName)

	-- Cascading check for valid combat event conditions for speed (Phinix)
		if releaseTriggers[abilityId] ~= nil then
			ProcessEvent(aName, sName, sType, tName, abilityId, TYPE_RELEASE, false) -- Release Trigger
		end

		if enchantProcs[abilityId] ~= nil then
			ProcessEvent(aName, sName, sType, tName, abilityId, TYPE_ENCHANT, false) -- Enchant Proc
		elseif fakeTargetDebuffs[abilityId] ~= nil then
			ProcessEvent(aName, sName, sType, tName, abilityId, TYPE_TARGET_DEBUFF, false) -- Target Debuff
		elseif specialProcs[abilityId] ~= nil then

		--	d(tostring(abilityId).." - "..tostring(result)) -- uncomment for debug events which need to be added to validResults (Phinix)
		--  https://wiki.esoui.com/Constant_Values#ACTION_RESULT_ABILITY_ON_COOLDOWN

			if result == ACTION_RESULT_EFFECT_FADED then -- if aura has faded remove custom proc (Phinix)
				local unitTag = specialProcs[abilityId].unitTag
				if (auraLookup[unitTag][abilityId]) then -- release current proc if present to reset timer (Phinix)
					auraLookup[unitTag][abilityId]:Release()
				end
				return
			end
			if specialProcs[abilityId].iH ~= nil then
				if result ~= specialProcs[abilityId].iH then return end -- prevent resetting cooldown timer when game sends multiple event updates to same initial ID (Phinix)
			else
				if not validResults[result] then return end
			end

			ProcessEvent(aName, sName, sType, tName, abilityId, TYPE_SPECIAL, false) -- Special Proc
		elseif abilityCooldowns[abilityId] ~= nil then
			if abilityCooldowns[abilityId].cdE == 1 then -- only process cooldown events that require EVENT_COMBAT_EVENT to avoid desyncs (Phinix)
				if equippedSets[abilityCooldowns[abilityId].s1] or equippedSets[abilityCooldowns[abilityId].s2] then -- only look at cooldown status for sets you actually have equipped (Phinix)

				--	d(tostring(abilityId).." - "..tostring(result))  -- uncomment for debug events which need to be added to validResults (Phinix)
				--  https://wiki.esoui.com/Constant_Values#ACTION_RESULT_ABILITY_ON_COOLDOWN

					if result == ACTION_RESULT_EFFECT_FADED then -- if aura has faded remove custom proc (Phinix)
						local unitTag = abilityCooldowns[abilityId].unitTag
						if (auraLookup[unitTag][abilityId]) then -- release current proc if present to reset timer (Phinix)
							auraLookup[unitTag][abilityId]:Release()
						end
						return
					end
					if abilityCooldowns[abilityId].iH ~= nil then
						if result ~= abilityCooldowns[abilityId].iH then return end -- prevent resetting cooldown timer when game sends multiple event updates to same initial ID (Phinix)
					else
						if not validResults[result] then return end
					end

					local unitTag = (abilityCooldowns[abilityId].unitTag ~= nil) and abilityCooldowns[abilityId].unitTag or "player"
					if (auraLookup[unitTag][abilityId]) then -- release current proc if present to reset timer (Phinix)
						auraLookup[unitTag][abilityId]:Release()
					end
					ProcessEvent(aName, sName, sType, tName, abilityId, TYPE_COOLDOWN, true) -- Ability Cooldown
				else
					return
				end
			else
				return
			end
		else
			return
		end
	end

	function Srendarr:ConfigureCombatDebug() -- Only register for unfiltered event data if debug set to show combat events (Phinix)
		if Srendarr.db.showCombatEvents == true then
			EVENT_MANAGER:RegisterForEvent('Srendarr_CombatDebug', EVENT_COMBAT_EVENT, Srendarr.CombatDebug)
		else
			EVENT_MANAGER:UnregisterForEvent('Srendarr_CombatDebug', EVENT_COMBAT_EVENT)
		end
	end

	function Srendarr:ConfigureOnCombatEvent()
	-- Since this event fires VERY often and is only used for a preset database of abilityIDs, use filters to improve performance (Phinix)
		for abilityID, _ in pairs(releaseTriggers) do
			EVENT_MANAGER:RegisterForEvent('Srendarr_Release_' ..tostring(abilityID), EVENT_COMBAT_EVENT, Srendarr.OnCombatEvent)
			EVENT_MANAGER:AddFilterForEvent('Srendarr_Release_' ..tostring(abilityID), EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, abilityID)
		end
		for abilityID, _ in pairs(enchantProcs) do
			EVENT_MANAGER:RegisterForEvent('Srendarr_Enchants_' ..tostring(abilityID), EVENT_COMBAT_EVENT, Srendarr.OnCombatEvent)
			EVENT_MANAGER:AddFilterForEvent('Srendarr_Enchants_' ..tostring(abilityID), EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, abilityID)
		end
		for abilityID, _ in pairs(specialNames) do
			EVENT_MANAGER:RegisterForEvent('Srendarr_SpecNames_' ..tostring(abilityID), EVENT_COMBAT_EVENT, Srendarr.OnCombatEvent)
			EVENT_MANAGER:AddFilterForEvent('Srendarr_SpecNames_' ..tostring(abilityID), EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, abilityID)
		end
		for abilityID, _ in pairs(stackingAuras) do
			EVENT_MANAGER:RegisterForEvent('Srendarr_Stacking_' ..tostring(abilityID), EVENT_COMBAT_EVENT, Srendarr.OnCombatEvent)
			EVENT_MANAGER:AddFilterForEvent('Srendarr_Stacking_' ..tostring(abilityID), EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, abilityID)
		end
		for abilityID, _ in pairs(fakeTargetDebuffs) do
			EVENT_MANAGER:RegisterForEvent('Srendarr_FakeDebuff_' ..tostring(abilityID), EVENT_COMBAT_EVENT, Srendarr.OnCombatEvent)
			EVENT_MANAGER:AddFilterForEvent('Srendarr_FakeDebuff_' ..tostring(abilityID), EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, abilityID)
		end
		for abilityID, _ in pairs(specialProcs) do
			EVENT_MANAGER:RegisterForEvent('Srendarr_FakeBuff_' ..tostring(abilityID), EVENT_COMBAT_EVENT, Srendarr.OnCombatEvent)
			EVENT_MANAGER:AddFilterForEvent('Srendarr_FakeBuff_' ..tostring(abilityID), EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, abilityID)
		end
		for abilityID, _ in pairs(abilityCooldowns) do
			if abilityCooldowns[abilityID].cdE == 1 then
				EVENT_MANAGER:RegisterForEvent('Srendarr_Cooldowns_' ..tostring(abilityID), EVENT_COMBAT_EVENT, Srendarr.OnCombatEvent)
				EVENT_MANAGER:AddFilterForEvent('Srendarr_Cooldowns_' ..tostring(abilityID), EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, abilityID)
			end
		end
	end
end


-- ------------------------
-- DEBUG FUNCTIONS
-- ------------------------
local function ClearDebug()
	debugAuras = {}
end

local function dbAdd(option)
	option = tostring(option):gsub("%D",'')
	if option ~= "" then
		debugAuras[tonumber(option)] = "flood"
		d('Hiding '..option)
	end
end

local function dbRemove(option)
	option = tostring(option):gsub("%D",'')
	if option ~= "" then
		if debugAuras[tonumber(option)] ~= nil then
			debugAuras[tonumber(option)] = nil
			d('Showing next '..option)
		end
	end
end

local function dbIgnore(option)
	option = tostring(option):gsub("%D",'')
	if option ~= "" then
		debugAuras[tonumber(option)] = "ignore"
		d('Always showing '..option)
	end
end


-- ------------------------
-- INITIALIZATION
-- ------------------------
function Srendarr:InitializeAuraControl()
	-- setup debug system (Phinix)
	SLASH_COMMANDS['/sdbclear']		= ClearDebug
	SLASH_COMMANDS['/sdbadd']		= function(option) dbAdd(option) end
	SLASH_COMMANDS['/sdbremove']	= function(option) dbRemove(option) end
	SLASH_COMMANDS['/sdbignore']	= function(option) dbIgnore(option) end
	
	EVENT_MANAGER:RegisterForEvent(self.name,	EVENT_PLAYER_ACTIVATED,					Srendarr.OnPlayerActivatedAlive) -- same action for both events
	EVENT_MANAGER:RegisterForEvent(self.name,	EVENT_PLAYER_ALIVE,						Srendarr.OnPlayerActivatedAlive) -- same action for both events
	EVENT_MANAGER:RegisterForEvent(self.name,	EVENT_PLAYER_DEAD,						Srendarr.OnPlayerDead)
	EVENT_MANAGER:RegisterForEvent(self.name,	EVENT_EFFECT_CHANGED,					Srendarr.OnEffectChanged)

	self:ConfigureOnCombatState()			-- EVENT_PLAYER_COMBAT_STATE
	self:ConfigureOnTargetChanged()			-- EVENT_RETICLE_TARGET_CHANGED
	self:ConfigureOnActionSlotAbilityUsed()	-- EVENT_ACTION_SLOT_ABILITY_USED
	self:ConfigureOnCombatEvent()			-- EVENT_COMBAT_EVENT
	self:ConfigureCombatDebug()				-- EVENT_COMBAT_EVENT

	self:ConfigureAuraHandler()

end
