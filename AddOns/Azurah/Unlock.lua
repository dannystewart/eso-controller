local Azurah		= _G['Azurah'] -- grab addon table from global
local L				= Azurah:GetLocale()

-- UPVALUES --
local strformat				= string.format

Azurah.uiFrames = {
	keyboard = {
		['ZO_PlayerAttributeHealth']							= {1, L.Health},
		['ZO_PlayerAttributeSiegeHealth']						= {2, L.HealthSiege},
		['ZO_PlayerAttributeMagicka']							= {1, L.Magicka},
		['ZO_PlayerAttributeWerewolf']							= {2, L.Werewolf},
		['ZO_PlayerAttributeStamina']							= {1, L.Stamina},
		['ZO_PlayerAttributeMountStamina']						= {2, L.StaminaMount},
		['ZO_PlayerProgress']									= {1, L.Experience},
		['ZO_HUDEquipmentStatus']								= {1, L.EquipmentStatus},
		['ZO_SynergyTopLevelContainer']							= {1, L.Synergy},
		['ZO_CompassFrame']										= {1, L.Compass},
		['ZO_TargetUnitFramereticleover']						= {1, L.ReticleOver},
		['ZO_ActionBar1']										= {1, L.ActionBar},
		['PetGroupAnchorFrame']									= {1, L.PetGroup},
		['ZO_SmallGroupAnchorFrame']							= {1, L.Group},
		['ZO_LargeGroupAnchorFrame1']							= {1, L.Raid1},
		['ZO_LargeGroupAnchorFrame2']							= {1, L.Raid2},
		['ZO_LargeGroupAnchorFrame3']							= {1, L.Raid3},
		['ZO_LargeGroupAnchorFrame4']							= {1, L.Raid4},
		['ZO_LargeGroupAnchorFrame5']							= {1, L.Raid5},
		['ZO_LargeGroupAnchorFrame6']							= {1, L.Raid6},
		['ZO_FocusedQuestTrackerPanel']							= {1, L.FocusedQuest, nil, 200},
		['ZO_PlayerToPlayerAreaPromptContainer']				= {1, L.PlayerPrompt, nil, 30},
		['ZO_AlertTextNotification']							= {1, L.AlertText, 600, 56},
		['ZO_CenterScreenAnnounce']								= {1, L.CenterAnnounce, nil, 100},
		['ZO_HUDInfamyMeter']									= {1, L.InfamyMeter},
		['ZO_HUDTelvarMeter']									= {1, L.TelVarMeter},
		['ZO_ActiveCombatTipsTip']								= {1, L.ActiveCombatTips, 250, 20},
		['ZO_TutorialHudInfoTipKeyboard']						= {1, L.Tutorial},
		['ZO_ObjectiveCaptureMeter']							= {1, L.CaptureMeter, 128, 128},
		['Azurah_BagWatcher']									= {1, strformat('[%s] %s', L.Azurah, L.BagWatcher)},
		['Azurah_WerewolfTimer']								= {1, strformat('[%s] %s', L.Azurah, L.WerewolfTimer)},
		['ZO_LootHistoryControl_Keyboard']						= {1, L.LootHistory, 280, 400},
		['ZO_RamTopLevel']										= {1, L.RamSiege},
		['ZO_Subtitles']										= {1, L.Subtitles, 256, 80},
		['Azurah_PlayerBuffs']									= {1, L.PlayerBuffs},
		['Azurah_TargetDebuffs']								= {1, L.TargetDebuffs},
		['ZO_ReticleContainerInteract']							= {1, L.Interact},
		['ZO_ReticleContainerStealthIcon']						= {1, L.StealthIcon, 64, 64},
		['ZO_ReticleContainerReticle']							= {1, L.Reticle},
		['ZO_BattlegroundHUDFragmentTopLevel']					= {1, L.BattlegroundScore},
		['ZO_InteractWindowDivider']							= {1, L.DialogueWindow, 300, 200},
--		['ZO_Character']										= {1, L.PaperDoll, 240, 360},
	},
	gamepad = {
		['ZO_PlayerAttributeHealth']							= {1, L.Health},
		['ZO_PlayerAttributeSiegeHealth']						= {2, L.HealthSiege},
		['ZO_PlayerAttributeMagicka']							= {1, L.Magicka},
		['ZO_PlayerAttributeWerewolf']							= {2, L.Werewolf},
		['ZO_PlayerAttributeStamina']							= {1, L.Stamina},
		['ZO_PlayerAttributeMountStamina']						= {2, L.StaminaMount},
		['ZO_PlayerProgress']									= {1, L.Experience},
		['ZO_HUDEquipmentStatus']								= {1, L.EquipmentStatus},
		['ZO_SynergyTopLevelContainer']							= {1, L.Synergy},
		['ZO_CompassFrame']										= {1, L.Compass},
		['ZO_TargetUnitFramereticleover']						= {1, L.ReticleOver},
		['ZO_ActionBar1']										= {1, L.ActionBar},
		['PetGroupAnchorFrame']									= {1, L.PetGroup},
		['ZO_SmallGroupAnchorFrame']							= {1, L.Group},
		['ZO_FocusedQuestTrackerPanelContainerQuestContainer']	= {1, L.FocusedQuest},
		['ZO_AlertTextNotificationGamepad']						= {1, L.AlertText, 600, 112},
		['ZO_PlayerToPlayerAreaPromptContainer']				= {1, L.PlayerPrompt, nil, 30},
		['ZO_CenterScreenAnnounce']								= {1, L.CenterAnnounce, nil, 100},
		['ZO_HUDInfamyMeter']									= {1, L.InfamyMeter},
		['ZO_HUDTelvarMeter']									= {1, L.TelVarMeter},
		['ZO_ActiveCombatTipsTip']								= {1, L.ActiveCombatTips, 250, 20},
		['ZO_TutorialHudInfoTipGamepad']						= {1, L.Tutorial},
		['ZO_ObjectiveCaptureMeter']							= {1, L.CaptureMeter, 128, 128},
		['Azurah_BagWatcher']									= {1, strformat('[%s] %s', L.Azurah, L.BagWatcher)},
		['Azurah_WerewolfTimer']								= {1, strformat('[%s] %s', L.Azurah, L.WerewolfTimer)},
		['ZO_FocusedQuestTrackerPanelTimerAnchor']				= {1, L.QuestTimer, 128, 128},
--		['ZO_BuffDebuffTopLevelSelfContainer']					= {1, L.PlayerBuffs, 400, 70},
		['Azurah_PlayerBuffs']									= {1, L.PlayerBuffs},
		['Azurah_TargetDebuffs']								= {1, L.TargetDebuffs},
		['ZO_ReticleContainerInteract']							= {1, L.Interact},
		['ZO_ReticleContainerReticle']							= {1, L.Reticle},
		['ZO_ReticleContainerStealthIcon']						= {1, L.StealthIcon, 64, 64},
		['ZO_BattlegroundHUDFragmentTopLevel']					= {1, L.BattlegroundScore},
--		['ZO_Subtitles']										= {1, L.Subtitles, 256, 80},
--		['ZO_LootHistoryControl_Gamepad']						= {1, L.LootHistory, 280, 400},
--		['ZO_RamTopLevel']										= {1, L.RamSiege},
	}
}

