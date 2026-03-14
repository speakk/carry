local input = require 'src.input'

local PlayerControls = Concord.system({
	pool = {"position", "physics_object", "player_controlled"},
})

function PlayerControls:init()
	self.pool.onAdded = function(_, entity)
		entity.player_controlled.input = input
	end
end

function PlayerControls:update(dt)
	for _, entity in ipairs(self.pool) do
		local player_input = entity.player_controlled.input
		player_input:update()

		local movement_speed = 300

		local input_x, input_y = player_input:get("move")

		local body = entity.physics_object.body
		body:applyForce(input_x * movement_speed, input_y * movement_speed)
	end
end

return PlayerControls
