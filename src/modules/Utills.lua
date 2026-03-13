local m = {}
m.colorUtills = {}
m.scaleUtills = {}

function m.colorUtills.RGBtoUnit(R, G, B, A)
    return (R/255), (G/255), (B/255), (A or 255/255)
end

function m.colorUtills.HexToUnit(hex)
    hex = hex:gsub("#","")

    local r = tonumber(hex:sub(1,2), 16)
    local g = tonumber(hex:sub(3,4), 16)
    local b = tonumber(hex:sub(5,6), 16)

    return r/255, g/255, b/255
end

function m.colorUtills.Lerp(c1, c2, t)
    return
        c1[1] + (c2[1] - c1[1]) * t,
        c1[2] + (c2[2] - c1[2]) * t,
        c1[3] + (c2[3] - c1[3]) * t,
        (c1[4] or 1) + ((c2[4] or 1) - (c1[4] or 1)) * t
end

function m.colorUtills.Multiply(r, g, b, factor)
    return r * factor, g * factor, b * factor
end

function m.scaleUtills.PercentX(percent)
    return love.graphics.getWidth() * percent
end

function m.scaleUtills.PercentY(percent)
    return love.graphics.getHeight() * percent
end

function m.scaleUtills.Center(w, h)
    local sw, sh = love.graphics.getDimensions()
    return (sw - w)/2, (sh - h)/2
end

function m.scaleUtills.Anchor(w, h, anchorX, anchorY)
    local sw, sh = love.graphics.getDimensions()

    return
        (sw - w) * anchorX,
        (sh - h) * anchorY
end

function m.scaleUtills.Fit(baseW, baseH)
    local sw, sh = love.graphics.getDimensions()

    local scaleX = sw / baseW
    local scaleY = sh / baseH

    return math.min(scaleX, scaleY)
end

function m.scaleUtills.Smooth(current, target, speed, dt)
    return current + (target - current) * speed * dt
end

return m