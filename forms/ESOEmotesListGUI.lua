ESOTheatreII.ESOEmotesListGUI = {}
local IsConfigurationMode = false
local ETII = ESOTheatreII
local IsDataLoaded = false

function ETII.SetEmoteListItem(control, data)
  control:SetWidth(ETII.TweaksUI.EmoteConfigWindow.ButtonSize)
  local listitemtext = control:GetNamedChild( "Name" )
  listitemtext:SetText( data.EmoteName )
  listitemtext:SetColor(0.77, 0.76, 0.62, 1)
  listitemtext:SetWidth(ETII.TweaksUI.EmoteConfigWindow.ButtonSize - 10)
end

function ETII.ESOEmotesListGUI:FillScrollList()
  local control = GetControl("PlaybillFrameList")
  ZO_ScrollList_Clear(control)

  local tblCategory = ETII.ETIIEmoteCategory
  for k in pairs (tblCategory) do
    --ZO_ScrollList_AddCategory(control, tblCategory[k])
    ZO_ScrollList_AddCategory(control, k)
  end

  local datalist = ZO_ScrollList_GetDataList(control)
  local tblemote = ETII.ETIIEmoteData
  local listsize = ETII.TableSize( tblemote )
  for i = 1, listsize do
    datalist[i] = ZO_ScrollList_CreateDataEntry( 1, { EmoteName = tblemote[i][4], ID = tblemote[i][3], }, tblemote[i][2])
  end
  ZO_ScrollList_Commit(control, datalist)
end


function ETII.ESOEmotesListGUI:Initialize()
  local control = GetControl("PlaybillFrameList")
  control:SetHeight(300)
  control:SetWidth(125)
  ZO_ScrollList_AddDataType(control, 1, "PlaybillListItemTemplate", 20, ETII.SetEmoteListItem)
end

function ETII.ESOEmotesListGUI:ToggleWindow()
  local control = GetControl("PlaybillFrame")
  if ( control:IsHidden() ) then
    ETII.ESOEmotesListGUI:Show()
  else
    control:SetHidden( true )
  end
end

function ETII.ESOEmotesListGUI:PlaybillFrameOnSave()
  local lastEmote = ETII.GetLastEmote()
  if (lastEmote.ID > 0) then
    local control = GetControl("PlaybillFrame")
    local statuspaneltxt = control:GetNamedChild("StatusLabel")
    local btntochange = statuspaneltxt:GetText()
    if ETII.IsVerbose() then
      ETII.PrintSystemChat( string.format("Going to change %s to emote id %d ( %s )", btntochange, lastEmote.ID, lastEmote.Name))
    end
    ETII.ESOFavoritesGUI:FavoriteButtonOnChange(btntochange, lastEmote.ID)
  end
  ETII.ESOEmotesListGUI:Hide()
end


