local utills = require("src.modules.Utills")
local inputs = require("src.modules.Inputs")
local states = require("src.modules.States")
local events = require("src.modules.Events")
local SettingsModule = require("src.modules.SettingsModule")

local scene = {}

local screenSize = {x = utills.scaleUtills.PercentX(1), y = utills.scaleUtills.PercentY(1)}

-- perlin data
local noiseData, imageData
local scale = 0.03
local perlinY = math.random() * 1000
local t = math.random() * 1000

-- scrolling
local scrollAmmount = 0
local scrollSpeed = 25
local scrollLimit = 500

-- fonts
local titleFont = love.graphics.newFont("src/fonts/jersey10.ttf", utills.scaleUtills.PercentX(0.07))
local buttonFont = love.graphics.newFont("src/fonts/tiny5.ttf", utills.scaleUtills.PercentX(0.03))

-- back button
local backButtonColor = utills.colorUtills.RGBtoUnit(210,210,210)
local backButtonPos = {x = utills.scaleUtills.PercentX(0.07), y = utills.scaleUtills.PercentY(0.045)}
local backButtonSize = {x = utills.scaleUtills.PercentX(0.1), y = utills.scaleUtills.PercentY(0.05)}

-- settings
local definitions = SettingsModule.GetDefinitions()
local optionOrder = {}

