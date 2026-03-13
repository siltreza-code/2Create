local SongLoader = {}

-- Utility: check file exists
local function exists(path)
    return love.filesystem.getInfo(path) ~= nil
end

-- Utility: safely load a lua file that returns a table
local function safeLoadLua(path)
    local chunk, err = love.filesystem.load(path)
    if not chunk then
        return false, "Failed to load file: " .. (err or "")
    end

    local ok, result = pcall(chunk)
    if not ok then
        return false, "Error running file: " .. (result or "")
    end

    if type(result) ~= "table" then
        return false, "File did not return a table"
    end

    return true, result
end

-- Validate and load a single song folder
function SongLoader.loadSongFolder(folderPath)
    local infoPath  = folderPath .. "/info.lua"
    local chartPath = folderPath .. "/chart.lua"

    -- Required files
    if not exists(infoPath) then
        return nil, "Missing info.lua"
    end

    if not exists(chartPath) then
        return nil, "Missing chart.lua"
    end

    -- Load metadata
    local ok, infoOrError = safeLoadLua(infoPath)
    if not ok then
        return nil, infoOrError
    end

    local info = infoOrError

    -- Validate required fields
    if not info.name or not info.audio then
        return nil, "info.lua missing required fields (name or audio)"
    end

    local audioPath = folderPath .. "/" .. info.audio
    if not exists(audioPath) then
        return nil, "Audio file not found: " .. info.audio
    end

    -- Optional thumbnail
    local image = nil
    if info.image then
        local imagePath = folderPath .. "/" .. info.image
        if exists(imagePath) then
            image = love.graphics.newImage(imagePath)
        end
    end

    -- Build final song object
    local song = {
        folder = folderPath,
        name = info.name,
        artist = info.artist or "Unknown",
        bpm = info.bpm or 120,
        audioPath = audioPath,
        chartPath = chartPath,
        image = image
    }

    return song
end

-- Load all songs inside /songs
function SongLoader.loadAllSongs()
    local songs = {}

    if not exists("songs") then
        print("[SongLoader] No songs folder found.")
        return songs
    end

    local items = love.filesystem.getDirectoryItems("songs")

    for _, folderName in ipairs(items) do
        local folderPath = "songs/" .. folderName
        local info = love.filesystem.getInfo(folderPath)

        if info and info.type == "directory" then
            local song, err = SongLoader.loadSongFolder(folderPath)

            if song then
                table.insert(songs, song)
                print("[SongLoader] Loaded:", song.name)
            else
                print("[SongLoader] Skipped:", folderName, "| Reason:", err)
            end
        end
    end

    table.sort(songs, function(a, b)
        return a.name:lower() < b.name:lower()
    end)

    return songs
end

-- Load chart later (for gameplay scene)
function SongLoader.loadChart(song)
    if not song or not song.chartPath then
        return nil, "Invalid song"
    end

    local ok, chartOrError = safeLoadLua(song.chartPath)
    if not ok then
        return nil, chartOrError
    end

    return chartOrError
end

return SongLoader