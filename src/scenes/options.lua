local utills = require("src.modules.Utills")
local inputs = require("src.modules.Inputs")
local states = require("src.modules.States")
local events = require("src.modules.Events")

local scene = {}
local screenSize = {x = utills.scaleUtills.PercentX(1), y = utills.scaleUtills.PercentY(1)}

-- perlin data
local noiseData, imageData
local scale = 0.03
local perlinY = math.random() * 1000
local t = math.random() * 1000
-- perlin will only be moving up

-- screen data
local scrollAmmount = 0
local scrollSpeed = 25
local scrollLimit = 500

-- fonts
local titleFont = love.graphics.newFont("src/fonts/jersey10.ttf", utills.scaleUtills.PercentX(0.05))

local function GenPerlinImg()
    noiseData = love.image.newImageData(screenSize.x, screenSize.y)

    for px = 0, screenSize.x - 1 do
        for py = 0, screenSize.y - 1 do
            local noiseValue = love.math.noise(
                (px) * scale,
                (py + perlinY) * scale,
                t
            )

            noiseData:setPixel(px, py, noiseValue, noiseValue, noiseValue, 1)
        end
    end
    imageData = love.graphics.newImage(noiseData)
end

local scrollConn = inputs.OnMouseWheel(function(x, y)
    scrollAmmount = scrollAmmount - y * scrollSpeed
    scrollAmmount = utills.mathUtills.Clamp(scrollAmmount, -scrollLimit, 0)
end)

function scene.load()
    GenPerlinImg()
end

function scene.unload()
    scrollConn.Remove()
end

function scene.update(DT)
    screenSize = {x = utills.scaleUtills.PercentX(1), y = utills.scaleUtills.PercentY(1)} -- update screen size

    perlinY = perlinY + 10 * DT
    
    GenPerlinImg()
end

function scene.draw()
    love.graphics.setColor(utills.colorUtills.RGBtoUnit(120, 85, 35)) -- reset color for bg
    love.graphics.draw(imageData, 0, 0)
    love.graphics.setColor(1, 1, 1, 1) -- reset color for other elements

    love.graphics.printf("Options",utills.scaleUtills.PercentX(0.1),utills.scaleUtills.PercentY(0.02) + scrollAmmount,utills.scaleUtills.PercentX(0.8),"center")

    local lineY = utills.scaleUtills.PercentY(0.1) + scrollAmmount
    love.graphics.line(utills.scaleUtills.PercentX(0.1), lineY, utills.scaleUtills.PercentX(0.9), lineY)
    lineY = utills.scaleUtills.PercentY(0.95) + scrollAmmount
    love.graphics.line(utills.scaleUtills.PercentX(0.1), lineY + scrollLimit, utills.scaleUtills.PercentX(0.9), lineY + scrollLimit)

    -- draw the options


    -- side line to show scroll amount
    local scrolllineSizeY = utills.scaleUtills.PercentY(0.1)
    local scrolllineY = utills.scaleUtills.PercentY(0.9) * math.abs(scrollAmmount)/scrollLimit
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.rectangle("fill", utills.scaleUtills.PercentX(0.98), scrolllineY, utills.scaleUtills.PercentX(0.02), scrolllineSizeY)
end

return scene