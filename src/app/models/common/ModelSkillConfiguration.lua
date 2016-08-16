
local ModelSkillConfiguration = require("src.global.functions.class")("ModelSkillConfiguration")

local ModelSkillGroupPassive = require("src.app.models.common.ModelSkillGroupPassive")
local ModelSkillGroupActive  = require("src.app.models.common.ModelSkillGroupActive")
local GameConstantFunctions  = require("src.app.utilities.GameConstantFunctions")
local LocalizationFunctions  = require("src.app.utilities.LocalizationFunctions")

local getLocalizedText = LocalizationFunctions.getLocalizedText

local MIN_POINTS, MAX_POINTS, POINTS_PER_STEP = GameConstantFunctions.getSkillPointsMinMaxStep()
local SKILL_POINTS_PER_ENERGY_REQUIREMENT     = GameConstantFunctions.getSkillPointsPerEnergyRequirement()

local SKILL_GROUP_ID_PASSIVE  = 0
local SKILL_GROUP_ID_ACTIVE_1 = 1
local SKILL_GROUP_ID_ACTIVE_2 = 2

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function getDescriptionForMaxPoints(self)
    if (self:isEmpty()) then
        return string.format("%s: %s", getLocalizedText(3, "MaxPoints"), getLocalizedText(3, "None"))
    else
        return string.format("%s: %d", getLocalizedText(3, "MaxPoints"), self:getMaxSkillPoints())
    end
end

local function getModelSkillGroupWithId(self, skillGroupID)
    if (skillGroupID == SKILL_GROUP_ID_PASSIVE) then
        return self.m_ModelSkillGroupPassive
    elseif (skillGroupID == SKILL_GROUP_ID_ACTIVE_1) then
        return self.m_ModelSkillGroupActive1
    elseif (skillGroupID == SKILL_GROUP_ID_ACTIVE_2) then
        return self.m_ModelSkillGroupActive2
    else
        error("ModelSkillConfiguration-getModelSkillGroupWithId() the param skillGroupID is invalid.")
    end
end

local function resetMaxSkillPoints(self)
    -- TODO: move the key constants to GameConstant.
    local skillPassive     = self.m_ModelSkillGroupPassive
    local skillActive1     = self.m_ModelSkillGroupActive1
    local skillActive2     = self.m_ModelSkillGroupActive2
    local isEnabledActive1 = skillActive1:isEnabled()
    local isEnabledActive2 = skillActive2:isEnabled()

    local extraPointsForPassive = 0
    if (not isEnabledActive1) then extraPointsForPassive = extraPointsForPassive + 50 end
    if (not isEnabledActive2) then extraPointsForPassive = extraPointsForPassive + 50 end

    local totalPointsForPassive = self:getMaxSkillPoints() + extraPointsForPassive
    skillPassive:setMaxSkillPoints(totalPointsForPassive)

    local extraPointsForActive = math.max(0, (totalPointsForPassive - skillPassive:getSkillPoints()))
    if (isEnabledActive1) then
        local basePoints = skillActive1:getEnergyRequirement() * SKILL_POINTS_PER_ENERGY_REQUIREMENT
        skillActive1:setMaxSkillPoints(basePoints + extraPointsForActive)
    end
    if (isEnabledActive2) then
        local basePoints = skillActive2:getEnergyRequirement() * SKILL_POINTS_PER_ENERGY_REQUIREMENT
        skillActive2:setMaxSkillPoints(basePoints + extraPointsForActive)
    end
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ModelSkillConfiguration:ctor(param)
    self.m_ModelSkillGroupPassive = self.m_ModelSkillGroupPassive or ModelSkillGroupPassive:create()
    self.m_ModelSkillGroupActive1 = self.m_ModelSkillGroupActive1 or ModelSkillGroupActive: create()
    self.m_ModelSkillGroupActive2 = self.m_ModelSkillGroupActive2 or ModelSkillGroupActive: create()

    param = param or {}
    self.m_ModelSkillGroupPassive:ctor(param.passive)
    self.m_ModelSkillGroupActive1:ctor(param.active1)
    self.m_ModelSkillGroupActive2:ctor(param.active2)
    self:setMaxSkillPoints(        param.maxPoints or 100)
        :setActivatingSkillGroupId(param.activatingSkillGroupId)

    return self
end

--------------------------------------------------------------------------------
-- The functions for serialization.
--------------------------------------------------------------------------------
function ModelSkillConfiguration:toSerializableTable()
    local active1 = self.m_ModelSkillGroupActive1
    local active2 = self.m_ModelSkillGroupActive2
    if (active1:isEnabled()) then
        if ((not active2:isEnabled()) or
            (active1:getEnergyRequirement() > active2:getEnergyRequirement())) then
            active1, active2 = active2, active1
        end
    end

    return {
        maxPoints              = self:getMaxSkillPoints(),
        activatingSkillGroupId = self:getActivatingSkillGroupId(),

        passive                = self.m_ModelSkillGroupPassive:toSerializableTable(),
        active1                = active1:toSerializableTable(),
        active2                = active2:toSerializableTable(),
    }
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ModelSkillConfiguration.getSkillGroupIdPassive()
    return SKILL_GROUP_ID_PASSIVE
end

function ModelSkillConfiguration.getSkillGroupIdActive1()
    return SKILL_GROUP_ID_ACTIVE_1
