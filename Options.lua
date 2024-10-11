-- ********************************************************
-- **                      Memoria                       **
-- **            <http://www.cosmocanyon.de>             **
-- ********************************************************
--
-- This addon is written and copyrighted by:
--    * Mîzukichan @ EU-Antonidas (2010-2021)
--
--
--    This file is part of Memoria.
--
--    Memoria is free software: you can redistribute it and/or 
--    modify it under the terms of the GNU General Public License as 
--    published by the Free Software Foundation, either version 3 of the 
--    License, or (at your option) any later version.
--
--    Memoria is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with Memoria.  
--    If not, see <http://www.gnu.org/licenses/>.
--

-- Check for addon table
local addonName, Memoria = ...

----------------------------
--  Variables and Locals  --
----------------------------
local IsEventValid = C_EventUtils.IsEventValid
Memoria.event_to_cbox = {
    ACHIEVEMENT_EARNED = {"MemoriaOptions_NewAchievementCB"},
    CHALLENGE_MODE_COMPLETED = {"MemoriaOptions_ChallengeDoneCB"},
    CHAT_MSG_SYSTEM = {
        "MemoriaOptions_ReputationChangeCB",
        "MemoriaOptions_ReputationChangeCB_ExaltedOnlyCB"
    },
    ENCOUNTER_END = {
        "MemoriaOptions_BosskillsCB",
        "MemoriaOptions_BosskillsCB_FirstkillsCB"
    },
    PLAYER_LEVEL_UP = {
        "MemoriaOptions_LevelUpCB",
        "MemoriaOptions_LevelUpCB_ShowPlayedCB",
        "MemoriaOptions_LevelUpCB_ShowPlayedCB_ResizeChatCB"
    },
    UPDATE_BATTLEFIELD_STATUS = {
        "MemoriaOptions_BattlegroundEndingCB",
        "MemoriaOptions_BattlegroundEndingCB_WinsOnlyCB",
        "MemoriaOptions_ArenaEndingCB",
        "MemoriaOptions_ArenaEndingCB_WinsOnlyCB"
    },
}
Memoria.option_to_cbox = {
    achievements = "MemoriaOptions_NewAchievementCB",
    levelUp = "MemoriaOptions_LevelUpCB",
    levelUpShowPlayed = "MemoriaOptions_LevelUpCB_ShowPlayedCB",
    resizeChat = "MemoriaOptions_LevelUpCB_ShowPlayedCB_ResizeChatCB",
    reputationChange = "MemoriaOptions_ReputationChangeCB",
    reputationChangeOnlyExalted = "MemoriaOptions_ReputationChangeCB_ExaltedOnlyCB",
    arenaEnding = "MemoriaOptions_ArenaEndingCB",
    arenaEndingOnlyWins = "MemoriaOptions_ArenaEndingCB_WinsOnlyCB",
    battlegroundEnding = "MemoriaOptions_BattlegroundEndingCB",
    battlegroundEndingOnlyWins = "MemoriaOptions_BattlegroundEndingCB_WinsOnlyCB",
    bosskills = "MemoriaOptions_BosskillsCB",
    bosskillsFirstkill = "MemoriaOptions_BosskillsCB_FirstkillsCB",
    challengeDone = "MemoriaOptions_ChallengeDoneCB",
}

----------------------
--  Option Handler  --
----------------------
function Memoria:OptionsEnableDisable(cbFrame)
    local enable = cbFrame:GetChecked() and cbFrame:IsEnabled()
    local colorEnable = {1, 1, 1, 1}
    local colorDisable = {0.5, 0.5, 0.5, 1}
    local children = {cbFrame:GetChildren()}
    local text = getglobal(cbFrame:GetName() .. "_Text")
    if (cbFrame:IsEnabled()) then
        text:SetTextColor(unpack(colorEnable))
    else
       text:SetTextColor(unpack(colorDisable))
    end
    for i = 1, #children do
        text = getglobal(children[i]:GetName() .. "_Text")
        if (enable) then
            children[i]:Enable()
            text:SetTextColor(unpack(colorEnable))
        else
            children[i]:Disable()
            text:SetTextColor(unpack(colorDisable))
        end
        Memoria:OptionsEnableDisable(children[i])
    end
