local utills = require("src.modules.Utills")

local screenCurrentSizeIndex = 3
local screenSizes = {
    {x = 400, y = 300},
    {x = 640, y = 480},
    {x = 800, y = 600},
    {x = 1280, y = 720},
    {x = 1920, y = 1080},
    {x = 2560, y = 1440},
    {x = 3840, y = 2160},
}

local rawoptions = { -- these are defaults for now
    screenSize = {800, 600},
    mainVolume = 1,
    sfxVolume = 1,
    musicVolume = 1,
    directionalAudio = false,
}
local options = {
    {name = "screen size: "..table.concat(rawoptions.screenSize, "x"), desc = "Size of the game window", type = "button", action = function()
        screenCurrentSizeIndex = screenCurrentSizeIndex + 1
        if screenCurrentSizeIndex > #screenSizes then screenCurrentSizeIndex = 1 end
        local newSize = screenSizes[screenCurrentSizeIndex]
        rawoptions.screenSize = newSize
    end
    },
    {name = "main volume: "..math.floor(rawoptions.mainVolume * 100).."%", desc = "The main volume of the game", type = "slider", value = rawoptions.mainVolume,
    action = function(value)
        rawoptions.mainVolume = value
    end
    },
    {name = "sfx volume: "..math.floor(rawoptions.sfxVolume * 100).."%", desc = "The volume of sound effects", type = "slider", value = rawoptions.sfxVolume,
    action = function(value)
        rawoptions.sfxVolume = value
    end
    },
    {name = "music volume: "..math.floor(rawoptions.musicVolume * 100).."%", desc = "The volume of background music", type = "slider", value = rawoptions.musicVolume,
    action = function(value)
        rawoptions.musicVolume = value
    end
    },
    {name = "directional audio: "..tostring(rawoptions.directionalAudio), desc = "Whether to use directional audio", type = "toggle",value = rawoptions.directionalAudio,
    action = function(value)
        rawoptions.directionalAudio = value
    end
    }
}

local m = {}

return m