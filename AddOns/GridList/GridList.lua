local ADDON_NAME			= "GridList"
local ADDON_AUTHOR			= "@KL1SK"
local ADDON_WEBSITE			= "https://www.esoui.com/downloads/info2341-GridList.html"

GridList = {}
local GL = GridList
GL.SV = {}
local SV = GL.SV
local SV_VER = 3

GL.media = {
	--
	name_backdrop = {
		"GridList",
		"Clean",
	},
	backdrop = {
		"GridList/textures/backdrop.dds",
		"",
	},
	--
	name_edge = {
		"GridList",
		"Clean",
	},
	edge = {
		"GridList/textures/edge.dds",
		"",
	},
	--
	fonts_shadows = {"outline", "thick-outline", "shadow", "soft-shadow-thin", "soft-shadow-thick"},
	--
	button = {
		list = "GridList/textures/list.dds",
		grid = "GridList/textures/grid.dds",
	}
}
GL.media.fonts = {
	"$(MEDIUM_FONT)",
	"$(BOLD_FONT)",
	"$(ANTIQUE_FONT)",
	"$(STONE_TABLET_FONT)",
	"$(HANDWRITTEN_FONT)",
	"$(GAMEPAD_LIGHT_FONT)",
	"$(GAMEPAD_MEDIUM_FONT)",
	"$(GAMEPAD_BOLD_FONT)",
}

local media = GL.media
local name_backdrop, backdrop, name_edge, edge, button_list, button_grid = media.name_backdrop, media.backdrop, media.name_edge, media.edge, media.button.list, media.button.grid

local LIST, GRID = 1, 3
local ResetScaleAnimation
local RefreshMode
local stackFontStyle

