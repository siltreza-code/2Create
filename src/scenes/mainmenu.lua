local utills = require("src.modules.Utills")
local inputs = require("src.modules.Inputs")
local states = require("src.modules.States")
local events = require("src.modules.Events")

local scene = {}

local screenSize = {x = utills.scaleUtills.PercentX(1), y = utills.scaleUtills.PercentY(1)}

-- perlin data
local scale = math.random() * 0.02 + 0.005
local noiseData
local imageData

local x = math.random() * 1000
local y = math.random() * 1000
local t = math.random() * 1000

local vx = (math.random() * 2 - 1) * 3
local vy = (math.random() * 2 - 1) * 3
local vt = (math.random() * 2 - 1)

local function GenPerlinImage()
    noiseData = love.image.newImageData(screenSize.x, screenSize.y)

    for px = 0, screenSize.x - 1 do
        for py = 0, screenSize.y - 1 do
            local noiseValue = love.math.noise(
                (px + x) * scale,
                (py + y) * scale,
                t
            )

            noiseData:setPixel(px, py, noiseValue, noiseValue, noiseValue, 1)
        end
    end

    imageData = love.graphics.newImage(noiseData)
end

local Buttons = {
    {
        text = "Singleplayer",
        color = utills.colorUtills.RGBtoUnit(210, 210, 210),
        hovor = utills.colorUtills.RGBtoUnit(140, 140, 140),
        next = ""
    }
}

function scene.load()
    love.math.setRandomSeed(os.time())
    GenPerlinImage()
end

function scene.update(dt)
    x = x + vx * dt
    y = y + vy * dt
    t = t + vt * dt

    GenPerlinImage()
end

function scene.draw()
    love.graphics.draw(imageData, 0, 0)
end

return scene