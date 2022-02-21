local ConsoleFont = {}

ConsoleFont.name = "ConsoleFont"

local gamepadFont_Light = "EsoUI/Common/Fonts/ftn47.otf"
local gamepadFont_Medium = "EsoUI/Common/Fonts/ftn57.otf"
local gamepadFont_Bold = "EsoUI/Common/Fonts/ftn87.otf"
local skyrimFont = "ConsoleFont/Fonts/fcm.ttf"

local THIN          = 'soft-shadow-thin'
local THICK         = 'soft-shadow-thick'
local SHADOW        = 'shadow'
local NONE          = 'none'

ConsoleFont.FONTSTYLE_VALUES =
{
  FONT_STYLE_NORMAL,
  FONT_STYLE_OUTLINE,
  FONT_STYLE_OUTLINE_THICK,
  FONT_STYLE_SHADOW,
  FONT_STYLE_SOFT_SHADOW_THICK,
  FONT_STYLE_SOFT_SHADOW_THIN,
}

local chatfontSize = 20
local charname = GetUnitName("player")

function ConsoleFont:Initialize()
    for key,value  in zo_insecurePairs(_G) do
        if (key):find("^Zo") and type(value) == "userdata" and value.SetFont then
		   local font = {value:GetFontInfo()}
		   if font[1] == "EsoUI/Common/Fonts/Univers47.otf" then
            font[1] = gamepadFont_Light
            font[2] = font[2] * 1.25
            value:SetFont(table.concat(font, "|"))
           end
           if font[1] == "EsoUI/Common/Fonts/Univers57.otf" then
            font[1] = gamepadFont_Medium
            font[2] = font[2] * 1.25
            value:SetFont(table.concat(font, "|"))
           end
           if font[1] == "EsoUI/Common/Fonts/Univers67.otf" then
            font[1] = gamepadFont_Bold
            font[2] = font[2] * 1.2
            value:SetFont(table.concat(font, "|"))
           end
        end
     end
    -- Update the chat system's font (edit box font won't change until updated)
    CHAT_SYSTEM:SetFontSize(CHAT_SYSTEM.GetFontSizeFromSetting())
     
    -- Set the Scrolling Combat Text font
    SetSCTKeyboardFont(gamepadFont_Bold .. "|" .. 42 .. "|",FONT_STYLE_SOFT_SHADOW_THICK)
    -- Set the Keyboard Nameplate font
    SetNameplateKeyboardFont(skyrimFont .. "|" .. 22 .. "|",FONT_STYLE_OUTLINE_THICK)
    --SetNameplateKeyboardFont(GetNameplateGamepadFont())

end

function ConsoleFont:ChangeChatFonts()
	    -- Entry Box
        ZoFontEditChat:SetFont(gamepadFont_Medium .. "|".. GetChatFontSize() .. "|", FONT_STYLE_SHADOW)

		-- Chat window
        ZoFontChat:SetFont(gamepadFont_Medium .. "|" .. GetChatFontSize() .. "|", FONT_STYLE_SOFT_SHADOW_THIN)
        CHAT_SYSTEM:SetFontSize(CHAT_SYSTEM.GetFontSizeFromSetting())
end

function ConsoleFont:UpdateSCTFonts()
  -- Set the Scrolling Combat Text font
  SetSCTKeyboardFont(gamepadFont_Bold .. "|" .. 42 .. "|",FONT_STYLE_SOFT_SHADOW_THICK)
  -- Set the Keyboard Nameplate font
  SetNameplateKeyboardFont(gamepadFont_Bold .. "|" .. 22 .. "|",FONT_STYLE_OUTLINE_THICK)
end

function ConsoleFont:SetupEvents(toggle)
  --EVENT_ZONE_CHANGED
  if toggle then
    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_ACTIVATED, ConsoleFont.UpdateSCTFonts)
  else
    EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_PLAYER_ACTIVATED)
  end
end

function ConsoleFont.OnAddonLoaded(event, addonName)
    if addonName ~= ConsoleFont.name then return end
    EVENT_MANAGER:UnregisterForEvent(ConsoleFont.name, EVENT_ADD_ON_LOADED, ConsoleFont.OnAddonLoaded)
    ConsoleFont.Initialize()
    ConsoleFont:SetupEvents(true)
		--ConsoleFont.ChangeChatFonts()
end

EVENT_MANAGER:RegisterForEvent(ConsoleFont.name, EVENT_ADD_ON_LOADED, ConsoleFont.OnAddonLoaded)