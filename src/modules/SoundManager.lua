local Utills = require("src.modules.Utills")

local cacheSFX = {} -- sfx caching
local cacheMUSIC = {} -- music caching

local SoundManager = {}
SoundManager.SFX = {}
SoundManager.Music = {}

local MAINVolume = 1
local SFXVolume = 1
local MUSICVolume = 1

function SoundManager.SFX.Load(fileName)
    if love.filesystem.getInfo("src/audio/sfx/" .. fileName) then
        if cacheSFX[fileName] then
            return cacheSFX[fileName] ~= nil
        else
            local sfx = love.audio.newSource("src/audio/sfx/" .. fileName, "static")
            cacheSFX[fileName] = sfx
            return cacheSFX[fileName] ~= nil
        end
    end
end

function SoundManager.Music.Load(fileName)
    if love.filesystem.getInfo("src/audio/music/" .. fileName) then
        if cacheMUSIC[fileName] then
            return cacheMUSIC[fileName] ~= nil
        else
            local music = love.audio.newSource("src/audio/music/" .. fileName, "stream")
            cacheMUSIC[fileName] = music
            return cacheMUSIC[fileName] ~= nil
        end
    end
end

function SoundManager.SFX.Play(fileName, Pitch)
    if cacheSFX[fileName] then
        local sfx = cacheSFX[fileName]:clone()
        sfx:setVolume(SFXVolume*MAINVolume)
        sfx:setPitch(Pitch or 1)
        sfx:play()
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
    if cacheSFX[fileName] then
        return cacheSFX[fileName]:isPlaying()
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