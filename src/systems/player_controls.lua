local create_new_input = require 'src.input'

local PlayerControls = Concord.system({
	pool = {"position", "physics_object", "player_controlled"},
	player_controllables = {"player_controllable"},
	map = { "map" }
})

function PlayerControls:init()
	self.pool.onAdded = function(_, entity)
		entity.player_controlled.input = create_new_input()
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
	local has_tile = layer.data[math.floor(tile_y)] and layer.data[math.floor(tile_y)][math.floor(tile_x+1)]
	return has_tile
end


-- GRAB DEBUG
lx,ly = 0, 0
ax,ay = 0, 0
bx,by = 0, 0
rx,ry = 0, 0
ll,aa,bb,rr = false, false, false, false

local function nextToSolidTile(x, y, map, grab_distance)
	local grab_distance = 14
	local left_tile_x, left_tile_y = map:convertPixelToTile(x - grab_distance, y)
	local above_tile_x, above_tile_y = map:convertPixelToTile(x, y - grab_distance)
	local below_tile_x, below_tile_y = map:convertPixelToTile(x, y + grab_distance)
	local right_tile_x, right_tile_y = map:convertPixelToTile(x + grab_distance, y)

	lx, ly = left_tile_x, left_tile_y
	ax, ay = above_tile_x, above_tile_y
	bx, by = below_tile_x, below_tile_y
	rx, ry = right_tile_x, right_tile_y

	local layer = map.layers["tiles"]
	local left = layer.data[math.ceil(left_tile_y)] and layer.data[math.ceil(left_tile_y)][math.ceil(left_tile_x)]
	local above = layer.data[math.ceil(above_tile_y)] and layer.data[math.ceil(above_tile_y)][math.floor(above_tile_x+1)]
	local below = layer.data[math.ceil(below_tile_y)] and layer.data[math.ceil(below_tile_y)][math.floor(below_tile_x+1)]
	local right = layer.data[math.round(right_tile_y)] and layer.data[math.round(right_tile_y)][math.floor(right_tile_x+1)]

	ll,aa,bb,rr = left, above, below, right

	return below or above or left or right
end

function PlayerControls:update(dt)
	local loaded_map = self.map:get(1).map.loaded_map

	local should_jump = false

	for _, entity in ipairs(self.pool) do
		local player_input = entity.player_controlled.input
		player_input:update()

		local movement_speed = 300

		local input_x, input_y = player_input:get("move")
		--local on_ground = entity.player_controlled.on_ground
		local on_ground = positionOnGround(entity.position.x, entity.position.y + 20, loaded_map)

		local body = entity.physics_object.body
		local control_multiply = 1
		if not on_ground then
			control_multiply = 0.5
		end
		body:applyForce(input_x * movement_speed * control_multiply, input_y * movement_speed * control_multiply)

		local shape = body:getShape()

		local hold_radius = 14

		if player_input:down "hold" and nextToSolidTile(entity.position.x, entity.position.y, loaded_map, hold_radius) then
			shape:setFriction(1.0)
			body:setAngularVelocity(0)
			body:setAngularDamping(10000.0)
			body:setLinearVelocity(0, 0)
			--body:setMass(3.2)
		end

		if player_input:released "hold" then
			shape:setFriction(0.1)
			body:setAngularDamping(0.1)
			--body:setMass(0.2)
		end

		local jump_enabled_radius = 18

		if player_input:pressed "jump" and nextToSolidTile(entity.position.x, entity.position.y, loaded_map, jump_enabled_radius) then
			should_jump = true
			-- Apply jump for all player balls
		end

		-- if player_input:pressed "switch" then
		-- 	for _, other_entity in ipairs(self.player_controllables) do
		-- 		if other_entity:has("player_controlled") then
		-- 			other_entity:remove("player_controlled")
		-- 		else
		-- 			other_entity:give("player_controlled")
		-- 		end
		-- 	end
		-- end
	end

	if should_jump then
		for _, player in ipairs(self.pool) do
			local player_body = player.physics_object.body
			player_body:applyLinearImpulse(0, -80)
		end
	end
end

return PlayerControls
