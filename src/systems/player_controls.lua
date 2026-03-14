local input = require 'src.input'

local PlayerControls = Concord.system({
	pool = {"position", "physics_object", "player_controlled"},
	player_controllables = {"player_controllable"}
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

		local shape = body:getShape()
		if player_input:down "hold" then
			shape:setFriction(1.0)
			body:setAngularVelocity(0)
			body:setAngularDamping(10000.0)
			body:setLinearVelocity(0, 0)
			body:setMass(0.2)
		else
			shape:setFriction(0.1)
			body:setAngularDamping(0.1)
			body:setMass(0.2)
		end

		if player_input:pressed "switch" then
			for _, other_entity in ipairs(self.player_controllables) do
				if other_entity:has("player_controlled") then
					other_entity:remove("player_controlled")
				else
					other_entity:give("player_controlled")
				end
			end
		end
	end
end

return PlayerControls
