-- NiceOne Addon - UI

local activeTab     = "de"
local selectedIndex = nil
local mainTab       = "greetings"

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
    return NiceOneL[NiceOneUILanguage()][key]
end

-- ─── Hauptfenster ─────────────────────────────────────────────────────────────

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

-- ─── Haupt-Tabs ───────────────────────────────────────────────────────────────

local mainTabGreet = CreateFrame("Frame", nil, window)
mainTabGreet:SetSize(130, 26)
mainTabGreet:SetPoint("TOPLEFT", window, "TOPLEFT", 12, -40)
mainTabGreet:EnableMouse(true)

local mainTabGreetText = mainTabGreet:CreateFontString(nil, "OVERLAY", "GameFontNormal")
mainTabGreetText:SetPoint("LEFT", mainTabGreet, "LEFT", 0, 0)
mainTabGreetText:SetFont(mainTabGreetText:GetFont(), 11, "")

local mainTabGreetLine = mainTabGreet:CreateTexture(nil, "ARTWORK")
mainTabGreetLine:SetPoint("BOTTOMLEFT", mainTabGreet, "BOTTOMLEFT", 0, -2)
mainTabGreetLine:SetPoint("BOTTOMRIGHT", mainTabGreet, "BOTTOMRIGHT", 0, -2)
mainTabGreetLine:SetHeight(2)

local mainTabOpts = CreateFrame("Frame", nil, window)
mainTabOpts:SetSize(100, 26)
mainTabOpts:SetPoint("LEFT", mainTabGreet, "RIGHT", 8, 0)
mainTabOpts:EnableMouse(true)

local mainTabOptsText = mainTabOpts:CreateFontString(nil, "OVERLAY", "GameFontNormal")
mainTabOptsText:SetPoint("LEFT", mainTabOpts, "LEFT", 0, 0)
mainTabOptsText:SetFont(mainTabOptsText:GetFont(), 11, "")

local mainTabOptsLine = mainTabOpts:CreateTexture(nil, "ARTWORK")
mainTabOptsLine:SetPoint("BOTTOMLEFT", mainTabOpts, "BOTTOMLEFT", 0, -2)
mainTabOptsLine:SetPoint("BOTTOMRIGHT", mainTabOpts, "BOTTOMRIGHT", 0, -2)
mainTabOptsLine:SetHeight(2)

local mainTabDivider = window:CreateTexture(nil, "ARTWORK")
mainTabDivider:SetPoint("TOPLEFT", window, "TOPLEFT", 2, -68)
mainTabDivider:SetPoint("TOPRIGHT", window, "TOPRIGHT", -2, -68)
mainTabDivider:SetHeight(1)
CT(mainTabDivider, unpack(C.border))

-- ─── Panel: Begrüßungen ───────────────────────────────────────────────────────

local greetPanel = CreateFrame("Frame", nil, window)
greetPanel:SetPoint("TOPLEFT", window, "TOPLEFT", 0, -70)
greetPanel:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", 0, 38)
greetPanel:Hide()

-- Feste Sub-Tabs: DE und EN
local tabDE = CreateFrame("Frame", nil, greetPanel)
tabDE:SetSize(80, 24)
tabDE:SetPoint("TOPLEFT", greetPanel, "TOPLEFT", 12, -8)
tabDE:EnableMouse(true)

local tabDEText = tabDE:CreateFontString(nil, "OVERLAY", "GameFontNormal")
tabDEText:SetPoint("LEFT", tabDE, "LEFT", 0, 0)
tabDEText:SetFont(tabDEText:GetFont(), 10, "")

local tabDELine = tabDE:CreateTexture(nil, "ARTWORK")
tabDELine:SetPoint("BOTTOMLEFT", tabDE, "BOTTOMLEFT", 0, -2)
tabDELine:SetPoint("BOTTOMRIGHT", tabDE, "BOTTOMRIGHT", 0, -2)
tabDELine:SetHeight(2)

local tabEN = CreateFrame("Frame", nil, greetPanel)
tabEN:SetSize(80, 24)
tabEN:SetPoint("LEFT", tabDE, "RIGHT", 4, 0)
tabEN:EnableMouse(true)

local tabENText = tabEN:CreateFontString(nil, "OVERLAY", "GameFontNormal")
tabENText:SetPoint("LEFT", tabEN, "LEFT", 0, 0)
tabENText:SetFont(tabENText:GetFont(), 10, "")

local tabENLine = tabEN:CreateTexture(nil, "ARTWORK")
tabENLine:SetPoint("BOTTOMLEFT", tabEN, "BOTTOMLEFT", 0, -2)
tabENLine:SetPoint("BOTTOMRIGHT", tabEN, "BOTTOMRIGHT", 0, -2)
tabENLine:SetHeight(2)

-- Dynamische custom-Tabs (max. 2): werden in RefreshList aufgebaut
local customTabFrames = {}  -- {frame, text, line, key}

-- Der "+" Button zum Hinzufügen einer neuen Sprache
local addLangBtn = CreateFrame("Button", nil, greetPanel, "BackdropTemplate")
addLangBtn:SetSize(22, 22)
BD(addLangBtn, 8)
addLangBtn:SetBackdropColor(unpack(C.bgMid))
addLangBtn:SetBackdropBorderColor(unpack(C.borderSub))
local addLangTex = addLangBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
addLangTex:SetAllPoints()
addLangTex:SetText("+")
addLangTex:SetFont(addLangTex:GetFont(), 13, "")
addLangTex:SetTextColor(unpack(C.teal))
addLangBtn:SetScript("OnEnter", function()
    addLangBtn:SetBackdropColor(unpack(C.tealBg))
    addLangBtn:SetBackdropBorderColor(unpack(C.tealDim))
end)
addLangBtn:SetScript("OnLeave", function()
    addLangBtn:SetBackdropColor(unpack(C.bgMid))
    addLangBtn:SetBackdropBorderColor(unpack(C.borderSub))
end)

