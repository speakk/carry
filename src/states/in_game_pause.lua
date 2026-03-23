local ennui = require("libs.ennui")
local Text = ennui.Widgets.Text
local TextButton = ennui.Widgets.TextButton
local Rectangle = ennui.Widgets.Rectangle
local StackPanel = ennui.Widgets.Stackpanel


local title_font = love.graphics.newFont("assets/fonts/ThaleahFat.ttf", 64, "mono")
local big_font = love.graphics.newFont("assets/fonts/ThaleahFat.ttf", 32, "mono")
local small_font = love.graphics.newFont("assets/fonts/m5x7.ttf", 24)

local button_colors = {
	["normal"] = {0.25, 0.45, 0.75},
	["hover"] = {0.35, 0.60, 0.95},
	["pressed"] = {0.65, 0.85, 0.45},
}

local function style_button(button)
	button:setSize(240, 80)
	button:setBackgroundColor(unpack(button_colors["normal"]))
	button:setPressedColor(unpack(button_colors["pressed"]))
	button:setHoverColor(unpack(button_colors["hover"]))
	return button
end

function get_menu()

	local in_game_paused = {}
	local host = ennui.Host():setSize(love.graphics.getDimensions())

	function in_game_paused:enter(states, in_game, completed_level, time)
		host:setSize(love.graphics.getDimensions())

		local time_formatted = string.format("%02d:%02d", time/60, time)
		local text = completed_level and "Level completed! Your time was: " .. time_formatted or "Game paused. Press ESC to unpause"

		local titleText = Text(text):setFont(big_font)
		:setSize(480, ennui.Size.auto())

		local resume_button = style_button(TextButton("Resume level")
			:onClick(function(button, event)
				in_game:set_pause(false)
			end))

		local next_level_button = style_button(TextButton("Next level")
			:onClick(function(button, event)
				in_game:go_to_next_level()
			end))

		local start_button = style_button(TextButton("Restart level")
		:onClick(function(button, event)
			in_game:restart_level()
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
		:setColor(0.34, 0.25, 0.29, 0.3)
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
		:setSize(ennui.Size.auto(), 50)
		:setVerticalAlignment("center")
		:setHorizontalAlignment("center")

		local button_panel = StackPanel()
		:setSpacing(15)
		:setPadding(10)
		:setSize(320, ennui.Size.auto())
		:setVerticalAlignment("center")
		:setHorizontalAlignment("center")

		container:addChild(panel)

		titles_panel:addChild(titleText)

		button_panel:addChild(start_button)
		button_panel:addChild(resume_button)
		if in_game:is_next_level_available() then
			button_panel:addChild(next_level_button)
		end
		button_panel:addChild(quit_button)

		panel:addChild(titles_panel)
		panel:addChild(spacer)
		panel:addChild(button_panel)

		host:addChild(container)
	end

	function in_game_paused:getHost()
		return host
	end

	return in_game_paused
end

return get_menu
