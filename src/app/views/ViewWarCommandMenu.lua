
local ViewWarCommandMenu = class("ViewWarCommandMenu", cc.Node)

local MENU_BACKGROUND_WIDTH  = 250
local MENU_BACKGROUND_HEIGHT = display.height * 0.8
local MENU_BACKGROUND_POSITION_X = (display.width - MENU_BACKGROUND_WIDTH) / 2
local MENU_BACKGROUND_POSITION_Y = (display.height - MENU_BACKGROUND_HEIGHT) / 2

local LIST_WIDTH  = MENU_BACKGROUND_WIDTH - 10
local LIST_HEIGHT = MENU_BACKGROUND_HEIGHT - 14
local LIST_POSITION_X = MENU_BACKGROUND_POSITION_X + 5
local LIST_POSITION_Y = MENU_BACKGROUND_POSITION_Y + 6

local function createScreenBackground()
    local background = cc.LayerColor:create({r = 0, g = 0, b = 0, a = 160})
    background:setContentSize(display.width, display.height)
        :ignoreAnchorPointForPosition(true)
        
    return background
end

local function initWithScreenBackground(view, background)
    view.m_ScreenBackground = background
    view:addChild(background)
end

local function createMenuBackground()
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 5, width = 1, height = 1})
    background:ignoreAnchorPointForPosition(true)
        :setPosition(MENU_BACKGROUND_POSITION_X, MENU_BACKGROUND_POSITION_Y)
        
        :setContentSize(MENU_BACKGROUND_WIDTH, MENU_BACKGROUND_HEIGHT)

    background.m_TouchSwallower = require("app.utilities.CreateTouchSwallowerForNode")(background)
    background:getEventDispatcher():addEventListenerWithSceneGraphPriority(background.m_TouchSwallower, background)

    return background
end

local function initWithMenuBackground(view, background)
    view.m_MenuBackground = background
    view:addChild(background)
end

local function createListView()
    local listView = ccui.ListView:create()
    listView:ignoreAnchorPointForPosition(true)
        :setPosition(LIST_POSITION_X, LIST_POSITION_Y)
        
        :setContentSize(LIST_WIDTH, LIST_HEIGHT)

        :setItemsMargin(5)
        :setGravity(ccui.ListViewGravity.centerHorizontal)
        :setCascadeOpacityEnabled(true)

    return listView    
end

local function initWithListView(view, listView)
    view.m_ListView = listView
    view:addChild(listView)
end

local function createTouchListener(view)
    local touchListener = cc.EventListenerTouchOneByOne:create()
    touchListener:setSwallowTouches(true)
    
	touchListener:registerScriptHandler(function()
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)
    
    touchListener:registerScriptHandler(function()
        view:setEnabled(false)
    end, cc.Handler.EVENT_TOUCH_ENDED)
    
    return touchListener
end

local function initWithTouchListener(view, touchListener)
    view.m_TouchListener = touchListener
    view:getEventDispatcher():addEventListenerWithSceneGraphPriority(view.m_TouchListener, view)
end

function ViewWarCommandMenu:ctor(param)
    initWithScreenBackground(self, createScreenBackground())
    initWithMenuBackground(self, createMenuBackground())
    initWithListView(self, createListView())
    initWithTouchListener(self, createTouchListener(self))
    
    self:ignoreAnchorPointForPosition(true)

        :setCascadeOpacityEnabled(true)
        :setOpacity(200)

	if (param) then
        self:load(param)
    end

	return self
end

function ViewWarCommandMenu:load(param)
    return self
end

function ViewWarCommandMenu.createInstance(param)
    local view = ViewWarCommandMenu.new():load(param)
    assert(view, "ViewWarCommandMenu.createInstance() failed.")

    return view
end

function ViewWarCommandMenu:pushBackItem(item)
    self.m_ListView:pushBackCustomItem(item)
    
    return self
end

function ViewWarCommandMenu:removeAllItems()
    self.m_ListView:removeAllItems()
    
    return self
end

function ViewWarCommandMenu:setEnabled(enabled)
    if (enabled) then
        self:setVisible(true)
        self:getEventDispatcher():resumeEventListenersForTarget(self, true)
    else
        self:setVisible(false)
        self:getEventDispatcher():pauseEventListenersForTarget(self, true)
    end
    
    return self
end

return ViewWarCommandMenu