local subTabDivider = greetPanel:CreateTexture(nil, "ARTWORK")
subTabDivider:SetPoint("TOPLEFT", greetPanel, "TOPLEFT", 2, -34)
subTabDivider:SetPoint("TOPRIGHT", greetPanel, "TOPRIGHT", -2, -34)
subTabDivider:SetHeight(1)
CT(subTabDivider, unpack(C.borderSub))

-- ─── Popup: Neue Sprache benennen ─────────────────────────────────────────────

local newLangPopup = CreateFrame("Frame", "NiceOneNewLang", UIParent, "BackdropTemplate")
newLangPopup:SetSize(280, 120)
newLangPopup:SetPoint("CENTER", window, "CENTER", 0, 0)
BD(newLangPopup, 14)
newLangPopup:SetBackdropColor(unpack(C.bgDark))
newLangPopup:SetBackdropBorderColor(unpack(C.teal))
newLangPopup:SetFrameStrata("TOOLTIP")
newLangPopup:Hide()

local newLangTitle = newLangPopup:CreateFontString(nil, "OVERLAY", "GameFontNormal")
newLangTitle:SetPoint("TOPLEFT", newLangPopup, "TOPLEFT", 14, -14)
newLangTitle:SetFont(newLangTitle:GetFont(), 11, "")
newLangTitle:SetTextColor(unpack(C.teal))

local newLangHint = newLangPopup:CreateFontString(nil, "OVERLAY", "GameFontNormal")
newLangHint:SetPoint("TOPLEFT", newLangTitle, "BOTTOMLEFT", 0, -6)
newLangHint:SetFont(newLangHint:GetFont(), 9, "ITALIC")
newLangHint:SetTextColor(unpack(C.textDim))

local newLangInput = CreateFrame("EditBox", nil, newLangPopup, "InputBoxTemplate")
newLangInput:SetSize(200, 24)
newLangInput:SetPoint("TOPLEFT", newLangHint, "BOTTOMLEFT", 0, -8)
newLangInput:SetAutoFocus(false)
newLangInput:SetMaxLetters(12)
newLangInput:SetTextColor(unpack(C.textMuted))

local newLangConfirm = CreateFrame("Button", nil, newLangPopup, "BackdropTemplate")
newLangConfirm:SetSize(90, 22)
newLangConfirm:SetPoint("BOTTOMRIGHT", newLangPopup, "BOTTOMRIGHT", -14, 12)
BD(newLangConfirm, 8)
newLangConfirm:SetBackdropColor(unpack(C.tealBg))
newLangConfirm:SetBackdropBorderColor(unpack(C.tealDim))
local newLangConfirmText = newLangConfirm:CreateFontString(nil, "OVERLAY", "GameFontNormal")
newLangConfirmText:SetAllPoints()
newLangConfirmText:SetFont(newLangConfirmText:GetFont(), 10, "")
newLangConfirmText:SetTextColor(unpack(C.teal))

local newLangCancel = CreateFrame("Button", nil, newLangPopup, "BackdropTemplate")
newLangCancel:SetSize(90, 22)
newLangCancel:SetPoint("RIGHT", newLangConfirm, "LEFT", -6, 0)
BD(newLangCancel, 8)
newLangCancel:SetBackdropColor(unpack(C.bgDark))
newLangCancel:SetBackdropBorderColor(unpack(C.borderSub))
local newLangCancelText = newLangCancel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
newLangCancelText:SetAllPoints()
newLangCancelText:SetFont(newLangCancelText:GetFont(), 10, "")
newLangCancelText:SetTextColor(unpack(C.textDim))

local function AddCustomLanguage()
    local name = newLangInput:GetText()
    if not name or name == "" then return end

    -- Eindeutigen Key generieren: Zeitstempel-basiert um Kollisionen zu vermeiden
    local key = "custom_" .. tostring(GetTime()):gsub("%.", "")
    table.insert(NiceOneCustomLangs, {key = key, name = name})
    NiceOneMessages[key] = {}

    newLangInput:SetText("")
    newLangInput:ClearFocus()
    newLangPopup:Hide()

    activeTab = key
    RefreshList()
end

newLangConfirm:SetScript("OnClick", AddCustomLanguage)
newLangCancel:SetScript("OnClick", function()
    newLangInput:SetText("")
    newLangInput:ClearFocus()
    newLangPopup:Hide()
end)
newLangInput:SetScript("OnEnterPressed", AddCustomLanguage)
newLangInput:SetScript("OnEscapePressed", function(self)
    self:SetText("")
    self:ClearFocus()
    newLangPopup:Hide()
end)

addLangBtn:SetScript("OnClick", function()
    newLangTitle:SetText(L("newLangTitle"))
    newLangHint:SetText(L("newLangHint"))
    newLangConfirmText:SetText(L("save"))
    newLangCancelText:SetText(L("cancel"))
    newLangInput:SetText("")
    newLangPopup:Show()
    newLangInput:SetFocus()
end)

-- ─── Nachrichten-Rows ─────────────────────────────────────────────────────────

local MAX_ROWS = 10
local rows = {}

