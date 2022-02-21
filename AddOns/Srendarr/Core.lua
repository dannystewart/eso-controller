--[[----------------------------------------------------------
	Srendarr - Aura (Buff & Debuff) Tracker
	----------------------------------------------------------
	*
	* Phinix, Kith, Garkin, silentgecko
	*
	*
]]--
local Srendarr				= _G['Srendarr'] -- grab addon table from global
local L						= Srendarr:GetLocale()
local ZOSName				= function (abilityID) return zo_strformat("<<t:1>>", GetAbilityName(abilityID)) end

Srendarr.name				= 'Srendarr'
Srendarr.slash				= '/srendarr'
Srendarr.version			= '2.4.75'
Srendarr.versionDB			= 3

Srendarr.displayFrames		= {}
Srendarr.displayFramesScene	= {}
Srendarr.PassToAuraHandler	= {}
Srendarr.slotData			= {}
Srendarr.tempPostitions		= {}

Srendarr.auraGroupStrings = {		-- used in several places to display the aura grouping text
	[Srendarr.GROUP_PLAYER_SHORT]	= L.Group_Player_Short,
	[Srendarr.GROUP_PLAYER_LONG]	= L.Group_Player_Long,
	[Srendarr.GROUP_PLAYER_TOGGLED]	= L.Group_Player_Toggled,
	[Srendarr.GROUP_PLAYER_PASSIVE]	= L.Group_Player_Passive,
	[Srendarr.GROUP_PLAYER_DEBUFF]	= L.Group_Player_Debuff,
	[Srendarr.GROUP_PLAYER_GROUND]	= L.Group_Player_Ground,
	[Srendarr.GROUP_PLAYER_MAJOR]	= L.Group_Player_Major,
	[Srendarr.GROUP_PLAYER_MINOR]	= L.Group_Player_Minor,
	[Srendarr.GROUP_PLAYER_ENCHANT]	= L.Group_Player_Enchant,
	[Srendarr.GROUP_TARGET_BUFF]	= L.Group_Target_Buff,
	[Srendarr.GROUP_TARGET_DEBUFF]	= L.Group_Target_Debuff,
	[Srendarr.GROUP_PROMINENT]		= L.Group_Prominent,
	[Srendarr.GROUP_PROMINENT2]		= L.Group_Prominent2,
	[Srendarr.GROUP_PROMDEBUFFS]	= L.Group_Debuffs,
	[Srendarr.GROUP_PROMDEBUFFS2]	= L.Group_Debuffs2,
	[Srendarr.GROUP_CDTRACKER]		= L.Group_Cooldowns,
}

Srendarr.uiLocked			= true	-- flag for whether the UI is current drag enabled
Srendarr.uiHidden			= false	-- flag for whether auras should be hidden in UI state
Srendarr.groupUnits			= {}
Srendarr.auraPolling		= true
local gearSwapDelay			= true

------------------------------------------------------------------------------------------------------------------------------
-- ADDON INITIALIZATION
------------------------------------------------------------------------------------------------------------------------------
function Srendarr.OnInitialize(code, addon)
	if addon ~= Srendarr.name then return end

	EVENT_MANAGER:UnregisterForEvent(Srendarr.name, EVENT_ADD_ON_LOADED)
	SLASH_COMMANDS[Srendarr.slash] = Srendarr.SlashCommand

	Srendarr.db = ZO_SavedVars:NewAccountWide('SrendarrDB', Srendarr.versionDB, nil, Srendarr:GetDefaults())

	if (not Srendarr.db.useAccountWide) then -- not using global settings, generate (or load) character specific settings
		Srendarr.db = ZO_SavedVars:NewCharacterIdSettings('SrendarrDB', Srendarr.versionDB, nil, Srendarr:GetDefaults())
	end

	local displayBase

	-- create display frames
	for x = 1, Srendarr.NUM_DISPLAY_FRAMES do

		local groupFrame = (x < Srendarr.GROUP_DSTART_FRAME) and Srendarr:GetGroupBuffTab() or Srendarr:GetGroupDebuffTab()
		displayBase = (x > 10) and Srendarr.db.displayFrames[groupFrame].base or Srendarr.db.displayFrames[x].base

		Srendarr.displayFrames[x] = Srendarr.DisplayFrame:Create(x, displayBase.point, displayBase.x, displayBase.y, displayBase.alpha, displayBase.scale)

		Srendarr.displayFrames[x]:Configure()

		-- add each frame to the ZOS scene manager to control visibility
		Srendarr.displayFramesScene[x] = ZO_HUDFadeSceneFragment:New(Srendarr.displayFrames[x], 0, 0)

		HUD_SCENE:AddFragment(Srendarr.displayFramesScene[x])
		HUD_UI_SCENE:AddFragment(Srendarr.displayFramesScene[x])
		SIEGE_BAR_SCENE:AddFragment(Srendarr.displayFramesScene[x])

		Srendarr.displayFrames[x]:SetHandler('OnEffectivelyShown', function(f)
			f:SetAlpha(f.displayAlpha) -- ensure alpha is reset after a scene fade
		end)
	end

	Srendarr:PopulateFilteredAuras()		-- AuraData.lua
	Srendarr:ConfigureAuraFadeTime()		-- Aura.lua
	Srendarr:ConfigureDisplayAbilityID()	-- Aura.lua
	Srendarr:ConfigureTimeSettings()		-- Aura.lua
	Srendarr:InitializeAuraControl()		-- AuraControl.lua
	Srendarr:InitializeCastBar()			-- CastBar.lua
	Srendarr:InitializeProcs()				-- Procs.lua
	Srendarr:InitializeSettings()			-- Settings.lua
	Srendarr:PartialUpdate()
	Srendarr:HideInMenus()

	-- setup events to handle actionbar slotted abilities (used for procs and the castbar)
	for slot = 3, 8 do
		Srendarr.slotData[slot] = {}
		Srendarr.OnActionSlotUpdated(nil, slot) -- populate initial data (before events registered so no triggers before setup is done)
	end

	EVENT_MANAGER:RegisterForEvent(Srendarr.name, EVENT_ACTION_SLOTS_FULL_UPDATE,		Srendarr.OnActionSlotsFullUpdate)
	EVENT_MANAGER:RegisterForEvent(Srendarr.name, EVENT_ACTION_SLOT_UPDATED,			Srendarr.OnActionSlotUpdated)
	EVENT_MANAGER:RegisterForEvent(Srendarr.name, EVENT_ACTION_SLOT_STATE_UPDATED, 		Srendarr.OnActionSlotUpdated) -- needed for tracking dragging abilities on bar to change order (Phinix)
	EVENT_MANAGER:RegisterForEvent(Srendarr.name, EVENT_GROUP_TYPE_CHANGED, 			Srendarr.OnGroupChanged)
	EVENT_MANAGER:RegisterForEvent(Srendarr.name, EVENT_GROUP_MEMBER_JOINED, 			Srendarr.OnGroupChanged)
	EVENT_MANAGER:RegisterForEvent(Srendarr.name, EVENT_GROUP_MEMBER_LEFT, 				Srendarr.OnGroupChanged)
	EVENT_MANAGER:RegisterForEvent(Srendarr.name, EVENT_GROUP_UPDATE, 					Srendarr.OnGroupChanged)

	EVENT_MANAGER:RegisterForEvent(Srendarr.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE,	Srendarr.OnEquipChange)
	EVENT_MANAGER:AddFilterForEvent(Srendarr.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE,	REGISTER_FILTER_BAG_ID, BAG_WORN)
	EVENT_MANAGER:AddFilterForEvent(Srendarr.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE,	REGISTER_FILTER_INVENTORY_UPDATE_REASON, INVENTORY_UPDATE_REASON_DEFAULT)

	ZO_CreateStringId("SI_BINDING_NAME_TOGGLE_VISIBILITY", L.ToggleVisibility)
end

function Srendarr.KeybindVisibilityToggle()
	if (Srendarr.KeybindVisibility) then
		for x = 1, Srendarr.NUM_DISPLAY_FRAMES do
			Srendarr.displayFrames[x]:SetHidden(true)
		end
		Srendarr.KeybindVisibility = false
	else
		for x = 1, Srendarr.NUM_DISPLAY_FRAMES do
			Srendarr.displayFrames[x]:SetHidden(false)
		end
		Srendarr.KeybindVisibility = true
	end