end

function ModelSkillConfiguration.getSkillGroupIdActive2()
    return SKILL_GROUP_ID_ACTIVE_2
end

function ModelSkillConfiguration:isEmpty()
    return not self:getMaxSkillPoints()
end

function ModelSkillConfiguration:isValid()
    if (self:isEmpty()) then
        return false
    end

    local valid, err = self.m_ModelSkillGroupPassive:isValid()
    if (not valid) then
        return false, getLocalizedText(7, "InvalidSkillGroupPassive", err)
    end

    valid, err = self.m_ModelSkillGroupActive1:isValid()
    if (not valid) then
        return false, getLocalizedText(7, "InvalidSkillGroupActive1", err)
    end

    valid, err = self.m_ModelSkillGroupActive2:isValid()
    if (not valid) then
        return false, getLocalizedText(7, "InvalidSkillGroupActive2", err)
    end

    return true
end

function ModelSkillConfiguration:getDescription()
    return string.format("%s\n\n%s\n\n%s\n\n%s",
        getDescriptionForMaxPoints(self),
        self.m_ModelSkillGroupPassive:getDescription(),
        self.m_ModelSkillGroupActive1:getDescription(),
        self.m_ModelSkillGroupActive2:getDescription()
    )
end

function ModelSkillConfiguration:isModelSkillGroupEnabled(skillGroupID)
    return getModelSkillGroupWithId(self, skillGroupID):isEnabled()
end

function ModelSkillConfiguration:setModelSkillGroupEnabled(skillGroupID, enabled)
    getModelSkillGroupWithId(self, skillGroupID):setEnabled(enabled)
    resetMaxSkillPoints(self)

    return self
end

function ModelSkillConfiguration:getEnergyRequirement()
    return self.m_ModelSkillGroupActive1:getEnergyRequirement(),
        self.m_ModelSkillGroupActive2:getEnergyRequirement()
end

function ModelSkillConfiguration:setEnergyRequirement(skillGroupID, requirement)
    getModelSkillGroupWithId(self, skillGroupID):setEnergyRequirement(requirement)
    resetMaxSkillPoints(self)

    return self
end

function ModelSkillConfiguration:getActivatingSkillGroupId()
    return self.m_ActivatingSkillGroupID
end

function ModelSkillConfiguration:setActivatingSkillGroupId(skillGroupID)
    assert(not (self.m_ActivatingSkillGroupID and skillGroupID))
    assert((skillGroupID == SKILL_GROUP_ID_ACTIVE_1) or (skillGroupID == SKILL_GROUP_ID_ACTIVE_2) or (skillGroupID == nil))
    self.m_ActivatingSkillGroupID = skillGroupID

    return self
end

function ModelSkillConfiguration:setMaxSkillPoints(points)
    assert((points >= MIN_POINTS) and (points <= MAX_POINTS) and ((points - MIN_POINTS) % POINTS_PER_STEP == 0))

    self.m_MaxPoints = points
    resetMaxSkillPoints(self)

    return self
end

function ModelSkillConfiguration:getMaxSkillPoints()
    return self.m_MaxPoints
end

function ModelSkillConfiguration:setSkill(skillGroupID, slotIndex, skillID, level)
    getModelSkillGroupWithId(self, skillGroupID):setSkill(slotIndex, skillID, level)
    resetMaxSkillPoints(self)

    return self
end

function ModelSkillConfiguration:clearSkill(skillGroupID, slotIndex)
    getModelSkillGroupWithId(self, skillGroupID):clearSkill(slotIndex)
    resetMaxSkillPoints(self)

    return self
end

function ModelSkillConfiguration:getProductionCostModifier(tiledID)
    local modifier = self.m_ModelSkillGroupPassive:getProductionCostModifier(tiledID)
    if (self.m_ActivatingSkillGroupID) then
        modifier = modifier + getModelSkillGroupWithId(self, self.m_ActivatingSkillGroupID):getProductionCostModifier(tiledID)
    end

    return modifier
end

function ModelSkillConfiguration:getAttackModifier(attacker, attackerGridIndex, target, targetGridIndex, modelTileMap, modelWeatherManager)
    local modifier = self.m_ModelSkillGroupPassive:getAttackModifier(
        attacker, attackerGridIndex, target, targetGridIndex, modelTileMap, modelWeatherManager)
    if (self.m_ActivatingSkillGroupID) then
        modifier = modifier + getModelSkillGroupWithId(self, self.m_ActivatingSkillGroupID):getAttackModifier(
            attacker, attackerGridIndex, target, targetGridIndex, modelTileMap, modelWeatherManager)
    end

    return modifier
end

function ModelSkillConfiguration:getDefenseModifier(attacker, attackerGridIndex, target, targetGridIndex, modelTileMap, modelWeatherManager)
    local modifier = self.m_ModelSkillGroupPassive:getDefenseModifier(
        attacker, attackerGridIndex, target, targetGridIndex, modelTileMap, modelWeatherManager)
    if (self.m_ActivatingSkillGroupID) then
        modifier = modifier + getModelSkillGroupWithId(self, self.m_ActivatingSkillGroupID):getDefenseModifier(
            attacker, attackerGridIndex, target, targetGridIndex, modelTileMap, modelWeatherManager)
    end

    return modifier
end

return ModelSkillConfiguration