-- NiceOne Addon - Hauptlogik

NiceOneL = {
    de = {
        greetIn      = "Begrüßen in:",
        clickAgain   = "nochmal klicken um Begrüßungssprache zu setzen",
        add          = "+ hinzufügen",
        save         = "speichern",
        cancel       = "abbrechen",
        delete       = "löschen",
        removeMsg    = "Nachricht entfernen?",
        placeholder  = "Neue Begrüßung eingeben...",
        msgSaved     = "NiceOne: Nachricht gespeichert.",
        langSet      = "NiceOne: Begrüßungssprache ist jetzt Deutsch",
        noMessages   = "NiceOne: Keine Nachrichten vorhanden!",
        uiNotLoaded  = "NiceOne: UI nicht geladen.",
    },
    en = {
        greetIn      = "Greet in:",
        clickAgain   = "click again to set as greeting language",
        add          = "+ add",
        save         = "save",
        cancel       = "cancel",
        delete       = "delete",
        removeMsg    = "Remove message?",
        placeholder  = "Enter new greeting...",
        msgSaved     = "NiceOne: Message saved.",
        langSet      = "NiceOne: Greeting language is now English",
        noMessages   = "NiceOne: No messages available!",
        uiNotLoaded  = "NiceOne: UI not loaded.",
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

local function InitDB()
    if not NiceOneDB then
        NiceOneDB = {
            language = "de",
            inParty  = true,
            inRaid   = true,
            messages = {
                de = {},
                en = {},
            },
        }
        for _, msg in ipairs(defaultMessages.de) do
            table.insert(NiceOneDB.messages.de, msg)
        end
        for _, msg in ipairs(defaultMessages.en) do
            table.insert(NiceOneDB.messages.en, msg)
        end
    end
    NiceOneMessages = NiceOneDB.messages
    NiceOneLanguage = NiceOneDB.language
    NiceOneInParty  = NiceOneDB.inParty
    NiceOneInRaid   = NiceOneDB.inRaid
end

local function SaveDB()
    NiceOneDB.language = NiceOneLanguage
    NiceOneDB.inParty  = NiceOneInParty
    NiceOneDB.inRaid   = NiceOneInRaid
    NiceOneDB.messages = NiceOneMessages
end

local lastIndex        = nil
local inRaid           = false
local raidGreeted      = false
local instanceGreeted  = false
local partyMembers     = {}
local lastGroupSize    = 0

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
    local L = NiceOneL[NiceOneLanguage]
    if not messages or #messages == 0 then
        print(L.noMessages)
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
        partyMembers = GetCurrentPartyMembers()
        lastGroupSize = GetNumGroupMembers()
        inRaid = IsInRaid()
        raidGreeted = false
        instanceGreeted = false
        return
    end

    if event == "GROUP_JOINED" then
        if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and not instanceGreeted then
            instanceGreeted = true
            C_Timer.After(2.5, function()
                if NiceOneInParty then
                    SendGreeting()
                end
            end)
        elseif IsInRaid() and not raidGreeted then
            raidGreeted = true
            C_Timer.After(2.5, function()
                if NiceOneInRaid then
                    SendGreeting()
                end
            end)
        end
        return
    end

    if event == "GROUP_ROSTER_UPDATE" then
        C_Timer.After(2.5, function()
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
                    -- Normale Party: nur grüßen wenn jemand NEU dazugekommen ist
                     if NiceOneInParty then
                        local current = GetCurrentPartyMembers()
                        local currentSize = GetNumGroupMembers()
                        -- Nur grüßen wenn die Gruppe größer geworden ist
                        if currentSize > lastGroupSize then
                            local newPlayerFound = false
                            for name, _ in pairs(current) do
                                if not partyMembers[name] then
                                    newPlayerFound = true
                                end
                            end
                            if newPlayerFound then
                                SendGreeting()
                            end
                        end
                        lastGroupSize = currentSize
                        partyMembers = current
                    end
                end
                inRaid = false
                raidGreeted = false

            else
                partyMembers = {}
                inRaid = false
                raidGreeted = false
                instanceGreeted = false
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
        print(NiceOneL[NiceOneLanguage or "de"].uiNotLoaded)
    end
end