end

function Srendarr.PlayerLoaded(_, initial)
	Srendarr.OnEquipChange()
end

function Srendarr.SlashCommand(text)
	local groupStart = Srendarr.GROUP_START_FRAME - 1
	if text == 'lock' then
		for x = 1, groupStart do
			Srendarr.displayFrames[x]:DisableDragOverlay()
		end
		Srendarr.Cast:DisableDragOverlay()
		Srendarr.uiLocked = true
		local auraLookup = Srendarr.auraLookup
		for unit, data in pairs(auraLookup) do
			for aura, ability in pairs(auraLookup[unit]) do
				ability:SetExpired()
				ability:Release()
			end
		end
	elseif text == 'unlock' then
		for x = 1, groupStart do
			Srendarr.displayFrames[x]:EnableDragOverlay()
		end
		Srendarr.Cast:EnableDragOverlay()
		Srendarr.uiLocked = false
		local auraLookup = Srendarr.auraLookup
		for unit, data in pairs(auraLookup) do
			for aura, ability in pairs(auraLookup[unit]) do
				ability:SetExpired()
				ability:Release()
			end
		end
	else
		CHAT_SYSTEM:AddMessage(L.Usage)
	end
end


------------------------------------------------------------------------------------------------------------------------------
-- GROUP DATA HANDLING
------------------------------------------------------------------------------------------------------------------------------
do
-- re-dock group frame windows when group size changes. (Phinix)
	function Srendarr.RepopulateGroupAuras(numAuras, unitTag, frame1, frame2)
		local GetGameTimeMillis	= GetGameTimeMilliseconds
		local PassToAuraHandler = Srendarr.PassToAuraHandler
		local auraName, finish, icon, effectType, abilityType, abilityID
		if numAuras > 0 then -- unit has auras, repopulate
			local ts = GetGameTimeMillis() / 1000
			for i = 1, numAuras do
				auraName, _, finish, _, _, icon, _, effectType, abilityType, _, abilityID = GetUnitBuffInfo(unitTag, i)
				PassToAuraHandler(true, auraName, unitTag, ts, finish, icon, effectType, abilityType, abilityID, 3)
			end
		end
		-- re-shuffle repopulated abilities to avoid gaps
		Srendarr.displayFrames[frame1]:Configure()
		Srendarr.displayFrames[frame2]:Configure()
		Srendarr.displayFrames[frame1]:UpdateDisplay()
		Srendarr.displayFrames[frame2]:UpdateDisplay()
	end

	function Srendarr.AnchorGroupFrames(groupSize, s, numAuras, unitTag, frame1, frame2)
		local gBX = Srendarr.db.displayFrames[11].base.x
		local gBY = Srendarr.db.displayFrames[11].base.y
		local rBX = Srendarr.db.displayFrames[12].base.x
		local rBY = Srendarr.db.displayFrames[12].base.y
		local gDX = Srendarr.db.displayFrames[13].base.x
		local gDY = Srendarr.db.displayFrames[13].base.y
		local rDX = Srendarr.db.displayFrames[14].base.x
		local rDY = Srendarr.db.displayFrames[14].base.y
		local fs = Srendarr.displayFrames[frame1]
		local fd = Srendarr.displayFrames[frame2]
		local groupAuraMode = Srendarr.db.groupAuraMode
		local raidAuraMode = Srendarr.db.raidAuraMode

		-- prepare to re-anchor display frames (addon support goes here)
		fs:ClearAnchors() 
		fd:ClearAnchors()

		local function defaultGroup() ---------------------------------------------------------------------- Default group frame configuration
			local groupSlot = tostring(unitTag:gsub("%a",''))
			local control = GetControl('ZO_GroupUnitFramegroup'..groupSlot..'Name')
			fs:SetAnchor(BOTTOMLEFT, control, TOPLEFT, gBX, gBY)
			fd:SetAnchor(TOPLEFT, control, TOPRIGHT, gDX, gDY)
			Srendarr.RepopulateGroupAuras(numAuras, unitTag, frame1, frame2)
			return
		end
		local function defaultRaid() ----------------------------------------------------------------------- Default raid frame configuration
			local groupSlot = tostring(unitTag:gsub("%a",''))
			local control = GetControl('ZO_RaidUnitFramegroup'..groupSlot)
			fs:SetAnchor(TOPLEFT, control, TOPRIGHT, rBX, rBY + 1)
			fd:SetAnchor(BOTTOMLEFT, control, BOTTOMRIGHT, rDX, rDY - 3)
			Srendarr.RepopulateGroupAuras(numAuras, unitTag, frame1, frame2)
			return
		end

		if groupSize <= 4 then
			if groupAuraMode == 1 then
				defaultGroup()
			elseif groupAuraMode == 2 then ----------------------------------------------------------------- Group frame support for Foundry Tactical Combat
				if FTC_VARS then
					local EnableFrames = FTC_VARS.Default[GetDisplayName()]["$AccountWide"].EnableFrames
					local GroupFrames = FTC_VARS.Default[GetDisplayName()]["$AccountWide"].GroupFrames
					if (EnableFrames == true and GroupFrames == true) then
						local control = GetControl('FTC_GroupFrame'..s..'_Health')
						fs:SetAnchor(TOPLEFT, control, BOTTOMLEFT, gBX + 2, gBY + 3)
						fd:SetAnchor(TOPLEFT, control, TOPRIGHT, gDX + 2, gDY + 3)
						Srendarr.RepopulateGroupAuras(numAuras, unitTag, frame1, frame2)
						return
					else
						defaultGroup()
					end
				else
					defaultGroup()
				end
			elseif groupAuraMode == 3 then ----------------------------------------------------------------- Group frame support for Lui Extended
				if LUIESV then
					local EnableFrames = LUIESV.Default[GetDisplayName()]["$AccountWide"].UnitFrames_Enabled
					local GroupFrames = LUIESV.Default[GetDisplayName()]["$AccountWide"].UnitFrames.CustomFramesGroup
					if (EnableFrames == true and GroupFrames == true) then
						local function getLUIframe()
							for i = 1, 4 do
								local frame = 'SmallGroup'..i
								local uT = LUIE.UnitFrames.CustomFrames[frame].unitTag
								if uT == unitTag then
									return i
								end
							end
							return 0
						end
						local frame = getLUIframe()
						if frame ~= 0 then
							local control = LUIE.UnitFrames.CustomFrames['SmallGroup'..frame].control
							fs:SetAnchor(TOPLEFT, control, BOTTOMLEFT, gBX + 2, gBY + 2)
							fd:SetAnchor(TOPLEFT, control, TOPRIGHT, gDX + 2, gDY + 2)
							Srendarr.RepopulateGroupAuras(numAuras, unitTag, frame1, frame2)
						end
						return
					else
						defaultGroup()
					end
				else
					defaultGroup()
				end
			elseif groupAuraMode == 4 then ----------------------------------------------------------------- Group frame support for Bandits User Interface 
				if BUI_VARS then
					local EnableFrames = BUI.Vars.RaidFrames
					if EnableFrames == true then
						local groupSlot = tostring(unitTag:gsub("%a",''))
						local control = GetControl('BUI_RaidFrame'..s)
						fs:SetAnchor(BOTTOMLEFT, control, TOPRIGHT, gBX + 2, gBY + 16)
						fd:SetAnchor(LEFT, control, RIGHT, gDX + 2, gDY)
						Srendarr.RepopulateGroupAuras(numAuras, unitTag, frame1, frame2)
						return
					else
						defaultGroup()
					end
				else
					defaultGroup()
				end
			elseif groupAuraMode == 5 then ----------------------------------------------------------------- Group frame support for AUI
				if AUI_Main then
					local EnableFrames = AUI_Main.Default[GetDisplayName()]["$AccountWide"].modul_unit_frames_enabled
					local EnableGroup = (AUI_Attributes) and AUI_Attributes.Default[GetDisplayName()]["$AccountWide"].group_unit_frames_enabled or false
					if (EnableFrames) and (EnableGroup) then
						local groupSlot = tostring(unitTag:gsub("%a",''))
						local gTemplate = AUI_Templates.Default[GetDisplayName()]["$AccountWide"]["Attributes"]["Group"]
						local gFrame = ""
						if gTemplate == "AUI" then
							gFrame = "AUI_GroupFrame"
						elseif gTemplate == "AUI_TESO" then
							gFrame = "TESO_GroupFrame"
						elseif gTemplate == "AUI_Tactical" then
							gFrame = "AUI_Tactical_GroupFrame"
						end
						local control = GetControl(gFrame..groupSlot)
						fs:SetAnchor(TOPLEFT, control, BOTTOMLEFT, gBX + 2, gBY + 3)
						fd:SetAnchor(TOPLEFT, control, TOPRIGHT, gDX + 2, gDY + 3)
						Srendarr.RepopulateGroupAuras(numAuras, unitTag, frame1, frame2)
						return
					else
						defaultGroup()
					end
				else
					defaultGroup()
				end
			end
		elseif groupSize >= 5 then
			if raidAuraMode == 1 then
				defaultRaid()
			elseif raidAuraMode == 2 then ------------------------------------------------------------------ Raid frame support for Foundry Tactical Combat
				if FTC_VARS then
					local EnableFrames = FTC_VARS.Default[GetDisplayName()]["$AccountWide"].EnableFrames
					local RaidFrames = FTC_VARS.Default[GetDisplayName()]["$AccountWide"].RaidFrames
					if (EnableFrames == true and RaidFrames == true) then
						local control = GetControl('FTC_RaidFrame'..s)
						fs:SetAnchor(TOPLEFT, control, TOPRIGHT, rBX, rBY + 4)
						fd:SetAnchor(BOTTOMLEFT, control, BOTTOMRIGHT, rDX, rDY - 2)
						Srendarr.RepopulateGroupAuras(numAuras, unitTag, frame1, frame2)
						return
					else
						defaultRaid()
					end
				else
					defaultRaid()
				end
			elseif raidAuraMode == 3 then ------------------------------------------------------------------ Raid frame support for Lui Extended
				if LUIESV then
					local EnableFrames = LUIESV.Default[GetDisplayName()]["$AccountWide"].UnitFrames_Enabled
					local RaidFrames = LUIESV.Default[GetDisplayName()]["$AccountWide"].UnitFrames.CustomFramesRaid
					if (EnableFrames == true and RaidFrames == true) then
						local function getLUIframe()
							for i = 1, 24 do
								local frame = 'RaidGroup'..i
								if LUIE.UnitFrames.CustomFrames[frame] then
									local uT = LUIE.UnitFrames.CustomFrames[frame].unitTag
									if uT == unitTag then
										return i
									end
								end
							end
							return 0
						end
						local frame = getLUIframe()
						if frame ~= 0 then
							local control1 = LUIE.UnitFrames.CustomFrames['RaidGroup'..frame].control
							local control2 = LUIE.UnitFrames.CustomFrames['RaidGroup'..frame].name
							fs:SetAnchor(TOPLEFT, control2, TOPRIGHT, rBX, rBY)
							fd:SetAnchor(TOPLEFT, control1, TOPRIGHT, rDX, rDY)
							Srendarr.RepopulateGroupAuras(numAuras, unitTag, frame1, frame2)
						end
						return
					else
						defaultRaid()
					end
				else
					defaultRaid()
				end
			elseif raidAuraMode == 4 then ------------------------------------------------------------------ Raid frame support for Bandits User Interface 
				if BUI_VARS then
					local EnableFrames = BUI.Vars.RaidFrames
					if EnableFrames == true then
						local groupSlot = tostring(unitTag:gsub("%a",''))
						local control = GetControl('BUI_RaidFrame'..s)
						fs:SetAnchor(TOPLEFT, control, TOPRIGHT, rBX + 2, rBY)
						fd:SetAnchor(BOTTOMLEFT, control, BOTTOMRIGHT, rDX + 2, rDY - 12)
						Srendarr.RepopulateGroupAuras(numAuras, unitTag, frame1, frame2)
						return
					else
						defaultRaid()
					end
				else
					defaultRaid()
				end
			elseif raidAuraMode == 5 then ------------------------------------------------------------------ Raid frame support for AUI
				if AUI_Main then
					local EnableFrames = AUI_Main.Default[GetDisplayName()]["$AccountWide"].modul_unit_frames_enabled
					local EnableRaid = (AUI_Attributes) and AUI_Attributes.Default[GetDisplayName()]["$AccountWide"].raid_unit_frames_enabled or false
					if (EnableFrames) and (EnableRaid) then
						local raidSlot = tostring(unitTag:gsub("%a",''))
						local rTemplate = AUI_Templates.Default[GetDisplayName()]["$AccountWide"]["Attributes"]["Raid"]
						local rFrame = ""
						if rTemplate == "AUI" then
							rFrame = "AUI_RaidFramegroup"
						elseif rTemplate == "AUI_Tactical" then
							rFrame = "AUI_Tactical_RaidFramegroup"
						end
						local control = GetControl(rFrame..raidSlot)
						fs:SetAnchor(TOPLEFT, control, TOPRIGHT, rBX, rBY + 4)
						fd:SetAnchor(BOTTOMLEFT, control, BOTTOMRIGHT, rDX, rDY - 2)
						Srendarr.RepopulateGroupAuras(numAuras, unitTag, frame1, frame2)
						return
					else
						defaultRaid()
					end
				else
					defaultRaid()
				end
			end
		end
	end

	function Srendarr.OnGroupChanged()
		Srendarr.groupUnits = {}
		local auraLookup = Srendarr.auraLookup

		if not Srendarr.GroupEnabled then return end -- abort if unsupported group frame detected

		for g = 1, 24 do -- clear auras when group changes to avoid floating remnants
			local unit = "group" .. tostring(g)
			if auraLookup[unit] then
				for aura, ability in pairs(auraLookup[unit]) do
					ability:SetExpired()
					ability:Release()
				end
			end
		end

		if IsUnitGrouped("player") then
			local groupSize = GetGroupSize()
			for s = 1, groupSize do
				local frame1 = s + 10
				local frame2 = s + 34
				local unitTag = GetGroupUnitTagByIndex(s)

				if (DoesUnitExist(unitTag)) then
					--	zo_strformat("<<t:1>>", GetUnitName(unitTag))
					--	/script d(zo_strformat("<<t:1>>", GetUnitName(GetGroupUnitTagByIndex(1))))

					local numAuras = GetNumBuffs(unitTag)
					Srendarr.groupUnits[unitTag] = {index = s + 199} -- store the group frame order
					Srendarr.AnchorGroupFrames(groupSize, s, numAuras, unitTag, frame1, frame2)
				end
			end
		end
	end