for i = 1, MAX_ROWS do
    local rowFrame = CreateFrame("Frame", nil, greetPanel, "BackdropTemplate")
    rowFrame:SetSize(400, 28)
    rowFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 0})
    rowFrame:SetBackdropColor(0, 0, 0, 0)
    rowFrame:EnableMouse(true)
    rowFrame:Hide()

    local msgText = rowFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    msgText:SetPoint("LEFT", rowFrame, "LEFT", 8, 0)
    msgText:SetWidth(340)
    msgText:SetJustifyH("LEFT")
    msgText:SetFont(msgText:GetFont(), 11, "")
    msgText:SetTextColor(unpack(C.textMuted))

    local editBtn = CreateFrame("Button", nil, greetPanel, "BackdropTemplate")
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

    local delBtn = CreateFrame("Button", nil, greetPanel, "BackdropTemplate")
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

    rows[i] = {frame = rowFrame, text = msgText, edit = editBtn, del = delBtn}
end

-- Eingabefeld
local inputBox = CreateFrame("EditBox", nil, greetPanel, "InputBoxTemplate")
inputBox:SetSize(316, 26)
inputBox:SetPoint("BOTTOMLEFT", greetPanel, "BOTTOMLEFT", 14, 6)
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

local addBtn = CreateFrame("Button", nil, greetPanel, "BackdropTemplate")
addBtn:SetSize(110, 26)
addBtn:SetPoint("LEFT", inputBox, "RIGHT", 8, 0)
BD(addBtn, 10)
addBtn:SetBackdropColor(unpack(C.tealBg))
addBtn:SetBackdropBorderColor(unpack(C.tealDim))
local addBtnText = addBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
addBtnText:SetAllPoints()
addBtnText:SetFont(addBtnText:GetFont(), 10, "")
addBtnText:SetTextColor(unpack(C.teal))
addBtn:SetScript("OnEnter", function() addBtn:SetBackdropColor(0.110, 0.260, 0.240, 0.7) end)
addBtn:SetScript("OnLeave", function() addBtn:SetBackdropColor(unpack(C.tealBg)) end)
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

-- ─── Panel: Options ───────────────────────────────────────────────────────────

local optsPanel = CreateFrame("Frame", nil, window)
optsPanel:SetPoint("TOPLEFT", window, "TOPLEFT", 0, -70)
optsPanel:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", 0, 38)
optsPanel:Hide()

local function MakeToggle(parent, label, xOffset, yOffset, getValue, setValue, onChanged)
    local track = CreateFrame("Button", nil, parent, "BackdropTemplate")
    track:SetSize(36, 16)
    track:SetPoint("TOPLEFT", parent, "TOPLEFT", xOffset, yOffset)
    track:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 0, insets = {left=2, right=2, top=2, bottom=2}})

    local knob = track:CreateTexture(nil, "OVERLAY")
    knob:SetSize(12, 12)

    local labelText = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    labelText:SetPoint("LEFT", track, "RIGHT", 8, 0)
    labelText:SetFont(labelText:GetFont(), 10, "")
    labelText:SetTextColor(unpack(C.textMuted))
    labelText:SetText(label)

    local function UpdateVisual()
        if getValue() then
            track:SetBackdropColor(unpack(C.tealBg))
            track:SetBackdropBorderColor(unpack(C.teal))
            knob:SetColorTexture(unpack(C.teal))
            knob:ClearAllPoints()
            knob:SetPoint("RIGHT", track, "RIGHT", -3, 0)
        else
            track:SetBackdropColor(unpack(C.bgDark))
            track:SetBackdropBorderColor(unpack(C.borderSub))
            knob:SetColorTexture(unpack(C.textDim))
            knob:ClearAllPoints()
            knob:SetPoint("LEFT", track, "LEFT", 3, 0)
        end
    end

    track:SetScript("OnClick", function()
        setValue(not getValue())
        UpdateVisual()
        if onChanged then onChanged() end
    end)

    UpdateVisual()
    return track, labelText, UpdateVisual
end

-- Abschnitt: Active language
local langLabel = optsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
langLabel:SetPoint("TOPLEFT", optsPanel, "TOPLEFT", 16, -20)
langLabel:SetFont(langLabel:GetFont(), 10, "")
langLabel:SetTextColor(unpack(C.textDim))

local langBtnDE = CreateFrame("Button", nil, optsPanel, "BackdropTemplate")
langBtnDE:SetSize(90, 24)
langBtnDE:SetPoint("TOPLEFT", optsPanel, "TOPLEFT", 16, -40)
BD(langBtnDE, 8)
local langBtnDEText = langBtnDE:CreateFontString(nil, "OVERLAY", "GameFontNormal")
langBtnDEText:SetAllPoints()
langBtnDEText:SetFont(langBtnDEText:GetFont(), 10, "")

local langBtnEN = CreateFrame("Button", nil, optsPanel, "BackdropTemplate")
langBtnEN:SetSize(90, 24)
langBtnEN:SetPoint("LEFT", langBtnDE, "RIGHT", 6, 0)
BD(langBtnEN, 8)
local langBtnENText = langBtnEN:CreateFontString(nil, "OVERLAY", "GameFontNormal")
langBtnENText:SetAllPoints()
langBtnENText:SetFont(langBtnENText:GetFont(), 10, "")

-- Dynamische custom-Sprachbuttons im Optionen-Tab (Aktive Sprache Sektion)
local customLangBtns = {}  -- {btn, btnText}

-- Dynamische custom-Rows für Verwaltung (edit/del)
local customLangRows = {}  -- {frame, nameText, editBtn, delBtn}