local uiPanel
local changesPending = false
local uiFrames = Azurah.uiFrames

-- ---------------------------------
-- BUTTON FLIP ANIMATION OVERRIDE
-- ---------------------------------
local origApplyFlipAnimationStyle = ActionButton.ApplyFlipAnimationStyle

local function ApplyFlipAnimationStyle(self)
	local timeline = self.hotbarSwapAnimation

	if (timeline) then
		local width, height = self.flipCard:GetDimensions()
		local scale = self.flipCard:GetScale()

		width, height = (width / scale) , (height / scale)

		local firstAnimation = timeline:GetFirstAnimation()
		local lastAnimation = timeline:GetLastAnimation()

		firstAnimation:SetStartAndEndWidth(width, width)
		firstAnimation:SetStartAndEndHeight(height, 0)
		lastAnimation:SetStartAndEndWidth(width, width)
		lastAnimation:SetStartAndEndHeight(0, height)
	end
end

-- ---------------------------------
-- ALERT TEXT ALIGNMENT OVERRIDE
-- ---------------------------------
local alertTextAlign = TEXT_ALIGN_RIGHT

local function AlertTextNotificationAlignmentFunc(control, data)
	control:SetWidth(ZO_Compass:GetLeft() - GuiRoot:GetLeft() - 40)
	control:SetText(data.text)
	control:SetColor(data.color:UnpackRGBA())
	control:SetHorizontalAlignment(alertTextAlign)

	ZO_SoundAlert(data.category, data.soundId)
end

