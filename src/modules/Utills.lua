local m = {}
m.colorUtills = {}
m.scaleUtills = {}
m.mathUtills = {}
m.VectorUtills = {}
m.gridUtills = {}

function m.colorUtills.RGBtoUnit(R, G, B, A)
    return {R/255, G/255, B/255, (A or 255)/255}
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

function m.scaleUtills.CenterX(w)
    local sw = love.graphics.getWidth()
    return (sw - w)/2
end

function m.scaleUtills.CenterY(h)
    local sh = love.graphics.getHeight()
    return (sh - h)/2
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

function m.mathUtills.Clamp(x, min, max)
    return math.max(min, math.min(max, x))
end

function m.mathUtills.sin(amplitude, frequency)
    return math.sin(love.timer.getTime() * frequency) * amplitude
end

function m.mathUtills.Lerp(a, b, t)
    return a + (b - a) * t
end

function m.mathUtills.Round(x)
    return math.floor(x + 0.5)
end

function m.mathUtills.Sign(x)
    if x > 0 then return 1
    elseif x < 0 then return -1
    else return 0 end
end

function m.mathUtills.Chance(percent)
    return love.math.random() < percent
end


function m.VectorUtills.Distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function m.VectorUtills.Length(x, y)
    return math.sqrt(x*x + y*y)
end

function m.VectorUtills.Normalize(x, y)
    local length = m.VectorUtills.Length(x, y)
    if length == 0 then
        return 0, 0
    end
    return x / length, y / length
end

function m.VectorUtills.Angle(x1, y1, x2, y2)
    return math.atan2(y2 - y1, x2 - x1)
end

function m.VectorUtills.MoveTowards(x, y, tx, ty, speed, dt)
    local dx = tx - x
    local dy = ty - y
    local dist = math.sqrt(dx*dx + dy*dy)

    if dist == 0 then
        return x, y
    end

    local step = speed * dt

    if step >= dist then
        return tx, ty
    end

    return x + dx/dist * step, y + dy/dist * step
end

function m.gridUtills.BlockToChunk(bx, by, chunkSize)
    return math.floor(bx / chunkSize), math.floor(by / chunkSize)
end

function m.gridUtills.WorldToChunk(x, y, blockSize, chunkSize)
    local bx = math.floor(x / blockSize)
    local by = math.floor(y / blockSize)

    return math.floor(bx / chunkSize), math.floor(by / chunkSize)
end


return m