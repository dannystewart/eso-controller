TB_Crafting = ZO_Object:Subclass()

function TB_Crafting:New(...)
	local object = ZO_Object.New(self)
	object:Initialize(...)
	return object
end

function TB_Crafting:Initialize()
	self.patternList = {}
	if LibLazyCrafting then
		--addonName, autocraft, functionCallback
		self.LLC = LLC:AddRequestingAddon(TraitBuddy.ADDON_NAME, true, function(event, station, results)
			if event == LLC_CRAFT_SUCCESS then
				--d(zo_strformat("TraitBuddy Debug: '<<1>>' <<2>>", tostring(event), tostring(station)))
				--d(results)
				d(zo_strformat("<<1>>: Created <<2>> for <<3>>", results.Requester, GetItemLink(results.bag, results.slot), results.reference))
			end
		end )
	end
end

function TB_Crafting:Available()
	local available = (LibLazyCrafting ~= nil) and (self.LLC ~= nil)
	local warn = true
	if not available and warn == true then
		d( zo_strformat("<<1>> <<2>> = ", TraitBuddy.ADDON_NAME, GetString(SI_CRAFTING_PERFORM_FREE_CRAFT)) .. zo_strformat(SI_ADDON_MANAGER_DEPENDENCIES, LibLazyCrafting.name) )
	end
	return available
end

function TB_Crafting:Version()
	if not self:Available() then return 0 end
	return LibLazyCrafting.version
end

function TB_Crafting:Craft(craftingSkillType, patternIndex, traitItemIndex, reference)
	if not self:Available() then return end
	--	local setPatternOffset = {}
	--if craftRequestTable["setIndex"] == 1 then
	--	setPatternOffset = {0,0,[6]=0,[7]=0}
	--end
	--setPatternOffset[craftRequestTable["station"]]
	
	--Shields are not crafting properly but wooded weapons are
	if craftingSkillType==CRAFTING_TYPE_BLACKSMITHING or craftingSkillType==CRAFTING_TYPE_CLOTHIER or craftingSkillType==CRAFTING_TYPE_WOODWORKING or craftingSkillType==CRAFTING_TYPE_JEWELRYCRAFTING then
		local o = {
			patternIndex = patternIndex,
			isCP = false,
			level = 1,
			styleIndex = GetFirstKnownItemStyleId(patternIndex),
			traitIndex = traitItemIndex,
			useUniversalStyleItem = false,
			stationOverride = craftingSkillType,
			setIndex = 1, --No set
			quality = 1,
			autocraft = true,
			reference = reference
		}

		if craftingSkillType==CRAFTING_TYPE_CLOTHIER then
			o.patternIndex = o.patternIndex + 1
		end
		local requestTable = self.LLC:CraftSmithingItemByLevel(o.patternIndex, o.isCP, o.level, o.styleIndex, o.traitIndex, o.useUniversalStyleItem, o.stationOverride, o.setIndex, o.quality, o.autocraft, o.reference)
	end
end