local function ConfigureAlertTextNotificationTextAlign(point)
	local line

	if Azurah.db.notificationHAlign == 1 then
		if (point == 2 or point == 3 or point == 6) then -- LEFT or TOPLEFT or BOTTOMLEFT
			alertTextAlign = TEXT_ALIGN_LEFT
		else
			alertTextAlign = TEXT_ALIGN_RIGHT
		end
	elseif Azurah.db.notificationHAlign == 2 then
		alertTextAlign = TEXT_ALIGN_LEFT
	elseif Azurah.db.notificationHAlign == 3 then
		alertTextAlign = TEXT_ALIGN_RIGHT
	elseif Azurah.db.notificationHAlign == 4 then
		alertTextAlign = TEXT_ALIGN_CENTER
	end

	if (not IsInGamepadPreferredMode()) then
		line = ZO_AlertTextNotification:GetChild(1)
	else
		line = ZO_AlertTextNotificationGamepad:GetChild(1)
	end

	line.fadingControlBuffer.anchor = ZO_Anchor:New(point)
end

-- ---------------------------------
-- DEFAULTS
-- ---------------------------------
function Azurah:RestoreDefaultData()
	if (not IsInGamepadPreferredMode()) then
		self.db.uiData.keyboard = {}
	else
		self.db.uiData.gamepad = {}
	end

	ReloadUI('ingame')
end

-- ---------------------------------
-- USER SETTINGS
-- ---------------------------------
function Azurah:RecordUserData(frame, point, x, y, scale)
	if (not IsInGamepadPreferredMode()) then
		if (not self.db.uiData.keyboard) then
			self.db.uiData.keyboard = {}
		end
		if (not self.db.uiData.keyboard[frame]) then
			self.db.uiData.keyboard[frame] = {}
		end

		self.db.uiData.keyboard[frame].point		= point
		self.db.uiData.keyboard[frame].x			= x
		self.db.uiData.keyboard[frame].y			= y
		self.db.uiData.keyboard[frame].scale		= scale
	else
		if (not self.db.uiData.gamepad) then
			self.db.uiData.gamepad = {}
		end
		if (not self.db.uiData.gamepad[frame]) then
			self.db.uiData.gamepad[frame] = {}
		end

		self.db.uiData.gamepad[frame].point		= point
		self.db.uiData.gamepad[frame].x			= x
		self.db.uiData.gamepad[frame].y			= y
		self.db.uiData.gamepad[frame].scale		= scale
	end

	-- special cases
	if (frame == 'ZO_CompassframeName') then
		AZ_MOVED_COMPASS = true	-- GLOBALS FOR WYKKYD
	end

	if (frame == 'ZO_TargetUnitFramereticleover') then
		AZ_MOVED_TARGET = true	-- GLOBALS FOR WYKKYD
	end

	if (frame == 'ZO_PlayerAttributeHealth') then -- scale attached bar
		ZO_PlayerAttributeSiegeHealth:SetScale(scale)
	end

	if (frame == 'ZO_PlayerAttributeMagicka') then -- scale attached bar
		ZO_PlayerAttributeWerewolf:SetScale(scale)
	end

	if (frame == 'ZO_PlayerAttributeStamina') then -- scale attached bar
		ZO_PlayerAttributeMountStamina:SetScale(scale)
	end

	if (frame == 'ZO_AlertTextNotification' or frame == 'ZO_AlertTextNotificationGamepad') then -- configure the alignment of alert text notifications
		ConfigureAlertTextNotificationTextAlign(point)
	end

	if (frame == 'ZO_ActionBar1') then
		if (scale ~= 1) then -- scale of action bar is not the default, replace ActionButton.ApplyFlipAnimationStyle with our own
			ActionButton.ApplyFlipAnimationStyle = ApplyFlipAnimationStyle
		else -- scale is default, ensure original function is in place
			ActionButton.ApplyFlipAnimationStyle = origApplyFlipAnimationStyle
		end
		Azurah:ConfigureActionBarElements()
	end
end

function Azurah:RestoreUserData()
	local obj, userData, framesList

	if (self.db.uiData and not self.db.uiData.keyboard) then
		-- Old data conversion
		self.db.oldData			= self.db.uiData
		self.db.uiData			= nil

		self.db.uiData			= {}
		self.db.uiData.keyboard	= self.db.oldData
		self.db.uiData.gamepad	= {}
		self.db.oldData			= nil
	elseif (not self.db.uiData) then
		-- Create new data
		self.db.uiData			= {}
		self.db.uiData.keyboard	= {}
		self.db.uiData.gamepad	= {}
	end
