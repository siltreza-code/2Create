local json = require("src.modules.json")
local M = {}

local screenSizes = {
    {400,300},
    {640,480},
    {800,600},
    {1280,720},
    {1920,1080},
    {2560,1440},
    {3840,2160},
}

-- actual option values
local values = {
    screenSizeIndex = 3,
    mainVolume = 1,
    sfxVolume = 1,
    musicVolume = 1,
    directionalAudio = false
}

-- metadata for the settings scene
local definitions = {
    screenSize = {
        name = "Screen Size",
        desc = "Size of the game window",
        type = "button",
        get = function()
            local s = screenSizes[values.screenSizeIndex]
            return s[1].."x"..s[2]
        end,
        action = function()
            values.screenSizeIndex = values.screenSizeIndex + 1
            if values.screenSizeIndex > #screenSizes then
                values.screenSizeIndex = 1
            end
        end
    },

    mainVolume = {
        name = "Main Volume",
        desc = "Master game volume",
        type = "slider",
        get = function()
            return math.floor(values.mainVolume * 100).."%"
        end,
        action = function(v)
            values.mainVolume = v
        end
    },

    sfxVolume = {
        name = "SFX Volume",
        desc = "Sound effects volume",
        type = "slider",
        get = function()
            return math.floor(values.sfxVolume * 100).."%"
        end,
        action = function(v)
            values.sfxVolume = v
        end
    },

    musicVolume = {
        name = "Music Volume",
        desc = "Background music volume",
        type = "slider",
        get = function()
            return math.floor(values.musicVolume * 100).."%"
        end,
        action = function(v)
            values.musicVolume = v
        end
    },

    directionalAudio = {
        name = "Directional Audio",
        desc = "Enable positional audio",
        type = "toggle",
        get = function()
            return tostring(values.directionalAudio)
        end,
        action = function(v)
            values.directionalAudio = v
        end
    }
}

-- expose data
function M.GetValue(name)
    return values[name]
end

function M.Set(name, input)
    local def = definitions[name]
    if def and def.action then
        def.action(input)
    end
end

function M.GetDefinitions()
    return definitions
end

function M.GetValues()
    return values
end

function M.SaveData()
    local encrypted = json.encode(values)
    love.filesystem.write("settings.dat", encrypted)
end

function M.LoadData()
    local data = love.filesystem.read("settings.dat")
    if data then
        values = json.decode(data)

        love.window.setMode(screenSizes[values.screenSizeIndex][1], screenSizes[values.screenSizeIndex][2], {fullscreen = false})
        love.audio.setVolume(values.mainVolume)
    end
end

return M