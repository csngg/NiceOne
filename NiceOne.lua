-- NiceOne Addon - Hauptlogik

NiceOneL = {
    de = {
        -- UI Tabs
        tabGreetings   = "Begrüßungen",
        tabOptions     = "Optionen",
        tabDE          = "Deutsch",
        tabEN          = "Englisch",

        -- Optionen Labels
        optLanguage    = "Aktive Sprache:",
        optParty       = "Party",
        optRaid        = "Raid",
        optPartyOnce   = "Einmalig in Party",
        greetIn        = "Begrüßen in:",
        optCustomLangs = "Eigene Sprachen:",

        -- Eingabe / Buttons
        add            = "+ hinzufügen",
        save           = "speichern",
        cancel         = "abbrechen",
        delete         = "löschen",
        removeMsg      = "Nachricht entfernen?",
        placeholder    = "Neue Begrüßung eingeben...",
        newLangTitle   = "Neue Sprache",
        newLangHint    = "Name eingeben (max. 12 Zeichen)",
        deleteLang     = "Sprache löschen?",

        -- System Nachrichten
        msgSaved       = "NiceOne: Nachricht gespeichert.",
        noMessages     = "NiceOne: Keine Nachrichten vorhanden!",
        uiNotLoaded    = "NiceOne: UI nicht geladen.",
    },
    en = {
        -- UI Tabs
        tabGreetings   = "Greetings",
        tabOptions     = "Options",
        tabDE          = "German",
        tabEN          = "English",

        -- Options Labels
        optLanguage    = "Active language:",
        optParty       = "Party",
        optRaid        = "Raid",
        optPartyOnce   = "Once in Party",
        greetIn        = "Greet in:",
        optCustomLangs = "Custom languages:",

        -- Input / Buttons
        add            = "+ add",
        save           = "save",
        cancel         = "cancel",
        delete         = "delete",
        removeMsg      = "Remove message?",
        placeholder    = "Enter new greeting...",
        newLangTitle   = "New language",
        newLangHint    = "Enter name (max. 12 characters)",
        deleteLang     = "Delete language?",

        -- System Messages
        msgSaved       = "NiceOne: Message saved.",
        noMessages     = "NiceOne: No messages available!",
        uiNotLoaded    = "NiceOne: UI not loaded.",
    },
}

local defaultMessages = {
    de = {
        "Hey zusammen! Wie Eleven sagen würde: Friends don't wipe. Schön dabei zu sein!",
        "Moin! Laut Dr. Cox bin ich zwar niemand – aber heute bin ich euer NiceOne. Los geht's!",
        "Hallo! Malcolm hier – nein, NiceOne. Aber ich hab auch einen Plan. Meistens.",
        "Hi Leute! Wubba Lubba Dub Dub – NiceOne ist bereit für Action!",
    },
    en = {
        "Hey everyone! As Eleven would say: Friends don't wipe. Happy to be here!",
        "Hi there! Dr. Cox would call me a newbie – but today I am your NiceOne. Let's go!",
        "Hello! Malcolm in the middle of this dungeon. NiceOne reporting, I have a plan. Mostly.",
        "Hey team! Wubba Lubba Dub Dub – NiceOne is ready for action!",
    },
}

-- UI-Sprache: custom-Sprachen -> immer Englisch, de/en -> aktive Sprache
function NiceOneUILanguage()
    if NiceOneLanguage == "de" then
        return "de"
    end
    return "en"
end

