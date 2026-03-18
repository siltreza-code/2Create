

local config = {
    stats = {
        health = 100,
        maxHealth = 100,

        stamina = 10.0,
        maxStamina = 10.0,

        staminaDrain = (config.stats.maxStamina / (120 * (1/32))), -- per tick (32 ticks a second), this equation used to find drain
    },
    player = {
        radius = 1, -- size of player in blocks
        state = "idle", -- idle, walking, running, jumping, falling, etc
        stateTime = 0, -- how long the player has been in the current state, used for animations and such
    },
    health = 100,
    maxHealth = 100,
    stamina = 10.0,
    maxStamina = 10.0,
    speed = 1,
    runSpeed = 1.7,
    jumpPower = 1,

    inventorySize = 27,
    hotbarSize = 9, -- nine because I dont want to use the 0 key
    inventory = {},


}

local Player = {}

function Player.Update(DT)
    
end

return Player