local Utills = require("src.modules.Utills")

local cacheSFX = {} -- sfx caching
local cacheMUSIC = {} -- music caching
local activeSFX = {} -- active sfx tracking

local SoundManager = {}
SoundManager.SFX = {}
SoundManager.Music = {}

local MAINVolume = 1
local SFXVolume = 1
local MUSICVolume = 1

function SoundManager.SFX.Load(fileName)
    if not love.filesystem.getInfo("src/audio/sfx/" .. fileName) then
        return false
    end
    if cacheSFX[fileName] then
        return true
    else
        local sfx = love.audio.newSource("src/audio/sfx/" .. fileName, "static")
        cacheSFX[fileName] = sfx
        return true
    end
end

function SoundManager.Music.Load(fileName)
    if not love.filesystem.getInfo("src/audio/music/" .. fileName) then
        return false
    end
    if cacheMUSIC[fileName] then
        return true
    else
        local music = love.audio.newSource("src/audio/music/" .. fileName, "stream")
        cacheMUSIC[fileName] = music
        return true
    end
end

function SoundManager.SFX.Play(fileName, Pitch)
    if cacheSFX[fileName] then
        local sfx = cacheSFX[fileName]:clone()
        sfx:setVolume(SFXVolume*MAINVolume)
        sfx:setPitch(Pitch or 1)
        sfx:play()
        table.insert(activeSFX, {source = sfx, fileName = fileName})
    end
end

function SoundManager.Music.Play(fileName)
    if cacheMUSIC[fileName] then
        local music = cacheMUSIC[fileName]
        music:setVolume(MUSICVolume*MAINVolume)
        music:play()
    end
end

SoundManager.Volume = {}
function SoundManager.Volume.ChangeSFXVolume(newVolume)
    SFXVolume = Utills.mathUtills.Clamp(newVolume, 0, 1)
end

function SoundManager.Volume.ChangeMUSICVolume(newVolume)
    MUSICVolume = Utills.mathUtills.Clamp(newVolume, 0, 1)
end

function SoundManager.SFX.IsPlaying(fileName)
    -- Remove stopped sources
    for i = #activeSFX, 1, -1 do
        if not activeSFX[i].source:isPlaying() then
            table.remove(activeSFX, i)
        end
    end
    -- Check if any remaining match fileName
    for _, entry in ipairs(activeSFX) do
        if entry.fileName == fileName then
            return true
        end
    end
    return false
end

function SoundManager.Music.IsPlaying(fileName)
    if cacheMUSIC[fileName] then
        return cacheMUSIC[fileName]:isPlaying()
    end
    return false
end

function SoundManager.Music.AnyPlaying()
    for _, music in pairs(cacheMUSIC) do
        if music:isPlaying() then
            return true
        end
    end
    return false
end

return SoundManager