-- above is reverted on scene change unless UI is reloaded? (Phinix)
-- it seems ZOS internal scene references are not reloading controls
-- when switching between keyboard and gamepad modes

	if (not IsInGamepadPreferredMode()) then
		userData = self.db.uiData.keyboard
		framesList	= uiFrames.keyboard
	else
		userData = self.db.uiData.gamepad
		framesList	= uiFrames.gamepad
	end

	for frame, data in pairs(framesList) do
		if _G[frame] ~= nil then

			obj = _G[frame]

			-- Apply minimum dimensions if needed
			if (data[3] or data[4]) then
				obj:SetDimensionConstraints(data[3], data[4])
			end
	
			-- special cases
			if (frame == 'ZO_PlayerAttributeHealth') then -- scale attached bar
				if (userData[frame]) then
					ZO_PlayerAttributeSiegeHealth:SetScale(userData[frame].scale)
				else
					ZO_PlayerAttributeSiegeHealth:SetScale(1)
				end
			end
	
			if (frame == 'ZO_PlayerAttributeMagicka') then -- scale attached bar
				if (userData[frame]) then
					ZO_PlayerAttributeWerewolf:SetScale(userData[frame].scale)
				else
					ZO_PlayerAttributeWerewolf:SetScale(1)
				end
			end
	
			if (frame == 'ZO_PlayerAttributeStamina') then -- scale attached bar
				if (userData[frame]) then
					ZO_PlayerAttributeMountStamina:SetScale(userData[frame].scale)
				else
					ZO_PlayerAttributeMountStamina:SetScale(1)
				end
			end
	
			if ((frame == 'ZO_AlertTextNotification' or frame == 'ZO_AlertTextNotificationGamepad') and userData[frame]) then
				ConfigureAlertTextNotificationTextAlign(userData[frame].point) -- configure the alignment of alert text notifications
			end
	
			if (frame == 'ZO_ObjectiveCaptureMeter') then
				ZO_ObjectiveCaptureMeterFrame:SetAnchor(BOTTOM, ZO_ObjectiveCaptureMeter, BOTTOM, 0, 0)
			end
	
			if (userData[frame]) then
	
				obj:ClearAnchors()
				obj:SetAnchor(userData[frame].point, GuiRoot, userData[frame].point, userData[frame].x, userData[frame].y)
				obj:SetScale(userData[frame].scale)
	
				if (frame == 'ZO_PlayerAttributeMountStamina') then -- gamepad mod doesn't anchor mount bar (Phinix)
					if (IsInGamepadPreferredMode()) then
						ZO_PlayerAttributeMountStamina:ClearAnchors()
						ZO_PlayerAttributeMountStamina:SetAnchor(TOPLEFT, ZO_PlayerAttributeStamina, BOTTOMLEFT, 0, 0)
					end
				end
	
				if (frame == 'ZO_PlayerAttributeWerewolf') then -- gamepad mod doesn't anchor ww bar (Phinix)
					if (IsInGamepadPreferredMode()) then
						ZO_PlayerAttributeWerewolf:ClearAnchors()
						ZO_PlayerAttributeWerewolf:SetAnchor(TOPRIGHT, ZO_PlayerAttributeMagicka, BOTTOMRIGHT, 0, 0)
					end
				end
	
				if (frame == 'ZO_Subtitles') then -- Fix scaled subtitle background alignment (Phinix)
					local scale = userData[frame].scale
					local bgLeft = _G["ZO_SubtitlesTextBackgroundLeft"]
					local bgRight = _G["ZO_SubtitlesTextBackgroundRight"]
	
					bgLeft:SetDimensionConstraints(0, 0, 64 * scale, 0)
					bgRight:SetDimensionConstraints(0, 0, 64 * scale, 0)
					bgLeft:SetWidth(64 * scale)
					bgRight:SetWidth(64 * scale)
				end
	
				if (frame == 'ZO_CompassFrame') then
					AZ_MOVED_COMPASS = true	-- GLOBALS FOR WYKKYD
				end
	
				if (frame == 'ZO_TargetUnitFramereticleover') then
					AZ_MOVED_TARGET = true	-- GLOBALS FOR WYKKYD
				end
	
				if (frame == 'ZO_ActionBar1' and userData[frame].scale ~= 1) then -- scale of action bar is not the default, replace ActionButton.ApplyFlipAnimationStyle with our own
					ActionButton.ApplyFlipAnimationStyle = ApplyFlipAnimationStyle
				end
			else
				-- Needs updating after adjusting the dimensions when it hasn't been moved before
				if (frame == "ZO_ActiveCombatTips" and not userData[frame]) then
					obj:ClearAnchors()
					obj:SetAnchor(CENTER, GuiRoot, CENTER, 0, 0)
				-- No saved variable data but position/scale changed, reset based on temp values (Phinix)
				elseif Azurah.uiNoData and Azurah.uiNoData[frame] then
					local nFrame = Azurah.uiNoData[frame]
					obj:ClearAnchors()
					obj:SetAnchor(nFrame.nPoint, GuiRoot, nFrame.nPoint, nFrame.nX, nFrame.nY)
					obj:SetScale(1)
				end
			end
		end
	end