function ETII.ESOEmotesListGUI:Show(aname)

  local width
  local height
  local control = GetControl("PlaybillFrame")

  if (control:IsHidden()) then
    ETII.SetLastEmote("", 0)
    control:SetHidden( false )
    local emotelabel = GetControl("PlaybillFrameBottomPanelStatusEmote")
    emotelabel:SetText("")

    local WindowTitle = GetControl("PlaybillFrameHeaderPanelTitle")
    local btnSave = control:GetNamedChild("ButtonSave")
    local btnCancel = control:GetNamedChild("ButtonCancel")

    local tblemote = ETII.ETIIEmoteData

    --btnSave:SetText(ETII.AddOnStrings.EN_SAVE)
    --btnCancel:SetText(ETII.AddOnStrings.EN_CANCEL)

    if (aname ~= nil) then
      IsConfigurationMode = true
      width = ETII.TweaksUI.EmoteConfigWindow.WindowMaxWidth
      height = ETII.TweaksUI.EmoteConfigWindow.WindowMaxHeight
      ETII.ESOFavoritesGUI:MinimizeWindowToggle()
      local statuspaneltxt = control:GetNamedChild("StatusLabel")
      statuspaneltxt:SetText(string.sub(aname, 13))
      if ETII.IsVerbose() then
        statuspaneltxt:SetHidden( false )
      else
        statuspaneltxt:SetHidden( true )
      end
      local apanel = control:GetNamedChild("List")
      apanel:SetHeight( height - 120 )
      apanel:SetWidth( ETII.TweaksUI.EmoteConfigWindow.ButtonSize )

      local apanel = control:GetNamedChild("BottomPanel")
      apanel:SetWidth( width - 5 )
      apanel:SetHeight( 45 )
      local child = apanel:GetNamedChild("StatusEmote")
      child:ClearAnchors()
      child:SetAnchor( CENTER, apanel, TOP, 0, 2)
      btnSave:SetHidden( false )
      btnCancel:SetHidden( false )
    else
      IsConfigurationMode = false
      width = ETII.TweaksUI.EmoteConfigWindow.WindowMinWidth
      height = ETII.TweaksUI.EmoteConfigWindow.WindowMinHeight
      local apanel = control:GetNamedChild("List")
      apanel:SetHeight( height - 110 )
      apanel:SetWidth( ETII.TweaksUI.EmoteConfigWindow.ButtonSize )

      local apanel = control:GetNamedChild("BottomPanel")
      apanel:SetWidth( width - 5 )
      apanel:SetHeight( 35 )
      local child = apanel:GetNamedChild("StatusEmote")
      child:ClearAnchors()
      child:SetAnchor( CENTER, apanel, CENTER, nil, nil)
      btnSave:SetHidden( true )
      btnCancel:SetHidden( true )
    end
    control:SetWidth(width)
    control:SetHeight(height)
    local apanel = control:GetNamedChild("HeaderPanel")
    apanel:SetWidth( width - 5 )
    local apanel = control:GetNamedChild("CenterPanel")
    apanel:SetWidth( width - 5 )
    apanel:SetHeight( height - 5 )

  else
    if (aname ~= nil) then
      ETII.ESOEmotesListGUI:Hide()
      ETII.ESOEmotesListGUI:Show(aname)
    end
  end

  if not IsDataLoaded then
    IsDataLoaded = true
    local control = GetControl("PlaybillFrameList")
    ZO_ScrollList_HideAllCategories(control)
    for k in ipairs (ETII.ETIIEmoteCategory) do
      --d(k)
      ZO_ScrollList_ShowCategory(control, k)
    end
  end
  
end

function ETII.ESOEmotesListGUI:Hide()
  local control = GetControl("PlaybillFrame")
  control:SetHidden( true )
  if (IsConfigurationMode == true) then
    ETII.ESOFavoritesGUI:MinimizeWindowToggle()
  end
end

function ETII.ESOEmotesListGUI:MoveWindow( x, y )
  local mainframe = GetControl("PlaybillFrame")
  mainframe:ClearAnchors()
  mainframe:SetAnchor( TOPLEFT, GetControl("GuiRoot"), TOPLEFT, x, y)
end

function ETII.ESOEmotesListGUI:SaveWindowPosition()
  local mainframe = GetControl("PlaybillFrame")
  local x = mainframe:GetLeft()
  local y = mainframe:GetTop()
  if ETII.IsVerbose() then
    ETII.PrintSystemChat( string.format("Top and Left inside GuiRoot= %d : %d", x, y ))
  end
  ETII.CurrentSVars.UserSettings.PlaybillLocation.Xoffset = x
  ETII.CurrentSVars.UserSettings.PlaybillLocation.Yoffset = y
end

function ETII.ESOEmotesListGUI:LoadCategoryFilters()
  local comboBox = ZO_ComboBox_ObjectFromContainer(PlaybillFrameComboBox01)
  comboBox:SetSortsItems(false)
  comboBox:SetSpacing(4)

  local function OnFilterChanged(comboBox, entryText, entry)
    if ETII.IsVerbose() then
      ETII.PrintSystemChat( string.format("%s", entryText ))
    end
    local emotecatid = ETII.CategoryIdByName(entryText)
    local control = GetControl("PlaybillFrameList")
    ZO_ScrollList_HideAllCategories(control)
    if (emotecatid < 15) then
      ZO_ScrollList_ShowCategory(control, emotecatid)
    else
      for k in ipairs (ETII.ETIIEmoteCategory) do
        --d(k)
        ZO_ScrollList_ShowCategory(control, k)
      end
    end
  end

  local tblCategory = ETII.ETIIEmoteCategory

  for k in ipairs (tblCategory) do
    local entry = comboBox:CreateItemEntry(tblCategory[k], OnFilterChanged)
    comboBox:AddItem(entry)
  end

  comboBox:SetSelectedItem("all")
end
