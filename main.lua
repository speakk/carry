local love = require("love") -- Needed to make the lsp happy

-- Globals
require("libs.batteries"):export()
Concord = require "libs.concord"
Concord.utils.loadNamespace("src/components")
Systems = {}
Concord.utils.loadNamespace("src/systems", Systems)
-- Globals end

local states = require("src.states.states")
local input = require("src.input")

function love.update(dt)
  input:update()
	states:update(dt)
end

function love.draw()
	states:draw()
end