end

-- ---------------------------------
-- UNLOCK PANEL
-- ---------------------------------
local function CreateButton(text, anchor, yOffset)
	local btn = WINDOW_MANAGER:CreateControlFromVirtual(nil, uiPanel, 'ZO_DefaultButton')
	btn:SetAnchor(TOP, anchor, BOTTOM, 0, yOffset)
	btn:SetWidth(180)
	btn:SetHeight(24)
	btn:SetFont('$(BOLD_FONT)|16|soft-shadow-thick')
	btn:SetText(text)
	return btn
end

local function BuildUnlockPanel()
	-- base frame setup
	uiPanel = WINDOW_MANAGER:CreateControl(nil, GuiRoot, CT_TOPLEVELCONTROL)
	uiPanel:SetDimensions(180, 193)
	uiPanel:SetAnchor(CENTER, GuiRoot, CENTER, 0, -128)
	uiPanel:SetMouseEnabled(true)
	uiPanel:SetMovable(true)
	uiPanel:SetClampedToScreen(true)
	-- background
	uiPanel.bg = WINDOW_MANAGER:CreateControl(nil, uiPanel, CT_BACKDROP)
	uiPanel.bg:SetAnchorFill(uiPanel)
	uiPanel.bg:SetCenterColor(0, 0, 0, 0.5)
	uiPanel.bg:SetEdgeColor(0,0,0,1)
	uiPanel.bg:SetEdgeTexture('', 8, 8, 1, 0)
	uiPanel.bg:SetInsets(3,3,-3,-3)
	-- header
	uiPanel.header = WINDOW_MANAGER:CreateControl(nil, uiPanel, CT_LABEL)
	uiPanel.header:SetAnchor(TOP, uiPanel, TOP, 0, 4)
	uiPanel.header:SetFont('ZoFontWinH4')
	uiPanel.header:SetText(L.Azurah .. ' - ' .. L.UnlockHeader)
	-- snap button
	uiPanel.snap = CreateButton(L.UnlockGridDisable, uiPanel.header, 2)
	uiPanel.snap:SetHandler('OnClicked', function()
		Azurah.snapToGrid = not Azurah.snapToGrid
		uiPanel.snap:SetText(Azurah.snapToGrid and L.UnlockGridDisable or L.UnlockGridEnable)
	end)
	-- lock button
	uiPanel.lock = CreateButton(L.UnlockLockFrames, uiPanel.snap, 6)
	uiPanel.lock:SetHandler('OnClicked', function()
		Azurah:LockUI(1)
	end)
	-- undo button
	uiPanel.undo = CreateButton(L.UndoChanges, uiPanel.lock, 6)
	uiPanel.undo:SetHandler('OnClicked', function()
		Azurah:LockUI(2)
	end)
	-- exit button
	uiPanel.exit = CreateButton(L.ExitNoSave, uiPanel.undo, 6)
	uiPanel.exit:SetHandler('OnClicked', function()
		Azurah:LockUI(3)
	end)

	-- changes pending warning icon (Phinix)
	Azurah.changesPendingIcon = WINDOW_MANAGER:CreateControl(nil, uiPanel, CT_BUTTON)
	Azurah.changesPendingIcon:SetAnchor(LEFT, uiPanel.lock, RIGHT, 0, 0)
	Azurah.changesPendingIcon:SetWidth(24)
	Azurah.changesPendingIcon:SetHeight(24)
	Azurah.changesPendingIcon:SetNormalTexture("Azurah/changes_pending.dds")
	Azurah.changesPendingIcon:SetMouseOverTexture("Azurah/changes_pending.dds")
	Azurah.changesPendingIcon:SetHandler("OnMouseEnter", function()
		InitializeTooltip(InformationTooltip, Azurah.changesPendingIcon, BOTTOMLEFT, 0, 0, TOPRIGHT)
		SetTooltipText(InformationTooltip, L.ChangesPending)
	end)
	Azurah.changesPendingIcon:SetHandler("OnMouseExit", function()
		ClearTooltip(InformationTooltip)
	end)
	Azurah.changesPendingIcon:SetHidden(true)

	-- reset to defaults button
	uiPanel.reset = CreateButton(L.UnlockReset, uiPanel.exit, 16)
	uiPanel.reset:SetHandler('OnClicked', function()
		uiPanel.confirm:SetHidden(false)
		uiPanel.reset:SetHidden(true)
	end)
	-- reset to defaults confirm button
	uiPanel.confirm = CreateButton(L.UnlockResetConfirm, uiPanel.exit, 16)
	uiPanel.confirm:SetHandler('OnClicked', function()
		changesPending = false
		Azurah:RestoreDefaultData()
		uiPanel.reset:SetHidden(false)
		uiPanel.confirm:SetHidden(true)
	end)
	uiPanel.confirm:SetHidden(true)
	-- handlers
	uiPanel:SetHandler('OnShow', function()
		uiPanel.confirm:SetHidden(true)
		uiPanel.reset:SetHidden(false)

		for _, mover in pairs(Azurah.movers) do
			mover:Show()
		end
	end)
	uiPanel:SetHandler('OnHide', function()
		for _, mover in pairs(Azurah.movers) do
			mover:Hide()
		end
	end)
	uiPanel:SetHandler('OnMouseUp', function()
		uiPanel:StopMovingOrResizing()
	end)

	Azurah.uiPanel = uiPanel
