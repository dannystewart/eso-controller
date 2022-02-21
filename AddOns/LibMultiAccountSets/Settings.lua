local LCCC = LibCodesCommonCode
local Internal = LibMultiAccountSetsInternal
local Public = LibMultiAccountSets


--------------------------------------------------------------------------------
-- Settings Panel
--------------------------------------------------------------------------------

function Internal.RegisterSettingsPanel( )
	local LAM = LibAddonMenu2

	if (LAM) then
		local panelId = "LMASSettings"

		Internal.settingsPanel = LAM:RegisterAddonPanel(panelId, {
			type = "panel",
			name = Internal.name,
			version = "2.0.5",
			author = "@code65536",
			website = "https://www.esoui.com/downloads/info2843.html",
			donation = "https://www.esoui.com/downloads/info2843.html#donate",
			slashCommand = "/lmas",
			registerForRefresh = true,
		})

		Internal.shareText = ""

		local getAccountList = function( key )
			local accounts = { }
			for account in pairs(Internal.vars[key]) do
				table.insert(accounts, account)
			end
			table.sort(accounts)
			return table.concat(accounts, ", ")
		end

		local setAccountList = function( key, text )
			Internal.vars[key] = { }
			local accounts = { zo_strsplit(", ", zo_strlower(text)) }
			for _, account in ipairs(accounts) do
				Internal.vars[key][DecorateDisplayName(account)] = true
			end
		end

		LAM:RegisterOptionControls(panelId, {
			--------------------------------------------------------------------
			{
				type = "description",
				text = SI_LMAS_SETTINGS_CHATCOMMAND,
			},

			--------------------------------------------------------------------
			{
				type = "header",
				name = SI_LMAS_SETTINGS_CHAT_SECTION,
			},
			--------------------
			{
				type = "checkbox",
				name = SI_LMAS_SETTINGS_CHAT_UPDATES,
				getFunc = function() return Internal.vars.chatUpdates end,
				setFunc = function(enabled) Internal.vars.chatUpdates = enabled end,
			},

			--------------------------------------------------------------------
			{
				type = "header",
				name = SI_LMAS_SETTINGS_SHARE_SECTION,
			},
			--------------------
			{
				type = "editbox",
				name = SI_LMAS_SETTINGS_SHARE_CAPTION,
				getFunc = function() return Internal.shareText end,
				setFunc = function(text) Internal.shareText = text end,
				isMultiline = true,
				isExtraWide = true,
				maxChars = 0xFFFF,
				textType = TEXT_TYPE_ALL,
				reference = "LMAS_ExportBox",
			},
			--------------------
			{
				type = "button",
				name = SI_LMAS_SETTINGS_SHARE_EXPORTC,
				func = Internal.ExportCurrent,
				tooltip = SI_LMAS_SETTINGS_SHARE_EXPORTCT,
				width = "half",
			},
			--------------------
			{
				type = "button",
				name = SI_LMAS_SETTINGS_SHARE_IMPORT,
				func = Internal.Import,
				width = "half",
			},
			--------------------
			{
				type = "button",
				name = SI_LMAS_SETTINGS_SHARE_EXPORTA,
				func = function() Internal.ExportMultiple(true) end,
				tooltip = SI_LMAS_SETTINGS_SHARE_EXPORTAT,
				width = "half",
			},
			--------------------
			{
				type = "button",
				name = SI_LMAS_SETTINGS_SHARE_CLEAR,
				func = function() Internal.shareText = "" end,
				width = "half",
			},
			--------------------
			{
				type = "button",
				name = Internal.GetExportSelectedText,
				func = function() Internal.ExportMultiple(false) end,
				tooltip = SI_LMAS_SETTINGS_SHARE_EXPORTST,
				width = "half",
				disabled = function() return Internal.CountExportSelection() == 0 end,
				reference = "LMAS_ExportSelected",
			},
			--------------------
			{
				type = "submenu",
				name = SI_LMAS_SETTINGS_SHARE_SELECT,
				controls = {
					{
						type = "editbox",
						name = SI_LMAS_SETTINGS_SHARE_SELECTT,
						getFunc = function() return getAccountList("exportSelection") end,
						setFunc = function( text )
							setAccountList("exportSelection", text)
							if (LMAS_ExportSelected and LMAS_ExportSelected.button) then
								LMAS_ExportSelected.button:SetText(Internal.GetExportSelectedText())
							end
						end,
						isExtraWide = true,
						maxChars = 0xFF,
						textType = TEXT_TYPE_ALL,
					},
				},
			},

			--------------------------------------------------------------------
			{
				type = "header",
				name = SI_LMAS_SETTINGS_DELETE_SECTION,
			},
			--------------------
			{
				type = "custom",
				width = "half",
			},
			--------------------
			{
				type = "button",
				name = SI_LMAS_SETTINGS_DELETE_BUTTON,
				func = function( )
					LibMultiAccountSetsData = { }
					ReloadUI()
				end,
				tooltip = SI_LMAS_SETTINGS_DELETE_WARNING,
				width = "half",
				isDangerous = true,
				warning = SI_LMAS_SETTINGS_DELETE_WARNING,
			},

			--------------------------------------------------------------------
			{
				type = "header",
				name = SI_LMAS_SETTINGS_NOSAVE_SECTION,
			},
			--------------------
			{
				type = "editbox",
				name = SI_LMAS_SETTINGS_NOSAVE_CAPTION,
				getFunc = function() return getAccountList("noSave") end,
				setFunc = function(text) setAccountList("noSave", text) end,
				isMultiline = true,
				isExtraWide = true,
				maxChars = 0xFFF,
				textType = TEXT_TYPE_ALL,
			},
		})
	end
