--[[--

		All the world's a stage,
			And all the men and women merely players;
			They have their exits and their entrances...

			-- As You Like It (Act 2, Scene 7, Page 6)  William Shakespeare

--]]--
ESOTheatreII.ESOFavoritesGUI = {}
local ETII = ESOTheatreII
local maxButtons = 10
local StageIsActive = false

function ETII.ESOFavoritesGUI:Initialize()
  local control = GetControl("TheatreFrame")
  local quickbtns = CreateControlFromVirtual("TheatreFrameButtonGroup", control, "ButtonPanelTemplate", 1)
  quickbtns:ClearAnchors()
  quickbtns:SetAnchor(CENTER, control, TOP, 0, 10)
  quickbtns:SetHidden( true )

  local BtnClose = control:GetNamedChild( "ButtonClose" )
  BtnClose:SetHandler( 'OnClicked', function() self:Hide() StageIsActive = false end )
  local BtnMinimize = control:GetNamedChild( "ButtonMinimize" )
  BtnMinimize:SetHandler( 'OnClicked', function() ESOTheatreII.ESOFavoritesGUI:MinimizeWindowToggle() end )

  local BtnTest = control:GetNamedChild( "ButtonTesting" )
  BtnTest:SetHidden(true)

  local checkboxcontrol = GetControl("TheatreFrameCheckbox")
  checkboxcontrol.checkedText = "Off"
  checkboxcontrol.uncheckedText = "On"
  checkboxcontrol:SetText("Off")
  --checkboxcontrol:SetState(BSTATE_NORMAL, true)
  ZO_PreHookHandler(checkboxcontrol, "OnClicked", function() ESOTheatreII.SetTransparentFlag(not ESOTheatreII.GetTransparentFlag()) end )

end

function ETII.ESOFavoritesGUI:Show()
  local control = GetControl("TheatreFrame")
  if StageIsActive then
    control:SetHidden( false )
  end
end

function ETII.ESOFavoritesGUI:Hide()
  local control = GetControl("TheatreFrame")
  control:SetHidden( true )
end

function ETII.ESOFavoritesGUI:ToggleWindow()
  local control = GetControl("TheatreFrame")
  if ( control:IsHidden() ) then
    StageIsActive = true
    control:SetHidden( false )
  else
    StageIsActive = false
    control:SetHidden( true )
  end
end

function ETII.ESOFavoritesGUI:LoadFavoriteButtons()

  local control = GetControl("TheatreFrame")

  local x = 0
  local y = 0

  local uielements = ETII.TweaksUI.MainWindow

  control:SetWidth(uielements.WindowWidth)
  control:SetHeight(uielements.WindowHeight)

  local xOffsetbase = uielements.ButtonBaseOffsetX
  local yOffsetbase = uielements.ButtonBaseOffsetY
  local xOffsetRelative = uielements.ButtonRelativeOffsetX
  local yOffsetRelative = uielements.ButtonRelativeOffsetY
  local btnWidth = uielements.ButtonSize


  for i, v in pairs(ETII.CurrentSVars.FavoriteTable) do
    if (y < 5) then
      y = y + 1
    else
      y = 1
      x = x + 1
    end

    local itemcontrol = CreateControlFromVirtual("TheatreFrameButtonFavorite", control, "ButtonFavoriteTemplate", i)
    itemcontrol:ClearAnchors()
    itemcontrol:SetAnchor(TOPLEFT, nul, nul, xOffsetbase + (xOffsetRelative * x), yOffsetbase + (yOffsetRelative * y))
    local favbtncontrol = itemcontrol:GetNamedChild( "ButtonFavorite" )
    favbtncontrol:SetHandler( 'OnClicked', function() ESOTheatreII.PlayEmoteByID( v["ID"] ) end )
    favbtncontrol:SetWidth(btnWidth)
    local favbtnLabel = favbtncontrol:GetLabelControl()
    favbtnLabel:SetText(string.format("%s", v["EmoteName"] ))
    local cfgbtncontrol = itemcontrol:GetNamedChild( "ButtonCfgFavorite" )
    cfgbtncontrol:SetHandler( 'OnClicked', function() ESOTheatreII.ESOEmotesListGUI:Show( itemcontrol:GetName() ) end )
    if ( i <= 5 ) then
      local btncontrol = GetControl("TheatreFrameButtonGroup1Panel"..i.."Button" )
      btncontrol:SetHandler( 'OnClicked', function() ESOTheatreII.PlayEmoteByID( v["ID"] ) end )
    end
    if ( x > 0) then
      cfgbtncontrol:ClearAnchors()
      cfgbtncontrol:SetAnchor(TOPLEFT, favbtncontrol, TOPRIGHT, - 10, 0)
    end
  end

end

function ETII.ESOFavoritesGUI:ReLoadFavoriteButtons()

  for i, v in pairs(ETII.CurrentSVars.FavoriteTable) do
    local favbtncontrol = GetControl( "TheatreFrameButtonFavorite"..i.."ButtonFavorite" )
    favbtncontrol:SetHandler( 'OnClicked', function() ESOTheatreII.PlayEmoteByID( v["ID"] ) end )
    local favbtnLabel = favbtncontrol:GetLabelControl()
    favbtnLabel:SetText(string.format("%s", v["EmoteName"] ))
    local cfgbtncontrol = GetControl( "TheatreFrameButtonFavorite"..i.."ButtonCfgFavorite" )
    cfgbtncontrol:SetHandler( 'OnClicked', function() ESOTheatreII.ESOEmotesListGUI:Show( "TheatreFrameButtonFavorite"..i ) end )
  end

