local json = require("src.modules.json")

local m = {}

m.worlds = {}
m.loadedWorld = nil -- world, player, items data
m.loadedWorldName = nil -- folder name

-- loads baisic information
function m.Start()
    local info = love.filesystem.getInfo("worlds")

    if not info or info.type ~= "directory" then
        love.filesystem.createDirectory("worlds")
        return
    end

    for _, folder in ipairs(love.filesystem.getDirectoryItems("worlds")) do
        local folderPath = "worlds/" .. folder
        local fInfo = love.filesystem.getInfo(folderPath)

        if fInfo and fInfo.type == "directory" then
            local universePath = folderPath .. "/universe.dat"
            local data = love.filesystem.read(universePath)

            if data then
                local universeData = json.decode(data)
                m.worlds[folder] = {
                    name = universeData.name or folder,
                    image = universeData.image
                }
            end
        end
    end
end

local function GetUniqueWorldName(baseName)
    local name = baseName:gsub("%s+", "_")
    local finalName = name
    local index = 1

    local function exists(folderName)
        local info = love.filesystem.getInfo("worlds/" .. folderName)
        return info ~= nil
    end

    while exists(finalName) do
        finalName = name .. "(" .. index .. ")"
        index = index + 1
    end

    return finalName
end

function m.SaveWorld(Name, World, Player, Items, last_image, Play_time)
    local newName = GetUniqueWorldName(Name)
    local folderPath = "worlds/" .. newName

    local success, message = pcall(function()
        -- Create world folder
        love.filesystem.createDirectory(folderPath)

        -- Save core data
        love.filesystem.write(folderPath .. "/world.dat", json.encode(World))
        love.filesystem.write(folderPath .. "/player.dat", json.encode(Player))
        love.filesystem.write(folderPath .. "/items.dat", json.encode(Items))

        -- Save image
        if last_image then
            love.filesystem.write(folderPath .. "/image.png", last_image)
        end

        -- Save metadata
        local universeData = json.encode({
            name = newName,
            folder = newName,
            image = last_image and "image.png" or nil,
            lastPlayed = os.time(),
            playTime = Play_time or 0
        })

        love.filesystem.write(folderPath .. "/universe.dat", universeData)
    end)

    return success, message, newName
end

function m.LoadWorld(folderName)
    local folderPath = "worlds/" .. folderName
    local info = love.filesystem.getInfo(folderPath)
    if info and info.type == "directory" then
        local worldData = love.filesystem.read(folderPath .. "/world.dat")
        local playerData = love.filesystem.read(folderPath .. "/player.dat")
        local itemsData = love.filesystem.read(folderPath .. "/items.dat")

        if worldData and playerData and itemsData then
            m.loadedWorld = {
                world = json.decode(worldData),
                player = json.decode(playerData),
                items = json.decode(itemsData)
            }
            m.loadedWorldName = folderName
            return true
        else
            return false, "Failed to read world data files."
        end
    else
        return false, "World folder does not exist."
    end
    return false, "Unknown error loading world."
end

return m