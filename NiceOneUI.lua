-- NiceOne Addon - UI

local activeTab     = "de"
local selectedIndex = nil

local C = {
    bg        = {0.118, 0.122, 0.133, 1},
    bgDark    = {0.090, 0.094, 0.102, 1},
    bgMid     = {0.145, 0.150, 0.165, 1},
    bgHover   = {0.110, 0.204, 0.196, 0.35},
    border    = {0.260, 0.270, 0.290, 1},
    borderSub = {0.200, 0.208, 0.224, 1},
    teal      = {0.302, 0.714, 0.675, 1},
    tealDim   = {0.302, 0.714, 0.675, 0.25},
    tealBg    = {0.110, 0.204, 0.196, 0.5},
    textMain  = {0.880, 0.900, 0.900, 1},
    textMuted = {0.620, 0.645, 0.660, 1},
    textDim   = {0.380, 0.395, 0.420, 1},
    red       = {0.937, 0.604, 0.604, 1},
    redBg     = {0.200, 0.090, 0.090, 0.8},
    redBorder = {0.600, 0.200, 0.200, 1},
}

local function CT(frame, r, g, b, a)
    frame:SetColorTexture(r, g, b, a or 1)
end

local function BD(frame, edge)
    edge = edge or 10
    frame:SetBackdrop({
        bgFile   = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = edge,
        insets   = {left=2, right=2, top=2, bottom=2},
    })
end

local function L(key)
    return NiceOneL[NiceOneLanguage][key]
end

-- Hauptfenster
local window = CreateFrame("Frame", "NiceOneWindow", UIParent, "BackdropTemplate")
window:SetSize(480, 500)
window:SetPoint("CENTER")
window:SetMovable(true)
window:EnableMouse(true)
window:RegisterForDrag("LeftButton")
window:SetScript("OnDragStart", window.StartMoving)
window:SetScript("OnDragStop", window.StopMovingOrSizing)
BD(window, 14)
window:SetBackdropColor(unpack(C.bg))
window:SetBackdropBorderColor(unpack(C.border))
window:SetFrameStrata("DIALOG")
window:Hide()

-- Titelleiste
local titleBar = window:CreateTexture(nil, "BACKGROUND")
titleBar:SetPoint("TOPLEFT", window, "TOPLEFT", 2, -2)
titleBar:SetPoint("TOPRIGHT", window, "TOPRIGHT", -2, -2)
titleBar:SetHeight(30)
CT(titleBar, unpack(C.bgDark))

local titleText = window:CreateFontString(nil, "OVERLAY", "GameFontNormal")
titleText:SetPoint("TOPLEFT", window, "TOPLEFT", 14, -10)
titleText:SetTextColor(unpack(C.teal))
titleText:SetText("NICEONE")
titleText:SetFont(titleText:GetFont(), 11, "")

-- Schließen Button
local closeBtn = CreateFrame("Button", nil, window, "BackdropTemplate")
closeBtn:SetSize(20, 20)
closeBtn:SetPoint("TOPRIGHT", window, "TOPRIGHT", -10, -7)
BD(closeBtn, 8)
closeBtn:SetBackdropColor(unpack(C.bgDark))
closeBtn:SetBackdropBorderColor(unpack(C.borderSub))
local closeTex = closeBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
closeTex:SetAllPoints()
closeTex:SetText("X")
closeTex:SetFont(closeTex:GetFont(), 11, "")
closeTex:SetTextColor(unpack(C.textDim))
closeBtn:SetScript("OnClick", function() window:Hide() end)
closeBtn:SetScript("OnEnter", function()
    closeTex:SetTextColor(unpack(C.textMain))
    closeBtn:SetBackdropBorderColor(unpack(C.border))
end)
closeBtn:SetScript("OnLeave", function()
    closeTex:SetTextColor(unpack(C.textDim))
    closeBtn:SetBackdropBorderColor(unpack(C.borderSub))
end)

local titleLine = window:CreateTexture(nil, "ARTWORK")
titleLine:SetPoint("TOPLEFT", window, "TOPLEFT", 2, -32)
titleLine:SetPoint("TOPRIGHT", window, "TOPRIGHT", -2, -32)
titleLine:SetHeight(1)
CT(titleLine, unpack(C.border))

-- Tabs
local tabDE = CreateFrame("Frame", nil, window)
tabDE:SetSize(110, 26)
tabDE:SetPoint("TOPLEFT", window, "TOPLEFT", 12, -40)
tabDE:EnableMouse(true)

