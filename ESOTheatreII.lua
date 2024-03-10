--[[--

ETII.ETIIEmoteData integer description
[1] = string slashName
[2] = number EmoteCategory category
[3] = number emoteId
[4] = string displayName
[5] = boolean showInGamepadUI

--]]--

ESOTheatreII = {
  Name = "ESOTheatreII",
  Title = "ESO Theatre II",
  Author = "Halja, II by AnotherFoxGuy",
  Version = "2.1.1",
  SV = "ESOTheatreIISavedVariables",
  SVersion = "2.1.1",
  CurrentSVars = {},
}

local ETII = ESOTheatreII
ETII.ETIIEmoteData = {}

ETII.ETIIEmoteCategory =
{
  [0] = "ceremonial",
  [1] = "cheers and jeers",
  [2] = "collected",
  [3] = "deprecated",
  [4] = "emotion",
  [5] = "entertainment",
  [6] = "food and drink",
  [7] = "give directions",
  [8] = "invalid",
  [9] = "perpetual",
  [10] = "personality override",
  [11] = "physical",
  [12] = "poses and fidgets",
  [13] = "prop",
  [14] = "social",
  [15] = "all"
}

local TransparentFlag = false
local LastKnownTarget = nil

local verboseFlag = false
local lastEmote = {
  Name = "",
  ID = 0,
}

function ETII.GetEmoteData()
  local edat
  for i = 1, GetNumEmotes() do
    edat = { GetEmoteInfo(i) }
    ETII.ETIIEmoteData[i] = edat
  end
end

function ETII.GetLastEmote()
  return lastEmote
end

function ETII.SetLastEmote(name, id)
  lastEmote.Name = name
  lastEmote.ID = id
end

function ETII.GetLastKnownTarget()
  return LasstKnownTarget
end

function ETII.IsVerbose()
  if (verboseFlag ~= nil) then
    return verboseFlag
  else
    return false
  end
end

local function PlayerTargetOnChange()
  local name = GetUnitName("reticleover")
  local caption = GetUnitCaption("reticleover")
  if DoesUnitExist('reticleover') then
    --if IsUnitPlayer('reticleover') then
    if (name ~= LastKnownTarget) then
      LastKnownTarget = name
      if ETII.IsVerbose() then
        ETII.PrintSystemChat( "New Target: "..name )
      end
    end
    --end
  end
end

function ETII.PrintSystemChat( text )
  if (type(text) ~= string) then
    text = tostring(text)
  end
  --d( text )
  CHAT_SYSTEM:AddMessage(text)
end

function ETII.EmptyTable( aTable )
  for k, v in pairs (aTable) do
    aTable[k] = nil
  end
end

function ETII.TableSize( aTable )
  -- # shortcut for lua table count is not always working?
  local count = 0
  for k in pairs (aTable) do
    count = count + 1
  end
  return count
end

function ETII.IsString(obj)
  return type(obj) == 'string'
end

function ETII.IsNumber(obj)
  return type(obj) == 'number'
end

function ETII.GetTransparentFlag()
  return TransparentFlag
end

function ETII.SetTransparentFlag()
  TransparentFlag = not TransparentFlag
  if ETII.IsVerbose()then
    ETII.PrintSystemChat(TransparentFlag)
  end
  local TransparencyLevel = tonumber(ETII.CurrentSVars.UserSettings.TransparencyLevel)

  if (TransparencyLevel < 1) then TransparencyLevel = 1 end
  if (TransparencyLevel > 100) then TransparencyLevel = 100 end
  TransparencyLevel = (TransparencyLevel / 100)

  local mainFrame = GetControl("TheatreFrame")
  local configFrame = GetControl("PlaybillFrame")
  if TransparentFlag then
    mainFrame:SetAlpha(1)
    configFrame:SetAlpha(1)
  else
    mainFrame:SetAlpha(TransparencyLevel)
    configFrame:SetAlpha(TransparencyLevel)
  end
end

function ETII.EmoteIdByName(aname)
  local id = -1
  local tblemote = ETII.ETIIEmoteData

  for k, v in pairs (tblemote) do
    if (aname == v[4]) then
      id = v[3]
    end
  end
  return id
end

