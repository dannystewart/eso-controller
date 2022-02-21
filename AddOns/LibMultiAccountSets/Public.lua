local Internal = LibMultiAccountSetsInternal
local Public = LibMultiAccountSets


--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

-- Item collection and tradability status
Public.ITEM_UNCOLLECTIBLE        = nil -- Not a collectible set item
Public.ITEM_COLLECTED            = 1 -- Collected by the specified account
Public.ITEM_UNCOLLECTED_TRADE    = 2 -- Not collected by and tradeable with the specified account
Public.ITEM_UNCOLLECTED_NOTRADE  = 3 -- Not collected by and not tradeable with the specified account
Public.ITEM_UNCOLLECTED_UNKTRADE = 4 -- Not collected by the specified account, with unknown trade eligibility

-- Callback events
Public.EVENT_INITIALIZED = 1
Public.EVENT_COLLECTION_UPDATED = 2


--------------------------------------------------------------------------------
-- Base-Game Analogues
--------------------------------------------------------------------------------

function Public.GetNumItemSetCollectionSlotsUnlockedForAccount( account, itemSetId )
	if (account == nil or account == Internal.account) then
		return GetNumItemSetCollectionSlotsUnlocked(itemSetId)
	elseif (Internal.serverData[account] and Internal.serverData[account][itemSetId]) then
		local found = 0
		local slotId = Internal.serverData[account][itemSetId]

		while (slotId > 0) do
			if (slotId % 2 == 1) then
				found = found + 1
			end
			slotId = zo_floor(slotId / 2)
		end

		return found
	else
		return 0
	end
end

function Public.IsItemSetCollectionSlotUnlockedForAccount( account, itemSetId, slot )
	if (account == nil or account == Internal.account) then
		return IsItemSetCollectionSlotUnlocked(itemSetId, slot)
	elseif (Internal.serverData[account]) then
		return Internal.CheckSlot(Internal.serverData[account][itemSetId], Id64ToString(slot) + 0)
	else
		return false
	end
end

function Public.IsItemSetCollectionPieceUnlockedForAccount( account, pieceId )
	if (account == nil or account == Internal.account) then
		return IsItemSetCollectionPieceUnlocked(pieceId)
	else
		return Public.IsItemSetCollectionItemLinkUnlockedForAccount(account, GetItemSetCollectionPieceItemLink(pieceId, LINK_STYLE_DEFAULT, ITEM_TRAIT_TYPE_NONE))
	end
end

function Public.GetItemReconstructionCurrencyOptionCostForAccount( account, itemSetId, currencyType )
	if (account == nil or account == Internal.account) then
		return GetItemReconstructionCurrencyOptionCost(itemSetId, currencyType)
	elseif (currencyType == CURT_CHAOTIC_CREATIA) then
		local setSize = GetNumItemSetCollectionPieces(itemSetId)
		local collected = Public.GetNumItemSetCollectionSlotsUnlockedForAccount(account, itemSetId)
		if (setSize > 0 and collected > 0) then
			local completion = (setSize == 1) and 1 or (collected - 1) / (setSize - 1)
			return zo_floor(75 - 50 * completion)
		end
	end
	return nil
end


--------------------------------------------------------------------------------
-- Other Functions
--------------------------------------------------------------------------------

function Public.GetAccountList( excludeCurrentAccount )
	local accounts = { }
	for account in pairs(Internal.serverData) do
		if (not (excludeCurrentAccount and account == Internal.account)) then
			table.insert(accounts, account)
		end
	end
	table.sort(accounts)
	return accounts
end

function Public.IsItemSetCollectionItemLinkUnlockedForAccount( account, itemLink )
	if (account == nil or account == Internal.account) then
		return IsItemSetCollectionPieceUnlocked(GetItemLinkItemId(itemLink))
	else
		return Public.IsItemSetCollectionSlotUnlockedForAccount(account, select(6, GetItemLinkSetInfo(itemLink)), GetItemLinkItemSetCollectionSlot(itemLink))
	end
end

