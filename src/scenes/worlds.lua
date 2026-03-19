local utills = require("src.modules.Utills")
local inputs = require("src.modules.Inputs")
local states = require("src.modules.States")
local events = require("src.modules.Events")
local WorldManager = require("src.modules.WorldManager")

local scene = {}

local screen = {
    width = utills.scaleUtills.PercentX(1),
    height = utills.scaleUtills.PercentY(1),
}

local scrollLimit = 0
local scrollAmount = 0
local scrollConn = inputs.MouseWheel(function(_, y)
    scrollAmount = scrollAmount + y * 25
    scrollAmount = utills.mathUtills.Clamp(scrollAmount, 0, scrollLimit)
end)

function scene.load()
    WorldManager.worlds = {} -- reset loaded worlds before adding more
    WorldManager.Start()
    scrollAmount = 0
end

function scene.unload()
    WorldManager.worlds = {} -- also reset it when unloading
    if scrollConn then
        scrollConn.Remove()
    end
end

function scene.update(DT)
    
end

function scene.draw()
    -- draw a bg image here, have no image for now

    love.graphics.rectangle("fill",screen.width/2,screen.height/2,screen.width*0.7,screen.height) -- draw a overlay to darken bg

end

return scene