function ETII.CategoryIdByName(aname)
  local id = 0
  local tblCategory = ETII.ETIIEmoteCategory

  for k in pairs (tblCategory) do
    if (aname == tblCategory[k]) then
      id = k
    end
  end
  return id
end

function ETII.EmoteNameByID(id)
  local name = ""
  local tblemote = ETII.ETIIEmoteData

  for k, v in pairs (tblemote) do
    if (id == v[3]) then
      name = v[4]
    end
  end
  return name
end

function ETII.PlayEmoteByName(name)
  local emoteid = ETII.EmoteIdByName(name)
  if (emoteid > 0) then
    PlayEmoteByIndex(GetEmoteIndex(emoteid))
    if ETII.IsVerbose() then
      ETII.PrintSystemChat( "Playing "..name.." By Name")
    end
    ETII.SetLastEmote(name, emoteid)
  end
end

function ETII.PlayEmoteByID(id)
  PlayEmoteByIndex(GetEmoteIndex(id))
  if ETII.IsVerbose() then
    ETII.PrintSystemChat( "Playing "..ETII.EmoteNameByID(id) .." By ID")
  end
  ETII.SetLastEmote(eName, ID)
end

local function ShouldHideAddon()
  local CompassIsHidden = ZO_CompassFrame:IsHidden()
  if (CompassIsHidden and IsReticleHidden() ) then
    ESOTheatreII:Hide()
    ESOEmotesListGUI:Hide()
  else
    --There is a variable in the class to check that it should really become visible.
    ESOTheatreII:Show()
  end
end

function ETII.ToggleAddon()
  ETII.ESOFavoritesGUI:ToggleWindow()
end

function ETII.ToggleEmotesWindow()
  ETII.ESOEmotesListGUI:ToggleWindow()
end

function ETII.QuickEmotes( btnNumber )
  local emotename = ETII.ESOFavoritesGUI:GetFavoriteButtonEmote( btnNumber )
  if (emotename ~= nul) then
    ETII.PlayEmoteByName(emotename)
  end
end

function ETII.RandomEmote()
  local randomIndex = math.random(1, GetNumEmotes())
  local randomEmote = { GetEmoteInfo(randomIndex) }
  ETII.PrintSystemChat( "Playing "..randomEmote[4])
  PlayEmoteByIndex(randomIndex)
end

local function ReloadRawTable()
  ETII.CurrentSVars.RawTable = {}

  for i = 1, GetNumEmotes() do
    d(GetEmoteInfo(i))
  end

  ETII.CurrentSVars.RawTable = ETII.ETIIEmoteData
end

local function ReloadAddOnDefaults()

  local size = ETII.TableSize(ETII.FavoriteTable)

  if ( size > 0) then
    if ETII.IsVerbose() then
      ETII.PrintSystemChat("Starting reset...")
    end

    ETII.EmptyTable( ETII.CurrentSVars.FavoriteTable )
    ETII.EmptyTable( ETII.CurrentSVars.RawTable )
    ETII.EmptyTable( ETII.CurrentSVars.UserSettings )

    ETII.CurrentSVars.UserSettings = ETII.UserSettings
    ETII.CurrentSVars.FavoriteTable = ETII.FavoriteTable
    ETII.CurrentSVars.RawTable = {}

    ETII.ESOFavoritesGUI.ReLoadFavoriteButtons()
    local x = ETII.CurrentSVars.UserSettings.StageLocation.Xoffset
    local y = ETII.CurrentSVars.UserSettings.StageLocation.Yoffset
    ETII.ESOFavoritesGUI:MoveWindow( x, y )

    x = ETII.CurrentSVars.UserSettings.PlaybillLocation.Xoffset
    y = ETII.CurrentSVars.UserSettings.PlaybillLocation.Yoffset
    ETII.ESOEmotesListGUI:MoveWindow( x, y )

    if ETII.IsVerbose() then
      ETII.PrintSystemChat("Reset Done")
    end
  end
end

