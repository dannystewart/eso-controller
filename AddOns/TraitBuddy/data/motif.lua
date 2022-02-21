TB_Data_Motif = ZO_Object:Subclass()
function TB_Data_Motif:New(test, itemStyleId, achievementId, collectibleId, id, quality, hasChapters)
	local o = ZO_Object.New(self)
	o._test = test
	o._id = id -- itemId
	if itemStyleId == 108 then
		-- Ancestral Akaviri does not have a motif to learn them all, or a crown store motif
		o._id = nil
		id = id - 1
	end
	o._quality = quality or ITEM_QUALITY_ARTIFACT
	o._itemStyleId = itemStyleId
	o._achievementId = achievementId -- Three motifs this is nil
	o._collectibleId = collectibleId
	o._hasChapters = true
	if hasChapters == false then o._hasChapters = false end
	if o._hasChapters then
		o._chapters = {}
		for i = 1, 14 do
			o._chapters[i] = id + i
		end
	end
	o._materialId = nil
	o._materialIcon = nil
	o._order = nil
	o._issues = {}
	return o
end

function TB_Data_Motif:TestName()
	return self._test:lower()
end

function TB_Data_Motif:Id()
	return self._id
end

function TB_Data_Motif:Quality()
	return self._quality
end

function TB_Data_Motif:ItemStyleId()
	return self._itemStyleId
end

function TB_Data_Motif:AchievementId()
	return self._achievementId
end

function TB_Data_Motif:HasAchievement()
	return self._achievementId and true
end

function TB_Data_Motif:CollectibleId()
	return self._collectibleId
end

function TB_Data_Motif:CollectibleIcon()
	return GetCollectibleIcon(self._collectibleId)
end

function TB_Data_Motif:CollectibleDescription()
	return GetCollectibleDescription(self._collectibleId)
end

function TB_Data_Motif:HasChapters()
	return self._hasChapters
end

function TB_Data_Motif:Chapters(order)
	return self._chapters
end

function TB_Data_Motif:ChapterId(order)
	return self._chapters[order]
end

function TB_Data_Motif:IsCrownStoreOnly()
	-- Crown Crafting Motif 46: Frostcaster Style
	local linkName = self:LinkName()
	if linkName == nil then return false end
	local nameCheck =  zo_strformat("crown crafting motif <<1>>:", self._order)
	local found, findStart, findEnd = zo_plainstrfind(linkName:lower(), nameCheck)
	return found
end

function TB_Data_Motif:SetMaterial(id, icon)
	self._materialId = id
	self._materialIcon = icon
end

function TB_Data_Motif:MaterialId()
	return self._materialId
end

function TB_Data_Motif:MaterialIcon()
	return self._materialIcon
end