end


--------------------------------------------------------------------------------
-- Public Access
--------------------------------------------------------------------------------

function Public.OpenSettingsPanel( )
	if (Internal.settingsPanel) then
		LibAddonMenu2:OpenToPanel(Internal.settingsPanel)
	end
end


--------------------------------------------------------------------------------
-- Export/Import
--------------------------------------------------------------------------------

local LDEI = LibDataExportImport
local SHARE_TAG = "S"
local SHARE_VERSION = 4 -- Version of the current export/import format

--[[
Control field: 12 bits (2 bytes)
	2 bits (0-3) for half of the data field length (0-6 bytes)
	10 bits (0-1023) for the set ID
Data field: 0/12/24/36 bits (0/2/4/6 bytes)
	Bitfield corresponding to the 36 possible Item Set Collection slots
--]]

function Internal.CountExportSelection( )
	local count = 0
	for _ in pairs(Internal.vars.exportSelection) do
		count = count + 1
	end
	return count
end

function Internal.GetExportSelectedText( )
	return string.format(GetString(SI_LMAS_SETTINGS_SHARE_EXPORTS), Internal.CountExportSelection())
end

function Internal.ExportSelectText( )
	if (LMAS_ExportBox and LMAS_ExportBox.editbox) then
		zo_callLater(function( )
			LMAS_ExportBox:UpdateValue()
			LMAS_ExportBox.editbox:SelectAll()
			LMAS_ExportBox.editbox:TakeFocus()
		end, 100)
	end
end

function Internal.CreateExportEntry( server, account, data )
	local result = { }
	for setId, slotId in pairs(data) do
		if (setId == "timestamp") then
			-- Ignore
		elseif (setId > 0 and setId < 0x400 and slotId < 0x1000000000) then
			local dataField = LCCC.Encode(slotId, 0)
			table.insert(result, LCCC.Encode(BitOr(setId, BitAnd(BitLShift(zo_strlen(dataField), 9), 0xC00)), 2))
			table.insert(result, dataField)
		else
			Internal.Msg(GetString(SI_LMAS_SHARE_EXPORT_ERROR))
		end
	end

	return LDEI.Wrap(SHARE_TAG, SHARE_VERSION, {
		server,
		UndecorateDisplayName(account),
		LCCC.Encode(data.timestamp or 0, 1),
		table.concat(result, ""),
	})
end

function Internal.ExportCurrent( )
	Internal.shareText = Internal.CreateExportEntry(Internal.server, Internal.account, Internal.currentSlots) .. " "
	Internal.ExportSelectText()
end