local panelData, optionsData, DEF
local function Settings()
	DEF = {
		-- list.mode ------------------------------------------------------------------------------
		[1] = LIST, [2] = LIST, [3] = LIST, [4] = LIST, [5] = LIST, [6] = LIST, [7] = LIST, [8] = LIST, [9] = LIST, [10] = LIST, [11] = LIST,
		-------------------------------------------------------------------------------------------
		skin_backdrop					= "GridList/textures/backdrop.dds",
		skin_backdrop_insets			= 0,
		slot_backdrop_col				= {20/255, 20/255, 20/255, 1},
		skin_edge						= "GridList/textures/edge.dds",
		skin_edge_thickness				= 20,
		skin_edge_file_width			= 128,
		skin_edge_file_height			= 16,
		-------------------------------------------------------------------------------------------
		slot_size						= 64,
		slot_spacing					= 5,

		slot_highlight_col				= {96/255, 125/255, 139/255, 1},

		edge_quality_trash_col			= {30/255, 30/255, 30/255, .6},
		edge_quality_normal_col			= {80/255, 80/255, 80/255, .6},
		edge_quality_a					= .6,
		edge_quality_b					= 1,

		icon_size						= 38,

		icon_anim						= true,
		anim_duration					= 125,
		anim_scale						= 1.4,

		tooltip_near_slot				= false,

		status_icon_tooltip				= false,
		status_icon_size				= 22,
		status_icon_x					= 1,
		status_icon_y					= 1,
		status_icon_a					= 0.8,

		trait_icon_tooltip				= false,
		trait_icon_size					= 24,
		trait_icon_x					= 0,
		trait_icon_y					= 0,
		trait_icon_a					= 0.9,

		stack_font						= GL.media.fonts[2],
		stack_font_shadow				= GL.media.fonts_shadows[1],
		stack_font_style_a				= 0.5,
		stack_font_size					= 15,
		stack_font_a					= 1,
		stack_font_x					= -4,
		stack_font_y					= -1,

		pre_create_lists				= false,
	}
	GL.SV = ZO_SavedVars:NewAccountWide(ADDON_NAME .. "_SV", SV_VER, nil, DEF)

	if not LibAddonMenu2 then return end

	panelData = {
		type							= "panel",
		name							= ADDON_NAME,
		author							= ADDON_AUTHOR,
		website							= ADDON_WEBSITE,
		slashCommand					= "/gridlist",
		registerForRefresh				= true,
		registerForDefaults				= true,
	}
	optionsData = {
		{	type = "submenu", name = "Skins",
			controls = {
				{	type = "header", name = "Backdrop", },
				{	type				= 'iconpicker',
					name				= "Backdrop",
					choices				= backdrop,
					choicesTooltips		= name_backdrop,
					getFunc				= function() return GL.SV.skin_backdrop end,
					setFunc				= function(str) GL.SV.skin_backdrop = str RefreshMode(INVENTORY_BACKPACK) end,
					maxColumns			= 3,
					visibleRows			= 5,
					iconSize			= 52,
					default				= DEF.skin_backdrop,
					width				= "half",
				},
				{	type 				= "slider", name = "Insets",
					max					= 100, min = 0,
					getFunc				= function() return GL.SV.skin_backdrop_insets end,
					setFunc				= function(value) GL.SV.skin_backdrop_insets = value RefreshMode(INVENTORY_BACKPACK) end,
					default				= DEF.skin_backdrop_insets,
					width				= "half",
				},
				{	type				= "colorpicker", name = "Color",
					getFunc				= function() return unpack(GL.SV.slot_backdrop_col) end,
					setFunc				= function(r, g, b, a) GL.SV.slot_backdrop_col = { r, g, b, a } RefreshMode(INVENTORY_BACKPACK) end,
					width				= "half",
					default				= {r = DEF.slot_backdrop_col[1], g = DEF.slot_backdrop_col[2], b = DEF.slot_backdrop_col[3], a = DEF.slot_backdrop_col[4]},
				},
				{	type				= "colorpicker", name = "Highlight color",
					getFunc				= function() return unpack(GL.SV.slot_highlight_col) end,
					setFunc				= function(r, g, b, a) GL.SV.slot_highlight_col = { r, g, b, a } RefreshMode(INVENTORY_BACKPACK) end,
					width				= "half",
					default				= {r = DEF.slot_highlight_col[1], g = DEF.slot_highlight_col[2], b = DEF.slot_highlight_col[3], a = DEF.slot_highlight_col[4]},
				},
				{	type = "header", name = "Edge", },
				{	type				= 'iconpicker',
					name				= "Edge",
					choices				= edge,
					choicesTooltips		= name_edge,
					getFunc				= function() return GL.SV.skin_edge end,
					setFunc				= function(str) GL.SV.skin_edge = str RefreshMode(INVENTORY_BACKPACK) end,
					maxColumns			= 3,
					visibleRows			= 5,
					iconSize			= 52,
					default				= DEF.skin_edge,
					width				= "half",
				},
				{	type 				= "slider", name = "Thickness",
					max					= 100, min = 1,
					getFunc				= function() return GL.SV.skin_edge_thickness end,
					setFunc				= function(value) GL.SV.skin_edge_thickness = value RefreshMode(INVENTORY_BACKPACK) end,
					default				= DEF.skin_edge_thickness,
					width				= "half",
				},
				{	type				= 'dropdown',
					name				= "File Width",
					choices				= {2, 4, 8, 16, 32, 64, 128, 256, 512, 1024},
					getFunc				= function() return GL.SV.skin_edge_file_width end,
					setFunc				= function(value) GL.SV.skin_edge_file_width = value end,
					default				= DEF.skin_edge_file_width,
					width				= "half",
				},
				{	type				= 'dropdown',
					name				= "File Height",
					choices				= {2, 4, 8, 16, 32, 64, 128, 256, 512, 1024},
					getFunc				= function() return GL.SV.skin_edge_file_height end,
					setFunc				= function(value) GL.SV.skin_edge_file_height = value end,
					default				= DEF.skin_edge_file_height,
					width				= "half",
				},
				{	type = "header", name = "Edge: quality color", },
				{	type				= "colorpicker", name = "'Trash'",
					getFunc				= function() return unpack(GL.SV.edge_quality_trash_col) end,
					setFunc				= function(r, g, b, a) GL.SV.edge_quality_trash_col = { r, g, b, a } RefreshMode(INVENTORY_BACKPACK) end,
					width				= "half",
					default				= {r = DEF.edge_quality_trash_col[1], g = DEF.edge_quality_trash_col[2], b = DEF.edge_quality_trash_col[3], a = DEF.edge_quality_trash_col[4]},
				},
				{	type				= "colorpicker", name = "'Normal'",
					getFunc				= function() return unpack(GL.SV.edge_quality_normal_col) end,
					setFunc				= function(r, g, b, a) GL.SV.edge_quality_normal_col = { r, g, b, a } RefreshMode(INVENTORY_BACKPACK) end,
					width				= "half",
					default				= {r = DEF.edge_quality_normal_col[1], g = DEF.edge_quality_normal_col[2], b = DEF.edge_quality_normal_col[3], a = DEF.edge_quality_normal_col[4]},
				},
				{	type				= "slider", name = "Brightness (1.x)",
					tooltip				= "Except: 'Trash' and 'Normal'",
					min					= 0.0, max = 1.0, step = 0.01, decimals = 2,
					getFunc				= function() return GL.SV.edge_quality_b end,
					setFunc				= function(value) GL.SV.edge_quality_b = value RefreshMode(INVENTORY_BACKPACK) end,
					width				= "half",
					default				= DEF.edge_quality_b,
				},
				{	type				= "slider", name = "Transparency (1.x)",
					tooltip				= "Except: 'Trash' and 'Normal'",
					min					= 0.0, max = 1.0, step = 0.01, decimals = 2,
					getFunc				= function() return GL.SV.edge_quality_a end,
					setFunc				= function(value) GL.SV.edge_quality_a = value RefreshMode(INVENTORY_BACKPACK) end,
					width				= "half",
					default				= DEF.edge_quality_a,
				},
			},
		},
		{	type = "header", name = "Slot", },
		{	type 				= "slider", name = "Size",
			max					= 100, min = 30,
			getFunc				= function() return GL.SV.slot_size end,
			setFunc				= function(value) GL.SV.slot_size = value RefreshMode(INVENTORY_BACKPACK) end,
			default				= DEF.slot_size,
		},
		{	type				= "slider", name = "Spacing",
			max					= 50, min = 0,
			getFunc				= function() return GL.SV.slot_spacing end,
			setFunc				= function(value) GL.SV.slot_spacing = value RefreshMode(INVENTORY_BACKPACK) end,
			default				= DEF.slot_spacing,
		},
		{	type				= "checkbox", name = "Tooltip near the slot",
			getFunc				= function() return GL.SV.tooltip_near_slot end,
			setFunc				= function(value) GL.SV.tooltip_near_slot = value RefreshMode(INVENTORY_BACKPACK) end,
			default				= DEF.tooltip_near_slot,
		},
		{	type = "header", name = "Icon", },
		{	type				= "slider", name = "Size",
			max					= 100, min = 10,
			getFunc				= function() return GL.SV.icon_size end,
			setFunc				= function(value) GL.SV.icon_size = value RefreshMode(INVENTORY_BACKPACK) end,
			default				= DEF.icon_size,
		},
		{	type				= "checkbox", name = "MouseOver animation",
			getFunc				= function() return GL.SV.icon_anim end,
			setFunc				= function(value) GL.SV.icon_anim = value ResetScaleAnimation() end,
			default				= DEF.icon_anim,
		},
		{	type				= "slider", name = "MouseOver animation: Scale (1.x)",
			min					= 1.0, max = 2.0, step = 0.01, decimals = 2,
			getFunc				= function() return GL.SV.anim_scale end,
			setFunc				= function(value) GL.SV.anim_scale = value ResetScaleAnimation() end,
			default				= DEF.anim_scale,
			disabled			= function() return not GL.SV.icon_anim end,
		},
		{	type				= "slider", name = "MouseOver animation: Duration (ms)",
			max					= 1000, min = 0,
			getFunc				= function() return GL.SV.anim_duration end,
			setFunc				= function(value) GL.SV.anim_duration = value ResetScaleAnimation() end,
			default				= DEF.anim_duration,
			disabled			= function() return not GL.SV.icon_anim end,
		},
		{	type = "header", name = "Status icon", },
		{	type				= "checkbox", name = "Enable tooltip",
			getFunc				= function() return GL.SV.status_icon_tooltip end,
			setFunc				= function(value) GL.SV.status_icon_tooltip = value RefreshMode(INVENTORY_BACKPACK) end,
			default				= DEF.status_icon_tooltip,
		},
		{	type				= "slider", name = "Size",
			max					= 50, min = 2,
			getFunc				= function() return GL.SV.status_icon_size end,
			setFunc				= function(value) GL.SV.status_icon_size = value RefreshMode(INVENTORY_BACKPACK) end,
			default				= DEF.status_icon_size,
		},
		{	type				= "slider", name = "Transparency (1.x)",
			min					= 0.0, max = 1.0, step = 0.01, decimals = 2,
			getFunc				= function() return GL.SV.status_icon_a end,
			setFunc				= function(value) GL.SV.status_icon_a = value RefreshMode(INVENTORY_BACKPACK) end,
			default				= DEF.status_icon_a,
		},
		{	type				= "slider", name = "                        Position X",
			max					= 100, min = -100,
			getFunc				= function() return GL.SV.status_icon_x end,
			setFunc				= function(value) GL.SV.status_icon_x = value RefreshMode(INVENTORY_BACKPACK) end,
			width				= "half",
			default				= DEF.status_icon_x,
		},
		{	type				= "slider", name = "                        Position Y",
			max					= 100, min = -100,
			getFunc				= function() return GL.SV.status_icon_y end,
			setFunc				= function(value) GL.SV.status_icon_y = value RefreshMode(INVENTORY_BACKPACK) end,
			width				= "half",
			default				= DEF.status_icon_y,
		},
		{	type = "header", name = "Trait icon", },
		{	type				= "checkbox", name = "Enable tooltip",
			getFunc				= function() return GL.SV.trait_icon_tooltip end,
			setFunc				= function(value) GL.SV.trait_icon_tooltip = value RefreshMode(INVENTORY_BACKPACK) end,
			default				= DEF.trait_icon_tooltip,
		},
		{	type				= "slider", name = "Size",
			max					= 50, min = 2,
			getFunc				= function() return GL.SV.trait_icon_size end,
			setFunc				= function(value) GL.SV.trait_icon_size = value RefreshMode(INVENTORY_BACKPACK) end,
			default				= DEF.trait_icon_size,
		},
		{	type				= "slider", name = "Transparency (1.x)",
			min					= 0.0, max = 1.0, step = 0.01, decimals = 2,
			getFunc				= function() return GL.SV.trait_icon_a end,
			setFunc				= function(value) GL.SV.trait_icon_a = value RefreshMode(INVENTORY_BACKPACK) end,
			default				= DEF.trait_icon_a,
		},
		{	type				= "slider", name = "                        Position X",
			max					= 100, min = -100,
			getFunc				= function() return GL.SV.trait_icon_x end,
			setFunc				= function(value) GL.SV.trait_icon_x = value RefreshMode(INVENTORY_BACKPACK) end,
			width				= "half",
			default				= DEF.trait_icon_x,
		},
		{	type				= "slider", name = "                        Position Y",
			max					= 100, min = -100,
			getFunc				= function() return GL.SV.trait_icon_y end,
			setFunc				= function(value) GL.SV.trait_icon_y = value RefreshMode(INVENTORY_BACKPACK) end,
			width				= "half",
			default				= DEF.trait_icon_y,
		},
		{	type = "header", name = "Stack Count", },
		{	type				= 'dropdown',
			name				= "Font",
			choices				= GL.media.fonts,
			getFunc				= function() return GL.SV.stack_font end,
			setFunc				= function(str) GL.SV.stack_font = str
												stackFontStyle = string.format("%s|%s|%s", GL.SV.stack_font, GL.SV.stack_font_size, GL.SV.stack_font_shadow)
												RefreshMode(INVENTORY_BACKPACK) end,
			default				= DEF.stack_font,
		},
		{	type				= 'dropdown',
			name				= "Shadow",
			choices				= GL.media.fonts_shadows,
			getFunc				= function() return GL.SV.stack_font_shadow end,
			setFunc				= function(str) GL.SV.stack_font_shadow = str
												stackFontStyle = string.format("%s|%s|%s", GL.SV.stack_font, GL.SV.stack_font_size, GL.SV.stack_font_shadow)
												RefreshMode(INVENTORY_BACKPACK) end,
			default				= DEF.stack_font_shadow,
		},
		{	type				= "slider", name = "Shadow transparency(1.x)",
			min					= 0.0, max = 1.0, step = 0.01, decimals = 2,
			getFunc				= function() return GL.SV.stack_font_style_a end,
			setFunc				= function(value) GL.SV.stack_font_style_a = value RefreshMode(INVENTORY_BACKPACK) end,
			default				= DEF.stack_font_style_a,
		},
		{	type				= "slider", name = "Font size",
			max					= 100, min = 1,
			getFunc				= function() return GL.SV.stack_font_size end,
			setFunc				= function(value) GL.SV.stack_font_size = value
												  stackFontStyle = string.format("%s|%s|%s", GL.SV.stack_font, GL.SV.stack_font_size, GL.SV.stack_font_shadow)
												  RefreshMode(INVENTORY_BACKPACK) end,
			default				= DEF.stack_font_size,
		},
		{	type				= "slider", name = "Font transparency (1.x)",
			min					= 0.0, max = 1.0, step = 0.01, decimals = 2,
			getFunc				= function() return GL.SV.stack_font_a end,
			setFunc				= function(value) GL.SV.stack_font_a = value RefreshMode(INVENTORY_BACKPACK) end,
			default				= DEF.stack_font_a,
		},
		{	type				= "slider", name = "                        Position X",
			max					= 100, min = -100,
			getFunc				= function() return GL.SV.stack_font_x end,
			setFunc				= function(value) GL.SV.stack_font_x = value RefreshMode(INVENTORY_BACKPACK) end,
			width				= "half",
			default				= DEF.stack_font_x,
		},
		{	type				= "slider", name = "                        Position Y",
			max					= 100, min = -100,
			getFunc				= function() return GL.SV.stack_font_y end,
			setFunc				= function(value) GL.SV.stack_font_y = value RefreshMode(INVENTORY_BACKPACK) end,
			width				= "half",
			default				= DEF.stack_font_y,
		},
		{	type = "header", name = "Additional", },
		{	type				= "checkbox", name = "Pre-create lists",
			tooltip				= "Pre-creating lists to avoid delays on first access. (backpack, quest item, craft bag, bank, house bank, guild bank) May increase game loading time (~0-5 sec).",
			getFunc				= function() return GL.SV.pre_create_lists end,
			setFunc				= function(value) GL.SV.pre_create_lists = value end,
			default				= DEF.pre_create_lists,
			requiresReload		= true,
		},
	}
