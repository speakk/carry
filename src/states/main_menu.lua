local ennui = require("libs.ennui")
local Text = require("libs.ennui.widgets.text")
local TextButton = require("libs.ennui.widgets.textbutton")
local Rectangle = ennui.Widgets.Rectangle
local StackPanel = ennui.Widgets.Stackpanel

local host = ennui.Host():setSize(love.graphics.getDimensions())

local title_font = love.graphics.newFont("assets/fonts/ThaleahFat.ttf", 64, "mono")
local big_font = love.graphics.newFont("assets/fonts/ThaleahFat.ttf", 48, "mono")
local small_font = love.graphics.newFont("assets/fonts/m5x7.ttf", 24)
love.graphics.setFont(big_font)

local state = {}

local button_colors = {
	["normal"] = {0.25, 0.45, 0.75},
	["hover"] = {0.35, 0.60, 0.95},
	["pressed"] = {0.65, 0.85, 0.45},
}

local function style_button(button)
	button:setSize(200, 80)
	button:setBackgroundColor(unpack(button_colors["normal"]))
	button:setPressedColor(unpack(button_colors["pressed"]))
	button:setHoverColor(unpack(button_colors["hover"]))
	return button
end

function state:enter(states)
	local title = Text("CounterBalance!")
		:setFont(title_font)
		:setColor(0.55, 0.65, 1.0)
		--:setSize(ennui.Size.auto(), 28)
		:setSize(460, 28)
		:setTextHorizontalAlignment("center")
	local subtitle = Text("by speak"):setFont(small_font)
		:setTextHorizontalAlignment("right")
		:setSize(450, ennui.Size.auto())

	local start_button = style_button(TextButton("Start game!")
    :onClick(function(button, event)
				states:set_state("in_game")
    end))

	local quit_button = style_button(TextButton("Quit")
    :onClick(function(button, event)
				love.event.quit()
    end))
	
	local spacer = Rectangle():setSize(ennui.Size.fill(), 20)
		:setColor(0.44, 0.35, 0.63)
		:setBorderWidth(0)
	
	local container = Rectangle()
		:setSize(ennui.Size.fill(), ennui.Size.fill())
		:setColor(0.34, 0.25, 0.29, 1.0)
		:setBorderWidth(0)

	local panel = StackPanel()
    :setSpacing(15)
    :setPadding(10)
    :setSize(800, ennui.Size.auto())
		:setVerticalAlignment("center")
		:setHorizontalAlignment("center")

	local titles_panel = StackPanel()
    :setSpacing(15)
    :setPadding(10)
    :setSize(ennui.Size.auto(), 80)
		:setVerticalAlignment("center")
		:setHorizontalAlignment("center")

	local button_panel = StackPanel()
    :setSpacing(15)
    :setPadding(10)
    :setSize(320, ennui.Size.auto())
		:setVerticalAlignment("center")
		:setHorizontalAlignment("center")

	container:addChild(panel)

	titles_panel:addChild(title)
	titles_panel:addChild(subtitle)

	button_panel:addChild(start_button)
	button_panel:addChild(quit_button)

	panel:addChild(titles_panel)
	panel:addChild(spacer)
	panel:addChild(button_panel)

	host:addChild(container)
end

function state:getHost()
	return host
end

return state