local tabDEDot = tabDE:CreateFontString(nil, "OVERLAY", "GameFontNormal")
tabDEDot:SetPoint("LEFT", tabDE, "LEFT", 0, 0)
tabDEDot:SetText("O")
tabDEDot:SetFont(tabDEDot:GetFont(), 8, "OUTLINE")
tabDEDot:SetTextColor(unpack(C.teal))
tabDEDot:Hide()

local tabDEText = tabDE:CreateFontString(nil, "OVERLAY", "GameFontNormal")
tabDEText:SetPoint("LEFT", tabDE, "LEFT", 14, 0)
tabDEText:SetText("Deutsch")
tabDEText:SetFont(tabDEText:GetFont(), 11, "")

local tabDELine = tabDE:CreateTexture(nil, "ARTWORK")
tabDELine:SetPoint("BOTTOMLEFT", tabDE, "BOTTOMLEFT", 0, -2)
tabDELine:SetPoint("BOTTOMRIGHT", tabDE, "BOTTOMRIGHT", 0, -2)
tabDELine:SetHeight(2)

local tabEN = CreateFrame("Frame", nil, window)
tabEN:SetSize(110, 26)
tabEN:SetPoint("LEFT", tabDE, "RIGHT", 4, 0)
tabEN:EnableMouse(true)

local tabENDot = tabEN:CreateFontString(nil, "OVERLAY", "GameFontNormal")
tabENDot:SetPoint("LEFT", tabEN, "LEFT", 0, 0)
tabENDot:SetText("O")
tabENDot:SetFont(tabENDot:GetFont(), 8, "OUTLINE")
tabENDot:SetTextColor(unpack(C.teal))
tabENDot:Hide()

local tabENText = tabEN:CreateFontString(nil, "OVERLAY", "GameFontNormal")
tabENText:SetPoint("LEFT", tabEN, "LEFT", 14, 0)
tabENText:SetText("English")
tabENText:SetFont(tabENText:GetFont(), 11, "")

local tabENLine = tabEN:CreateTexture(nil, "ARTWORK")
tabENLine:SetPoint("BOTTOMLEFT", tabEN, "BOTTOMLEFT", 0, -2)
tabENLine:SetPoint("BOTTOMRIGHT", tabEN, "BOTTOMRIGHT", 0, -2)
tabENLine:SetHeight(2)

local tabHint = window:CreateFontString(nil, "OVERLAY", "GameFontNormal")
tabHint:SetPoint("TOPLEFT", window, "TOPLEFT", 240, -50)
tabHint:SetTextColor(unpack(C.textDim))
tabHint:SetFont(tabHint:GetFont(), 9, "ITALIC")

local tabLine = window:CreateTexture(nil, "ARTWORK")
tabLine:SetPoint("TOPLEFT", window, "TOPLEFT", 2, -68)
tabLine:SetPoint("TOPRIGHT", window, "TOPRIGHT", -2, -68)
tabLine:SetHeight(1)
CT(tabLine, unpack(C.border))

-- Checkbox
local function MakeCheckbox(parent, xOffset, yOffset, getValue, setValue)
    local box = CreateFrame("Button", nil, parent, "BackdropTemplate")
    box:SetSize(14, 14)
    box:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", xOffset, yOffset)
    BD(box, 8)

    local check = box:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    check:SetAllPoints()
    check:SetText("v")
    check:SetFont(check:GetFont(), 9, "OUTLINE")
    check:SetTextColor(unpack(C.teal))

    local labelText = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    labelText:SetPoint("LEFT", box, "RIGHT", 6, 0)
    labelText:SetFont(labelText:GetFont(), 10, "")
    labelText:SetTextColor(unpack(C.textMuted))

    local function UpdateCheck()
        if getValue() then
            check:Show()
            box:SetBackdropColor(unpack(C.tealBg))
            box:SetBackdropBorderColor(unpack(C.teal))
        else
            check:Hide()
            box:SetBackdropColor(unpack(C.bgDark))
            box:SetBackdropBorderColor(unpack(C.borderSub))
        end
    end

    box:SetScript("OnClick", function()
        setValue(not getValue())
        UpdateCheck()
    end)

    UpdateCheck()
    return box, labelText, UpdateCheck
end

