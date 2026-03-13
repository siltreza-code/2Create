local States = require("src.modules.States")
local SceneM = require("src.modules.SceneManager")
local Events = require("src.modules.Events")
local Inputs = require("src.modules.Inputs")
local SongLoader = require("src.modules.SongLoader")
local Timer = require("src.modules.timer")
local VolumeManager = require("src.modules.VolumeManager")

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
            -- extra safety: don't enter gameplay without a selected song
            if nextScene == "gameplay" and not States.Exists("SelectedSong") then
                print("[main] redirecting from gameplay to songview (no SelectedSong)")
                States.Set("CurrentScene", "songview")
                nextScene = "songview"
            end
            SceneM.loadScene(nextScene)
        end
    end)

    States.New("CurrentScene", "mainmenu")
    Events.Fire("reloadScene")

    States.New("Songs", SongLoader.loadAllSongs())
end

function love.update(DT)
    Timer.update(DT)
    SceneM.update(DT)
end

function love.draw()
    SceneM.draw()
end