function TB_Data_Motif:MaterialLink()
	-- return ZO_LinkHandler_CreateLink("",nil,ITEM_LINK_TYPE,self._materialId,30,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
	return ZO_LinkHandler_CreateChatLink(GetItemStyleMaterialLink, self._itemStyleId)
end

function TB_Data_Motif:Link()
	if self._id == nil then
		return nil
	else
		return ZO_LinkHandler_CreateLink("",nil,ITEM_LINK_TYPE,self._id,self._quality+1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
	end
end

function TB_Data_Motif:LinkNameFromAchievement()
	-- Where there is no learn all motif book, or a crown store motif book, make up a link name based off the achievement
	if self:HasAchievement() and self:HasChapters() then
		local achievementName = GetAchievementName(self._achievementId)
		local linkName = self:ChapterLinkName(1)
		local found, findStart, findEnd = zo_plainstrfind(linkName, ": ")
		if found then
			return zo_strformat("<<1>><<2>>", zo_strsub(linkName, 1, findEnd-1), achievementName)
		end
	end
	return nil
end

function TB_Data_Motif:LinkName()
	local link = self:Link();
	if link then
		return zo_strformat("<<1>>", GetItemLinkName(link))
	else
		return self:LinkNameFromAchievement()
	end
end

function TB_Data_Motif:SimpleLinkName()
	local linkName = self:LinkName()
	if linkName ~= nil then
		local found, findStart, findEnd = zo_plainstrfind(linkName, ": ")
		if found then
			linkName = tostring(self._order)..zo_strsub(linkName, findStart)
		end
	end
	return linkName
end

function TB_Data_Motif:ChapterLink(order)
	local chapterId = self._chapters[order]
	return ZO_LinkHandler_CreateLink("",nil,ITEM_LINK_TYPE,chapterId,self._quality+1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
end

function TB_Data_Motif:ChapterLinkName(order)
	return zo_strformat("<<1>>", GetItemLinkName(self:ChapterLink(order)))
end

function TB_Data_Motif:SimpleChapterLinkName(order)
	local linkName = self:ChapterLinkName(order)
	local found, findStart, findEnd = zo_plainstrfind(linkName, ": ")
	if found then
		linkName = zo_strsub(linkName, findEnd)
	end
	return linkName
end

function TB_Data_Motif:AchievementLink()
	return ZO_LinkHandler_CreateChatLink(GetAchievementLink, self._achievementId)
end

function TB_Data_Motif:Order()
	-- Could also be named 'motif number'
	return self._order
end

function TB_Data_Motif:SetOrder(order)
	self._order = order
end

function TB_Data_Motif:AddIssue(msg)
	self._issues[#self._issues+1] = msg
end
function TB_Data_Motif:Issues()
	return self._issues
end
function TB_Data_Motif:NumberOfIssues()
	return #self._issues
end
function TB_Data_Motif:HasIssues()
	return (#self._issues>0)
end
function TB_Data_Motif:Check()
	-- Check as many of the properties of the motif as I can
	local motifTest = self:TestName()

	-- Check order
	if not self._order then self:AddIssue("[order]: Missing") end

	-- Check itemStyleId
	if not self._itemStyleId then self:AddIssue("[itemStyleId]: Missing") end

	-- Don't do the other checks until the above is okay
	if self:HasIssues() then return end

	-- Always call the IsCrownStoreOnly() code
	local crownStoreOnly = self:IsCrownStoreOnly()

	-- Check motif name
	local linkName = self:LinkName()
	if not linkName then
		self:AddIssue("[LinkName]: Missing")
	else
		if linkName:len()==0 then
			self:AddIssue("[LinkName]: Missing, length is zero")
		else
			-- Crafting Motif 21: Ancient Orc Style
			local nameCheck = zo_strformat("crafting motif <<1>>: <<2>> style", self._order, motifTest)
			if crownStoreOnly then nameCheck = "crown "..nameCheck end
			if self._id == nil then nameCheck = nameCheck.." master" end
			if linkName:lower() ~= nameCheck then
				self:AddIssue(zo_strformat("[LinkName]: Correct '<<1>>'", linkName))
				self:AddIssue(zo_strformat("[LinkName]: Checked '<<1>>'", nameCheck))
			end
		end
	end
	local simpleLinkName = self:SimpleLinkName()
	if not simpleLinkName then
		self:AddIssue("[SimpleLinkName]: Missing")
	else
		if simpleLinkName:len()==0 then
			self:AddIssue("[SimpleLinkName]: Missing, length is zero")
		end
	end

	-- Check achievementId
	if (not self._achievementId) and (not crownStoreOnly) then self:AddIssue("[achievementId]: Missing") end
	if self._achievementId then
		-- Check achievment name
		local name = GetAchievementInfo(self._achievementId)
		name = name:lower()
		local nameTest = motifTest
		local nameCheck = ""
		if self._order >= 1 and self._order <= 9 then
			nameCheck = "alliance style master"
		elseif self._order >= 10 and self._order <= 14 then
			nameCheck = "rare style master"
		elseif self._order == 40 then
			nameCheck = "order of the hour style master"
		elseif self._order == 42 then
			nameCheck = zo_strformat("happy work for <<1>>", motifTest)
		elseif self._order == 78 then
			nameCheck = "moongrave style master"
		else
			nameCheck = zo_strformat("<<1>> style master", motifTest)
		end
		if name ~= nameCheck then
			self:AddIssue(zo_strformat("[achievementId]: Correct '<<1>>'", name))
			self:AddIssue(zo_strformat("[achievementId]: Checked '<<1>>'", nameCheck))
		end
	end
	
	-- Check collectible
	if not self._collectibleId then self:AddIssue("[collectibleId]: Missing") end
	local collectibleIcon = self:CollectibleIcon()
	if not collectibleIcon then
		self:AddIssue("[collectibleIcon]: Missing")
	else
		if collectibleIcon:len()==0 then self:AddIssue("[collectibleIcon]: Missing, length is zero") end
	end
	local collectibleDescription = self:CollectibleDescription():lower()
	if not collectibleDescription then
		self:AddIssue("[collectibleDescription]: Missing")
	else
		if collectibleDescription:len()==0 then
			self:AddIssue("[collectibleDescription]: Missing, length is zero")
		else
			local name = motifTest
			if self._order == 40 then name = "order of the hour" end
			if self._order == 61 then name = motifTest.." order" end
			if self._order == 71 then name = motifTest.." goblin" end
			-- Crafting Style, Style, or Motif
			local found = zo_plainstrfind(collectibleDescription, zo_strformat("<<1>> crafting style", name))
			if not found then
				found = zo_plainstrfind(collectibleDescription, zo_strformat("<<1>> motif", name))
				if not found then
					found = zo_plainstrfind(collectibleDescription, zo_strformat("<<1>> style", name))
					if not found then
						self:AddIssue(zo_strformat("[collectibleDescription]: Does not contain <<1>> crafting style, style, or motif", name))
					end
				end
			end
		end
	end

	-- Check material
	if not self._materialId then self:AddIssue("[materialId]: Missing") end
	if not self._materialIcon then self:AddIssue("[materialIcon]: Missing") end
	-- Check material description?

	if self._hasChapters then
		local types = {"axes", "belts", "boots", "bows", "chests", "daggers", "gloves", "helmets", "legs", "maces", "shields", "shoulders", "staves", "swords"}
		for i,type in pairs(types) do
			local linkName = self:ChapterLinkName(i):lower()
			if not linkName then
				self:AddIssue("[Chapter "..i.." linkName]: Missing")
			else
				if linkName:len()==0 then
					self:AddIssue("[Chapter "..i.." linkName]: Missing, length is zero")
				else
					-- Crafting Motif 21: Ancient Orc Axes
					if self._order == 59 and type == "shoulders" then type = "cops" end -- Scalecaller
					local nameCheck = zo_strformat("crafting motif <<1>>: <<2>> <<3>>", self._order, motifTest, type)
					if linkName ~= nameCheck then
						self:AddIssue(zo_strformat("[Chapter <<1>> linkName]: Correct '<<2>>'", i, linkName))
						self:AddIssue(zo_strformat("[Chapter <<1>> linkName]: Checked '<<2>>'", i, nameCheck))
					end
				end
			end
		end
	end
end