end


------------------------------------------------------------------------------------------------------------------------------
-- SLOTTED ABILITY DATA HANDLING
------------------------------------------------------------------------------------------------------------------------------
do
	local GetSlotBoundId		= GetSlotBoundId
	local GetAbilityCastInfo	= GetAbilityCastInfo
	local GetAbilityIcon		= GetAbilityIcon
	local procAbilityNames		= Srendarr.procAbilityNames

	local abilityID, abilityName, slotData, isChannel, castTime, channelTime

	function Srendarr.OnActionSlotsFullUpdate()
		for slot = 3, 8 do
			Srendarr.OnActionSlotUpdated(nil, slot)
		end
	end

	function Srendarr.OnActionSlotUpdated(e, slot)

		if (slot < 3 or slot > 8) then return end -- abort if not a main ability (or ultimate)

		abilityID	= GetSlotBoundId(slot)
		slotData	= Srendarr.slotData[slot]

		if abilityID == 0 then return end -- avoid showing proc on empty slots (Phinix)
		if slotData.abilityID == abilityID then return end -- nothing has changed, abort

		abilityName				= ZOSName(abilityID)

		slotData.abilityID		= abilityID
		slotData.abilityName	= abilityName
		slotData.abilityIcon	= GetAbilityIcon(abilityID)

		isChannel, castTime, channelTime = GetAbilityCastInfo(abilityID)

		if (castTime > 0 or channelTime > 0) then
			slotData.isDelayed		= true			-- check for needing a cast bar
			slotData.isChannel		= isChannel
			slotData.castTime		= castTime
			slotData.channelTime	= channelTime
		else
			slotData.isDelayed		= false
		end

		if (procAbilityNames[abilityName]) then -- this is currently a proc'd ability (or special case for crystal fragments)
			Srendarr:ProcAnimationStart(slot)
		elseif slot ~= 8 then -- cannot have procs on ultimate slot
			Srendarr:ProcAnimationStop(slot)
		end
	end
