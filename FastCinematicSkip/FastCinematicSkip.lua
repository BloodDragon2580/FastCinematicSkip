local L = LibStub("AceLocale-3.0"):GetLocale("FastCinematicSkip", false)

local rev = tonumber(("$Revision: 6 $"):match("%d+"))
local function msg(...)
    print("|cffd6266cFastCinematicSkip|r: ", ...)
end
msg("Loaded rev " .. rev)

local debug_enabled = false
local function debug(...)
    if debug_enabled then
        msg(...)
    end
end

local function modifierDown()
    return IsShiftKeyDown() or IsControlKeyDown() or IsAltKeyDown()
end

--
-- WICHTIG:
-- CinematicFrame_CancelCinematic() ruft intern geschützte Blizzard-Funktionen
-- wie CancelScene() auf. Diese dürfen aus normalen AddOns heraus nicht
-- automatisch aufgerufen werden. Genau dadurch entsteht dein
-- [ADDON_ACTION_BLOCKED]-Fehler.
--
-- Deshalb skippen wir "echte" CinematicFrame-Szenen NICHT mehr automatisch.
-- Stattdessen zeigen wir nur einen Hinweis an. Mit gedrückter Modifikatortaste
-- (Shift/Strg/Alt) passiert ebenfalls nichts.
--
CinematicFrame:HookScript("OnShow", function(self, ...)
    debug("CinematicFrame:OnShow", ...)

    if modifierDown() then
        return
    end

    msg(L["CinematicProtected"] or "Diese Cinematic kann wegen Blizzard-Schutz nicht automatisch übersprungen werden. Bitte ESC benutzen.")
end)

-- Normale MovieFrame-Movies können weiterhin auf diese Weise beendet werden.
local originalPlayMovie = _G["MovieFrame_PlayMovie"]
_G["MovieFrame_PlayMovie"] = function(...)
    debug("MovieFrame_PlayMovie", ...)

    if modifierDown() then
        return originalPlayMovie(...)
    end

    msg(L["Movie"])
    CinematicFinished(1)
    return true
end