-- Check Bereich
local checkTopLine = window:CreateTexture(nil, "ARTWORK")
checkTopLine:SetPoint("BOTTOMLEFT", window, "BOTTOMLEFT", 2, 120)
checkTopLine:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", -2, 120)
checkTopLine:SetHeight(1)
CT(checkTopLine, unpack(C.border))

local checkBotLine = window:CreateTexture(nil, "ARTWORK")
checkBotLine:SetPoint("BOTTOMLEFT", window, "BOTTOMLEFT", 2, 80)
checkBotLine:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", -2, 80)
checkBotLine:SetHeight(1)
CT(checkBotLine, unpack(C.border))

local checkLabel = window:CreateFontString(nil, "OVERLAY", "GameFontNormal")
checkLabel:SetPoint("BOTTOMLEFT", window, "BOTTOMLEFT", 14, 96)
checkLabel:SetFont(checkLabel:GetFont(), 10, "")
checkLabel:SetTextColor(unpack(C.textDim))

local partyCheck, partyLabel, partyUpdate = MakeCheckbox(
    window, 130, 91,
    function() return NiceOneInParty end,
    function(v) NiceOneInParty = v end
)

local raidCheck, raidLabel, raidUpdate = MakeCheckbox(
    window, 220, 91,
    function() return NiceOneInRaid end,
    function(v) NiceOneInRaid = v end
)

-- Eingabefeld mit InputBoxTemplate
local inputBox = CreateFrame("EditBox", nil, window, "InputBoxTemplate")
inputBox:SetSize(316, 26)
inputBox:SetPoint("BOTTOMLEFT", window, "BOTTOMLEFT", 14, 50)
inputBox:SetAutoFocus(false)
inputBox:SetMaxLetters(200)
inputBox:SetTextColor(unpack(C.textMuted))
inputBox:SetScript("OnEscapePressed", function(self)
    self:ClearFocus()
    self:SetText("")
    selectedIndex = nil
    RefreshList()
end)
inputBox:SetScript("OnEnterPressed", function(self)
    local text = self:GetText()
    if text and text ~= "" then
        if selectedIndex then
            NiceOneMessages[activeTab][selectedIndex] = text
            selectedIndex = nil
            print(L("msgSaved"))
        else
            table.insert(NiceOneMessages[activeTab], text)
        end
        self:SetText("")
        self:ClearFocus()
        RefreshList()
    end
end)

local footerLine = window:CreateTexture(nil, "ARTWORK")
footerLine:SetPoint("BOTTOMLEFT", window, "BOTTOMLEFT", 2, 38)
footerLine:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", -2, 38)
footerLine:SetHeight(1)
CT(footerLine, unpack(C.border))

-- Add/Save Button
local addBtn = CreateFrame("Button", nil, window, "BackdropTemplate")
addBtn:SetSize(120, 26)
addBtn:SetPoint("LEFT", inputBox, "RIGHT", 8, 0)
BD(addBtn, 10)
addBtn:SetBackdropColor(unpack(C.tealBg))
addBtn:SetBackdropBorderColor(unpack(C.tealDim))
local addBtnText = addBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
addBtnText:SetAllPoints()
addBtnText:SetFont(addBtnText:GetFont(), 10, "")
addBtnText:SetTextColor(unpack(C.teal))
addBtn:SetScript("OnEnter", function()
    addBtn:SetBackdropColor(0.110, 0.260, 0.240, 0.7)
end)
addBtn:SetScript("OnLeave", function()
    addBtn:SetBackdropColor(unpack(C.tealBg))
end)
addBtn:SetScript("OnClick", function()
    local text = inputBox:GetText()
    if text and text ~= "" then
        if selectedIndex then
            NiceOneMessages[activeTab][selectedIndex] = text
            selectedIndex = nil
            print(L("msgSaved"))
        else
            table.insert(NiceOneMessages[activeTab], text)
        end
        inputBox:SetText("")
        inputBox:ClearFocus()
        RefreshList()
    end
end)

-- Bestätigungsdialog
local confirmDialog = CreateFrame("Frame", "NiceOneConfirm", UIParent, "BackdropTemplate")
confirmDialog:SetSize(300, 130)
confirmDialog:SetPoint("CENTER", window, "CENTER", 0, 0)
BD(confirmDialog, 14)
confirmDialog:SetBackdropColor(unpack(C.bgDark))
confirmDialog:SetBackdropBorderColor(unpack(C.redBorder))
confirmDialog:SetFrameStrata("TOOLTIP")
confirmDialog:Hide()