end


------------------------------------------------------------------------------------------------------------------------------
-- EQUIPMENT CHANGE HANDLING FOR COOLDOWN TRACKING
------------------------------------------------------------------------------------------------------------------------------
do
	function Srendarr.OnEquipChange()
		if (gearSwapDelay) then
			local abilityBarSets = Srendarr.abilityBarSets
			local abilityCooldowns = Srendarr.abilityCooldowns
	
			local function GetNormalSet(setId)
				if abilityBarSets[setId] then
					for k, v in pairs(abilityBarSets[setId]) do
						if abilityCooldowns[v] then
							if abilityCooldowns[v].s1 ~= 0 then
								return abilityCooldowns[v].s1
							end
						end
					end
				end
				return 0
			end
			local function GetPerfectSet(setId)
				if abilityBarSets[setId] then
					for k, v in pairs(abilityBarSets[setId]) do
						if abilityCooldowns[v] then
							if abilityCooldowns[v].s2 ~= 0 then
								return abilityCooldowns[v].s2
							end
						end
					end
				end
				return 0
			end
	
			local setTable = {}
			local allSets = {}
			Srendarr.equippedSets = {}
	
			for i = 0, 21 do -- count the total number of set pieces equipped
				local itemLink = GetItemLink(BAG_WORN, i)
			--[[
			--	0	= helm
			--	1	= necklace
			--	2	= chest
			--	3	= shoulders
			--	4	= weapon 1 mainhand (or 2h)
			--	5	= weapon 1 offhand
			--	6	= belt
			--	7	= ?
			--	8	= pants
			--	9	= feet
			--	10	= disguise
			--	11	= ring 1
			--	12	= ring 2
			--	13	= poison 1
			--	14	= poison 2
			--	15	= ?
			--	16	= hands
			--	17	= ?
			--	18	= ?
			--	19	= ?
			--	20	= weapon 2 mainhand (or 2h)
			--	21	= weapon 2 offhand
			--]]
				if itemLink ~= "" then -- this is necessary because numNormalEquipped and numPerfectedEquipped only count items on your active bar (Phinix)
				--	GetItemLinkSetInfo(string itemLink, boolean equipped) - Returns: boolean hasSet, string setName, number numBonuses, number numNormalEquipped, number maxEquipped, number setId, number numPerfectedEquipped
					local hasSet, setName, _, _, maxEquipped, setId = GetItemLinkSetInfo(itemLink, true)
					local addValue = (GetItemLinkEquipType(itemLink) == EQUIP_TYPE_TWO_HAND) and 2 or 1
					--[[
					--	EQUIP_TYPE_CHEST		3
					--	EQUIP_TYPE_COSTUME		11
					--	EQUIP_TYPE_FEET			10
					--	EQUIP_TYPE_HAND			13
					--	EQUIP_TYPE_HEAD			1
					--	EQUIP_TYPE_LEGS			9
					--	EQUIP_TYPE_MAIN_HAND	14
					--	EQUIP_TYPE_NECK			2
					--	EQUIP_TYPE_OFF_HAND		7
					--	EQUIP_TYPE_ONE_HAND		5
					--	EQUIP_TYPE_POISON		15
					--	EQUIP_TYPE_RING			12
					--	EQUIP_TYPE_SHOULDERS	4
					--	EQUIP_TYPE_TWO_HAND		6
					--	EQUIP_TYPE_WAIST		8
					--]]
					if hasSet then
						local isPerfectedSet = GetItemSetUnperfectedSetId(setId) > 0
						local perfectedName = (isPerfectedSet) and "Perfected " or ""
						if abilityBarSets[setId] ~= nil then
							local normalId
							local perfectId
							if isPerfectedSet then
								perfectId = setId
								normalId = GetNormalSet(setId)
							else
								perfectId = GetPerfectSet(setId)
								normalId = setId
							end
							local setString = tostring(normalId).."-"..tostring(perfectId)
							if setTable[setString] ~= nil then
								if isPerfectedSet then
									setTable[setString].pE = setTable[setString].pE + addValue
								else
									setTable[setString].nE = setTable[setString].nE + addValue
								end
							else
								if isPerfectedSet then
									setTable[setString] = {nE = 0, nId = normalId, nName = "", pE = addValue, pId = perfectId, pName = setName, full = maxEquipped}
								else
									setTable[setString] = {nE = addValue, nId = normalId, nName = setName, pE = 0, pId = perfectId, pName = "", full = maxEquipped}
								end
							end
						end
						if allSets[tonumber(setId)] == nil then
							allSets[tonumber(setId)] = perfectedName..setName
						end
					end
				end
			end
		
		--	d(setTable)
		--	d(allSets)

			gearSwapDelay = false -- spam control for armory and gear swap addons (Phinix)
			zo_callLater(
				function()
					gearSwapDelay = true
				--	d("gear swap delay complete")

					for k, v in pairs(setTable) do
						if v.nE + v.pE >= v.full then Srendarr.equippedSets[v.nId] = zo_strformat("<<t:1>>",v.nName) end
					end
		
					if Srendarr.db.setIdDebug == true then
						for k, v in pairs(allSets) do
							d(zo_strformat("<<t:1>>", tostring(k)..": "..v))
						end
					end
					Srendarr.OnPlayerActivatedAlive()
				end,
			2000 + GetLatency()
			)
		else
			return
		end
	end
end


------------------------------------------------------------------------------------------------------------------------------
-- BLACKLIST AND PROMINENT AURAS CONTROL
do ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	local STR_PROMBYID				= Srendarr.STR_PROMBYID
	local STR_PROMBYID2				= Srendarr.STR_PROMBYID2
	local STR_BLOCKBYID				= Srendarr.STR_BLOCKBYID
	local STR_DEBUFFBYID			= Srendarr.STR_DEBUFFBYID
	local STR_DEBUFFBYID2			= Srendarr.STR_DEBUFFBYID2
	local STR_GROUPBUFFBYID			= Srendarr.STR_GROUPBUFFBYID
	local STR_GROUPDEBUFFBYID		= Srendarr.STR_GROUPDEBUFFBYID

	local DoesAbilityExist			= DoesAbilityExist
	local GetAbilityDuration		= GetAbilityDuration
	local GetAbilityDescription		= GetAbilityDescription
	local IsAbilityPassive			= IsAbilityPassive

	local maxAbilityID				= Srendarr.maxAbilityID
	local specialNames				= Srendarr.specialNames
	local fakeAuras					= Srendarr.fakeAuras
	local matchedIDs				= {}

	function Srendarr:RemoveAltProminent(auraName, list, listFormat, mode)
		local removed = 0
		local checkID = 0
		local string1
		local string2
		local var1
		local var2

		if mode == 1 then
			string1 = STR_PROMBYID
			string2 = STR_PROMBYID2
			var1 = self.db.prominentWhitelist
			var2 = self.db.prominentWhitelist2
		else
			string1 = STR_DEBUFFBYID
			string2 = STR_DEBUFFBYID2
			var1 = self.db.debuffWhitelist
			var2 = self.db.debuffWhitelist2
		end

		if listFormat == 1 then
			checkID = zo_strformat("<<t:1>>", tostring(auraName))
		end

		if list == 1 then
			if (var1[string1]) then
				for k, v in pairs(var1[string1]) do
					if zo_strformat("<<t:1>>", k) == auraName then
						var1[string1][k] = nil
						removed = removed + 1
					end
				end
			end
			if (var1[string1]) and (var1[string1][auraName]) then
				var1[string1][auraName] = nil
				removed = removed + 1
			end
			if (var1[auraName]) then
				for id in pairs(var1[auraName]) do
					var1[auraName][id] = nil
				end
				var1[auraName] = nil
				removed = removed + 1
			end
			if checkID ~= 0 then
				if (var1[checkID]) then
					for id in pairs(var1[checkID]) do
						var1[checkID][id] = nil
					end
					var1[checkID] = nil
					removed = removed + 1
				end
			end
			if removed > 0 then
				if mode == 1 then
					Srendarr:PopulateProminentAurasDropdown()
					Srendarr:PopulateProminentAurasDropdown2()
				else
					Srendarr:PopulateTargetDebuffDropdown()
					Srendarr:PopulateTargetDebuffDropdown2()
				end
			end
		elseif list == 2 then 
			if (var2[string2]) then
				for k, v in pairs(var2[string2]) do
					if zo_strformat("<<t:1>>", k) == auraName then
						var2[string2][k] = nil
						removed = removed + 1
					end
				end
			end
			if (var2[string2]) and (var2[string2][auraName]) then
				var2[string2][auraName] = nil
				removed = removed + 1
			end
			if (var2[auraName]) then
				for id in pairs(var2[auraName]) do
					var2[auraName][id] = nil
				end
				var2[auraName] = nil
				removed = removed + 1
			end
			if checkID ~= 0 then
				if (var2[checkID]) then
					for id in pairs(var2[checkID]) do
						var2[checkID][id] = nil
					end
					var2[checkID] = nil
					removed = removed + 1
				end
			end
			if removed > 0 then
				if mode == 1 then
					Srendarr:PopulateProminentAurasDropdown()
					Srendarr:PopulateProminentAurasDropdown2()
				else
					Srendarr:PopulateTargetDebuffDropdown()
					Srendarr:PopulateTargetDebuffDropdown2()
				end
			end
		end
	end

	function Srendarr:FindIDByName(auraName, stage, list, tdebug)
		local prominentPassiveBuffs = self.db.prominentPassiveBuffs
