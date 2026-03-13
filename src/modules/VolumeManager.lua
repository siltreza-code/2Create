local Inputs = require("src.modules.Inputs")
local Utills = require("src.modules.Utills")

local m = {}
m.volume = 1

Inputs.OnKeyPressed(function(key)
    if key == "f3" then
        m.volume = m.volume + 0.025
    elseif key == "f2" then
        m.volume = m.volume - 0.025
    end
    m.volume = math.max(0, math.min(1, m.volume))
    love.audio.setVolume(m.volume)
end)

function m.Draw()
    local xSize = Utills.scaleUtills.PercentX(0.01)
    local ySize = Utills.scaleUtills.PercentY(0.12)
    local xPos = Utills.scaleUtills.PercentX(0.99) - xSize
    local yPos = Utills.scaleUtills.PercentY(0.99) - ySize
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", xPos, yPos, xSize, ySize)
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.rectangle("fill", xPos, yPos + (ySize - ySize * m.volume), xSize, ySize * m.volume)
end

return m