--===============================================================================================--
	LibAddonMenu2:RegisterAddonPanel(ADDON_NAME .. "Options", panelData)
	LibAddonMenu2:RegisterOptionControls(ADDON_NAME .. "Options", optionsData)

	CALLBACK_MANAGER:RegisterCallback("LAM-PanelOpened", function(panel)
		if panel ~= GridListOptions then return end
		SCENE_MANAGER:GetScene('gameMenuInGame'):AddFragment(INVENTORY_FRAGMENT)
		SCENE_MANAGER:GetScene('gameMenuInGame'):AddFragment(RIGHT_PANEL_BG_FRAGMENT)
	end)
	CALLBACK_MANAGER:RegisterCallback("LAM-PanelClosed", function(panel)
		if panel ~= GridListOptions then return end
		SCENE_MANAGER:GetScene('gameMenuInGame'):RemoveFragment(INVENTORY_FRAGMENT)
		SCENE_MANAGER:GetScene('gameMenuInGame'):RemoveFragment(RIGHT_PANEL_BG_FRAGMENT)
	end)
end

local list = {
	[1]		= INVENTORY_BACKPACK,
	[2] 	= INVENTORY_QUEST_ITEM,
	[3] 	= INVENTORY_BANK,
	[4] 	= INVENTORY_HOUSE_BANK,
	[5] 	= INVENTORY_GUILD_BANK,
	[6] 	= INVENTORY_CRAFT_BAG,
	[7] 	= QUICKSLOT_WINDOW,
	[8] 	= STORE_WINDOW,
	[9] 	= BUY_BACK_WINDOW,
	[10]	= REPAIR_WINDOW,
	[11]	= ZO_RETRAIT_KEYBOARD.inventory,
}

