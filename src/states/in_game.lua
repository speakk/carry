local get_in_game_pause_menu = require 'src.states.in_game_pause'

local in_game = {}

local InGameSystem = Concord.system({})

function InGameSystem:all_collectables_collected()
	in_game:all_collectables_collected()
end

function in_game:enter(states)
	self.states = states
	print("Initializing world")
	self.world = Concord.world()

	self.world:addSystems(
		InGameSystem,
		Systems.physics,
		Systems.map,
		Systems.player_controls,
		Systems.roped_to,
		Systems.collectable,
		Systems.particle,
		Systems.draw_system,
		Systems.sound
	)

	Concord.entity(self.world)
		:give("map", "map02")
		:give("position", 0, 0)

		self.world:emit("resize", love.graphics.getDimensions())
end

function in_game:update(dt)
	if not self.paused then
		self.world:emit("update", dt)
	end
end

function in_game:draw()
	self.world:emit("draw")
end

function in_game:resize(w, h)
	self.world:emit("resize", w, h)
end

function in_game:set_pause(pause)
	self.paused = pause

	if pause then
		self.pause_menu = get_in_game_pause_menu()
		self.pause_menu:enter(self.states, self)
		self.getHost = function()
			return self.pause_menu:getHost()
		end

		print("Set pause trued")
	else
		self.pause_menu = nil
		self.getHost = nil
		print("Set pause removed")
	end
end

function in_game:all_collectables_collected()
	print("should set pause, in in game all_collectables_collected")
	self:set_pause(true)
end

function in_game:keypressed(key, scancode, isRepeat)
	if key == "escape" then
		self:set_pause(not self.paused)
	end
end

return in_game