for key in pairs(definitions) do
    optionOrder[#optionOrder+1] = key
end
table.sort(optionOrder)

local scrollConn

local function GenPerlinImg()
    noiseData = love.image.newImageData(screenSize.x, screenSize.y)

    for px = 0, screenSize.x - 1 do
        for py = 0, screenSize.y - 1 do
            local noiseValue = love.math.noise(
                px * scale,
                (py + perlinY) * scale,
                t
            )

            noiseData:setPixel(px, py, noiseValue, noiseValue, noiseValue, 1)
        end
    end

    imageData = love.graphics.newImage(noiseData)
end

function scene.load()

    scrollConn = inputs.OnMouseWheel(function(_, y)
        scrollAmmount = scrollAmmount - y * scrollSpeed
        scrollAmmount = utills.mathUtills.Clamp(scrollAmmount, -scrollLimit, 0)
    end)

    GenPerlinImg()
end

function scene.unload()

    if scrollConn then
        scrollConn.Remove()
    end

    SettingsModule.SaveData()
end

function scene.update(DT)

    screenSize = {
        x = utills.scaleUtills.PercentX(1),
        y = utills.scaleUtills.PercentY(1)
    }

    perlinY = perlinY + 10 * DT

    GenPerlinImg()

    local mouseX, mouseY = inputs.MousePosition()

    -- back button logic
    local isHover =
        mouseX > backButtonPos.x - backButtonSize.x/2 and
        mouseX < backButtonPos.x + backButtonSize.x/2 and
        mouseY > backButtonPos.y - backButtonSize.y/2 and
        mouseY < backButtonPos.y + backButtonSize.y/2

    if isHover and inputs.MousePressed(1) then
        states.Set("CurrentScene", "mainmenu")
        events.Fire("reloadScene")
    end

    -- options logic
    local startY = utills.scaleUtills.PercentY(0.15) + scrollAmmount
    local spacing = utills.scaleUtills.PercentY(0.09)

    for i, key in ipairs(optionOrder) do

        local def = definitions[key]

        local y = startY + (i-1)*spacing
        local x = utills.scaleUtills.PercentX(0.15)
        local width = utills.scaleUtills.PercentX(0.7)
        local height = utills.scaleUtills.PercentY(0.06)

        local hovering =
            mouseX > x and mouseX < x + width and
            mouseY > y and mouseY < y + height

        if hovering and inputs.MousePressed(1) then

            if def.type == "button" then
                SettingsModule.Set(key)

            elseif def.type == "toggle" then
                local current = SettingsModule.GetValue(key)
                SettingsModule.Set(key, not current)

            elseif def.type == "slider" then
                local percent = (mouseX-x)/width
                percent = utills.mathUtills.Clamp(percent,0,1)

                SettingsModule.Set(key, percent)
            end

        end
    end
end

function scene.draw()

    love.graphics.setColor(utills.colorUtills.RGBtoUnit(120,85,35))
    love.graphics.draw(imageData,0,0)

    love.graphics.setColor(1,1,1,1)

    love.graphics.setFont(titleFont)
    love.graphics.printf(
        "Options",
        utills.scaleUtills.PercentX(0.1),
        scrollAmmount,
        utills.scaleUtills.PercentX(0.8),
        "center"
    )

    local lineY = utills.scaleUtills.PercentY(0.1) + scrollAmmount
    love.graphics.line(utills.scaleUtills.PercentX(0.1), lineY,
                       utills.scaleUtills.PercentX(0.9), lineY)

    lineY = utills.scaleUtills.PercentY(0.95) + scrollAmmount
    love.graphics.line(utills.scaleUtills.PercentX(0.1), lineY + scrollLimit,
                       utills.scaleUtills.PercentX(0.9), lineY + scrollLimit)

    love.graphics.setFont(buttonFont)

    local startY = utills.scaleUtills.PercentY(0.15) + scrollAmmount
    local spacing = utills.scaleUtills.PercentY(0.09)

    local mouseX, mouseY = inputs.MousePosition()

    for i, key in ipairs(optionOrder) do

        local def = definitions[key]

        local y = startY + (i-1)*spacing
        local x = utills.scaleUtills.PercentX(0.15)
        local width = utills.scaleUtills.PercentX(0.7)
        local height = utills.scaleUtills.PercentY(0.06)

        local hovering =
            mouseX > x and mouseX < x + width and
            mouseY > y and mouseY < y + height

        local clr = hovering and {0.55,0.55,0.55,1} or {0.8,0.8,0.8,1}

        love.graphics.setColor(clr)
        love.graphics.rectangle("fill",x,y,width,height,8,8)

        love.graphics.setColor(0,0,0,1)

        local text = def.name..": "..def.get()

        love.graphics.printf(text,x+10,y+height/4,width,"left")

        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle("line",x,y,width,height,8,8)
    end

    -- scroll bar
    local scrolllineSizeY = utills.scaleUtills.PercentY(0.1)
    local scrolllineY = utills.scaleUtills.PercentY(0.9) * math.abs(scrollAmmount)/scrollLimit

    love.graphics.setColor(1,1,1,0.5)
    love.graphics.rectangle(
        "fill",
        utills.scaleUtills.PercentX(0.98),
        scrolllineY,
        utills.scaleUtills.PercentX(0.02),
        scrolllineSizeY
    )

    -- back button draw
    backButtonPos = {x = utills.scaleUtills.PercentX(0.07), y = utills.scaleUtills.PercentY(0.045)}
    backButtonSize = {x = utills.scaleUtills.PercentX(0.1), y = utills.scaleUtills.PercentY(0.05)}

    local mouseX, mouseY = inputs.MousePosition()

    local isHover =
        mouseX > backButtonPos.x - backButtonSize.x/2 and
        mouseX < backButtonPos.x + backButtonSize.x/2 and
        mouseY > backButtonPos.y - backButtonSize.y/2 and
        mouseY < backButtonPos.y + backButtonSize.y/2

    local clr = isHover and utills.colorUtills.RGBtoUnit(140,140,140) or backButtonColor

    love.graphics.setColor(unpack(clr))

    love.graphics.rectangle(
        "fill",
        backButtonPos.x - backButtonSize.x/2,
        backButtonPos.y - backButtonSize.y/2,
        backButtonSize.x,
        backButtonSize.y,
        10,10
    )

    love.graphics.setColor(0,0,0,1)

    love.graphics.printf(
        "Back",
        backButtonPos.x - backButtonSize.x/2,
        backButtonPos.y - backButtonSize.y/2,
        backButtonSize.x,
        "center"
    )

    love.graphics.setLineWidth(2.7)
    love.graphics.rectangle(
        "line",
        backButtonPos.x - backButtonSize.x/2,
        backButtonPos.y - backButtonSize.y/2,
        backButtonSize.x,
        backButtonSize.y,
        10,10
    )
end

return scene