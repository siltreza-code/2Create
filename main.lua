local States = require("src.modules.States")
local SceneM = require("src.modules.SceneManager")
local Events = require("src.modules.Events")
local Inputs = require("src.modules.Inputs")
local Timer = require("src.modules.timer")
local SettingModule = require("src.modules.SettingsModule")
local worldM = require("src.modules.WorldManager")

local kps = 0
Inputs.OnKeyPressed(function(key)
    if key == "f5" then
        kps = kps + 1

        if kps >= 5 then
            love.event.quit()
        end

        Timer.after(1, function()
            kps = kps - 1
        end)
    end
end)

function love.load()
    Events.NewEvent("reloadScene")
    Events.Hook("reloadScene", function()
        if States.Exists("CurrentScene") then
            local nextScene = States.Get("CurrentScene")
            SceneM.loadScene(nextScene)
        end
    end)

    States.New("CurrentScene", "mainmenu")
    Events.Fire("reloadScene")

    SettingModule.LoadData()
    local screenshot = love.graphics.captureScreenshot(function(imageData)
        local encoded = imageData:encode("png")
        local bytes = encoded:getString()

        worldM.SaveWorld("Test", {}, {}, {}, bytes, 50)
    end)
end

function love.update(DT)
    Timer.update(DT)
    SceneM.update(DT)
    Inputs.Update()
end

function love.draw()
    SceneM.draw()
end