local confirmTitle = confirmDialog:CreateFontString(nil, "OVERLAY", "GameFontNormal")
confirmTitle:SetPoint("TOPLEFT", confirmDialog, "TOPLEFT", 14, -14)
confirmTitle:SetTextColor(unpack(C.red))
confirmTitle:SetFont(confirmTitle:GetFont(), 11, "")

local confirmMsgText = confirmDialog:CreateFontString(nil, "OVERLAY", "GameFontNormal")
confirmMsgText:SetPoint("TOPLEFT", confirmTitle, "BOTTOMLEFT", 0, -8)
confirmMsgText:SetWidth(270)
confirmMsgText:SetTextColor(unpack(C.textDim))
confirmMsgText:SetJustifyH("LEFT")
confirmMsgText:SetFont(confirmMsgText:GetFont(), 10, "ITALIC")

local confirmCancel = CreateFrame("Button", nil, confirmDialog, "BackdropTemplate")
confirmCancel:SetSize(100, 22)
confirmCancel:SetPoint("BOTTOMRIGHT", confirmDialog, "BOTTOMRIGHT", -14, 12)
BD(confirmCancel, 10)
confirmCancel:SetBackdropColor(unpack(C.bgDark))
confirmCancel:SetBackdropBorderColor(unpack(C.borderSub))
local confirmCancelText = confirmCancel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
confirmCancelText:SetAllPoints()
confirmCancelText:SetFont(confirmCancelText:GetFont(), 10, "")
confirmCancelText:SetTextColor(unpack(C.textDim))
confirmCancel:SetScript("OnClick", function()
    confirmDialog:Hide()
    selectedIndex = nil
end)

local confirmDelete = CreateFrame("Button", nil, confirmDialog, "BackdropTemplate")
confirmDelete:SetSize(100, 22)
confirmDelete:SetPoint("RIGHT", confirmCancel, "LEFT", -6, 0)
BD(confirmDelete, 10)
confirmDelete:SetBackdropColor(unpack(C.redBg))
confirmDelete:SetBackdropBorderColor(unpack(C.redBorder))
local confirmDeleteText = confirmDelete:CreateFontString(nil, "OVERLAY", "GameFontNormal")
confirmDeleteText:SetAllPoints()
confirmDeleteText:SetFont(confirmDeleteText:GetFont(), 10, "")
confirmDeleteText:SetTextColor(unpack(C.red))
confirmDelete:SetScript("OnClick", function()
    if selectedIndex then
        table.remove(NiceOneMessages[activeTab], selectedIndex)
        selectedIndex = nil
        inputBox:SetText("")
        inputBox:ClearFocus()
        confirmDialog:Hide()
        RefreshList()
    end
end)

-- Feste Rows
local MAX_ROWS = 10
local rows = {}

for i = 1, MAX_ROWS do
    local rowFrame = CreateFrame("Frame", nil, window, "BackdropTemplate")
    rowFrame:SetSize(400, 28)
    rowFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeSize = 0,
    })
    rowFrame:SetBackdropColor(0,0,0,0)
    rowFrame:EnableMouse(true)
    rowFrame:Hide()

    local msgText = rowFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    msgText:SetPoint("LEFT", rowFrame, "LEFT", 8, 0)
    msgText:SetWidth(340)
    msgText:SetJustifyH("LEFT")
    msgText:SetFont(msgText:GetFont(), 11, "")
    msgText:SetTextColor(unpack(C.textMuted))

    local editBtn = CreateFrame("Button", nil, window, "BackdropTemplate")
    editBtn:SetSize(36, 22)
    BD(editBtn, 8)
    editBtn:SetBackdropColor(unpack(C.tealBg))
    editBtn:SetBackdropBorderColor(unpack(C.tealDim))
    editBtn:Hide()
    local editTex = editBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    editTex:SetAllPoints()
    editTex:SetText("edit")
    editTex:SetFont(editTex:GetFont(), 9, "")
    editTex:SetTextColor(unpack(C.teal))

    local delBtn = CreateFrame("Button", nil, window, "BackdropTemplate")
    delBtn:SetSize(30, 22)
    BD(delBtn, 8)
    delBtn:SetBackdropColor(unpack(C.redBg))
    delBtn:SetBackdropBorderColor(unpack(C.redBorder))
    delBtn:Hide()
    local delTex = delBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    delTex:SetAllPoints()
    delTex:SetText("del")
    delTex:SetFont(delTex:GetFont(), 9, "")
    delTex:SetTextColor(unpack(C.red))

    rows[i] = {
        frame  = rowFrame,
        text   = msgText,
        edit   = editBtn,
        editTx = editTex,
        del    = delBtn,
        delTx  = delTex,
    }
