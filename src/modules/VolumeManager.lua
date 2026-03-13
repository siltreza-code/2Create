local Inputs = require("src.modules.Inputs")
local Utills = require("src.modules.Utills")

local m = {}
m.mainVolume = 1
m.musicVolume = 1
m.sfxVolume = 1

Inputs.OnKeyPressed(function(key)
    if key == "f3" then
        m.mainVolume = m.mainVolume + 0.025
    elseif key == "f2" then
        m.mainVolume = m.mainVolume - 0.025
    end
    m.mainVolume = math.max(0, math.min(1, m.mainVolume))
    love.audio.setVolume(m.mainVolume)
end)

return m