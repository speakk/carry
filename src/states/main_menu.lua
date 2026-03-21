local ennui = require("libs.ennui")
local TextButton = require("libs.ennui.widgets.textbutton")
local Rectangle = ennui.Widgets.Rectangle
local StackPanel = ennui.Widgets.Stackpanel

local host = ennui.Host():setSize(love.graphics.getDimensions())

local big_font = love.graphics.newFont("assets/fonts/ThaleahFat.ttf", 48, "mono")
local small_font = love.graphics.newFont("assets/fonts/m5x7.ttf", 14)
love.graphics.setFont(big_font)

local state = {}

local button_colors = {
	["normal"] = {0.25, 0.45, 0.75},
	["hover"] = {0.35, 0.60, 0.95},
	["pressed"] = {0.65, 0.85, 0.45},
}

local function style_button(button)
	button:setSize(300, 80)
	button:setBackgroundColor(unpack(button_colors["normal"]))
	button:setPressedColor(unpack(button_colors["pressed"]))
	button:setHoverColor(unpack(button_colors["hover"]))
	return button
end

function state:enter(states)
	local start_button = style_button(TextButton("Start game!")
    :onClick(function(button, event)
				states:set_state("in_game")
    end))

	local quit_button = style_button(TextButton("Quit")
    :setSize(300, 80)
    :onClick(function(button, event)
				love.event.quit()
    end))
	
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