end

-- Tabs aktualisieren
local function UpdateTabs()
    if activeTab == "de" then
        tabDEText:SetTextColor(unpack(C.teal))
        CT(tabDELine, unpack(C.teal))
        tabENText:SetTextColor(unpack(C.textDim))
        CT(tabENLine, 0,0,0,0)
    else
        tabENText:SetTextColor(unpack(C.teal))
        CT(tabENLine, unpack(C.teal))
        tabDEText:SetTextColor(unpack(C.textDim))
        CT(tabDELine, 0,0,0,0)
    end

    if NiceOneLanguage == "de" then
        tabDEDot:Show()
        tabENDot:Hide()
    else
        tabENDot:Show()
        tabDEDot:Hide()
    end

    if NiceOneLanguage ~= activeTab then
        tabHint:SetText(L("clickAgain"))
    else
        tabHint:SetText("")
    end
end

-- Lokalisierung
local function UpdateLocale()
    checkLabel:SetText(L("greetIn"))
    partyLabel:SetText("Party")
    raidLabel:SetText("Raid")
    confirmTitle:SetText(L("removeMsg"))
    confirmCancelText:SetText(L("cancel"))
    confirmDeleteText:SetText(L("delete"))
    if selectedIndex then
        addBtnText:SetText(L("save"))
    else
        addBtnText:SetText(L("add"))
    end
end

-- RefreshList
function RefreshList()
    UpdateTabs()
    UpdateLocale()
    partyUpdate()
    raidUpdate()

    local messages = NiceOneMessages[activeTab]

    for i = 1, MAX_ROWS do
        rows[i].frame:Hide()
        rows[i].edit:Hide()
        rows[i].del:Hide()
    end

    for i, msg in ipairs(messages) do
        if i > MAX_ROWS then break end
        local yOffset = -70 + ((i-1) * -30)
        local r = rows[i]

        r.frame:ClearAllPoints()
        r.frame:SetPoint("TOPLEFT", window, "TOPLEFT", 12, yOffset)
        r.frame:SetBackdropColor(0,0,0,0)
        r.frame:Show()

        r.text:SetText(msg)
        r.text:SetTextColor(unpack(C.textMuted))

        r.edit:ClearAllPoints()
        r.edit:SetPoint("TOPLEFT", window, "TOPLEFT", 410, yOffset - 3)
        r.edit:Show()

        r.del:ClearAllPoints()
        r.del:SetPoint("TOPLEFT", window, "TOPLEFT", 450, yOffset - 3)
        r.del:Show()

        local capturedI = i
        r.frame:SetScript("OnEnter", function()
            r.frame:SetBackdropColor(unpack(C.bgHover))
            r.text:SetTextColor(unpack(C.textMain))
        end)
        r.frame:SetScript("OnLeave", function()
            r.frame:SetBackdropColor(0,0,0,0)
            r.text:SetTextColor(unpack(C.textMuted))
        end)
        r.edit:SetScript("OnClick", function()
            selectedIndex = capturedI
            inputBox:SetText(NiceOneMessages[activeTab][capturedI])
            inputBox:SetFocus()
            addBtnText:SetText(L("save"))
        end)
        r.del:SetScript("OnClick", function()
            selectedIndex = capturedI
            confirmMsgText:SetText('"' .. NiceOneMessages[activeTab][capturedI] .. '"')
            confirmDialog:Show()
        end)
    end
end

-- Tab Klicks
tabDE:SetScript("OnMouseDown", function()
    if activeTab == "de" then
        NiceOneLanguage = "de"
        print(NiceOneL["de"].langSet)
    else
        activeTab = "de"
        selectedIndex = nil
        inputBox:SetText("")
        inputBox:ClearFocus()
    end
    RefreshList()
end)

tabEN:SetScript("OnMouseDown", function()
    if activeTab == "en" then
        NiceOneLanguage = "en"
        print(NiceOneL["en"].langSet)
    else
        activeTab = "en"
        selectedIndex = nil
        inputBox:SetText("")
        inputBox:ClearFocus()
    end
    RefreshList()
end)

-- Toggle
function NiceOneUI_Toggle()
    if window:IsShown() then
        window:Hide()
    else
        selectedIndex = nil
        RefreshList()
        window:Show()
    end
end