end

function Azurah:LockUI(op) -- op=1 save changes and lock, op=2 undo changes and keep unlocked op=3 exit without save or undo (Phinix)
	self.uiUnlocked = false

	if uiPanel then
		uiPanel:SetHidden(true)
		uiPanel = nil

		Azurah.changesPendingIcon:SetHidden(true)
		Azurah.changesPendingIcon = nil

		local framesList
		if (not IsInGamepadPreferredMode()) then
			framesList = uiFrames.keyboard
		else
			framesList = uiFrames.gamepad
		end
		for frame, data in pairs(framesList) do
			Azurah.movers[frame] = nil
		end
	end

	if op == 1 then -- save changes and lock
		-- Only apply changes to saved variables when UI is locked, allowing cancel changes option (Phinix)
		if Azurah.uiChanges ~= nil then
			for k, v in pairs(Azurah.uiChanges) do
				Azurah:RecordUserData(k, v.cPoint, v.cX, v.cY, v.cScale)
			end
		end
		changesPending = false
	elseif op == 2 then -- undo changes and keep unlocked
		changesPending = false
		Azurah:RestoreUserData()
		Azurah:UnlockUI()
	elseif op == 3 then -- exit without save or undo
		changesPending = true
	end
end

function Azurah:UnlockUI()
	Azurah.uiNoData = {} -- Temp table of position data for frames with no saved variables for cancel changes option (Phinix)

	if Azurah.uiChanges == nil or (not changesPending) then
		Azurah.uiChanges = {} -- Temp table of UI changes for cancel changes option (Phinix)
	end

	if (not uiPanel) then -- first time using the overlays, register!
		BuildUnlockPanel() -- build ui panel

		local mover, userData, framesList

		if (not IsInGamepadPreferredMode()) then
			userData	= (self.db.uiData.keyboard) and self.db.uiData.keyboard or {}
			framesList	= uiFrames.keyboard
		else
			userData	= (self.db.uiData.gamepad) and self.db.uiData.gamepad or {}
			framesList	= uiFrames.gamepad
		end

		for frame, data in pairs(framesList) do
			-- Target frame is anchored to the compass by default in gamepad mode
			if (frame == 'ZO_TargetUnitFramereticleover' and IsInGamepadPreferredMode() and not userData[frame]) then
				_G[frame]:SetAnchor(TOP, GuiRoot, TOP, 0, 140)
			end

			if _G[frame] ~= nil then
				mover = self.Mover:New(_G[frame], data[2])

				if (not userData[frame]) then -- Store position data for frames with no saved variables for cancel changes option (Phinix)
					local point, x, y = Azurah.GetAnchorRelativeToScreen(_G[frame])
					Azurah.uiNoData[frame] = {nPoint = point, nX = x, nY = y}

				end
			end

			if (data[1] == 2) then -- anchored frame, show but disallow drag
				mover:SetMouseEnabled(false)
				mover.overlay:SetCenterColor(0.6, 0.6, 0.6, 0.32)
				mover.overlay:SetEdgeColor(0.6, 0.6, 0.6, 1)
				mover.label:SetColor(0.6, 0.6, 0.6, 1)
			end
		end

		if changesPending then -- show pending changes warning icon/tooltip (Phinix)
			Azurah.changesPendingIcon:SetHidden(false)
		end
	end

	uiPanel:SetHidden(false)

	self.uiUnlocked = true
end

-- ---------------------------------
-- COMPASS PINS
-- ---------------------------------
local compassPinScaleRef