local optsDivider1 = optsPanel:CreateTexture(nil, "ARTWORK")
optsDivider1:SetPoint("TOPLEFT", optsPanel, "TOPLEFT", 2, -76)
optsDivider1:SetPoint("TOPRIGHT", optsPanel, "TOPRIGHT", -2, -76)
optsDivider1:SetHeight(1)
CT(optsDivider1, unpack(C.borderSub))

-- Abschnitt: Greet in
local greetInLabel = optsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
greetInLabel:SetPoint("TOPLEFT", optsPanel, "TOPLEFT", 16, -92)
greetInLabel:SetFont(greetInLabel:GetFont(), 10, "")
greetInLabel:SetTextColor(unpack(C.textDim))

local _, partyToggleLabel, partyToggleUpdate = MakeToggle(
    optsPanel, "", 16, -116,
    function() return NiceOneInParty end,
    function(v) NiceOneInParty = v end
)

local _, raidToggleLabel, raidToggleUpdate = MakeToggle(
    optsPanel, "", 140, -116,
    function() return NiceOneInRaid end,
    function(v) NiceOneInRaid = v end
)

local optsDivider2 = optsPanel:CreateTexture(nil, "ARTWORK")
optsDivider2:SetPoint("TOPLEFT", optsPanel, "TOPLEFT", 2, -152)
optsDivider2:SetPoint("TOPRIGHT", optsPanel, "TOPRIGHT", -2, -152)
optsDivider2:SetHeight(1)
CT(optsDivider2, unpack(C.borderSub))

-- Abschnitt: Party-Modus
local partyOnceLabel = optsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
partyOnceLabel:SetPoint("TOPLEFT", optsPanel, "TOPLEFT", 16, -168)
partyOnceLabel:SetFont(partyOnceLabel:GetFont(), 10, "")
partyOnceLabel:SetTextColor(unpack(C.textDim))

local _, _, partyOnceToggleUpdate = MakeToggle(
    optsPanel, "", 16, -192,
    function() return NiceOneInPartyOnce end,
    function(v) NiceOneInPartyOnce = v end
)

-- ─── Popup: Sprache umbenennen ────────────────────────────────────────────────

local renameLangPopup = CreateFrame("Frame", "NiceOneRenameLang", UIParent, "BackdropTemplate")
renameLangPopup:SetSize(280, 120)
renameLangPopup:SetPoint("CENTER", window, "CENTER", 0, 0)
BD(renameLangPopup, 14)
renameLangPopup:SetBackdropColor(unpack(C.bgDark))
renameLangPopup:SetBackdropBorderColor(unpack(C.teal))
renameLangPopup:SetFrameStrata("TOOLTIP")
renameLangPopup:Hide()

local renameLangTitle = renameLangPopup:CreateFontString(nil, "OVERLAY", "GameFontNormal")
renameLangTitle:SetPoint("TOPLEFT", renameLangPopup, "TOPLEFT", 14, -14)
renameLangTitle:SetFont(renameLangTitle:GetFont(), 11, "")
renameLangTitle:SetTextColor(unpack(C.teal))

local renameLangHint = renameLangPopup:CreateFontString(nil, "OVERLAY", "GameFontNormal")
renameLangHint:SetPoint("TOPLEFT", renameLangTitle, "BOTTOMLEFT", 0, -6)
renameLangHint:SetFont(renameLangHint:GetFont(), 9, "ITALIC")
renameLangHint:SetTextColor(unpack(C.textDim))

local renameLangInput = CreateFrame("EditBox", nil, renameLangPopup, "InputBoxTemplate")
renameLangInput:SetSize(200, 24)
renameLangInput:SetPoint("TOPLEFT", renameLangHint, "BOTTOMLEFT", 0, -8)
renameLangInput:SetAutoFocus(false)
renameLangInput:SetMaxLetters(12)
renameLangInput:SetTextColor(unpack(C.textMuted))

local renameLangConfirm = CreateFrame("Button", nil, renameLangPopup, "BackdropTemplate")
renameLangConfirm:SetSize(90, 22)
renameLangConfirm:SetPoint("BOTTOMRIGHT", renameLangPopup, "BOTTOMRIGHT", -14, 12)
BD(renameLangConfirm, 8)
renameLangConfirm:SetBackdropColor(unpack(C.tealBg))
renameLangConfirm:SetBackdropBorderColor(unpack(C.tealDim))
local renameLangConfirmText = renameLangConfirm:CreateFontString(nil, "OVERLAY", "GameFontNormal")
renameLangConfirmText:SetAllPoints()
renameLangConfirmText:SetFont(renameLangConfirmText:GetFont(), 10, "")
renameLangConfirmText:SetTextColor(unpack(C.teal))

local renameLangCancel = CreateFrame("Button", nil, renameLangPopup, "BackdropTemplate")
renameLangCancel:SetSize(90, 22)
renameLangCancel:SetPoint("RIGHT", renameLangConfirm, "LEFT", -6, 0)
BD(renameLangCancel, 8)
renameLangCancel:SetBackdropColor(unpack(C.bgDark))
renameLangCancel:SetBackdropBorderColor(unpack(C.borderSub))
local renameLangCancelText = renameLangCancel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
renameLangCancelText:SetAllPoints()
renameLangCancelText:SetFont(renameLangCancelText:GetFont(), 10, "")
renameLangCancelText:SetTextColor(unpack(C.textDim))

local renameLangTargetIndex = nil  -- welche custom-Sprache gerade umbenannt wird

local function DoRename()
    local name = renameLangInput:GetText()
    if not name or name == "" then return end
    if renameLangTargetIndex then
        NiceOneCustomLangs[renameLangTargetIndex].name = name
    end
    renameLangInput:SetText("")
    renameLangInput:ClearFocus()
    renameLangPopup:Hide()
    RefreshList()
