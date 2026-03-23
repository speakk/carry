local get_in_game_pause_menu = require 'src.states.in_game_pause'

local in_game = {}

local InGameSystem = Concord.system({})

local all_levels = {
	"map01", "map02", "map03"
}

function InGameSystem:all_collectables_collected()
	in_game:all_collectables_collected()
end

function in_game:enter(states)
	self.states = states
end

function in_game:setup(level_index)
	self.level_index = level_index or 1
	self.timer = 0

	print("Initializing world with level index", level_index)
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
		:give("map", level_index and all_levels[level_index] or "testmap")
		:give("position", 0, 0)

		self.world:emit("resize", love.graphics.getDimensions())
end

function in_game:update(dt)
	if not self.paused then
		self.world:emit("update", dt)
		self.timer = self.timer + dt
	end
end

local function format_time(time)
	return string.format("%02d:%02d", time/60, time)
end

function in_game:draw()
	self.world:emit("draw")

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print("Time: " .. format_time(self.timer), 50, 50)
end

function in_game:resize(w, h)
	self.world:emit("resize", w, h)
end

function in_game:set_pause(pause, finished_level)
	self.paused = pause

	if pause then
		self.pause_menu = get_in_game_pause_menu()
		self.pause_menu:enter(self.states, self, finished_level, self.timer)
		self.getHost = function()
			return self.pause_menu:getHost()
		end

		print("Set pause trued")
	else
		self.getHost = nil
		self.pause_menu = nil
		print("Set pause removed")
	end
end

function in_game:all_collectables_collected()
	print("should set pause, in in game all_collectables_collected")
	self:handle_level_finished()
	self:set_pause(true, true)
end

function in_game:handle_level_finished()
	local current_unlocked_level = tonumber(love.filesystem.read("savefile") or 1)
	if current_unlocked_level >= #all_levels then return end
	love.filesystem.write("savefile", tostring(current_unlocked_level + 1))
end

function in_game:is_next_level_available()
	local current_unlocked_level = tonumber(love.filesystem.read("savefile") or 1)
	print("unlocked level vs current index", current_unlocked_level, self.level_index)
	return self.level_index < current_unlocked_level and self.level_index < #all_levels
end

function in_game:restart_level()
	self.states:set_state("in_game", true)
	self.states:_call("setup", self.level_index)
end

function in_game:go_to_next_level()
	self.states:set_state("in_game", true)
	self.states:_call("setup", self.level_index + 1)
end

function in_game:exit()
	print("In game exit called")
	self:set_pause(false)
	self.world:emit("cleanup")
	self.world = nil
end

function in_game:keypressed(key, scancode, isRepeat)
	if key == "escape" then
		self:set_pause(not self.paused)
	end
end

return in_game
