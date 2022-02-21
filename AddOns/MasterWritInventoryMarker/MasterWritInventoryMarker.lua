local name = "MasterWritInventoryMarker"

local function IsWritCompleted( slot )
	if (slot and slot.bagId and slot.slotIndex) then
		local list = WritWorthyInventoryList and WritWorthyInventoryList.singleton
		if (list) then
			local id = WritWorthy.UniqueID(slot.bagId, slot.slotIndex)
			local data = list:UniqueIDToInventoryData(id)
			if (data and data.ui_is_completed) then
				return true
			end
		end
	end
	return false
end

local function IsWritDoable( itemLink )
	local parser = WritWorthy.CreateParser(itemLink)
	if (not parser or not parser:ParseItemLink(itemLink) or not parser.ToKnowList) then
		return false
	else
		local knowList = parser:ToKnowList()
		if (knowList) then
			for _, know in ipairs(knowList) do
				if (not know.is_known) then
					return false
				end
			end
		end
		return true
	end
end

local function FlagListItem( link, control, context )
	if (context ~= "mail") then
		-- We're only interested in the icon button subcontrol, not the inventory slot control
		-- /esoui/ingame/inventory/inventoryslot.xml
		control = control:GetNamedChild("Button")
	end
	if (not control) then return end

	-- Different systems have different ways of passing the item link
	local itemLink
	if (type(link) == "string") then
		-- Trade slots
		itemLink = link
	elseif (type(link) == "table") then
		-- Vendors and loot windows
		itemLink = link[1](context[link[2]])
	else
		-- Bags/banks
		itemLink = GetItemLink(context.bagId, context.slotIndex)
	end

	local state = 0
	if (IsWritCompleted(context)) then
		state = 1
	elseif (IsWritDoable(itemLink)) then
		state = 2
	end

	-- Get or create our indicator
	local indicator = control:GetNamedChild(name)
	if (not indicator) then
		-- Be lazy; don't create an indicator unless we actually need to show it
		if (state == 0) then return end

		-- Create and initialize the indicator
		indicator = WINDOW_MANAGER:CreateControl(control:GetName() .. name, control, CT_TEXTURE)
		indicator:SetTexture("MasterWritInventoryMarker/art/indicator.dds")
		indicator:SetDimensions(24, 24)
		indicator:SetInheritScale(false)
		indicator:SetAnchor(TOPRIGHT)
		indicator:SetDrawTier(DT_HIGH)
	end

	if (state == 1) then
		indicator:SetColor(0.2, 0.6, 1, 1)
	elseif (state == 2) then
		indicator:SetColor(0, 1, 0, 1)
	end
	indicator:SetHidden(state == 0)
end

local function HookLists( )
	local ProcessListHooks = function( lists )
		for _, list in ipairs(lists) do
			local scrollList = _G[list.name]
			if (scrollList and ZO_ScrollList_GetDataTypeTable(scrollList, 1)) then
				SecurePostHook(ZO_ScrollList_GetDataTypeTable(scrollList, 1), "setupCallback", function(...) FlagListItem(list.link, ...) end)
			end
		end
	end

	--------
	-- Hook regular item lists
	--------

	ProcessListHooks({
		{ name = "ZO_PlayerInventoryList" },
		{ name = "ZO_PlayerBankBackpack" },
		{ name = "ZO_GuildBankBackpack" },
		{ name = "ZO_HouseBankBackpack" },
		{ name = "ZO_LootAlphaContainerList", link = { GetLootItemLink, "lootId" } },
	})

	--------
	-- The guild store can't be hooked until it has been opened at least once
	--------

	EVENT_MANAGER:RegisterForEvent(name, EVENT_OPEN_TRADING_HOUSE, function( eventCode )
		EVENT_MANAGER:UnregisterForEvent(name, EVENT_OPEN_TRADING_HOUSE)
		ProcessListHooks({
			{ name = "ZO_TradingHouseBrowseItemsRightPaneSearchResults", link = { GetTradingHouseSearchResultItemLink, "slotIndex" } },
		})
	end)

	--------
	-- Trade window slots are not technically item lists, but they reuse the same inventory slot control
	-- /esoui/ingame/tradewindow/keyboard/tradewindow_keyboard.lua
	--------

	SecurePostHook(TRADE, "InitializeSlot", function( self, who, index, ... )
		FlagListItem(GetTradeItemLink(who, index), self.Columns[who][index].Control)
	end)

	SecurePostHook(TRADE, "ResetSlot", function( self, who, index )
		FlagListItem("", self.Columns[who][index].Control)
	end)

	--------
	-- Mail attachment slots are not technically item lists, but they reuse the same inventory slot control
	-- /esoui/ingame/mail/keyboard/mail*_keyboard.lua
	--------

	SecurePostHook(MAIL_INBOX, "RefreshAttachmentSlots", function( self )
		local numAttachments = self:GetMailData(self.mailId).numAttachments
		for i = 1, numAttachments do
			FlagListItem(GetAttachedItemLink(self.mailId, i), self.attachmentSlots[i], "mail")
		end
	end)
end

local function RegisterFilters( )
	if (not AdvancedFilters) then return end
	local util = AdvancedFilters.util

	local filterName = "WritWorthy"

	local filterInformation = {
		submenuName = filterName,

		callbackTable = { },

		enStrings = { [filterName] = filterName },

		filterType = ITEMFILTERTYPE_ALL,
		subfilters = { "Writ" },
		onlyGroups = { "Consumables", "Junk" },
	}

	local getCallback = function( option )
		return function( slot, slotIndex )
			if (util.prepareSlot ~= nil) then
				if (slotIndex ~= nil and type(slot) ~= "table") then
					slot = util.prepareSlot(slot, slotIndex)
				end
			end
			if (option == "Doable") then
				return IsWritDoable(GetItemLink(slot.bagId, slot.slotIndex))
			elseif (option == "Completed") then
				return IsWritCompleted(slot)
			end
		end
	end

	for _, option in ipairs({ "Doable", "Completed" }) do
		table.insert(filterInformation.callbackTable, {
			name = option,
			filterCallback = getCallback(option),
		})
		filterInformation.enStrings[option] = option
	end

	AdvancedFilters_RegisterFilter(filterInformation)
end

EVENT_MANAGER:RegisterForEvent(name, EVENT_PLAYER_ACTIVATED, function( eventCode, initial )
	EVENT_MANAGER:UnregisterForEvent(name, EVENT_PLAYER_ACTIVATED)
	HookLists()
	RegisterFilters()
end)