local function GetList(inventoryType)
	local inventoryList
	if inventoryType > 6 then
		inventoryList = list[inventoryType].list
	else
		inventoryList = PLAYER_INVENTORY.inventories[list[inventoryType]].listView
	end
	return inventoryList
end

--ANIMATION-- --IconSlotMouseOverAnimation--
local ScaleAnimation  = ZO_ReversibleAnimationProvider:New("IconSlotMouseOverAnimation")
local animPool = ScaleAnimation.animationPool

ResetScaleAnimation = function() --local defined above
	ZO_ClearTable(animPool.m_Free)
end

local exCustomFactoryBehavior = animPool.customFactoryBehavior
animPool:SetCustomFactoryBehavior(function(animationTimeline, ...)
	exCustomFactoryBehavior(animationTimeline, ...)
	local anim = animationTimeline:GetAnimation()
	anim:SetDuration(GL.SV.anim_duration)
	anim:SetStartScale(1)
	anim:SetEndScale(GL.SV.anim_scale)
end)

local function CustomTooltipAnchor(tooltipUsed, buttonPart, ComparativeTooltip1, ComparativeTooltip2)
	local parent = buttonPart:GetParent()
	local --[[#1]] _, _, _, _, x = parent:GetAnchor()
	tooltipUsed:SetOwner(parent, RIGHT, -5 - x, 0)

	ComparativeTooltip1:SetOwner(tooltipUsed, TOPRIGHT, -10, 0)
	ComparativeTooltip2:SetOwner(ComparativeTooltip1, TOPRIGHT, -10, 0)
end

local function CreateBackdrop(control)
	if control.backdrop then return control.backdrop end

	control.backdrop = CreateControl("$(parent)Backdrop", control, CT_BACKDROP)

	local backdrop = control.backdrop

	backdrop:SetAnchorFill(control)
	backdrop:SetDrawLayer(0)
	backdrop:SetDrawLevel(0)
	backdrop:SetDrawTier(0)

	return control.backdrop
end

local function Core()
	local rowW, rowH, button, stack, name, status, sell, sellInfo, trait, bg, hl, backdrop

	SecurePostHook("ZO_Store_OnEntryMouseEnter", function(storeEntrySlot)
		local sellPrice = storeEntrySlot and GetControl(storeEntrySlot, "SellPrice")
		if sellPrice and sellPrice:IsHidden() then
			local text = sellPrice:GetText():gsub("|t.-:.-:", "|t18:18:")
			local r, g, b = sellPrice:GetColor()
			ItemTooltip:AddVerticalPadding(12)
			ItemTooltip:AddLine("|t36:36:/esoui/art/vendor/vendor_tabicon_buy_up.dds|t" .. text, "", r, g, b, CENTER, MODIFY_TEXT_TYPE_NONE, TEXT_ALIGN_CENTER, true)
		end
	end)

	ZO_PreHook("ZO_InventorySlot_SetControlScaledUp", function(control, scaledUp, instant)
		local gridListId	= control		and control:GetParent():GetParent()["gridListId"]	or nil
		local list			= gridListId	and GetList(gridListId)								or nil

		if list and list.mode == GRID then
			if not GL.SV.icon_anim then return true end
			if scaledUp then
				ScaleAnimation:PlayForward(control, instant)
			else
				ScaleAnimation:PlayBackward(control, instant)
			end
			return true
		end
	end)

	ZO_PreHook("ZO_InventorySlot_SetHighlightHidden", function(listPart, hidden, instant)
		local gridListId	= listPart		and listPart:GetParent()["gridListId"]	or nil
		local list			= gridListId	and GetList(gridListId)					or nil

		if list and list.mode == GRID then
			local backdrop = listPart.backdrop
			if backdrop then
				if hidden then
					backdrop:SetCenterColor(GL.SV.slot_backdrop_col[1], GL.SV.slot_backdrop_col[2], GL.SV.slot_backdrop_col[3], GL.SV.slot_backdrop_col[4])
				else
					backdrop:SetCenterColor(GL.SV.slot_highlight_col[1], GL.SV.slot_highlight_col[2], GL.SV.slot_highlight_col[3], GL.SV.slot_highlight_col[4])
				end
			end
			return true
		end
	end)

	local function ModeChangeButton(inventoryType)
		local control = GetList(inventoryType)

		local mcb = CreateControl("$(parent)ModeChangeButton", control, CT_BUTTON)
		mcb:SetDimensions(16, 16)
		mcb:SetAnchor(TOPLEFT, control, TOPLEFT, 10, -50)
		mcb:SetAlpha(.4)

		control["mode"] = GL.SV[inventoryType]
		mcb:SetNormalTexture(control.mode == LIST and button_grid or control.mode == GRID and button_list)
		if control.mode == GRID then
			control.useFadeGradient = true
			ZO_Scroll_SetMaxFadeDistance(control, 10)
		else
			if PP then
				ZO_Scroll_SetMaxFadeDistance(control, PP.SV.list_skin.list_fade_distance)
			else
				ZO_Scroll_SetMaxFadeDistance(control, 64)
			end
		end

		mcb:SetHandler("OnMouseEnter", function()
			mcb:SetAlpha(.9)
		end)
		mcb:SetHandler("OnMouseExit", function()
			mcb:SetAlpha(.4)
		end)
		mcb:SetHandler("OnClicked", function()
			if control.mode == LIST then
				control.mode = GRID
				GL.SV[inventoryType] = 3
				mcb:SetNormalTexture(button_list)

				control.useFadeGradient = true
				ZO_Scroll_SetMaxFadeDistance(control, 10)

				RefreshMode(inventoryType)
			elseif control.mode == GRID then
				control.mode = LIST
				GL.SV[inventoryType] = 1
				mcb:SetNormalTexture(button_grid)

				if PP then
					ZO_Scroll_SetMaxFadeDistance(control, PP.SV.list_skin.list_fade_distance)
				else
					ZO_Scroll_SetMaxFadeDistance(control, 64)
				end

				RefreshMode(inventoryType)
			end
		end)
	end

	local function RefreshControlMode_1(control, data, dataType)
		local backdrop	= CreateBackdrop(control)
		local button	= control:GetNamedChild("Button")
		local stack		= control:GetNamedChild("ButtonStackCount")
		local name		= control:GetNamedChild("Name")
		local status	= control:GetNamedChild("Status")
		local sellInfo	= control:GetNamedChild("SellInformation")
		local sellPrice = control:GetNamedChild("SellPrice")
		local trait		= control:GetNamedChild("TraitInfo")
		local bg		= control:GetNamedChild("Bg")
		local hl		= control:GetNamedChild("Highlight")

		control:SetDimensions(509, 52)

		sellPrice:SetHidden(false)

		name:SetHidden(false)
		hl:SetHidden(false)
		bg:SetAlpha(1)
		control.backdrop:SetHidden(true)

		if button.customTooltipAnchor then
			button.customTooltipAnchor = nil
		end

		button:SetDimensions(40, 40)
		button:ClearAnchors()
		button:SetAnchor(CENTER, control, TOPLEFT, 70, 26)
		button.customTooltipAnchor = nil

		stack:ClearAnchors()
		stack:SetAnchor(TOPLEFT, nil, TOPLEFT, -10, -1)
		stack:SetAnchor(BOTTOMRIGHT, nil, BOTTOMRIGHT, 2, -1)
		stack:SetFont("ZoFontGameOutline")
		stack:SetAlpha(1)
		stack:SetStyleColor(0, 0, 0, 1)

		sellInfo:SetDimensions(32, 32)
		sellInfo:ClearAnchors()
		sellInfo:SetAnchor(RIGHT, sellPrice, LEFT, -5, 0)
		sellInfo:SetAlpha(1)
		sellInfo:SetDrawLayer(0)
		sellInfo:SetMouseEnabled(true)

		trait:SetDimensions(32, 32)
		trait:SetAnchorFill(sellInfo)
		trait:SetAlpha(1)
		trait:SetDrawLayer(0)
		trait:SetMouseEnabled(true)

		status:SetDimensions(32, 32)
		status:ClearAnchors()
		status:SetAnchor(TOPLEFT, control, TOPLEFT, 0, 10)
		status:SetAlpha(1)
		status:SetMouseEnabled(true)
		status:GetNamedChild("Texture"):SetMouseEnabled(true)
		status:GetNamedChild("Texture"):SetDrawLayer(0)

		if control:GetNamedChild("ActiveIcon") then
			local activeIcon = control:GetNamedChild("ActiveIcon")
			activeIcon:SetDimensions(32, 32)
			activeIcon:ClearAnchors()
			activeIcon:SetAnchor(LEFT, control, LEFT, 0, 0)
			activeIcon:SetDrawLayer(0)
		end
	end

	stackFontStyle = string.format("%s|%s|%s", GL.SV.stack_font, GL.SV.stack_font_size, GL.SV.stack_font_shadow)

	local function RefreshControlMode_3(control, data, dataType)
		dataType.controlHeight	= GL.SV.slot_size
		dataType.controlWidth	= GL.SV.slot_size
		dataType.spacingX		= GL.SV.slot_spacing
		dataType.spacingY		= GL.SV.slot_spacing
	
		local backdrop	= CreateBackdrop(control)
		local button	= control:GetNamedChild("Button")
		local stack		= control:GetNamedChild("ButtonStackCount")
		local name		= control:GetNamedChild("Name")
		local status	= control:GetNamedChild("Status")
		local sellInfo	= control:GetNamedChild("SellInformation")
		local sellPrice = control:GetNamedChild("SellPrice")
		local trait		= control:GetNamedChild("TraitInfo")
		local bg		= control:GetNamedChild("Bg")
		local hl		= control:GetNamedChild("Highlight")
		
		control:SetDimensions(GL.SV.slot_size, GL.SV.slot_size)

		sellPrice:SetHidden(true)

		name:SetHidden(true)
		hl:SetHidden(true)
		bg:SetAlpha(0)

		if GL.SV.tooltip_near_slot then
			button.customTooltipAnchor = nil
		else
			button.customTooltipAnchor = CustomTooltipAnchor
		end

		button:SetDimensions(GL.SV.icon_size, GL.SV.icon_size)
		button:ClearAnchors()
		button:SetAnchor(CENTER, control, CENTER, 0, 0)

		stack:ClearAnchors()
		stack:SetAnchor(BOTTOMRIGHT, control, BOTTOMRIGHT, GL.SV.stack_font_x, GL.SV.stack_font_y)
		stack:SetFont(stackFontStyle)
		stack:SetAlpha(GL.SV.stack_font_a)
		stack:SetStyleColor(0, 0, 0, GL.SV.stack_font_style_a)

		status:SetDimensions(GL.SV.status_icon_size, GL.SV.status_icon_size)
		status:ClearAnchors()
		status:SetAnchor(TOPLEFT, control, TOPLEFT, GL.SV.status_icon_x, GL.SV.status_icon_y)
		status:SetAlpha(GL.SV.status_icon_a)
		status:SetMouseEnabled(GL.SV.status_icon_tooltip)
		status:GetNamedChild("Texture"):SetMouseEnabled(GL.SV.status_icon_tooltip)
		status:GetNamedChild("Texture"):SetDrawLayer(1)

		sellInfo:SetDimensions(GL.SV.trait_icon_size, GL.SV.trait_icon_size)
		sellInfo:ClearAnchors()
		sellInfo:SetAnchor(TOPRIGHT, control, TOPRIGHT, GL.SV.trait_icon_x, GL.SV.trait_icon_y)
		sellInfo:SetAlpha(GL.SV.trait_icon_a)
		sellInfo:SetDrawLayer(1)
		sellInfo:SetMouseEnabled(GL.SV.trait_icon_tooltip)

		trait:SetDimensions(GL.SV.trait_icon_size, GL.SV.trait_icon_size)
		trait:ClearAnchors()
		trait:SetAnchor(TOPRIGHT, control, TOPRIGHT, GL.SV.trait_icon_x, GL.SV.trait_icon_y)
		trait:SetAlpha(GL.SV.trait_icon_a)
		trait:SetDrawLayer(1)
		trait:SetMouseEnabled(GL.SV.trait_icon_tooltip)

		backdrop:SetHidden(false)
		backdrop:SetCenterTexture(GL.SV.skin_backdrop, 8, 0)
		backdrop:SetCenterColor(GL.SV.slot_backdrop_col[1], GL.SV.slot_backdrop_col[2], GL.SV.slot_backdrop_col[3], GL.SV.slot_backdrop_col[4])
		backdrop:SetInsets(GL.SV.skin_backdrop_insets, GL.SV.skin_backdrop_insets, -GL.SV.skin_backdrop_insets, -GL.SV.skin_backdrop_insets)
		backdrop:SetEdgeTexture(GL.SV.skin_edge, GL.SV.skin_edge_file_width, GL.SV.skin_edge_file_height, GL.SV.skin_edge_thickness, 0)

		if control:GetNamedChild("ActiveIcon") then
			local activeIcon = control:GetNamedChild("ActiveIcon")
			activeIcon:SetDimensions(22, 22)
			activeIcon:ClearAnchors()
			activeIcon:SetAnchor(TOPLEFT, control, TOPLEFT, 2, 2)
			activeIcon:SetDrawLayer(1)
		end
	end

	local function RefreshControlMode_3_Dynamic(control, data, dataType)
		control:GetNamedChild("SellPrice"):SetHidden(true)
		control:GetNamedChild("ButtonStackCount"):SetAlpha(GL.SV.stack_font_a)
		control:GetNamedChild("TraitInfo"):SetAlpha(GL.SV.trait_icon_a)

		local backdrop = control.backdrop

		local r, g, b = GetInterfaceColor(INTERFACE_COLOR_TYPE_ITEM_QUALITY_COLORS, data.quality)
		if data.quality == 0 then
			backdrop:SetEdgeColor(GL.SV.edge_quality_trash_col[1], GL.SV.edge_quality_trash_col[2], GL.SV.edge_quality_trash_col[3], GL.SV.edge_quality_trash_col[4])
		elseif data.quality == 1 then
			backdrop:SetEdgeColor(GL.SV.edge_quality_normal_col[1], GL.SV.edge_quality_normal_col[2], GL.SV.edge_quality_normal_col[3], GL.SV.edge_quality_normal_col[4])
		else
			backdrop:SetEdgeColor(r*GL.SV.edge_quality_b, g*GL.SV.edge_quality_b, b*GL.SV.edge_quality_b, GL.SV.edge_quality_a)
		end

	end

	local function RefreshList(list, control, dataType)
		if list.mode == LIST then
			list.refreshControlMode_1(control, data, dataType)
		elseif list.mode == GRID then
			list.refreshControlMode_3(control, data, dataType)
		end
	end

	RefreshMode = function(inventoryType) --local defined above
		local currentList = GetList(inventoryType)
		currentList.upd = false

		for typeId in pairs(currentList.dataTypes) do
			if typeId == 1 or typeId == 2 or typeId == 3 then
				local dataType	= ZO_ScrollList_GetDataTypeTable(currentList, typeId)
				local pool		= dataType.pool

				for _, control in pairs(pool.m_Free) do
					RefreshList(currentList, control, dataType)
				end
				for _, control in pairs(pool.m_Active) do
					RefreshList(currentList, control, dataType)
				end

				if not currentList.upd then
					currentList.upd = (#pool.m_Free > 0 and true) or (#pool.m_Active > 0 and true)
				end
			end
		end
		if currentList.upd then
			if inventoryType == 11 then
				list[inventoryType].owner:Refresh()
				ZO_ScrollList_Commit(currentList)
			elseif inventoryType > 6 then
				list[inventoryType]:UpdateList()
				ZO_ScrollList_Commit(currentList)
			else
				PLAYER_INVENTORY:UpdateList(list[inventoryType])
				ZO_ScrollList_Commit(currentList)
			end
		end
	end

	for inventoryType=1, #list do
		local list = GetList(inventoryType)
		
		if not list.refreshControlMode_1 then
			list.refreshControlMode_1 = RefreshControlMode_1
		end
		list.refreshControlMode_3			= RefreshControlMode_3
		list.refreshControlMode_3_dynamic	= RefreshControlMode_3_Dynamic

		list.contents.gridListId = inventoryType

		for typeId in pairs(list.dataTypes) do

			if typeId == 1 or typeId == 2 or typeId == 3 then
				rowW = GL.SV.slot_size
				rowH  = GL.SV.slot_size
			elseif typeId == 998 then --<<-- AutoCategory
				rowW = list.contents:GetWidth()
				rowH = list.dataTypes[typeId].height
			end

			local saveDataType = list.dataTypes[typeId]
			list.dataTypes[typeId] = nil
			local saveUniformControlHeight = list.uniformControlHeight

			ZO_ScrollList_AddControlOperation(list, typeId, nil, rowW, rowH, nil, saveDataType.setupCallback, saveDataType.hideCallback, GL.SV.slot_spacing, GL.SV.slot_spacing, 0, saveDataType.selectable, false)
			list.dataTypes[typeId].pool		= saveDataType.pool
			list.dataTypes[typeId].height	= saveDataType.height

			if PP then
				list.uniformControlHeight = PP.SV.list_skin.list_uniform_control_height
			else
				list.uniformControlHeight = saveUniformControlHeight or 52
			end

			if typeId == 1 or typeId == 2 or typeId == 3 then
				local dataType	= ZO_ScrollList_GetDataTypeTable(list, typeId)
				local pool		= dataType.pool

----------------Impresarrio Fix--------------------------------------------------------------------
				if list == ZO_StoreWindowList then
					local exSetupCallback = dataType.setupCallback
					dataType.setupCallback = function(control, data)
						exSetupCallback(control, data)

						if list.mode ~= GRID or control.changes then return end

						control.changes = true

						CreateBackdrop(control)

						if list.mode == LIST then
							list.refreshControlMode_1(control, data, dataType)
						elseif list.mode == GRID then
							list.refreshControlMode_3(control, data, dataType)
						end
					end
				else
					local exFactory	= pool.m_Factory
					pool.m_Factory = function(objectPool)
						local control = exFactory(objectPool)

						CreateBackdrop(control)

						if list.mode == LIST then
							list.refreshControlMode_1(control, data, dataType)
						elseif list.mode == GRID then
							list.refreshControlMode_3(control, data, dataType)
						end
						return control
					end
				end
---------------------------------------------------------------------------------------------------
				local exSetupCallback = dataType.setupCallback
				dataType.setupCallback = function(control, data)
					exSetupCallback(control, data)

					if list.mode ~= GRID then return end

					list.refreshControlMode_3_dynamic(control, data)
				end
			end
			if typeId == 998 then --<<-- AutoCategory
				local dataType = ZO_ScrollList_GetDataTypeTable(list, typeId)
				local existingSetupCallback = dataType.setupCallback
				dataType.setupCallback = function(control, data)
					existingSetupCallback(control, data)
					if list.mode == GRID then
						dataType.controlWidth = list.contents:GetWidth()
					end
				end
			end

		end
	end

	for inventoryType=1, #list do
		ModeChangeButton(inventoryType)
		RefreshMode(inventoryType)
	end

	if GL.SV.pre_create_lists then
		for bagId in pairs(PLAYER_INVENTORY.inventories) do
			local list = PLAYER_INVENTORY.inventories[bagId].listView
			local width, height = list.contents:GetDimensions()
			local slot = GL.SV.slot_size + GL.SV.slot_spacing
			local controls = (width / slot) * (height / slot) + (width / slot) * 2
			if bagId == 2 then controls = controls * .2 end
			for typeId in pairs(list.dataTypes) do
				if typeId == 1 or typeId == 2 or typeId == 3 then
					local dataType = ZO_ScrollList_GetDataTypeTable(list, typeId)
					local pool = dataType.pool
					for	i=1, controls do
						pool:AcquireObject()
					end
					for k, v in pairs(pool.m_Active) do
						pool.m_Free[k] = v
					end
					pool.m_Active = {}
				end
			end
		end
	end
end

GL.GetList	= GetList
GL.List		= list
--------------------------------------------------------------------------------------------------------
local function OnAddonLoaded(eventType, addonName)
	if addonName == ADDON_NAME then
		--hooks
		Settings()
		Core()
		--UnregisterForEvent--
		EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, eventType)
	end
end

EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, OnAddonLoaded)