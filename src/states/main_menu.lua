local ennui = require("libs.ennui")
local TextButton = require("libs.ennui.widgets.textbutton")
local Rectangle = ennui.Widgets.Rectangle
local StackPanel = ennui.Widgets.Stackpanel

local host = ennui.Host():setSize(love.graphics.getDimensions())

local big_font = love.graphics.newFont("assets/fonts/ThaleahFat.ttf", 48, "mono")
local small_font = love.graphics.newFont("assets/fonts/m5x7.ttf", 14)
love.graphics.setFont(big_font)

local state = {}

function state:enter(states)
	local start_button = TextButton("Start game!")
    :setSize(300, 80)
    :onClick(function(button, event)
				states:set_state("in_game")
    end)

	local quit_button = TextButton("Quit")
    :setSize(300, 80)
    :onClick(function(button, event)
				love.event.quit()
    end)
	
	local container = Rectangle()
		:setSize(ennui.Size.fill(), ennui.Size.fill())
		:setColor(0.34, 0.25, 0.29, 1.0)

	local panel = StackPanel()
    :setSpacing(15)
    :setPadding(10)
    :setSize(300, ennui.Size.auto())
		:setVerticalAlignment("center")
		:setHorizontalAlignment("center")

	container:addChild(panel)
	panel:addChild(start_button)
	panel:addChild(quit_button)

	host:addChild(container)
end

function state:update(dt)
	host:update(dt)
end

function state:draw()
	host:draw()
end

function state:resize(w, h)
	host:setSize(w, h)
end

function state:getHost()
	return host
end

return state