local function OnPinAreaChanged()
	local aQP = COMPASS.areaAnimationPools.areaQuestPins
	local aZP = COMPASS.areaAnimationPools.areaZoneStorySuggestionPins

	if aQP then
		for k, v in pairs(aQP:GetActiveObjects()) do
			v.areaTexture:SetScale(1 / compassPinScaleRef)
		end
	end
	if aZP then
		for k, v in pairs(aZP:GetActiveObjects()) do
			v.areaTexture:SetScale(1 / compassPinScaleRef)
		end
	end
end

function Azurah:ConfigureCompass()
	ZO_Compass:SetScale(self.db.compassPinScale)
	compassPinScaleRef = self.db.compassPinScale

	if (self.db.compassPinScale == 1) then -- default size
		EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_PLAYER_IN_PIN_AREA_CHANGED) -- unregister check event
		EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_QUEST_POSITION_REQUEST_COMPLETE) -- unregister check event
	else -- non-default size
		EVENT_MANAGER:RegisterForEvent(self.name,	EVENT_PLAYER_IN_PIN_AREA_CHANGED,		OnPinAreaChanged)
		EVENT_MANAGER:RegisterForEvent(self.name,	EVENT_QUEST_POSITION_REQUEST_COMPLETE,	OnPinAreaChanged)
	end

	OnPinAreaChanged()

	if (self.db.compassHidePinLabel) then
		ZO_CompassCenterOverPinLabel:SetHidden(true)
		ZO_CompassCenterOverPinLabel:SetAlpha(0)
	else
		ZO_CompassCenterOverPinLabel:SetHidden(false)
		ZO_CompassCenterOverPinLabel:SetAlpha(1)
	end
end

-- ---------------------------------
-- INITIALIZATION
-- ---------------------------------
local function ApplyTemplateHook(obj, funcName, controlName)
	local origFunc = obj[funcName]

	obj[funcName] = function(self)
		local result, data

		result = origFunc(self)

		if not IsInGamepadPreferredMode() then
			data = Azurah.db.uiData.keyboard[controlName]
		else
			data = Azurah.db.uiData.gamepad[controlName]
		end

		if data then
			_G[controlName]:ClearAnchors()
			_G[controlName]:SetAnchor(data.point, GuiRoot, data.point, data.x, data.y)
			_G[controlName]:SetScale(data.scale)
		end

		return result
	end
end

