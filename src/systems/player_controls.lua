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
		local movement_vector = vec2(0, 0)
		local movement_speed = 1000

		if player_input:pressed("left") then
			movement_vector.x = movement_vector.x - 1
		end

		if player_input:pressed("right") then
			movement_vector.x = movement_vector.x + 1
		end

		if player_input:pressed("up") then
			movement_vector.y = movement_vector.y - 1
		end

		if player_input:pressed("down") then
			movement_vector.y = movement_vector.y + 1
		end

		local body = entity.physics_object.body
		local final_vector = movement_vector * movement_speed
		body:applyForce(final_vector:unpack())
	end
end

return PlayerControls
