local sceneLocation = "src.scenes."

local m = {}
m.scene = nil
m.sceneRaw = nil

-- loads the scene given
function m.loadScene(name)
    -- unload previous scene
    if m.sceneRaw and type(m.sceneRaw.unload) == "function" then
        local ok, err = pcall(function()
            m.sceneRaw.unload()
        end)
        if not ok then
            print("Warning: error running previous scene.unload() msg: " .. (err or ""))
        end
    end

    -- optional: clear previous scene from require cache
    package.loaded[sceneLocation .. name] = nil

    local success, result = pcall(function()
        return require(sceneLocation .. name)
    end)

    if not success then
        m.scene = nil
        m.sceneRaw = nil
        error("err loading module. name: " .. name .. " msg: " .. (result or ""), 2)
    end

    m.scene = name
    m.sceneRaw = result
    
    -- call load if exists
    if m.sceneRaw and type(m.sceneRaw.load) == "function" then
        local ok, err = pcall(function()
            m.sceneRaw.load()
        end)

        if not ok then
            error("error running scene.load() for scene: " .. name .. " msg: " .. (err or ""), 2)
        end
    end
end

-- update
function m.update(DT)
    if DT and m.sceneRaw and type(m.sceneRaw.update) == "function" then
        m.sceneRaw.update(DT)
    else
        error("either DT is not an arg or theres no scene loaded!", 2)
    end
end

-- draw
function m.draw()
    if m.sceneRaw and type(m.sceneRaw.draw) == "function" then
        m.sceneRaw.draw()
    else
        error("there is no loaded scene!", 2)
    end
end

-- explicitly unload current scene (optional)
function m.unloadCurrent()
    if m.sceneRaw and type(m.sceneRaw.unload) == "function" then
        local ok, err = pcall(function()
            m.sceneRaw.unload()
        end)
        if not ok then
            print("Warning: error running scene.unload() msg: " .. (err or ""))
        end
    end
    m.scene = nil
    m.sceneRaw = nil
end

return m