function Azurah:InitializeUnlock()
	local uiData

	-- replace Alert Text Notification function with our own variable text alignment func.
	local line, AlertTextNotification

	if not IsInGamepadPreferredMode() then
		local line = ZO_AlertTextNotification:GetChild(1)

		if (not line) then
			ZO_Alert(UI_ALERT_CATEGORY_ALERT, nil, ' ')
			line = ZO_AlertTextNotification:GetChild(1)
		end

		line.fadingControlBuffer.templates.ZO_AlertLine.setup = AlertTextNotificationAlignmentFunc
	else
		local line = ZO_AlertTextNotificationGamepad:GetChild(1)

		if (not line) then
			ZO_Alert(UI_ALERT_CATEGORY_ALERT, nil, ' ')
			line = ZO_AlertTextNotificationGamepad:GetChild(1)
		end

		line.fadingControlBuffer.templates.ZO_AlertLineGamepad.setup = AlertTextNotificationAlignmentFunc
	end

	-- Create a custom control to hold the player buffs/debuffs
	local playerBuffsControl = _G["Azurah_PlayerBuffs"]
	if not playerBuffsControl then
		playerBuffsControl = WINDOW_MANAGER:CreateControl("Azurah_PlayerBuffs", GuiRoot, CT_CONTROL)
	end

	playerBuffsControl:SetDimensions(400, 70)
	playerBuffsControl:SetDrawLayer(DL_CONTROLS)
	playerBuffsControl:SetAnchor(CENTER, ZO_PlayerAttribute, TOP, 0, -40)

	ZO_BuffDebuffTopLevelSelfContainer:ClearAnchors()
	ZO_BuffDebuffTopLevelSelfContainer:SetAnchor(CENTER, playerBuffsControl, CENTER, 0, 0)

	-- Create a custom control to hold the target debuffs
	targetDebuffsControl = _G["Azurah_TargetDebuffs"]
	if not targetDebuffsControl then
		targetDebuffsControl = WINDOW_MANAGER:CreateControl("Azurah_TargetDebuffs", GuiRoot, CT_CONTROL)
	end

	targetDebuffsControl:SetDimensions(400, 70)
	targetDebuffsControl:SetDrawLayer(DL_CONTROLS)
	targetDebuffsControl:SetAnchor(CENTER, ZO_TargetUnitFramereticleover, BOTTOM, 0, 40)

	ZO_BuffDebuffTopLevelTargetContainer:ClearAnchors()
	ZO_BuffDebuffTopLevelTargetContainer:SetAnchor(CENTER, targetDebuffsControl, CENTER, 0, 0)

	self:RestoreUserData()

	if not IsInGamepadPreferredMode() then
		uiData = (self.db.uiData.keyboard) and self.db.uiData.keyboard or {}
	else
		uiData = (self.db.uiData.gamepad) and self.db.uiData.gamepad or {}
	end

	ZO_PreHookHandler(ZO_ActionBar1, 'OnShow', function()
		if (uiData['ZO_ActionBar1']) then -- user has moved the action bar
			if (ZO_Skills:IsHidden()) then -- restore to user location on skill window close
				local data = uiData['ZO_ActionBar1']
				ZO_ActionBar1:ClearAnchors()
				ZO_ActionBar1:SetAnchor(data.point, GuiRoot, data.point, data.x, data.y)
				ZO_ActionBar1:SetScale(data.scale)
			else -- skill window is open, restore default scale (window is moved by stock code)
				ZO_ActionBar1:SetScale(1)
			end
		end
	end)

	ZO_PreHookHandler(ZO_Skills, 'OnShow', function()
		if (uiData['ZO_ActionBar1']) then -- user moved the action bar, make sure to move it to its proper place when skill window is open
			ZO_ActionBar1:SetScale(1)
			ZO_ActionBar1:ClearAnchors()
			ZO_ActionBar1:SetAnchor(BOTTOM, ZO_Skills, BOTTOM, -40, 40)
		end
	end)

	local function manageDialogueFrame()
		local frame = 'ZO_InteractWindowDivider'
		local userData, framesList
		if (not IsInGamepadPreferredMode()) then
			userData = Azurah.db.uiData.keyboard
			framesList	= uiFrames.keyboard
		else
			userData = Azurah.db.uiData.gamepad
			framesList	= uiFrames.gamepad
		end
		if (userData[frame]) then
			ZO_InteractWindowDivider:ClearAnchors()
			ZO_InteractWindowDivider:SetAnchor(userData[frame].point, GuiRoot, userData[frame].point, userData[frame].x, userData[frame].y)
			ZO_InteractWindowDivider:SetScale(userData[frame].scale)
		end
	end

	ZO_PreHook(ZO_Interaction, 'AnchorBottomBG', -- special case to allow dialogue frame to be movable (Phinix)
	function(self, optionControl)
		local guiHM = GuiRoot:GetHeight() / 2
		local divY = ZO_InteractWindowDivider:GetTop() + (ZO_InteractWindowDivider:GetHeight() / 2)
		local osY = (divY > guiHM) and divY - guiHM or (guiHM - divY) * -1
		local control = self.control:GetNamedChild("BottomBG")
		manageDialogueFrame()
		ZO_InteractWindowBottomBG:ClearAnchors()
		ZO_InteractWindowBottomBG:SetAnchor(TOPRIGHT, GuiRoot, RIGHT, 0, osY)
		ZO_InteractWindowBottomBG:SetAnchor(BOTTOMLEFT, optionControl, BOTTOMLEFT, -40, 120)
		ZO_InteractWindowTopBG:ClearAnchors()
		ZO_InteractWindowTopBG:SetAnchor(TOPLEFT, ZO_InteractWindowTargetAreaTitle, TOPLEFT, -10, -120)
		ZO_InteractWindowTopBG:SetAnchor(BOTTOMRIGHT, GuiRoot, RIGHT, 0, osY)
		return true
	end)

	-- prevent dialogue frame position resetting/bugging when alt-tab is used before opening dialogue (Phinix)
	local interactionOnResize = ZO_Interaction.OnScreenResized
	ZO_Interaction.OnScreenResized = function(self,...)
		interactionOnResize(self,...)
		manageDialogueFrame()
	end

	--reapply user settings after template change
	ApplyTemplateHook(ACTIVE_COMBAT_TIP_SYSTEM, 'ApplyStyle', 'ZO_ActiveCombatTips')
	ApplyTemplateHook(CENTER_SCREEN_ANNOUNCE, 'ApplyStyle', 'ZO_CenterScreenAnnounce')
	ApplyTemplateHook(COMPASS_FRAME, 'ApplyStyle', 'ZO_CompassFrame')
	ApplyTemplateHook(PLAYER_PROGRESS_BAR, 'RefreshTemplate', 'ZO_PlayerProgressBar')

	self:ConfigureCompass()
end
