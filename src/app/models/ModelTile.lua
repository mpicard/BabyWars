
local ModelTile = class("ModelTile")

local MODEL_TILE_IDS       = require("res.data.GameConstant").Mapping_TiledIdToTemplateModelIdTileOrUnit
local MODEL_TILE_TEMPLATES = require("res.data.GameConstant").Mapping_IdToTemplateModelTile

local ComponentManager = require("global.components.ComponentManager")
local TypeChecker      = require("app.utilities.TypeChecker")

local function isOfSameTemplateModelTileID(tiledID1, tiledID2)
    if (not tiledID1) or (not tiledID2) then
        return false
    end

    return MODEL_TILE_IDS[tiledID1] == MODEL_TILE_IDS[tiledID2]
end

local function toModelTileTemplate(tiledID)
	return MODEL_TILE_TEMPLATES[MODEL_TILE_IDS[tiledID]]
end

local function initWithTiledID(model, tiledID)
    local template = toModelTileTemplate(tiledID)
    assert(template, "ModelTile-initWithTiledID() failed to get the model tile template with param tiledID.")

    ComponentManager.unbindAllComponents(model)

    ComponentManager.bindComponent(model, "GridIndexable")
    model.m_DefenseBonus = template.defenseBonus
    model.m_Description  = template.description

    if (template.specialProperties) then
        for _, specialProperty in ipairs(template.specialProperties) do
            ComponentManager.bindComponent(model, specialProperty.name)
            ComponentManager.getComponent(model, specialProperty.name):load(specialProperty)
        end
    end
end

local function loadOverwrites(model, overwrites)
    if (overwrites.gridIndex) then
        model:setGridIndex(overwrites.gridIndex)
    end
    model.m_DefenseBonus = overwrites.defenseBonus or model.m_DefenseBonus
    model.m_Description  = overwrites.description  or model.m_Description

    if (overwrites.specialProperties) then
        for _, specialProperty in ipairs(overwrites.specialProperties) do
            local component = ComponentManager.getComponent(model, specialProperty.name)
            assert(component, "ModelTile-loadOverwrites() attempting to overwrite a component that the model hasn't bound with.")
            component:load(specialProperty)
        end
    end
end

function ModelTile:ctor(param)
    if (param) then
        self:load(param)
    end

    return self
end

function ModelTile:load(param)
    if (param.tiledID) then
        if (not isOfSameTemplateModelTileID(param.tiledID, self.m_TiledID)) then
            initWithTiledID(self, param.tiledID)
        end

        self.m_TiledID = param.tiledID
    end

    loadOverwrites(self, param)

    if (self.m_View) then
        self:initView()
    end

	return self
end

function ModelTile.createInstance(param)
	local model = ModelTile.new():load(param)
	assert(model, "ModelTile.createInstance() failed.")

	return model
end

function ModelTile:initView()
    local view = self.m_View
	assert(view, "ModelTile:initView() no view is attached to the actor of the model.")

    self:setViewPositionWithGridIndex()
    view:updateWithTiledID(self.m_TiledID)

    return self
end

function ModelTile:getTiledID()
    return self.m_TiledID
end

function ModelTile:getDefenseBonus()
    return self.m_DefenseBonus
end

function ModelTile:getDescription()
    return self.m_Description
end

return ModelTile
