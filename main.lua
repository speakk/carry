local love = require("love") -- Needed to make the lsp happy
love.setDeprecationOutput(false)
love.window.setMode(800, 600, { resizable = true })

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

	local ennui_host = states:_call("getHost")
	if ennui_host then
		ennui_host:update()
	end
end

function love.draw()
	states:draw()

	local ennui_host = states:_call("getHost")
	if ennui_host then
		ennui_host:draw()
	end
end

function love.resize(w, h)
	states:_call("resize", w, h)

	local ennui_host = states:_call("getHost")
	if ennui_host then
		ennui_host:setSize(w, h)
	end
end

function love.mousepressed(x, y, button, isTouch)
	local ennui_host = states:_call("getHost")
	if ennui_host then
		ennui_host:mousepressed(x, y, button, isTouch)
	end
end

function love.mousereleased(x, y, button, isTouch)
	local ennui_host = states:_call("getHost")
	if ennui_host then
		ennui_host:mousereleased(x, y, button, isTouch)
	end
end

function love.mousemoved(x, y, dx, dy, isTouch)
	local ennui_host = states:_call("getHost")
	if ennui_host then
		ennui_host:mousemoved(x, y, dx, dy, isTouch)
	end
end

function love.wheelmoved(dx, dy)
	local ennui_host = states:_call("getHost")
	if ennui_host then
		ennui_host:wheelmoved(dx, dy)
	end
end

function love.keypressed(key, scancode, isRepeat)
	states:_call("keypressed", key, scancode, isRepeat)

	local ennui_host = states:_call("getHost")
	if ennui_host then
		ennui_host:keypressed(key, scancode, isRepeat)
	end
end

function love.keyreleased(key, scancode)
	local ennui_host = states:_call("getHost")
	if ennui_host then
		ennui_host:keyreleased(key, scancode)
	end
end

function love.textinput(text)
	local ennui_host = states:_call("getHost")
	if ennui_host then
		ennui_host:textinput(text)
	end
end