end

function ETII.ESOFavoritesGUI:FavoriteButtonOnChange(aname, emoteid)
  --Change the Stage button
  local control = GetControl("TheatreFrame")
  local favbtncontrol = control:GetNamedChild( aname.."ButtonFavorite" )
  favbtncontrol:SetHandler( 'OnClicked', function() ESOTheatreII.PlayEmoteByID( emoteid ) end )
  local favbtnLabel = favbtncontrol:GetLabelControl()
  local oldemote = favbtnLabel:GetText()
  favbtnLabel:SetText(string.format("%s", ETII.EmoteNameByID(emoteid)))

  --Update the SavedVariables
  --Using table index in-case someone wants an emote more than once
  local tableindex = 0
  tableindex = tonumber(string.sub(aname, 15))

  for i, v in pairs(ETII.CurrentSVars.FavoriteTable) do
    if ( i == tableindex ) then
      --[[--
			if ETII.IsVerbose() then
				ETII.PrintSystemChat( string.format("%d %s", i, v["ID"]))
				ETII.PrintSystemChat( string.format("%d %s", i, v["EmoteName"]))
			end
		--]]--
      v["ID"] = emoteid
      v["EmoteName"] = string.format("%s", ETII.EmoteNameByID(emoteid))
    end
  end
end

function ETII.ESOFavoritesGUI:ButtonStateToggle()
  --Used when the configuration window shown/hidden
  for i = 1, maxButtons do
    local cfgbtncontrol = GetControl("TheatreFrameButtonFavorite"..i.."ButtonCfgFavorite")
    local btnstatus = cfgbtncontrol:GetState()
    if (btnstatus == BSTATE_DISABLED) then
      cfgbtncontrol:SetState(BSTATE_NORMAL, false)
    else
      cfgbtncontrol:SetState(BSTATE_DISABLED, true)
    end
  end
end

function ETII.ESOFavoritesGUI:MinimizeWindowToggle()
  local control = GetControl("TheatreFrame")
  local btncontrol = control:GetNamedChild("ButtonGroup1" )
  if (btncontrol:IsHidden()) then
    btncontrol:SetHidden( false )
  else
    btncontrol:SetHidden( true )
  end
  --Quick way to appear to be minimizing window
  for i = 1, maxButtons do
    local cfgbtncontrol = GetControl("TheatreFrameButtonFavorite"..i.."ButtonCfgFavorite")
    local favbtncontrol = GetControl( "TheatreFrameButtonFavorite"..i.."ButtonFavorite" )

    if cfgbtncontrol:IsHidden() then
      cfgbtncontrol:SetHidden( false )
      favbtncontrol:SetHidden( false )
      control:SetHeight(215)
    else
      cfgbtncontrol:SetHidden( true )
      favbtncontrol:SetHidden( true )
      control:SetHeight(25)
    end
  end
end

function ETII.ESOFavoritesGUI:MoveWindow( x, y )
  local mainFrame = GetControl("TheatreFrame")
  mainFrame:ClearAnchors()
  mainFrame:SetAnchor( TOPLEFT, GetControl("GuiRoot"), TOPLEFT, x, y)
end

function ETII.ESOFavoritesGUI:SaveWindowPosition()

  local mainFrame = GetControl("TheatreFrame")
  local _, a, _, b, x, y = mainFrame:GetAnchor()
  local x2 = mainFrame:GetLeft()
  local y2 = mainFrame:GetTop()
  if ETII.IsVerbose() then
    ETII.PrintSystemChat( string.format("Anchor location returned= %d : %d", x, y ))
    ETII.PrintSystemChat( string.format("Top and Left inside GuiRoot= %d : %d", x2, y2 ))
  end
  --I'm going with Top and Left :D
  --Anchor appears to be influenced by other controls on the screen?
  ETII.CurrentSVars.UserSettings.StageLocation.Xoffset = x2
  ETII.CurrentSVars.UserSettings.StageLocation.Yoffset = y2

end

function ETII.ESOFavoritesGUI:GetFavoriteButtonEmote( btnnumber )
  local buttonid = tonumber(btnnumber) or 0
  if (buttonid > 0) and (buttonid <= maxButtons) then
    local favbtncontrol = GetControl( "TheatreFrameButtonFavorite"..buttonid.."ButtonFavorite" )
    local favbtnLabel = favbtncontrol:GetLabelControl()
    emotename = favbtnLabel:GetText()
    return emotename
  end
  return
end

function ETII.ESOFavoritesGUI:OnSlashCommand()
  local control = GetControl("TheatreFrame")
  StageIsActive = true
  ETII.ESOFavoritesGUI:Show()
  if ETII.IsVerbose() then
    ETII.PrintSystemChat(ETII.Name.." "..ETII.Version.." Loaded.")
  end
end