end

renameLangConfirm:SetScript("OnClick", DoRename)
renameLangCancel:SetScript("OnClick", function()
    renameLangInput:SetText("")
    renameLangInput:ClearFocus()
    renameLangPopup:Hide()
end)
renameLangInput:SetScript("OnEnterPressed", DoRename)
renameLangInput:SetScript("OnEscapePressed", function(self)
    self:SetText("")
    self:ClearFocus()
    renameLangPopup:Hide()
end)

-- ─── Bestätigungsdialog ───────────────────────────────────────────────────────

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

-- confirmDelete OnClick wird dynamisch gesetzt je nach Kontext (Nachricht oder Sprache)
local confirmMode  = "message"  -- "message" oder "language"
local confirmLangIndex = nil

confirmDelete:SetScript("OnClick", function()
    if confirmMode == "message" then
        if selectedIndex then
            table.remove(NiceOneMessages[activeTab], selectedIndex)
            selectedIndex = nil
            inputBox:SetText("")
            inputBox:ClearFocus()
        end
    elseif confirmMode == "language" then
        if confirmLangIndex then
            local key = NiceOneCustomLangs[confirmLangIndex].key
            -- Wenn die gelöschte Sprache gerade aktiv ist, zurück auf DE
            if NiceOneLanguage == key then
                NiceOneLanguage = "de"
            end
            -- Wenn der activeTab die gelöschte Sprache war, zurück auf DE
            if activeTab == key then
                activeTab = "de"
            end
            NiceOneMessages[key] = nil
            table.remove(NiceOneCustomLangs, confirmLangIndex)
            confirmLangIndex = nil
        end
    end
    confirmDialog:Hide()
    RefreshList()
end)

-- ─── Impressum Popup ──────────────────────────────────────────────────────────

local infoPopup = CreateFrame("Frame", "NiceOneInfoPopup", UIParent, "BackdropTemplate")
infoPopup:SetSize(340, 260)
infoPopup:SetPoint("CENTER", window, "CENTER", 0, 0)
BD(infoPopup, 14)
infoPopup:SetBackdropColor(unpack(C.bgDark))
infoPopup:SetBackdropBorderColor(unpack(C.teal))
infoPopup:SetFrameStrata("TOOLTIP")
infoPopup:Hide()

local infoTitle = infoPopup:CreateFontString(nil, "OVERLAY", "GameFontNormal")
infoTitle:SetPoint("TOPLEFT", infoPopup, "TOPLEFT", 14, -14)
infoTitle:SetTextColor(unpack(C.teal))
infoTitle:SetFont(infoTitle:GetFont(), 11, "")
infoTitle:SetText("NiceOne – Info & Support")

local infoLine = infoPopup:CreateTexture(nil, "ARTWORK")
infoLine:SetPoint("TOPLEFT", infoPopup, "TOPLEFT", 3, -30)
infoLine:SetPoint("TOPRIGHT", infoPopup, "TOPRIGHT", -3, -30)
infoLine:SetHeight(1)
CT(infoLine, unpack(C.teal))

local infoTextDE = infoPopup:CreateFontString(nil, "OVERLAY", "GameFontNormal")
infoTextDE:SetPoint("TOP", infoPopup, "TOP", 0, -42)
infoTextDE:SetWidth(310)
infoTextDE:SetJustifyH("CENTER")
infoTextDE:SetFont(infoTextDE:GetFont(), 9, "")
infoTextDE:SetTextColor(unpack(C.textMuted))
infoTextDE:SetText("Dieses Addon wird ohne Gewähr bereitgestellt.\nDer Autor übernimmt keine Verantwortung für\nNachrichten die über dieses Addon gesendet\nwerden oder daraus entstehende Konsequenzen.")

local infoLine2 = infoPopup:CreateTexture(nil, "ARTWORK")
infoLine2:SetPoint("TOPLEFT", infoPopup, "TOPLEFT", 3, -110)
infoLine2:SetPoint("TOPRIGHT", infoPopup, "TOPRIGHT", -3, -110)
infoLine2:SetHeight(1)
CT(infoLine2, unpack(C.borderSub))

local infoTextEN = infoPopup:CreateFontString(nil, "OVERLAY", "GameFontNormal")
infoTextEN:SetPoint("TOP", infoPopup, "TOP", 0, -118)
infoTextEN:SetWidth(310)
infoTextEN:SetJustifyH("CENTER")
infoTextEN:SetFont(infoTextEN:GetFont(), 9, "")
infoTextEN:SetTextColor(unpack(C.textDim))
infoTextEN:SetText("This addon is provided as-is. The author is not\nresponsible for any messages sent through this\naddon or any consequences arising from its use.")

local discordBtn = CreateFrame("Button", nil, infoPopup, "BackdropTemplate")
discordBtn:SetSize(140, 24)
discordBtn:SetPoint("BOTTOMLEFT", infoPopup, "BOTTOMLEFT", 14, 14)
BD(discordBtn, 8)
discordBtn:SetBackdropColor(unpack(C.tealBg))
local discordTex = discordBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
discordTex:SetAllPoints()
discordTex:SetFont(discordTex:GetFont(), 9, "")
discordTex:SetTextColor(unpack(C.teal))
discordTex:SetText("Join Discord")
discordBtn:SetScript("OnClick", function() print("https://discord.gg/bZGA353KYx") end)
discordBtn:SetScript("OnEnter", function() discordBtn:SetBackdropColor(0.110, 0.260, 0.240, 0.7) end)
discordBtn:SetScript("OnLeave", function() discordBtn:SetBackdropColor(unpack(C.tealBg)) end)