local function OnAddSlashCommand( ... )

  --only parsing the first argument
  local arg1 = select(1, ...)
  if ( arg1 ~= nil and arg1 ~= "") then
    if ETII.IsVerbose() then
      ETII.PrintSystemChat( arg1 )
    end

    if (arg1 == "-help" or arg1 == "-h"or arg1 == "-?") then
      ETII.PrintSystemChat(ETII.Name.." Slash Commands")
      ETII.PrintSystemChat("******************************************")
      ETII.PrintSystemChat("/esotheatre : Display emote window")
      ETII.PrintSystemChat("/et : Alias to display emote window")
      ETII.PrintSystemChat("/et -< Options >")
      ETII.PrintSystemChat("/et -help : This message")
      -- ETII.PrintSystemChat("/et -enumsys : Pulls system emotes and copies to SavedVariables file")
      ETII.PrintSystemChat("/et -reload : Reloads Add-on default to SavedVariables file")
      ETII.PrintSystemChat("/et -repin : Reset main window position to top left corner")
      ETII.PrintSystemChat("/et ####	Plays the games emote id")
      ETII.PrintSystemChat("/et -f##	Plays the emote based on the favorite's button number i.e. /et -f9 plays the emote you assigned to button 9.")
      ETII.PrintSystemChat("******************************************")
    end

    if arg1 == "-enumsys" then
      ReloadRawTable()
    end

    if arg1 == "-reload" then
      ReloadAddOnDefaults()
    end

    if arg1 == "-repin" then
      ETII.ESOFavoritesGUI:MoveWindow( 30, 20 )
      ETII.ESOEmotesListGUI:MoveWindow( 360, 20 )
    end

    if (string.sub(string.upper(arg1), 1, 2) == "-F") then
      local btnNumber = string.sub(arg1, 3)
      local emotename = ETII.ESOFavoritesGUI:GetFavoriteButtonEmote( btnNumber )
      if (emotename ~= nul) then
        --No error checking just tossing over the fence :P
        ETII.PlayEmoteByName(emotename)
      end
    end

    if arg1 == "-v" then
      if ETII.IsVerbose() then
        verboseFlag = false
      else
        verboseFlag = true
      end
    end


    local emoteid = tonumber(arg1)
    if (emoteid ~= nul and ETII.IsNumber(emoteid) == true) then
      ETII.PlayEmoteByID(emoteid)
    else
      --No error checking just tossing over the fence :P
      ETII.PlayEmoteByName(arg1)
    end

  else
    ETII.ESOFavoritesGUI:OnSlashCommand()
  end

end

function ETII.AddonInitialized( self )

  ETII.ESOFavoritesGUI:Initialize()
  ETII.ESOFavoritesGUI:Hide()

  ETII.ESOEmotesListGUI:Initialize()
  local control = GetControl("PlaybillFrame")
  control:SetHidden( true )

end

local function OnAddOnLoaded(eventCode, addOnName)
  if (addOnName == ETII.Name) then

    ETII.GetEmoteData()

    local defaultSV = {
      ["FavoriteTable"] =
      {
      },
      ["RawTable"] =
      {
      },
      ["UserSettings"] =
      {
      },
    }

    defaultSV.UserSettings = ETII.UserSettings
    defaultSV.FavoriteTable = ETII.FavoriteTable

    --initialize saved variables
    --if ( EmotesAccountWide == 1 ) then
    ETII.CurrentSVars = ZO_SavedVars:NewAccountWide(ETII.SV, ETII.SVersion, "Session", defaultSV)
    --else
    --ETII.CurrentSVars = ZO_SavedVars:New(ETII.SV, ETII.SVersion, "Session", defaultSV)
    --end

    --Initialize Slash commands
    SLASH_COMMANDS["/esotheatre"] = function( ... ) OnAddSlashCommand( ... ) end
    SLASH_COMMANDS["/et"] = function( ... ) OnAddSlashCommand( ... ) end

    ETII.ESOFavoritesGUI:LoadFavoriteButtons()
    local x = ETII.CurrentSVars.UserSettings.StageLocation.Xoffset
    local y = ETII.CurrentSVars.UserSettings.StageLocation.Yoffset
    ETII.ESOFavoritesGUI:MoveWindow( x, y )

    x = ETII.CurrentSVars.UserSettings.PlaybillLocation.Xoffset
    y = ETII.CurrentSVars.UserSettings.PlaybillLocation.Yoffset
    ETII.ESOEmotesListGUI:MoveWindow( x, y )

    ETII.ESOEmotesListGUI:LoadCategoryFilters()
    ETII.ESOEmotesListGUI:FillScrollList()
  end
