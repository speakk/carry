local input = require 'src.input'

local PlayerControls = Concord.system({
	pool = {"position", "physics_object", "player_controlled"},
	player_controllables = {"player_controllable"},
	map = { "map" }
})

function PlayerControls:init()
	self.pool.onAdded = function(_, entity)
		entity.player_controlled.input = input
	end
end

function PlayerControls:player_ground_start()
	for _, entity in ipairs(self.pool) do
		entity.player_controlled.on_ground = true
	end
end

function PlayerControls:player_ground_end()
	for _, entity in ipairs(self.pool) do
		entity.player_controlled.on_ground = false
	end
end

local function positionOnGround(x, y, map)
	local tile_x, tile_y = map:convertPixelToTile(x, y + 26)
	local layer = map.layers["tiles"]
	local has_tile = layer.data[math.floor(tile_y)] and layer.data[math.floor(tile_y)][math.floor(tile_x)]
	return has_tile
end

function PlayerControls:update(dt)
	for _, entity in ipairs(self.pool) do
		local player_input = entity.player_controlled.input
		player_input:update()

		local movement_speed = 300

		local input_x, input_y = player_input:get("move")
		--local on_ground = entity.player_controlled.on_ground
		local on_ground = positionOnGround(entity.position.x, entity.position.y + 20, self.map:get(1).map.loaded_map)

		local body = entity.physics_object.body
		local control_multiply = 1
		if not on_ground then
			control_multiply = 0.1
		end
		body:applyForce(input_x * movement_speed * control_multiply, input_y * movement_speed * control_multiply)

		local shape = body:getShape()

		if player_input:down "hold" and on_ground then
			shape:setFriction(1.0)
			body:setAngularVelocity(0)
			body:setAngularDamping(10000.0)
			body:setLinearVelocity(0, 0)
			body:setMass(3.2)
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