--	/script Srendarr:FindIDByName("Ability Name", 1, 1, true)
		local GetAbilityName = GetAbilityName
		local DoesAbilityExist = DoesAbilityExist
		local GetAbilityDuration = GetAbilityDuration
		local tempInt = (stage == 1) and 0 or 1
		local IdLow = (50000 * stage) - 50000
		local IdHigh = 50000 * stage
		IdLow = (IdLow > 0) and IdLow or 1
		local compareName = ""

		if stage == 1 then
			for i in pairs(matchedIDs) do
				matchedIDs[i] = nil -- reset matches
			end
			if (fakeAuras[auraName]) then -- a fake aura exists for this ability, add its ID
				local abilityID = fakeAuras[auraName].abilityID
				table.insert(matchedIDs, abilityID)
			end
		end

		for i = IdLow, IdHigh do
			local cId = i+tempInt
			if DoesAbilityExist(cId) then
				if (GetAbilityDuration(cId) > 0 and not IsAbilityPassive(cId)) or (prominentPassiveBuffs) then
				-- upon further investigation of the below detailed problem, it appears other abilities that should report as passive are also reporting wrong values.
				-- for example, Sorcerer's Volatile Familiar toggle (ID 23316) and likely others should report true for IsAbilityPassive() but instead wrongly report false.
				-- this makes attempting to sort these abilities more difficult as the information to filter them is very frequently unreliable.
				-- i am re-enabling this older double-check and rather than making another table of ID's for cases like this and below, users can just put in error ID's manually. (Phinix)
	
			--	if not IsAbilityPassive(cId) then
				-- the game wrongly reports GetAbilityDuration() as 0 for many valid abilities like Major Expedition ID 61736. 
				-- it is unclear what value limiting zero duration auras in addition to IsAbilityPassive() checks provides, and it significantly slows down the aura finder.
				-- combined with this frequently inaccurate output from the game for this function it is logical to remove it to avoid missing many valid auras when adding by name.
				-- in theory this extra check would only really be useful in a case where ZOS wrongly reported an ID duration as 0 AND wrongly reported it as a passive,
				-- in which rare instance, users can just input the ID manually.
				-- therefor this redundant and inaccurate check is removed, speeding up the aura finder and preventing missed auras like the one above. (Phinix)
	
					compareName = (specialNames[cId] ~= nil) and specialNames[cId].name or zo_strformat("<<t:1>>", GetAbilityName(cId))
					if string.find(compareName,auraName) ~= nil then -- matching ability with a duration (no toggles or passives in prominence)
				--	if compareName == auraName then -- text string pattern matching is an imperfect way of identifying target data (Phinix)
						table.insert(matchedIDs, cId)
					end
				end
			end
			if i == IdHigh then
				if stage == 4 then
					if tdebug then
						if next(matchedIDs) ~= nil then -- matches were found
							for _, id in ipairs(matchedIDs) do
							--	d('['..id ..'] '..zo_strformat("<<t:1>>", id) .. '-' .. GetAbilityDuration(id) .. '-' .. GetAbilityDescription(id))
								d(id.." - "..auraName)
							end
						end
					else
				-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				-- Prominent Whitelist 1
				-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
						if list == 1 then
							if next(matchedIDs) ~= nil then -- matches were found
						--	if #matchedIDs > 0 then -- matches were found
								Srendarr:RemoveAltProminent(auraName, 2, 0, 1) -- Can't add same ability to both prominent lists
								Srendarr.db.prominentWhitelist[auraName] = {} -- add a new whitelist entry
								for _, id in ipairs(matchedIDs) do
									Srendarr.db.prominentWhitelist[auraName][id] = true
								end
								Srendarr:ConfigureAuraHandler() -- update handler ref
								Srendarr:PopulateProminentAurasDropdown()
								CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Prominent_AuraAddSuccess)) -- inform user of successful addition
							else
								CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Prominent_AuraAddFail)) -- inform user of failed addition
							end
				-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				-- Prominent Whitelist 2
				-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
						elseif list == 2 then
							if next(matchedIDs) ~= nil then -- matches were found
						--	if #matchedIDs > 0 then -- matches were found
								Srendarr:RemoveAltProminent(auraName, 1, 0, 1) -- Can't add same ability to both prominent lists
								self.db.prominentWhitelist2[auraName] = {} -- add a new whitelist entry
								for _, id in ipairs(matchedIDs) do
									self.db.prominentWhitelist2[auraName][id] = true
								end
								Srendarr:ConfigureAuraHandler() -- update handler ref
								Srendarr:PopulateProminentAurasDropdown2()
								CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Prominent_AuraAddSuccess2)) -- inform user of successful addition
							else
								CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Prominent_AuraAddFail)) -- inform user of failed addition
							end
				-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				-- Debuff Whitelist 1
				-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
						elseif list == 3 then
							if next(matchedIDs) ~= nil then -- matches were found
						--	if (#matchedIDs > 0) then -- matches were found
								Srendarr:RemoveAltProminent(auraName, 2, 0, 2) -- Can't add same ability to both prominent lists
								self.db.debuffWhitelist[auraName] = {} -- add a new whitelist entry
								for _, id in ipairs(matchedIDs) do
									self.db.debuffWhitelist[auraName][id] = true
								end
								Srendarr:ConfigureAuraHandler() -- update handler ref
								Srendarr:PopulateTargetDebuffDropdown()
								CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Debuff_AuraAddSuccess)) -- inform user of successful addition
							else
								CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Prominent_AuraAddFail)) -- inform user of failed addition
							end
				-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				-- Debuff Whitelist 2
				-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
						elseif list == 4 then
							if next(matchedIDs) ~= nil then -- matches were found
						--	if (#matchedIDs > 0) then -- matches were found
								Srendarr:RemoveAltProminent(auraName, 1, 0, 2) -- Can't add same ability to both prominent lists
								self.db.debuffWhitelist2[auraName] = {} -- add a new whitelist entry
								for _, id in ipairs(matchedIDs) do
									self.db.debuffWhitelist2[auraName][id] = true
								end
								Srendarr:ConfigureAuraHandler() -- update handler ref
								Srendarr:PopulateTargetDebuffDropdown2()
								CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Debuff_AuraAddSuccess2)) -- inform user of successful addition
							else
								CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Prominent_AuraAddFail)) -- inform user of failed addition
							end
				-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				-- Group Buff Whitelist
				-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
						elseif list == 5 then
							if next(matchedIDs) ~= nil then -- matches were found
						--	if (#matchedIDs > 0) then -- matches were found
								self.db.groupBuffWhitelist[auraName] = {} -- add a new whitelist entry
								for _, id in ipairs(matchedIDs) do
									self.db.groupBuffWhitelist[auraName][id] = true
								end
								Srendarr:ConfigureAuraHandler() -- update handler ref
								Srendarr:PopulateGroupBuffsDropdown()
								CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Group_AuraAddSuccess)) -- inform user of successful addition
							else
								CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Prominent_AuraAddFail)) -- inform user of failed addition
							end
				-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				-- Group Debuff Whitelist
				-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
						elseif list == 6 then
							if next(matchedIDs) ~= nil then -- matches were found
						--	if (#matchedIDs > 0) then -- matches were found
								self.db.groupDebuffWhitelist[auraName] = {} -- add a new whitelist entry
								for _, id in ipairs(matchedIDs) do
									self.db.groupDebuffWhitelist[auraName][id] = true
								end
								Srendarr:ConfigureAuraHandler() -- update handler ref
								Srendarr:PopulateGroupDebuffsDropdown()
								CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Group_AuraAddSuccess2)) -- inform user of successful addition
							else
								CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Prominent_AuraAddFail)) -- inform user of failed addition
							end
				-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				-- Global Blacklist
				-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
						elseif list == 7 then
							if next(matchedIDs) ~= nil then -- matches were found
						--	if (#matchedIDs > 0) then -- matches were found
								self.db.blacklist[auraName] = {} -- add a new blacklist entry
								for _, id in ipairs(matchedIDs) do
									self.db.blacklist[auraName][id] = true
								end
								Srendarr:PopulateFilteredAuras() -- update filtered aura IDs
								Srendarr:PopulateBlacklistAurasDropdown()
								CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Blacklist_AuraAddSuccess)) -- inform user of successful addition
							else
								CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Blacklist_AuraAddFail)) -- inform user of failed addition
							end
						end
					end
					return
				else
					zo_callLater(function() Srendarr:FindIDByName(auraName, stage+1, list, tdebug) end, 500)
					return
				end
			end
		end
	end

	function Srendarr:ProminentAuraAdd(auraName)
		local prominentPassiveBuffs = self.db.prominentPassiveBuffs
		auraName = zo_strformat("<<t:1>>", auraName) -- strip out any control characters player may have entered
		if auraName == STR_PROMBYID then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- number entered, assume is an abilityID
			auraName = tonumber(auraName)
			if (auraName > 0 and auraName < maxAbilityID and DoesAbilityExist(auraName)) and ((GetAbilityDuration(auraName) > 0 or not IsAbilityPassive(auraName)) or (prominentPassiveBuffs)) then
				-- can only add timed abilities to the prominence whitelist
				Srendarr:RemoveAltProminent(auraName, 2, 1, 1) -- Can't add same ability to both prominent lists
				if (not self.db.prominentWhitelist[STR_PROMBYID]) then
					self.db.prominentWhitelist[STR_PROMBYID] = {} -- ensure the by ID table is present
				end
				self.db.prominentWhitelist[STR_PROMBYID][auraName] = true
				CHAT_SYSTEM:AddMessage(string.format('%s: [%d] (%s) %s', L.Srendarr, auraName, ZOSName(auraName), L.Prominent_AuraAddSuccess)) -- inform user of successful addition
				Srendarr:ConfigureAuraHandler() -- update handler ref
			else
				CHAT_SYSTEM:AddMessage(string.format('%s: [%s] %s', L.Srendarr, auraName, L.Prominent_AuraAddFailByID)) -- inform user of failed addition
			end
		else
			if (self.db.prominentWhitelist[auraName]) then return end -- already added this aura
			Srendarr:FindIDByName(auraName, 1, 1)
		end
	end

	function Srendarr:ProminentAuraAdd2(auraName)
		local prominentPassiveBuffs = self.db.prominentPassiveBuffs
		auraName = zo_strformat("<<t:1>>", auraName) -- strip out any control characters player may have entered
		if auraName == STR_PROMBYID2 then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- number entered, assume is an abilityID
			auraName = tonumber(auraName)
			if (auraName > 0 and auraName < maxAbilityID and DoesAbilityExist(auraName)) and ((GetAbilityDuration(auraName) > 0 or not IsAbilityPassive(auraName)) or (prominentPassiveBuffs)) then
				-- can only add timed abilities to the prominence whitelist
				Srendarr:RemoveAltProminent(auraName, 1, 1, 1) -- Can't add same ability to both prominent lists
				if (not self.db.prominentWhitelist2[STR_PROMBYID2]) then
					self.db.prominentWhitelist2[STR_PROMBYID2] = {} -- ensure the by ID table is present
				end
				self.db.prominentWhitelist2[STR_PROMBYID2][auraName] = true
				CHAT_SYSTEM:AddMessage(string.format('%s: [%d] (%s) %s', L.Srendarr, auraName, ZOSName(auraName), L.Prominent_AuraAddSuccess2)) -- inform user of successful addition
				Srendarr:ConfigureAuraHandler() -- update handler ref
			else
				CHAT_SYSTEM:AddMessage(string.format('%s: [%s] %s', L.Srendarr, auraName, L.Prominent_AuraAddFailByID)) -- inform user of failed addition
			end
		else
			if (self.db.prominentWhitelist2[auraName]) then return end -- already added this aura
			Srendarr:FindIDByName(auraName, 1, 2)
		end
	end

	function Srendarr:ProminentDebuffAdd(auraName)
		auraName = zo_strformat("<<t:1>>", auraName) -- strip out any control characters player may have entered
		if auraName == STR_DEBUFFBYID then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- number entered, assume is an abilityID
			auraName = tonumber(auraName)
			if (auraName > 0 and auraName < maxAbilityID and DoesAbilityExist(auraName) and (GetAbilityDuration(auraName) > 0 or not IsAbilityPassive(auraName))) then
				-- can only add timed abilities to the debuff whitelist
				Srendarr:RemoveAltProminent(auraName, 2, 1, 2) -- Can't add same ability to both prominent lists
				if (not self.db.debuffWhitelist[STR_DEBUFFBYID]) then
					self.db.debuffWhitelist[STR_DEBUFFBYID] = {} -- ensure the by ID table is present
				end
				self.db.debuffWhitelist[STR_DEBUFFBYID][auraName] = true
				CHAT_SYSTEM:AddMessage(string.format('%s: [%d] (%s) %s', L.Srendarr, auraName, ZOSName(auraName), L.Debuff_AuraAddSuccess)) -- inform user of successful addition
				Srendarr:ConfigureAuraHandler() -- update handler ref
			else
				CHAT_SYSTEM:AddMessage(string.format('%s: [%s] %s', L.Srendarr, auraName, L.Prominent_AuraAddFailByID)) -- inform user of failed addition
			end
		else
			if (self.db.debuffWhitelist[auraName]) then return end -- already added this aura
			Srendarr:FindIDByName(auraName, 1, 3)
		end
	end

	function Srendarr:ProminentDebuffAdd2(auraName)
		auraName = zo_strformat("<<t:1>>", auraName) -- strip out any control characters player may have entered
		if auraName == STR_DEBUFFBYID2 then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- number entered, assume is an abilityID
			auraName = tonumber(auraName)
			if (auraName > 0 and auraName < maxAbilityID and DoesAbilityExist(auraName) and (GetAbilityDuration(auraName) > 0 or not IsAbilityPassive(auraName))) then
				-- can only add timed abilities to the debuff whitelist
				Srendarr:RemoveAltProminent(auraName, 1, 1, 2) -- Can't add same ability to both prominent lists
				if (not self.db.debuffWhitelist2[STR_DEBUFFBYID2]) then
					self.db.debuffWhitelist2[STR_DEBUFFBYID2] = {} -- ensure the by ID table is present
				end
				self.db.debuffWhitelist2[STR_DEBUFFBYID2][auraName] = true
				CHAT_SYSTEM:AddMessage(string.format('%s: [%d] (%s) %s', L.Srendarr, auraName, ZOSName(auraName), L.Debuff_AuraAddSuccess2)) -- inform user of successful addition
				Srendarr:ConfigureAuraHandler() -- update handler ref
			else
				CHAT_SYSTEM:AddMessage(string.format('%s: [%s] %s', L.Srendarr, auraName, L.Prominent_AuraAddFailByID)) -- inform user of failed addition
			end
		else
			if (self.db.debuffWhitelist2[auraName]) then return end -- already added this aura
			Srendarr:FindIDByName(auraName, 1, 4)
		end
	end

	function Srendarr:GroupWhitelistAdd(auraName)
		auraName = zo_strformat("<<t:1>>", auraName) -- strip out any control characters player may have entered
		if auraName == STR_GROUPBUFFBYID then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- number entered, assume is an abilityID
			auraName = tonumber(auraName)
			if (auraName > 0 and auraName < maxAbilityID and DoesAbilityExist(auraName) and (GetAbilityDuration(auraName) > 0 or not IsAbilityPassive(auraName))) then
				-- can only add timed abilities to the group whitelist
				if (not self.db.groupBuffWhitelist[STR_GROUPBUFFBYID]) then
					self.db.groupBuffWhitelist[STR_GROUPBUFFBYID] = {} -- ensure the by ID table is present
				end
				self.db.groupBuffWhitelist[STR_GROUPBUFFBYID][auraName] = true
				CHAT_SYSTEM:AddMessage(string.format('%s: [%d] (%s) %s', L.Srendarr, auraName, ZOSName(auraName), L.Group_AuraAddSuccess)) -- inform user of successful addition
				Srendarr:ConfigureAuraHandler() -- update handler ref
			else
				CHAT_SYSTEM:AddMessage(string.format('%s: [%s] %s', L.Srendarr, auraName, L.Prominent_AuraAddFailByID)) -- inform user of failed addition
			end
		else
			if (self.db.groupBuffWhitelist[auraName]) then return end -- already added this aura
			Srendarr:FindIDByName(auraName, 1, 5)
		end
	end

	function Srendarr:GroupWhitelistAdd2(auraName)
		auraName = zo_strformat("<<t:1>>", auraName) -- strip out any control characters player may have entered
		if auraName == STR_GROUPDEBUFFBYID then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- number entered, assume is an abilityID
			auraName = tonumber(auraName)
			if (auraName > 0 and auraName < maxAbilityID and DoesAbilityExist(auraName) and (GetAbilityDuration(auraName) > 0 or not IsAbilityPassive(auraName))) then
				-- can only add timed abilities to the group whitelist
				if (not self.db.groupDebuffWhitelist[STR_GROUPDEBUFFBYID]) then
					self.db.groupDebuffWhitelist[STR_GROUPDEBUFFBYID] = {} -- ensure the by ID table is present
				end
				self.db.groupDebuffWhitelist[STR_GROUPDEBUFFBYID][auraName] = true
				CHAT_SYSTEM:AddMessage(string.format('%s: [%d] (%s) %s', L.Srendarr, auraName, ZOSName(auraName), L.Group_AuraAddSuccess2)) -- inform user of successful addition
				Srendarr:ConfigureAuraHandler() -- update handler ref
			else
				CHAT_SYSTEM:AddMessage(string.format('%s: [%s] %s', L.Srendarr, auraName, L.Prominent_AuraAddFailByID)) -- inform user of failed addition
			end
		else
			if (self.db.groupDebuffWhitelist[auraName]) then return end -- already added this aura
			Srendarr:FindIDByName(auraName, 1, 6)
		end
	end

	function Srendarr:BlacklistAuraAdd(auraName)
		auraName = zo_strformat("<<t:1>>", auraName) -- strip out any control characters player may have entered
		if auraName == STR_BLOCKBYID then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- number entered, assume is an abilityID
			auraName = tonumber(auraName)
			if (auraName > 0 and auraName < maxAbilityID+4000000) then -- sanity check on the ID given
			-- add 4000000 to allow to blacklist individual proc cooldowns so you can still track the ones you care about (Phinix)
				if (not self.db.blacklist[STR_BLOCKBYID]) then
					self.db.blacklist[STR_BLOCKBYID] = {} -- ensure the by ID table is present
				end
				self.db.blacklist[STR_BLOCKBYID][auraName] = true
				Srendarr:PopulateFilteredAuras() -- update filtered aura IDs
				CHAT_SYSTEM:AddMessage(string.format('%s: [%d] (%s) %s', L.Srendarr, auraName, ZOSName(auraName), L.Blacklist_AuraAddSuccess)) -- inform user of successful addition
			else
				CHAT_SYSTEM:AddMessage(string.format('%s: [%s] %s', L.Srendarr, auraName, L.Blacklist_AuraAddFailByID)) -- inform user of failed addition
			end
		else
			if (self.db.blacklist[auraName]) then return end -- already added this aura
			Srendarr:FindIDByName(auraName, 1, 7)
		end
	end

	function Srendarr:ProminentAuraRemove(auraName)
		auraName = zo_strformat("<<t:1>>", auraName) -- strip out any control characters player may have entered
		if auraName == STR_PROMBYID then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- trying to remove by number, assume is an abilityID
			auraName = tonumber(auraName)
			if (self.db.prominentWhitelist[STR_PROMBYID][auraName]) then -- ID is in list, remove and inform user
				self.db.prominentWhitelist[STR_PROMBYID][auraName] = nil
				Srendarr:ConfigureAuraHandler() -- update handler ref
				CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Prominent_AuraRemoved)) -- inform user of removal
			end
		else
			if (not self.db.prominentWhitelist[auraName]) then return end -- not in whitelist, abort
			for id in pairs(self.db.prominentWhitelist[auraName]) do
				self.db.prominentWhitelist[auraName][id] = nil -- clean out whitelist entry
			end
			self.db.prominentWhitelist[auraName] = nil -- remove whitelist entrys
			Srendarr:ConfigureAuraHandler() -- update handler ref
			CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Prominent_AuraRemoved)) -- inform user of removal
		end
	end

	function Srendarr:ProminentAuraRemove2(auraName)
		auraName = zo_strformat("<<t:1>>", auraName) -- strip out any control characters player may have entered
		if auraName == STR_PROMBYID2 then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- trying to remove by number, assume is an abilityID
			auraName = tonumber(auraName)
			if (self.db.prominentWhitelist2[STR_PROMBYID2][auraName]) then -- ID is in list, remove and inform user
				self.db.prominentWhitelist2[STR_PROMBYID2][auraName] = nil
				Srendarr:ConfigureAuraHandler() -- update handler ref
				CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Prominent_AuraRemoved2)) -- inform user of removal
			end
		else
			if (not self.db.prominentWhitelist2[auraName]) then return end -- not in whitelist, abort
			for id in pairs(self.db.prominentWhitelist2[auraName]) do
				self.db.prominentWhitelist2[auraName][id] = nil -- clean out whitelist entry
			end
			self.db.prominentWhitelist2[auraName] = nil -- remove whitelist entrys
			Srendarr:ConfigureAuraHandler() -- update handler ref
			CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Prominent_AuraRemoved2)) -- inform user of removal
		end
	end

	function Srendarr:ProminentDebuffRemove(auraName)
		auraName = zo_strformat("<<t:1>>", auraName) -- strip out any control characters player may have entered
		if auraName == STR_DEBUFFBYID then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- trying to remove by number, assume is an abilityID
			auraName = tonumber(auraName)
			if (self.db.debuffWhitelist[STR_DEBUFFBYID][auraName]) then -- ID is in list, remove and inform user
				self.db.debuffWhitelist[STR_DEBUFFBYID][auraName] = nil
				Srendarr:ConfigureAuraHandler() -- update handler ref
				CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Debuff_AuraRemoved)) -- inform user of removal
			end
		else
			if (not self.db.debuffWhitelist[auraName]) then return end -- not in whitelist, abort
			for id in pairs(self.db.debuffWhitelist[auraName]) do
				self.db.debuffWhitelist[auraName][id] = nil -- clean out whitelist entry
			end
			self.db.debuffWhitelist[auraName] = nil -- remove whitelist entrys
			Srendarr:ConfigureAuraHandler() -- update handler ref
			CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Debuff_AuraRemoved)) -- inform user of removal
		end
	end

	function Srendarr:ProminentDebuffRemove2(auraName)
		auraName = zo_strformat("<<t:1>>", auraName) -- strip out any control characters player may have entered
		if auraName == STR_DEBUFFBYID2 then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- trying to remove by number, assume is an abilityID
			auraName = tonumber(auraName)
			if (self.db.debuffWhitelist2[STR_DEBUFFBYID2][auraName]) then -- ID is in list, remove and inform user
				self.db.debuffWhitelist2[STR_DEBUFFBYID2][auraName] = nil
				Srendarr:ConfigureAuraHandler() -- update handler ref
				CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Debuff_AuraRemoved2)) -- inform user of removal
			end
		else
			if (not self.db.debuffWhitelist2[auraName]) then return end -- not in whitelist, abort
			for id in pairs(self.db.debuffWhitelist2[auraName]) do
				self.db.debuffWhitelist2[auraName][id] = nil -- clean out whitelist entry
			end
			self.db.debuffWhitelist2[auraName] = nil -- remove whitelist entrys
			Srendarr:ConfigureAuraHandler() -- update handler ref
			CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Debuff_AuraRemoved2)) -- inform user of removal
		end
	end

	function Srendarr:GroupAuraRemove(auraName)
		auraName = zo_strformat("<<t:1>>", auraName) -- strip out any control characters player may have entered
		if auraName == STR_GROUPBUFFBYID then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- trying to remove by number, assume is an abilityID
			auraName = tonumber(auraName)
			if (self.db.groupBuffWhitelist[STR_GROUPBUFFBYID][auraName]) then -- ID is in list, remove and inform user
				self.db.groupBuffWhitelist[STR_GROUPBUFFBYID][auraName] = nil
				Srendarr:ConfigureAuraHandler() -- update handler ref
				CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Group_AuraRemoved)) -- inform user of removal
			end
		else
			if (not self.db.groupBuffWhitelist[auraName]) then return end -- not in whitelist, abort
			for id in pairs(self.db.groupBuffWhitelist[auraName]) do
				self.db.groupBuffWhitelist[auraName][id] = nil -- clean out whitelist entry
			end
			self.db.groupBuffWhitelist[auraName] = nil -- remove whitelist entrys
			Srendarr:ConfigureAuraHandler() -- update handler ref
			CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Group_AuraRemoved)) -- inform user of removal
		end
	end

	function Srendarr:GroupAuraRemove2(auraName)
		auraName = zo_strformat("<<t:1>>", auraName) -- strip out any control characters player may have entered
		if auraName == STR_GROUPDEBUFFBYID then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- trying to remove by number, assume is an abilityID
			auraName = tonumber(auraName)
			if (self.db.groupDebuffWhitelist[STR_GROUPDEBUFFBYID][auraName]) then -- ID is in list, remove and inform user
				self.db.groupDebuffWhitelist[STR_GROUPDEBUFFBYID][auraName] = nil
				Srendarr:ConfigureAuraHandler() -- update handler ref
				CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Group_AuraRemoved2)) -- inform user of removal
			end
		else
			if (not self.db.groupDebuffWhitelist[auraName]) then return end -- not in whitelist, abort
			for id in pairs(self.db.groupDebuffWhitelist[auraName]) do
				self.db.groupDebuffWhitelist[auraName][id] = nil -- clean out whitelist entry
			end
			self.db.groupDebuffWhitelist[auraName] = nil -- remove whitelist entrys
			Srendarr:ConfigureAuraHandler() -- update handler ref
			CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Group_AuraRemoved2)) -- inform user of removal
		end
	end

	function Srendarr:BlacklistAuraRemove(auraName)
		auraName = zo_strformat("<<t:1>>", auraName) -- strip out any control characters player may have entered
		if auraName == STR_BLOCKBYID then return end -- make sure we don't mess with internal table
		if (tonumber(auraName)) then -- trying to remove by number, assume is an abilityID
			auraName = tonumber(auraName)
			if (self.db.blacklist[STR_BLOCKBYID][auraName]) then -- ID is in list, remove and inform user
				self.db.blacklist[STR_BLOCKBYID][auraName] = nil
				Srendarr:PopulateFilteredAuras() -- update filtered aura IDs
				CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Blacklist_AuraRemoved)) -- inform user of removal
			end
		else
			if (not self.db.blacklist[auraName]) then return end -- not in blacklist, abort
			for id in pairs(self.db.blacklist[auraName]) do
				self.db.blacklist[auraName][id] = nil -- clean out blacklist entry
			end
			self.db.blacklist[auraName] = nil -- remove blacklist entrys
			Srendarr:PopulateFilteredAuras() -- update filtered aura IDs
			CHAT_SYSTEM:AddMessage(string.format('%s: %s %s', L.Srendarr, auraName, L.Blacklist_AuraRemoved)) -- inform user of removal
		end
	end
