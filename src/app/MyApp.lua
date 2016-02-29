
local MyApp = class("MyApp", cc.load("mvc").AppBase)

function MyApp:onCreate()
    display.loadSpriteFrames("BabyWarsTextureTile.plist", "BabyWarsTextureTile.png")
    display.loadSpriteFrames("BabyWarsTextureUnit.plist", "BabyWarsTextureUnit.png")
    display.loadSpriteFrames("BabyWarsTextureUI.plist",   "BabyWarsTextureUI.png")
    
    require("app.utilities.AnimationLoader").load()
    
    math.randomseed(os.time())
end

return MyApp