local function InitDB()
    if not NiceOneDB then
        NiceOneDB = {
            language    = "de",
            inParty     = true,
            inRaid      = true,
            partyOnce   = false,
            customLangs = {},
            messages    = { de = {}, en = {} },
        }
        for _, msg in ipairs(defaultMessages.de) do
            table.insert(NiceOneDB.messages.de, msg)
        end
        for _, msg in ipairs(defaultMessages.en) do
            table.insert(NiceOneDB.messages.en, msg)
        end
    end

    -- Sicherheitsnetz: fehlende Felder aus alten Versionen ergänzen
    if NiceOneDB.partyOnce == nil then
        NiceOneDB.partyOnce = false
    end
    if NiceOneDB.customLangs == nil then
        NiceOneDB.customLangs = {}
    end

    -- Migration: alte custom1Name/custom2Name Felder aus v1.2.0-alpha
    if NiceOneDB.custom1Name then
        if #NiceOneDB.customLangs < 2 then
            local key = "custom" .. tostring(#NiceOneDB.customLangs + 1)
            table.insert(NiceOneDB.customLangs, {key = key, name = NiceOneDB.custom1Name})
            NiceOneDB.messages[key] = NiceOneDB.messages.custom1 or {}
        end
        NiceOneDB.custom1Name   = nil
        NiceOneDB.messages.custom1 = nil
    end
    if NiceOneDB.custom2Name then
        if #NiceOneDB.customLangs < 2 then
            local key = "custom" .. tostring(#NiceOneDB.customLangs + 1)
            table.insert(NiceOneDB.customLangs, {key = key, name = NiceOneDB.custom2Name})
            NiceOneDB.messages[key] = NiceOneDB.messages.custom2 or {}
        end
        NiceOneDB.custom2Name   = nil
        NiceOneDB.messages.custom2 = nil
    end

    NiceOneMessages    = NiceOneDB.messages
    NiceOneLanguage    = NiceOneDB.language
    NiceOneInParty     = NiceOneDB.inParty
    NiceOneInRaid      = NiceOneDB.inRaid
    NiceOneInPartyOnce = NiceOneDB.partyOnce
    NiceOneCustomLangs = NiceOneDB.customLangs
end

local function SaveDB()
    NiceOneDB.language    = NiceOneLanguage
    NiceOneDB.inParty     = NiceOneInParty
    NiceOneDB.inRaid      = NiceOneInRaid
    NiceOneDB.partyOnce   = NiceOneInPartyOnce
    NiceOneDB.customLangs = NiceOneCustomLangs
    NiceOneDB.messages    = NiceOneMessages
end

local lastIndex       = nil
local inRaid          = false
local raidGreeted     = false
local instanceGreeted = false
local partyGreeted    = false
local partyMembers    = {}
local lastGroupSize   = 0

local function GetChannel()
    if IsInRaid() and NiceOneInRaid then
        return "RAID"
    elseif IsInGroup() and not IsInRaid() and NiceOneInParty then
        if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
            return "INSTANCE_CHAT"
        else
            return "PARTY"
        end
    end
    return nil
end

local function SendGreeting()
    local messages = NiceOneMessages[NiceOneLanguage]
    local Lx       = NiceOneL[NiceOneUILanguage()]
    if not messages or #messages == 0 then
        print(Lx.noMessages)
        return
    end

    local channel = GetChannel()
    if not channel then return end

    if #messages == 1 then
        SendChatMessage(messages[1], channel)
        return
    end

    local index
    local tries = 0
    repeat
        index = math.random(1, #messages)
        tries = tries + 1
    until index ~= lastIndex or tries > 10

    lastIndex = index
    SendChatMessage(messages[index], channel)
end

local function GetCurrentPartyMembers()
    local members = {}
    for i = 1, GetNumGroupMembers() do
        local name = UnitName("party"..i)
        if name then members[name] = true end
    end
    return members
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:RegisterEvent("GROUP_JOINED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

frame:SetScript("OnEvent", function(self, event, arg1)

    if event == "ADDON_LOADED" and arg1 == "NiceOne" then
        InitDB()
        return
    end

    if event == "PLAYER_LOGOUT" then
        SaveDB()
        return
    end

    if event == "PLAYER_ENTERING_WORLD" then
        partyMembers    = GetCurrentPartyMembers()
        lastGroupSize   = GetNumGroupMembers()
        inRaid          = IsInRaid()
        raidGreeted     = false
        instanceGreeted = false
        partyGreeted    = false
        return
    end

    if event == "GROUP_JOINED" then
        if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and not instanceGreeted then
            instanceGreeted = true
            C_Timer.After(math.random(2, 7), function()
                if NiceOneInParty then SendGreeting() end
            end)
        elseif IsInRaid() and not raidGreeted then
            raidGreeted = true
            C_Timer.After(math.random(2, 7), function()
                if NiceOneInRaid then SendGreeting() end
            end)
        elseif IsInGroup() and not IsInRaid() and not IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
        end
        return
    end

    if event == "GROUP_ROSTER_UPDATE" then
        C_Timer.After(math.random(2, 7), function()
            if IsInRaid() then
                if not inRaid and NiceOneInRaid and not raidGreeted then
                    SendGreeting()
                    raidGreeted = true
                end
                inRaid = true

            elseif IsInGroup() then
                if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
                    if not instanceGreeted and NiceOneInParty then
                        instanceGreeted = true
                        SendGreeting()
                    end
                else
                    if NiceOneInParty then
                        local current     = GetCurrentPartyMembers()
                        local currentSize = GetNumGroupMembers()
                        if currentSize > lastGroupSize then
                            local newPlayerFound = false
                            for name, _ in pairs(current) do
                                if not partyMembers[name] then
                                    newPlayerFound = true
                                end
                            end
                            if newPlayerFound then
                                if NiceOneInPartyOnce then
                                    if not partyGreeted then
                                        partyGreeted = true
                                        SendGreeting()
                                    end
                                else
                                    SendGreeting()
                                end
                            end
                        end
                        lastGroupSize = currentSize
                        partyMembers  = current
                    end
                end
                inRaid      = false
                raidGreeted = false

            else
                partyMembers    = {}
                lastGroupSize   = 0
                inRaid          = false
                raidGreeted     = false
                instanceGreeted = false
                partyGreeted    = false
            end
        end)
    end
end)

SLASH_NICEONE1 = "/niceone"
SLASH_NICEONE2 = "/greet"
SlashCmdList["NICEONE"] = function(input)
    if NiceOneUI_Toggle then
        NiceOneUI_Toggle()
    else
        print(NiceOneL[NiceOneUILanguage()].uiNotLoaded)
    end
end