end

function ETII.TestFoo()
  ---A Placeholder for trying stuff

  ETII.ESOEmotesListGUI:FillScrollList()

  if ETII.IsVerbose() then
    ETII.PrintSystemChat( "Done :D" )
  end
end


EVENT_MANAGER:RegisterForEvent(ETII.Name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
--EVENT_MANAGER:RegisterForEvent(ETII.Name, EVENT_RETIIICLE_HIDDEN_UPDATE, ShouldHideAddon)  --also fires when main game main menu is triggered
EVENT_MANAGER:RegisterForEvent(ETII.Name, EVENT_RETIIICLE_TARGETII_CHANGED, PlayerTargetOnChange)
ZO_CreateStringId("SI_BINDING_NAME_DISPLAY_ESOTHEATER", "Display ESO Theatre Reloaded")
ZO_CreateStringId("SI_BINDING_NAME_DISPLAY_EMOTES", "Display Emotes |c888855( All )|r")
ZO_CreateStringId("SI_BINDING_NAME_QUICK_EMOTE_01", "Emote Favorite 01")
ZO_CreateStringId("SI_BINDING_NAME_QUICK_EMOTE_02", "Emote Favorite 02")
ZO_CreateStringId("SI_BINDING_NAME_QUICK_EMOTE_03", "Emote Favorite 03")
ZO_CreateStringId("SI_BINDING_NAME_QUICK_EMOTE_04", "Emote Favorite 04")
ZO_CreateStringId("SI_BINDING_NAME_QUICK_EMOTE_05", "Emote Favorite 05")
ZO_CreateStringId("SI_BINDING_NAME_QUICK_EMOTE_06", "Emote Favorite 06")
ZO_CreateStringId("SI_BINDING_NAME_QUICK_EMOTE_07", "Emote Favorite 07")
ZO_CreateStringId("SI_BINDING_NAME_QUICK_EMOTE_08", "Emote Favorite 08")
ZO_CreateStringId("SI_BINDING_NAME_QUICK_EMOTE_09", "Emote Favorite 09")
ZO_CreateStringId("SI_BINDING_NAME_QUICK_EMOTE_10", "Emote Favorite 10")
ZO_CreateStringId("SI_BINDING_NAME_RANDOM_EMOTE", "Play Random Emote")


ETII.FavoriteTable = {
  [1] =
  {
    ["EmoteName"] = "Hello",
    ["ID"] = 137,
  },
  [2] =
  {
    ["EmoteName"] = "Congratulate",
    ["ID"] = 143,
  },
  [3] =
  {
    ["EmoteName"] = "Sit chair",
    ["ID"] = 100,
  },
  [4] =
  {
    ["EmoteName"] = "Eat apple",
    ["ID"] = 178,
  },
  [5] =
  {
    ["EmoteName"] = "Drinking from flagon",
    ["ID"] = 8,
  },
  [6] =
  {
    ["EmoteName"] = "Play dead",
    ["ID"] = 115,
  },
  [7] =
  {
    ["EmoteName"] = "Dust off",
    ["ID"] = 80,
  },
  [8] =
  {
    ["EmoteName"] = "Dance",
    ["ID"] = 72,
  },
  [9] =
  {
    ["EmoteName"] = "Dance drunk",
    ["ID"] = 79,
  },
  [10] =
  {
    ["EmoteName"] = "Play lute",
    ["ID"] = 5,
  },
}

ESOTheatreII.TweaksUI = {
  ["MainWindow"] =
  {
    ["WindowWidth"] = 305,
    ["WindowHeight"] = 215,
    ["ButtonBaseOffsetX"] = 2,
    ["ButtonBaseOffsetY"] = 1,
    ["ButtonRelativeOffsetX"] = 140,
    ["ButtonRelativeOffsetY"] = 35,
    ["ButtonSize"] = 150,
  },
  ["EmoteConfigWindow"] =
  {
    ["WindowMinWidth"] = 250,
    ["WindowMinHeight"] = 750,
    ["ButtonSize"] = 250,
    ["WindowMaxWidth"] = 265,
    ["WindowMaxHeight"] = 750,
  },
}
