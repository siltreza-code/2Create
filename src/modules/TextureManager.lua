local m = {}

local cache = {}

-- Normalize names
local function normalize(name)
    return string.lower(tostring(name))
end

-- Get full cache entry
function m.GetCache(textureName)
    local name = normalize(textureName)
    return cache[name]
end

-- Get just texture (image)
function m.GetTexture(textureName)
    local entry = m.GetCache(textureName)
    return entry and entry.texture or nil
end

-- Get quad
function m.GetQuad(textureName)
    local entry = m.GetCache(textureName)
    return entry and entry.quad or nil
end

-- Create a cached texture quad
function m.NewCache(image, name, position, size)
    assert(image, "Image is required")
    assert(name, "Name is required")
    assert(position and position.x and position.y, "Invalid position")
    assert(size and size.x and size.y, "Invalid size")

    local key = normalize(name)

    -- Prevent overwrite
    if cache[key] then
        print("[TextureCache] Warning: Overwriting texture:", key)
    end

    local imgW, imgH = image:getWidth(), image:getHeight()

    local quad = love.graphics.newQuad(
        position.x,
        position.y,
        size.x,
        size.y,
        imgW,
        imgH
    )

    cache[key] = {
        name = key,
        texture = image,
        quad = quad,
        position = position,
        size = size
    }

    return cache[key]
end

function m.NewCacheFromIndex(image, name, index)
    assert(image, "Image is required")
    assert(name, "Name is required")
    assert(type(index) == "number", "Index must be a number")

    local tileSize = 32
    local imgW, imgH = image:getWidth(), image:getHeight()

    local cols = math.floor(imgW / tileSize)

    -- Convert index → x, y
    local x = (index % cols) * tileSize
    local y = math.floor(index / cols) * tileSize

    return m.NewCache(
        image,
        name,
        { x = x, y = y },
        { x = tileSize, y = tileSize }
    )
end

local function NewCacheFromIndexSized(image, name, index, tileSize)
    tileSize = tileSize or 32

    local imgW, imgH = image:getWidth(), image:getHeight()
    local cols = math.floor(imgW / tileSize)

    local x = (index % cols) * tileSize
    local y = math.floor(index / cols) * tileSize

    return m.NewCache(
        image,
        name,
        { x = x, y = y },
        { x = tileSize, y = tileSize }
    )
end

local config = {
    {
        image = "src/imgs/sheet1.png",
        tileSize = 32,

        textures = {
            { name = "dirt", index = 0 },
        }
    }
}

function m.LoadTextures()
    for i, sheet in ipairs(config) do
        assert(sheet.image, "[TextureLoader] Missing image path at config index: " .. i)

        local success, image = pcall(love.graphics.newImage, sheet.image)
        assert(success and image, "[TextureLoader] Failed to load image: " .. tostring(sheet.image))

        local tileSize = sheet.tileSize or 32

        assert(sheet.textures and #sheet.textures > 0,
            "[TextureLoader] No textures defined for: " .. sheet.image)

        for j, tex in ipairs(sheet.textures) do
            assert(tex.name, "[TextureLoader] Missing name at index: " .. j)
            assert(type(tex.index) == "number",
                "[TextureLoader] Invalid index for: " .. tostring(tex.name))
            if m.GetCache(tex.name) then
                error("[TextureLoader] Duplicate texture name: " .. tex.name)
            end
            
            m.NewCacheFromIndexSized(image, tex.name, tex.index, tileSize)
        end
    end
end

return m