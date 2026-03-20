local love = require("love") -- Needed to make the lsp happy
love.setDeprecationOutput(false)

-- Globals
require("libs.batteries"):export()
Concord = require "libs.concord"
Concord.utils.loadNamespace("src/components")
Systems = {}
Concord.utils.loadNamespace("src/systems", Systems)
-- Globals end

local states = require("src.states.states")
local input = require("src.input")

love.graphics.setDefaultFilter("nearest", "nearest")

function love.update(dt)
	states:update(dt)
end

function love.draw()
	states:draw()
end

function love.resize(w, h)
	states:_call("resize", w, h)
end