end


------------------------------------------------------------------------------------------------------------------------------
-- UI HELPER FUNCTIONS
------------------------------------------------------------------------------------------------------------------------------
do
	local math_abs				= math.abs
	local WM					= WINDOW_MANAGER

	function Srendarr:GetEdgeRelativePosition(object)
		local left, top     = object:GetLeft(),		object:GetTop()
		local right, bottom = object:GetRight(),	object:GetBottom()
		local rootW, rootH  = GuiRoot:GetWidth(),	GuiRoot:GetHeight()
		local point         = 0
		local x, y

		if (left < (rootW - right) and left < math_abs((left + right) / 2 - rootW / 2)) then
			x, point = left, 2 -- 'LEFT'
		elseif ((rootW - right) < math_abs((left + right) / 2 - rootW / 2)) then
			x, point = right - rootW, 8 -- 'RIGHT'
		else
			x, point = (left + right) / 2 - rootW / 2, 0
		end

		if (bottom < (rootH - top) and bottom < math_abs((bottom + top) / 2 - rootH / 2)) then
			y, point = top, point + 1 -- 'TOP|TOPLEFT|TOPRIGHT'
		elseif ((rootH - top) < math_abs((bottom + top) / 2 - rootH / 2)) then
			y, point = bottom - rootH, point + 4 -- 'BOTTOM|BOTTOMLEFT|BOTTOMRIGHT'
		else
			y = (bottom + top) / 2 - rootH / 2
		end

		point = (point == 0) and 128 or point -- 'CENTER'
		return point, x, y
	end

	function Srendarr.AddControl(parent, cType, level)
		local c = WM:CreateControl(nil, parent, cType)
		c:SetDrawLayer(DL_OVERLAY)
		c:SetDrawLevel(level)
		return c, c
	end

	function Srendarr:GetGroupBuffTab()
		local groupSize = GetGroupSize()
		if groupSize <= 4 then
			return 11
		elseif groupSize >= 5 then
			return 12
		end
	end

	function Srendarr:GetGroupDebuffTab()
		local groupSize = GetGroupSize()
		if groupSize <= 4 then
			return 13
		elseif groupSize >= 5 then
			return 14
		end
	end

	local function Hide()
		for i = 1, Srendarr.NUM_DISPLAY_FRAMES do
			if Srendarr.displayFrames[i] ~= nil then
				Srendarr.displayFrames[i]:SetHidden(true)
			end
		end
	end
	function Srendarr:HideInMenus() -- hide auras in menus except the move mouse cursor mode (Phinix)
		local hudScene = SCENE_MANAGER:GetScene("hud")
		hudScene:RegisterCallback("StateChange", function(oldState, newState)
			if newState == SCENE_HIDDEN then
				if SCENE_MANAGER:GetNextScene():GetName() ~= "hudui" then
					Srendarr.uiHidden = true
					Hide()
				end
			elseif newState == SCENE_SHOWN then
				Srendarr.uiHidden = false
				Srendarr.OnPlayerActivatedAlive(true, true)
			end
		end)
	end
end


EVENT_MANAGER:RegisterForEvent(Srendarr.name, EVENT_ADD_ON_LOADED, Srendarr.OnInitialize)
EVENT_MANAGER:RegisterForEvent(Srendarr.name, EVENT_PLAYER_ACTIVATED, Srendarr.PlayerLoaded)