function Public.GetItemCollectionAndTradabilityStatus( accounts, itemLink, itemSource )
	if (not itemLink) then
		if (itemSource.bagId and itemSource.slotIndex) then
			itemLink = GetItemLink(itemSource.bagId, itemSource.slotIndex)
		elseif (itemSource.who and itemSource.tradeIndex) then
			itemLink = GetTradeItemLink(itemSource.who, itemSource.tradeIndex)
		elseif (itemSource.lootId) then
			itemLink = GetLootItemLink(itemSource.lootId)
		else
			return Public.ITEM_UNCOLLECTIBLE
		end
	end

	if (not IsItemLinkSetCollectionPiece(itemLink)) then
		return Public.ITEM_UNCOLLECTIBLE
	end

	if (type(itemSource) ~= "table") then
		itemSource = { }
	end

	local GetStatus = function( account, tradeEligibility )
		if (Public.IsItemSetCollectionItemLinkUnlockedForAccount(account, itemLink)) then
			return Public.ITEM_COLLECTED
		elseif (tradeEligibility[account] == true) then
			return Public.ITEM_UNCOLLECTED_TRADE
		elseif (tradeEligibility[account] == false) then
			return Public.ITEM_UNCOLLECTED_NOTRADE
		else
			return Public.ITEM_UNCOLLECTED_UNKTRADE
		end
	end

	if (type(accounts) == "string") then
		-- Single account
		return GetStatus(accounts, Internal.GetTradeEligibility(itemLink, itemSource, { accounts }))
	else
		-- Multiple accounts
		if (not accounts) then
			accounts = Public.GetAccountList(true)
			table.insert(accounts, Internal.account)
		end

		local tradeEligibility = Internal.GetTradeEligibility(itemLink, itemSource, accounts)

		local results = { }
		for _, account in ipairs(accounts) do
			results[account] = GetStatus(account, tradeEligibility)
		end
		return results
	end
end

function Public.GetLastScanTime( account )
	local timestamp
	if (account == nil or account == Internal.account) then
		timestamp = Internal.currentSlots.timestamp
	elseif (Internal.serverData[account]) then
		timestamp = Internal.serverData[account].timestamp
	end
	return timestamp or 0
end


--------------------------------------------------------------------------------
-- Raw Data Access
--------------------------------------------------------------------------------

function Public.GetRawData( account, itemSetId )
	if (type(account) == "string" and type(itemSetId) == "number") then
		return Internal.serverData[account] and Internal.serverData[account][itemSetId]
	else
		return nil
	end
end

function Public.SetRawData( account, itemSetId, slots )
	if (type(account) == "string" and type(itemSetId) == "number" and type(slots) == "number" and slots >= 0 and slots < 0x1000000000 and zo_floor(slots) == slots) then
		if (account ~= Internal.account and Internal.serverData[account] and Internal.currentSlots[itemSetId]) then
			Internal.serverData[account][itemSetId] = slots
			return true
		end
	end
	return false
end


--------------------------------------------------------------------------------
-- Callbacks
--------------------------------------------------------------------------------

Internal.callbacks = {
	[Public.EVENT_INITIALIZED] = { },
	[Public.EVENT_COLLECTION_UPDATED] = { },
}

function Public.RegisterForCallback( name, eventCode, callback )
	if (type(name) == "string" and type(eventCode) == "number" and type(callback) == "function" and Internal.callbacks[eventCode]) then
		Internal.callbacks[eventCode][name] = callback
		return true
	end
	return false
end

function Public.UnregisterForCallback( name, eventCode )
	if (type(name) == "string" and type(eventCode) == "number" and Internal.callbacks[eventCode]) then
		Internal.callbacks[eventCode][name] = nil
		return true
	end
	return false
end

function Internal.FireCallbacks( eventCode, ... )
	for _, callback in pairs(Internal.callbacks[eventCode]) do
		callback(eventCode, ...)
	end
end


--------------------------------------------------------------------------------
-- Discontinued Functions
--------------------------------------------------------------------------------

function Public.AddAccountsCollectionStatusToTooltip( tooltipControl, itemLink, hideSingleAccount )
end
