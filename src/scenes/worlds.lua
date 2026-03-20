local utills = require("src.modules.Utills")
local inputs = require("src.modules.Inputs")
local states = require("src.modules.States")
local events = require("src.modules.Events")
local WorldManager = require("src.modules.WorldManager")

local scene = {}

local screen = {
    width = utills.scaleUtills.PercentX(1),
    height = utills.scaleUtills.PercentY(1),
}

local scrollLimit = 0
local scrollAmount = 0
local scrollConn

local worldTitleFont = love.graphics.newFont("src/fonts/jersey10.ttf", screen.height*0.1 or 20)
local worldInfoFont = love.graphics.newFont("src/fonts/jersey10.ttf", screen.height*0.06 or 12)

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
        text = "Back",
        colors = {color = utills.colorUtills.RGBtoUnit(210,210,210), hovor = utills.colorUtills.RGBtoUnit(140,140,140)},
        next = "mainmenu",
        px = 0.1,
        py = 0.95,
        sx = 0.1,
        sy = 0.08,
        lineThickness = 2.7,
    },
}

function scene.load()
    WorldManager.worlds = {}
    WorldManager.Start()
    WorldManager.SortWorlds()

    worldTitleFont = love.graphics.newFont("src/fonts/jersey10.ttf", screen.height*0.1)
    worldInfoFont = love.graphics.newFont("src/fonts/jersey10.ttf", screen.height*0.06)

    scrollAmount = 0

    if #WorldManager.worlds > 3 then
        local len = #WorldManager.worlds - 3
        scrollLimit = -(screen.height * 0.21) * len
    else
        scrollLimit = 0
    end

    scrollConn = inputs.OnMouseWheel(function(_, y)
        scrollAmount = scrollAmount + y * 25
        scrollAmount = utills.mathUtills.Clamp(scrollAmount, scrollLimit, 0)
    end)
end

function scene.unload()
    WorldManager.worlds = {} -- also reset it when unloading
    if scrollConn then
        scrollConn.Remove() -- clear scroll connection to not cause problems
    end
end

function scene.update(DT)
    local mouseX, mouseY = inputs.MousePosition()

    for _, button in ipairs(Buttons) do

        local posX = utills.scaleUtills.PercentX(button.px)
        local posY = utills.scaleUtills.PercentY(button.py)

        local sizeX = utills.scaleUtills.PercentX(button.sx)
        local sizeY = utills.scaleUtills.PercentY(button.sy)

        local isHover =
            mouseX > posX - sizeX/2 and mouseX < posX + sizeX/2 and
            mouseY > posY - sizeY/2 and mouseY < posY + sizeY/2

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
    -- draw a bg image here, have no image for now
    love.graphics.setColor(0, 0, 0, 0.2)
    love.graphics.rectangle("fill",screen.width*0.15,screen.height/2,screen.width*0.7,screen.height) -- draw a overlay to darken bg

    if WorldManager.worlds ~= nil then
        for I, UniData in ipairs(WorldManager.worlds) do
            if UniData.name or UniData.folder then
                local CurY = (I-1)*(screen.height*0.21) + scrollAmount + screen.height*0.15
                love.graphics.setColor(0, 0, 0, 0.1)
                love.graphics.rectangle("fill",screen.width*0.15,CurY,screen.width*0.7,screen.height*0.2)
                love.graphics.setColor(1, 1, 1, 0.7)
                love.graphics.rectangle("line",screen.width*0.15,CurY,screen.width*0.7,screen.height*0.2) -- draw outline

                love.graphics.setColor(1, 1, 1)
                local titleY = CurY + screen.height*0.04
                love.graphics.setFont(worldTitleFont)
                local text = UniData.name or UniData.folder or "error loading name"
                love.graphics.printf(text,screen.width*0.5,titleY,screen.width*0.65,"left")
            end
        end
    end

    -- bottom bar
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill",0,screen.height*0.85,screen.width,screen.width*0.15)
    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.line(0,screen.height*0.85,screen.width,screen.height*0.85)

    -- buttons
    for _, button in ipairs(Buttons) do

        local posX = utills.scaleUtills.PercentX(button.px)
        local posY = utills.scaleUtills.PercentY(button.py)

        local sizeX = utills.scaleUtills.PercentX(button.sx)
        local sizeY = utills.scaleUtills.PercentY(button.sy)

        DrawButton(
            {x = posX, y = posY},
            {x = sizeX, y = sizeY},
            button.colors,
            button.text,
            worldInfoFont,
            button.lineThickness
        )

    end
end

return scene