function Internal.ExportMultiple( exportAll )
	local result = { }
	local remaining = LDEI.SHARE_LIMIT

	for _, server in ipairs(Internal.GetSortedKeys(Internal.data, Internal.server)) do
		-- Sort the accounts on this server by the age of the data
		local accounts = { }
		for account in pairs(Internal.data[server]) do
			table.insert(accounts, account)
		end
		table.sort(accounts, function( a, b )
			return (Internal.data[server][a].timestamp or 0) > (Internal.data[server][b].timestamp or 0)
		end)

		-- Process the accounts
		for _, account in ipairs(accounts) do
			if (exportAll or Internal.vars.exportSelection[zo_strlower(account)]) then
				local entry = Internal.CreateExportEntry(server, account, Internal.data[server][account])
				local length = zo_strlen(entry)

				if (length < remaining) then
					table.insert(result, entry)
					remaining = remaining - length
				else
					Internal.Msg(string.format(GetString(SI_LMAS_SHARE_EXPORT_LIMIT), server, account))
				end
			end
		end
	end

	Internal.shareText = table.concat(result, "") .. " "
	Internal.ExportSelectText()
end

function Internal.Import( )
	if (not LDEI.Import(Internal.shareText, SHARE_TAG)) then
		Internal.Msg(GetString(SI_LMAS_SHARE_IMPORT_INVALID))
	end
end

function Internal.ProcessImportData( dataset )
	local newAccount = false
	local imported = 0

	for _, data in ipairs(dataset) do
		if (data.version ~= SHARE_VERSION) then
			return imported, SI_LMAS_SHARE_IMPORT_BADVERSION, newAccount
		else
			local server, account, timestamp, payload = zo_strsplit(",", data.payload)
			account = DecorateDisplayName(account)
			timestamp = LCCC.Decode(timestamp)

			if (server == Internal.server and account == Internal.account) then
				Internal.Msg(string.format(GetString(SI_LMAS_SHARE_IMPORT_STALE), server, account))
			else
				-- Prepare the destination data tables
				if (not Internal.data[server]) then Internal.data[server] = { } end
				if (not Internal.data[server][account]) then
					Internal.data[server][account] = { }
					newAccount = true
				end
				local data = Internal.data[server][account]

				if (data.timestamp and data.timestamp >= timestamp) then
					Internal.Msg(string.format(GetString(SI_LMAS_SHARE_IMPORT_STALE), server, account))
				else
					data.timestamp = timestamp

					local payloadLen = zo_strlen(payload)
					local i = 1
					while (i < payloadLen) do
						local controlField = LCCC.Decode(zo_strsub(payload, i, i + 1))
						local dataFieldLen = BitRShift(BitAnd(controlField, 0xC00), 9)
						local setId = BitAnd(controlField, 0x3FF)
						local slotId = LCCC.Decode(zo_strsub(payload, i + 2, i + 2 + dataFieldLen - 1))
						if (setId and slotId and setId > 0) then
							data[setId] = slotId
						else
							return imported, SI_LMAS_SHARE_IMPORT_INVALID, newAccount
						end
						i = i + 2 + dataFieldLen
					end

					imported = imported + 1

					Internal.Msg(string.format(GetString(SI_LMAS_SHARE_IMPORT_DONE), server, account, os.date("%Y/%m/%d %H:%M", timestamp)))
				end
			end
		end
	end

	return imported, nil, newAccount
end

LCCC.RunAfterInitialLoadscreen(function( )
	LDEI.RegisterProcessor(SHARE_TAG, function( ... )
		local importedCount, stringId, newAccount = Internal.ProcessImportData(...)

		if (importedCount > 0) then
			Internal.FireCallbacks(Public.EVENT_COLLECTION_UPDATED, newAccount)
		end

		if (stringId) then
			Internal.Msg(GetString(stringId))
		end

		if (newAccount) then
			Internal.Msg(GetString(SI_LMAS_SHARE_IMPORT_NEWACCOUNT))
		end

		Internal.Msg(string.format(GetString(SI_LMAS_SHARE_IMPORT_TALLY), importedCount))
		Internal.shareText = ""
	end)
end)