local supportBtn = CreateFrame("Button", nil, infoPopup, "BackdropTemplate")
supportBtn:SetSize(140, 24)
supportBtn:SetPoint("BOTTOMRIGHT", infoPopup, "BOTTOMRIGHT", -14, 14)
BD(supportBtn, 8)
supportBtn:SetBackdropColor(unpack(C.tealBg))
local supportTex = supportBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
supportTex:SetAllPoints()
supportTex:SetFont(supportTex:GetFont(), 9, "")
supportTex:SetTextColor(unpack(C.teal))
supportTex:SetText("Submit Alpha Feedback")
supportBtn:SetScript("OnClick", function() print("https://discord.gg/59KbxVRDpn") end)
supportBtn:SetScript("OnEnter", function() supportBtn:SetBackdropColor(0.110, 0.260, 0.240, 0.7) end)
supportBtn:SetScript("OnLeave", function() supportBtn:SetBackdropColor(unpack(C.tealBg)) end)
infoPopup:SetScript("OnMouseDown", function() infoPopup:Hide() end)

local infoBtn = CreateFrame("Button", nil, window, "BackdropTemplate")
infoBtn:SetSize(18, 18)
infoBtn:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", -10, 11)
BD(infoBtn, 8)
infoBtn:SetBackdropColor(unpack(C.bgMid))
local infoBtnTex = infoBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
infoBtnTex:SetAllPoints()
infoBtnTex:SetFont(infoBtnTex:GetFont(), 11, "OUTLINE")
infoBtnTex:SetTextColor(unpack(C.textMuted))
infoBtnTex:SetText("i")
infoBtn:SetScript("OnClick", function()
    if infoPopup:IsShown() then infoPopup:Hide() else infoPopup:Show() end
end)
infoBtn:SetScript("OnEnter", function()
    infoBtnTex:SetTextColor(unpack(C.teal))
    infoBtn:SetBackdropColor(unpack(C.tealBg))
end)
infoBtn:SetScript("OnLeave", function()
    infoBtnTex:SetTextColor(unpack(C.textMuted))
    infoBtn:SetBackdropColor(unpack(C.bgMid))
end)

-- ─── Haupt-Tab Logik ──────────────────────────────────────────────────────────

local function UpdateMainTabs()
    if mainTab == "greetings" then
        mainTabGreetText:SetTextColor(unpack(C.teal))
        CT(mainTabGreetLine, unpack(C.teal))
        mainTabOptsText:SetTextColor(unpack(C.textDim))
        CT(mainTabOptsLine, 0, 0, 0, 0)
        greetPanel:Show()
        optsPanel:Hide()
    else
        mainTabOptsText:SetTextColor(unpack(C.teal))
        CT(mainTabOptsLine, unpack(C.teal))
        mainTabGreetText:SetTextColor(unpack(C.textDim))
        CT(mainTabGreetLine, 0, 0, 0, 0)
        optsPanel:Show()
        greetPanel:Hide()
    end
end

local function UpdateLangButtons()
    local function Apply(btn, btnText, isActive)
        if isActive then
            btn:SetBackdropColor(unpack(C.tealBg))
            btn:SetBackdropBorderColor(unpack(C.teal))
            btnText:SetTextColor(unpack(C.teal))
        else
            btn:SetBackdropColor(unpack(C.bgDark))
            btn:SetBackdropBorderColor(unpack(C.borderSub))
            btnText:SetTextColor(unpack(C.textDim))
        end
    end
    Apply(langBtnDE, langBtnDEText, NiceOneLanguage == "de")
    Apply(langBtnEN, langBtnENText, NiceOneLanguage == "en")

    -- Alte custom-Buttons verstecken
    for _, cb in ipairs(customLangBtns) do
        cb.btn:Hide()
    end
    customLangBtns = {}

    -- Neue custom-Buttons direkt neben EN erstellen
    local lastBtn = langBtnEN
    for i, lang in ipairs(NiceOneCustomLangs) do
        local btn = CreateFrame("Button", nil, optsPanel, "BackdropTemplate")
        btn:SetSize(90, 24)
        btn:SetPoint("LEFT", lastBtn, "RIGHT", 6, 0)
        BD(btn, 8)
        local btnText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        btnText:SetAllPoints()
        btnText:SetFont(btnText:GetFont(), 10, "")
        Apply(btn, btnText, NiceOneLanguage == lang.key)
        btnText:SetText(lang.name)

        local capturedKey = lang.key
        btn:SetScript("OnClick", function()
            NiceOneLanguage = capturedKey
            UpdateLangButtons()
            RefreshList()
        end)

        customLangBtns[i] = {btn = btn, btnText = btnText}
        lastBtn = btn
    end
end

-- ─── RefreshList ──────────────────────────────────────────────────────────────