end

function Memoria:OptionsSave()
    for option, checkname in pairs(Memoria.option_to_cbox) do
        Memoria_Options[option] = _G[checkname]:GetChecked()
    end
    Memoria:RegisterEvents(MemoriaFrame)
end

function Memoria:OptionsRestore()
    for event, checkboxes in pairs(Memoria.event_to_cbox) do
        if not IsEventValid(event) then
            for _, checkname in ipairs(checkboxes) do
                _G[checkname]:Disable()
            end
        end
    end
    for option, checkname in pairs(Memoria.option_to_cbox) do
        _G[checkname]:SetChecked(Memoria_Options[option])
    end
    Memoria:OptionsEnableDisable(MemoriaOptions_NewAchievementCB)
    Memoria:OptionsEnableDisable(MemoriaOptions_LevelUpCB)
    Memoria:OptionsEnableDisable(MemoriaOptions_ReputationChangeCB)
    Memoria:OptionsEnableDisable(MemoriaOptions_ArenaEndingCB)
    Memoria:OptionsEnableDisable(MemoriaOptions_BattlegroundEndingCB)
    Memoria:OptionsEnableDisable(MemoriaOptions_BosskillsCB)
    Memoria:OptionsEnableDisable(MemoriaOptions_ChallengeDoneCB)
end

function Memoria:OptionsInitialize()
    -- parse localization
    MemoriaOptions_Title:SetText(Memoria.ADDONNAME.." v."..Memoria.ADDONVERSION)
    MemoriaOptions_EventsHeadline:SetText(Memoria.L["Take screenshot on"])
    MemoriaOptions_NewAchievementCB_Text:SetText(Memoria.L["new achievement"])
    MemoriaOptions_LevelUpCB_Text:SetText(Memoria.L["level up"])
    MemoriaOptions_LevelUpCB_ShowPlayedCB_Text:SetText(Memoria.L["show played"])
    MemoriaOptions_LevelUpCB_ShowPlayedCB_ResizeChatCB_Text:SetText(Memoria.L["resize chat window"])
    MemoriaOptions_ReputationChangeCB_Text:SetText(Memoria.L["new reputation level"])
    MemoriaOptions_ReputationChangeCB_ExaltedOnlyCB_Text:SetText(Memoria.L["exalted only"])
    MemoriaOptions_ArenaEndingCB_Text:SetText(Memoria.L["arena endings"])
    MemoriaOptions_ArenaEndingCB_WinsOnlyCB_Text:SetText(Memoria.L["wins only"])
    MemoriaOptions_BattlegroundEndingCB_Text:SetText(Memoria.L["battleground endings"])
    MemoriaOptions_BattlegroundEndingCB_WinsOnlyCB_Text:SetText(Memoria.L["wins only"])
    MemoriaOptions_BosskillsCB_Text:SetText(Memoria.L["bosskills"])
    MemoriaOptions_BosskillsCB_FirstkillsCB_Text:SetText(Memoria.L["only after first kill"])
    MemoriaOptions_ChallengeDoneCB_Text:SetText(Memoria.L["challenge instance endings"])
    -- parse current options
    Memoria:OptionsRestore()
end


----------------------
--  Register panel  --
----------------------
Memoria.OptionPanel = CreateFrame("Frame", "MemoriaOptions", UIParent, "MemoriaOptionsTemplate")
Memoria.OptionPanel.name = addonName
Memoria.OptionPanel.okay = function() Memoria:OptionsSave() end
Memoria.OptionPanel.cancel = function() Memoria:OptionsRestore() end
Memoria.OptionPanel.OnCommit = Memoria.OptionPanel.okay
Memoria.OptionPanel.OnCancel = Memoria.OptionPanel.cancel
if _G.InterfaceOptions_AddCategory then
  InterfaceOptions_AddCategory(Memoria.OptionPanel)
elseif Settings and Settings.RegisterCanvasLayoutCategory then
  local cat = Settings.RegisterCanvasLayoutCategory(Memoria.OptionPanel, Memoria.OptionPanel.name)
  Memoria.optionsCategory = cat
  Settings.RegisterAddOnCategory(cat)
end