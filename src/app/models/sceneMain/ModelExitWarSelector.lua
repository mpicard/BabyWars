
local ModelExitWarSelector = class("ModelExitWarSelector")

local ActionCodeFunctions   = requireBW("src.app.utilities.ActionCodeFunctions")
local AuxiliaryFunctions    = requireBW("src.app.utilities.AuxiliaryFunctions")
local LocalizationFunctions = requireBW("src.app.utilities.LocalizationFunctions")
local SingletonGetters      = requireBW("src.app.utilities.SingletonGetters")
local WarFieldManager       = requireBW("src.app.utilities.WarFieldManager")
local WebSocketManager      = requireBW("src.app.utilities.WebSocketManager")
local Actor                 = requireBW("src.global.actors.Actor")
local ActorManager          = requireBW("src.global.actors.ActorManager")

local os, string       = os, string
local getLocalizedText = LocalizationFunctions.getLocalizedText

local ACTION_CODE_GET_WAITING_WAR_CONFIGURATIONS = ActionCodeFunctions.getActionCode("ActionGetWaitingWarConfigurations")

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getPlayerNicknames(warConfiguration, currentTime)
    local players = warConfiguration.players
    local names   = {}
    for i = 1, WarFieldManager.getPlayersCount(warConfiguration.warFieldFileName) do
        if (players[i]) then
            names[i] = string.format("%s (%s: %s)", players[i].account, getLocalizedText(14, "TeamIndex"), AuxiliaryFunctions.getTeamNameWithTeamIndex(players[i].teamIndex))
        end
    end

    return names
end

--------------------------------------------------------------------------------
-- The composition elements.
--------------------------------------------------------------------------------
local function getActorWarFieldPreviewer(self)
    if (not self.m_ActorWarFieldPreviewer) then
        local actor = Actor.createWithModelAndViewName("sceneMain.ModelWarFieldPreviewer", nil, "sceneMain.ViewWarFieldPreviewer")

        self.m_ActorWarFieldPreviewer = actor
        self.m_View:setViewWarFieldPreviewer(actor:getView())
    end

    return self.m_ActorWarFieldPreviewer
end

local function getActorWarConfigurator(self)
    if (not self.m_ActorWarConfigurator) then
        local model = Actor.createModel("sceneMain.ModelWarConfigurator")
        local view  = Actor.createView( "sceneMain.ViewWarConfigurator")

        model:setModeExitWar()
            :setEnabled(false)
            :setCallbackOnButtonBackTouched(function()
                model:setEnabled(false)
                getActorWarFieldPreviewer(self):getModel():setEnabled(false)

                self.m_View:setMenuVisible(true)
                    :setButtonNextVisible(false)
            end)

        self.m_ActorWarConfigurator = Actor.createWithModelAndViewInstance(model, view)
        self.m_View:setViewWarConfigurator(view)
    end

    return self.m_ActorWarConfigurator
end

local function createWaitingWarList(self, warConfigurations)
    local warList               = {}
    local playerAccountLoggedIn = WebSocketManager.getLoggedInAccountAndPassword()

    for warID, warConfiguration in pairs(warConfigurations) do
        local warFieldFileName  = warConfiguration.warFieldFileName
        local playerIndexInTurn = warConfiguration.playerIndexInTurn

        warList[#warList + 1] = {
            warID        = warID,
            warFieldName = WarFieldManager.getWarFieldName(warFieldFileName),
            callback     = function()
                getActorWarFieldPreviewer(self):getModel():setWarField(warFieldFileName)
                    :setPlayerNicknames(getPlayerNicknames(warConfiguration, os.time()))
                    :setEnabled(true)
                self.m_View:setButtonNextVisible(true)

                self.m_OnButtonNextTouched = function()
                    getActorWarFieldPreviewer(self):getModel():setEnabled(false)
                    getActorWarConfigurator(self):getModel():resetWithWarConfiguration(warConfiguration)
                        :setEnabled(true)

                    self.m_View:setMenuVisible(false)
                        :setButtonNextVisible(false)
                end
            end,
        }
    end

    table.sort(warList, function(item1, item2)
        return item1.warID < item2.warID
    end)

    return warList
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelExitWarSelector:ctor(param)
    return self
end

--------------------------------------------------------------------------------
-- The callback function on start running.
--------------------------------------------------------------------------------
function ModelExitWarSelector:onStartRunning(modelSceneMain)
    self.m_ModelSceneMain = modelSceneMain
    getActorWarConfigurator(self):getModel():onStartRunning(modelSceneMain)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelExitWarSelector:setEnabled(enabled)
    self.m_IsEnabled = enabled

    if (enabled) then
        SingletonGetters.getModelMessageIndicator(self.m_ModelSceneMain):showMessage(getLocalizedText(14, "RetrievingExitableWar"))
        WebSocketManager.sendAction({
            actionCode = ACTION_CODE_GET_WAITING_WAR_CONFIGURATIONS,
        })
    end

    if (self.m_View) then
        self.m_View:setVisible(enabled)
            :setMenuVisible(true)
            :removeAllItems()
            :setButtonNextVisible(false)
    end

    getActorWarFieldPreviewer(self):getModel():setEnabled(false)
    getActorWarConfigurator(self):getModel():setEnabled(false)

    return self
end

function ModelExitWarSelector:isRetrievingWaitingWarConfigurations()
    return self.m_IsEnabled
end

function ModelExitWarSelector:updateWithWaitingWarConfigurations(warConfigurations)
    if (self.m_IsEnabled) then
        local warList = createWaitingWarList(self, warConfigurations)
        if (#warList == 0) then
            SingletonGetters.getModelMessageIndicator(self.m_ModelSceneMain):showMessage(getLocalizedText(8, "NoWaitingWar"))
        else
            self.m_View:showWarList(warList)
        end
    end

    return self
end

function ModelExitWarSelector:isRetrievingExitWarResult(warID)
    local modelWarConfigurator = getActorWarConfigurator(self):getModel()
    return (modelWarConfigurator:isEnabled()) and (modelWarConfigurator:getWarId() == warID)
end

function ModelExitWarSelector:onButtonBackTouched()
    self:setEnabled(false)
    SingletonGetters.getModelMainMenu(self.m_ModelSceneMain):setMenuEnabled(true)

    return self
end

function ModelExitWarSelector:onButtonNextTouched()
    self.m_OnButtonNextTouched()

    return self
end

return ModelExitWarSelector
