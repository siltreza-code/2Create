local utills = require("src.modules.Utills")
local inputs = require("src.modules.Inputs")
local states = require("src.modules.States")
local events = require("src.modules.Events")

local scene = {}

local screenSize = {x = utills.scaleUtills.PercentX(1), y = utills.scaleUtills.PercentY(1)}

local titleImg = love.graphics.newImage("src/imgs/title.png")
-- fonts
local titleFont = love.graphics.newFont("src/fonts/jersey10.ttf", utills.scaleUtills.PercentY(0.1)) -- unused
local buttonFont = love.graphics.newFont("src/fonts/tiny5.ttf", utills.scaleUtills.PercentY(0.05))

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

local function DrawButton(position, size, colors, text, font, thickness)
    local mousePos = {x = love.mouse.getX(), y = love.mouse.getY()}
    local isHover = mousePos.x > position.x - size.x / 2 and mousePos.x < position.x + size.x / 2 and
                    mousePos.y > position.y - size.y / 2 and mousePos.y < position.y + size.y / 2
    local clr = isHover and colors.hovor or colors.color

    love.graphics.push()
    love.graphics.setFont(font)
    love.graphics.setColor(unpack(clr))

    love.graphics.rectangle("fill", position.x - size.x / 2,
        position.y - size.y / 2,
        size.x, size.y,
        10, 10)
    
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf(text,position.x-size.x/2,position.y-size.y/2,size.x*0.97, "center")

    love.graphics.setLineWidth(thickness or 5)
    love.graphics.rectangle("line", position.x - size.x / 2,
        position.y - size.y / 2,
        size.x, size.y,
        10, 10)
    
    love.graphics.pop()
end

local Buttons = {
    {
        text = "Singleplayer",
        colors = {color = utills.colorUtills.RGBtoUnit(210, 210, 210), hovor = utills.colorUtills.RGBtoUnit(140, 140, 140)},
        next = "worlds", -- next scene when clicked
        position = {x = utills.scaleUtills.PercentX(0.5), y = utills.scaleUtills.PercentY(0.65)},
        size = {x = utills.scaleUtills.PercentX(0.3), y = utills.scaleUtills.PercentY(0.08)},
        lineThickness = 2.7,
    },
    {
        text = "Quit",
        colors = {color = utills.colorUtills.RGBtoUnit(210, 210, 210), hovor = utills.colorUtills.RGBtoUnit(140, 140, 140)},
        next = "Exit", -- next scene when clicked
        position = {x = utills.scaleUtills.PercentX(0.5), y = utills.scaleUtills.PercentY(0.85)},
        size = {x = utills.scaleUtills.PercentX(0.3), y = utills.scaleUtills.PercentY(0.08)},
        lineThickness = 2.7,
    },
    {
        text = "Options",
        colors = {color = utills.colorUtills.RGBtoUnit(210, 210, 210), hovor = utills.colorUtills.RGBtoUnit(140, 140, 140)},
        next = "options", -- next scene when clicked
        position = {x = utills.scaleUtills.PercentX(0.5), y = utills.scaleUtills.PercentY(0.75)},
        size = {x = utills.scaleUtills.PercentX(0.3), y = utills.scaleUtills.PercentY(0.08)},
        lineThickness = 2.7,
    }
}

function scene.load()
    love.math.setRandomSeed(os.time())
    GenPerlinImage()

    love.window.setTitle("2Create - BETA")
end

function scene.update(dt)
    screenSize = {x = utills.scaleUtills.PercentX(1), y = utills.scaleUtills.PercentY(1)} -- update screen size

    x = x + vx * dt
    y = y + vy * dt
    t = t + vt * dt

    GenPerlinImage()

    for _, button in ipairs(Buttons) do
        local mousePos = {x = love.mouse.getX(), y = love.mouse.getY()}
        local isHover = mousePos.x > button.position.x - button.size.x / 2 and mousePos.x < button.position.x + button.size.x / 2 and
                        mousePos.y > button.position.y - button.size.y / 2 and mousePos.y < button.position.y + button.size.y / 2

        if isHover and (inputs.MousePressed(1) or inputs.KeyPressed("return")) then
            if button.next == "Exit" then
                love.event.quit()
            else
                states.Set("CurrentScene", button.next)
                events.Fire("reloadScene")
            end
        end
    end
end

function scene.draw()
    love.graphics.setColor(1, 1, 1, 1) -- reset color

    love.graphics.draw(imageData, 0, 0)

    love.graphics.draw(titleImg, utills.scaleUtills.CenterX(titleImg:getWidth()), utills.scaleUtills.CenterY(titleImg:getHeight())-utills.scaleUtills.PercentY(0.2))

    for _, button in ipairs(Buttons) do
        DrawButton(button.position, button.size, button.colors, button.text, buttonFont, button.lineThickness)
    end
end

return scene