function RefreshList()
    -- Locale
    mainTabGreetText:SetText(L("tabGreetings"))
    mainTabOptsText:SetText(L("tabOptions"))
    tabDEText:SetText(L("tabDE"))
    tabENText:SetText(L("tabEN"))
    langLabel:SetText(L("optLanguage"))
    langBtnDEText:SetText(L("tabDE"))
    langBtnENText:SetText(L("tabEN"))
    greetInLabel:SetText(L("greetIn"))
    partyToggleLabel:SetText(L("optParty"))
    raidToggleLabel:SetText(L("optRaid"))
    partyOnceLabel:SetText(L("optPartyOnce"))
    confirmTitle:SetText(L("removeMsg"))
    confirmCancelText:SetText(L("cancel"))
    confirmDeleteText:SetText(L("delete"))
    renameLangTitle:SetText(L("newLangTitle"))
    renameLangHint:SetText(L("newLangHint"))
    renameLangConfirmText:SetText(L("save"))
    renameLangCancelText:SetText(L("cancel"))
    newLangConfirmText:SetText(L("save"))
    newLangCancelText:SetText(L("cancel"))

    if selectedIndex then
        addBtnText:SetText(L("save"))
    else
        addBtnText:SetText(L("add"))
    end

    UpdateMainTabs()
    UpdateLangButtons()
    partyToggleUpdate()
    raidToggleUpdate()
    partyOnceToggleUpdate()

    -- ── Sub-Tabs im Begrüßungen-Panel dynamisch aufbauen ──────────────────────

    -- Alte custom-Tab-Frames verstecken
    for _, ct in ipairs(customTabFrames) do
        ct.frame:Hide()
    end
    customTabFrames = {}

    -- Anker für den + Button: nach EN, dann nach letztem custom-Tab
    local lastTabFrame = tabEN

    for i, lang in ipairs(NiceOneCustomLangs) do
        local ct = CreateFrame("Frame", nil, greetPanel)
        ct:SetSize(80, 24)
        ct:SetPoint("LEFT", lastTabFrame, "RIGHT", 4, 0)
        ct:EnableMouse(true)

        local ctText = ct:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        ctText:SetPoint("LEFT", ct, "LEFT", 0, 0)
        ctText:SetFont(ctText:GetFont(), 10, "")
        ctText:SetText(lang.name)

        local ctLine = ct:CreateTexture(nil, "ARTWORK")
        ctLine:SetPoint("BOTTOMLEFT", ct, "BOTTOMLEFT", 0, -2)
        ctLine:SetPoint("BOTTOMRIGHT", ct, "BOTTOMRIGHT", 0, -2)
        ctLine:SetHeight(2)

        if activeTab == lang.key then
            ctText:SetTextColor(unpack(C.teal))
            CT(ctLine, unpack(C.teal))
        else
            ctText:SetTextColor(unpack(C.textDim))
            CT(ctLine, 0, 0, 0, 0)
        end

        local capturedKey = lang.key
        ct:SetScript("OnMouseDown", function()
            activeTab = capturedKey
            selectedIndex = nil
            inputBox:SetText("")
            inputBox:ClearFocus()
            RefreshList()
        end)

        customTabFrames[i] = {frame = ct, text = ctText, line = ctLine, key = lang.key}
        lastTabFrame = ct
    end

    -- "+" Button positionieren und nur zeigen wenn < 2 custom-Sprachen
    addLangBtn:ClearAllPoints()
    addLangBtn:SetPoint("LEFT", lastTabFrame, "RIGHT", 6, 1)
    if #NiceOneCustomLangs < 2 then
        addLangBtn:Show()
    else
        addLangBtn:Hide()
    end

    -- Sub-Tab Highlight für DE und EN
    if activeTab == "de" then
        tabDEText:SetTextColor(unpack(C.teal))
        CT(tabDELine, unpack(C.teal))
    else
        tabDEText:SetTextColor(unpack(C.textDim))
        CT(tabDELine, 0, 0, 0, 0)
    end
    if activeTab == "en" then
        tabENText:SetTextColor(unpack(C.teal))
        CT(tabENLine, unpack(C.teal))
    else
        tabENText:SetTextColor(unpack(C.textDim))
        CT(tabENLine, 0, 0, 0, 0)
    end

    -- ── Custom-Sprachen im Optionen-Panel dynamisch aufbauen ──────────────────

    -- Alte Rows verstecken
    for _, row in ipairs(customLangRows) do
        row.frame:Hide()
    end
    customLangRows = {}

    -- Divider und Abschnitt nur anzeigen wenn custom-Sprachen vorhanden
    local customSectionLabel = optsPanel.customSectionLabel
    if not customSectionLabel then
        customSectionLabel = optsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        customSectionLabel:SetFont(customSectionLabel:GetFont(), 10, "")
        customSectionLabel:SetTextColor(unpack(C.textDim))
        optsPanel.customSectionLabel = customSectionLabel
        optsPanel.customDivider = optsPanel:CreateTexture(nil, "ARTWORK")
        optsPanel.customDivider:SetHeight(1)
        CT(optsPanel.customDivider, unpack(C.borderSub))
    end

    if #NiceOneCustomLangs > 0 then
        -- Divider und Label unterhalb der Party-Once-Sektion
        optsPanel.customDivider:ClearAllPoints()
        optsPanel.customDivider:SetPoint("TOPLEFT", optsPanel, "TOPLEFT", 2, -228)
        optsPanel.customDivider:SetPoint("TOPRIGHT", optsPanel, "TOPRIGHT", -2, -228)
        optsPanel.customDivider:Show()

        customSectionLabel:ClearAllPoints()
        customSectionLabel:SetPoint("TOPLEFT", optsPanel, "TOPLEFT", 16, -244)
        customSectionLabel:SetText(L("optCustomLangs"))
        customSectionLabel:Show()

        for i, lang in ipairs(NiceOneCustomLangs) do
            local yOff = -260 - ((i - 1) * 34)

            local rowFrame = CreateFrame("Frame", nil, optsPanel)
            rowFrame:SetSize(440, 28)
            rowFrame:SetPoint("TOPLEFT", optsPanel, "TOPLEFT", 16, yOff)

            local nameText = rowFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            nameText:SetPoint("LEFT", rowFrame, "LEFT", 0, 0)
            nameText:SetFont(nameText:GetFont(), 10, "")
            nameText:SetTextColor(unpack(C.textMuted))
            nameText:SetText(lang.name)

            local editBtn = CreateFrame("Button", nil, optsPanel, "BackdropTemplate")
            editBtn:SetSize(36, 22)
            editBtn:SetPoint("TOPLEFT", optsPanel, "TOPLEFT", 300, yOff + 3)
            BD(editBtn, 8)
            editBtn:SetBackdropColor(unpack(C.tealBg))
            editBtn:SetBackdropBorderColor(unpack(C.tealDim))
            local editTex = editBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            editTex:SetAllPoints()
            editTex:SetText("edit")
            editTex:SetFont(editTex:GetFont(), 9, "")
            editTex:SetTextColor(unpack(C.teal))

            local delBtn = CreateFrame("Button", nil, optsPanel, "BackdropTemplate")
            delBtn:SetSize(30, 22)
            delBtn:SetPoint("LEFT", editBtn, "RIGHT", 6, 0)
            BD(delBtn, 8)
            delBtn:SetBackdropColor(unpack(C.redBg))
            delBtn:SetBackdropBorderColor(unpack(C.redBorder))
            local delTex = delBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            delTex:SetAllPoints()
            delTex:SetText("del")
            delTex:SetFont(delTex:GetFont(), 9, "")
            delTex:SetTextColor(unpack(C.red))

            local capturedI = i
            editBtn:SetScript("OnClick", function()
                renameLangTargetIndex = capturedI
                renameLangInput:SetText(NiceOneCustomLangs[capturedI].name)
                renameLangPopup:Show()
                renameLangInput:SetFocus()
            end)

            delBtn:SetScript("OnClick", function()
                confirmMode      = "language"
                confirmLangIndex = capturedI
                confirmTitle:SetText(L("deleteLang"))
                confirmMsgText:SetText('"' .. NiceOneCustomLangs[capturedI].name .. '"')
                confirmDialog:Show()
            end)

            customLangRows[i] = {frame = rowFrame, edit = editBtn, del = delBtn}
        end
    else
        optsPanel.customDivider:Hide()
        customSectionLabel:Hide()
    end

    -- ── Nachrichten-Liste ─────────────────────────────────────────────────────

    local messages = NiceOneMessages[activeTab] or {}

    for i = 1, MAX_ROWS do
        rows[i].frame:Hide()
        rows[i].edit:Hide()
        rows[i].del:Hide()
    end

    for i, msg in ipairs(messages) do
        if i > MAX_ROWS then break end
        local yOffset = -40 + ((i - 1) * -30)
        local r = rows[i]

        r.frame:ClearAllPoints()
        r.frame:SetPoint("TOPLEFT", greetPanel, "TOPLEFT", 12, yOffset)
        r.frame:SetBackdropColor(0, 0, 0, 0)
        r.frame:Show()

        r.text:SetText(msg)
        r.text:SetTextColor(unpack(C.textMuted))

        r.edit:ClearAllPoints()
        r.edit:SetPoint("TOPLEFT", greetPanel, "TOPLEFT", 410, yOffset - 3)
        r.edit:Show()

        r.del:ClearAllPoints()
        r.del:SetPoint("TOPLEFT", greetPanel, "TOPLEFT", 450, yOffset - 3)
        r.del:Show()

        local capturedI = i
        r.frame:SetScript("OnEnter", function()
            r.frame:SetBackdropColor(unpack(C.bgHover))
            r.text:SetTextColor(unpack(C.textMain))
        end)
        r.frame:SetScript("OnLeave", function()
            r.frame:SetBackdropColor(0, 0, 0, 0)
            r.text:SetTextColor(unpack(C.textMuted))
        end)
        r.edit:SetScript("OnClick", function()
            selectedIndex = capturedI
            inputBox:SetText(NiceOneMessages[activeTab][capturedI])
            inputBox:SetFocus()
            addBtnText:SetText(L("save"))
        end)
        r.del:SetScript("OnClick", function()
            confirmMode  = "message"
            selectedIndex = capturedI
            confirmTitle:SetText(L("removeMsg"))
            confirmMsgText:SetText('"' .. NiceOneMessages[activeTab][capturedI] .. '"')
            confirmDialog:Show()
        end)
    end
end

-- ─── Tab Klicks ───────────────────────────────────────────────────────────────

mainTabGreet:SetScript("OnMouseDown", function()
    mainTab = "greetings"
    RefreshList()
end)
mainTabOpts:SetScript("OnMouseDown", function()
    mainTab = "options"
    RefreshList()
end)

tabDE:SetScript("OnMouseDown", function()
    activeTab = "de"
    selectedIndex = nil
    inputBox:SetText("")
    inputBox:ClearFocus()
    RefreshList()
end)
tabEN:SetScript("OnMouseDown", function()
    activeTab = "en"
    selectedIndex = nil
    inputBox:SetText("")
    inputBox:ClearFocus()
    RefreshList()
end)

langBtnDE:SetScript("OnClick", function()
    NiceOneLanguage = "de"
    UpdateLangButtons()
    RefreshList()
end)
langBtnEN:SetScript("OnClick", function()
    NiceOneLanguage = "en"
    UpdateLangButtons()
    RefreshList()
end)

-- ─── Toggle ───────────────────────────────────────────────────────────────────

function NiceOneUI_Toggle()
    if window:IsShown() then
        window:Hide()
    else
        selectedIndex = nil
        RefreshList()
        window:Show()
    end
end