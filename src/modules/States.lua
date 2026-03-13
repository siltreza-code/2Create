local states = {}

local m = {}

function m.New(name, value)
    if states[name] ~= nil then
        error("state already exists!", 2)
    else
        -- always create the key, even if the initial value is nil/false
        states[name] = value
    end
end

function m.Set(name, Newvalue)
    if states[name] ~= nil then
        states[name] = Newvalue
    else
        -- auto-create missing state instead of erroring
        states[name] = Newvalue
        print("[States] warning: Set() called for non-existent state '" .. name .."'; creating it.")
    end
end

function m.Get(name)
    if name and states[name] ~= nil then
        return states[name]
    end
end

function m.Clear()
    states = {}
end

function m.Exists(name)
    return states[name] ~= nil
end

function m.Remove(name)
    if states[name] ~= nil then
        states[name] = nil
    else
        error("state does not exist!", 2)
    end
end

function m.GetAll()
    return states
end

return m