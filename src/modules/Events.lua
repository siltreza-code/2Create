local Events = {}

local m = {}

-- Create new event
function m.NewEvent(name)
    if Events[name] ~= nil then
        error("event already exists!", 2)
    end

    Events[name] = {}
end

-- Fire event
function m.Fire(name, ...)
    if Events[name] ~= nil then
        for _, callback in ipairs(Events[name]) do
            callback(...)
        end
    else
        -- create the missing event automatically so future hooks/fires won't crash
        Events[name] = {}
        print("[Events] warning: Fire() called for non-existent event '" .. name .."'; creating it.")
    end
end

-- Hook into event
function m.Hook(name, callback)
    if Events[name] == nil then
        -- automatically create the event so hooks don't blow up
        Events[name] = {}
        print("[Events] warning: Hook() called for non-existent event '" .. name .."'; creating it.")
    end

    table.insert(Events[name], callback)

    local hookedEvent = name
    local hookedCallback = callback

    local funcs = {}

    function funcs.UnHook()
        local eventTable = Events[hookedEvent]
        if eventTable then
            for i, cb in ipairs(eventTable) do
                if cb == hookedCallback then
                    table.remove(eventTable, i)
                    break
                end
            end
        end
    end

    return funcs
end

-- Remove all callbacks from one event
function m.Clear(name)
    if Events[name] ~= nil then
        Events[name] = {}
    else
        error("event does not exist!", 2)
    end
end

-- Remove entire event
function m.RemoveEvent(name)
    if Events[name] ~= nil then
        Events[name] = nil
    else
        error("event does not exist!", 2)
    end
end

-- Get all callbacks (for debugging)
function m.GetAll(name)
    if Events[name] ~= nil then
        return Events[name]
    else
        error("event does not exist!", 2)
    end
end

-- Check if event exists
function m.Exists(name)
    return Events[name] ~= nil
end

return m