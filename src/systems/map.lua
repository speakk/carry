local sti = require 'libs.sti'

local MapSystem = Concord.system({
	pool = {"position", "map"},
	physics_world = {"physics_world"}
})

function MapSystem:init()
	self.pool.onAdded = function(_, entity)
		local map = entity.map
		map.loaded_map = sti("assets/maps/" .. map.name .. ".lua", { "box2d" })

		local physics_world_entity = self.physics_world:get(1)
		assert(physics_world_entity, "No physics world initialized when trying to initialize map")

		map.loaded_map:box2d_init(physics_world_entity.physics_world.physics_world)

		for _, player_spawn_object in ipairs(map.loaded_map.layers["player_spawn"].objects) do
			self:getWorld():emit("player_spawn_object_created", player_spawn_object)
			print("Created player spawn object")
		end

		for _, collectable_object in ipairs(map.loaded_map.layers["collectables"].objects) do
			self:getWorld():emit("collectable_object_created", collectable_object)
		end
	end
end

function MapSystem:player_spawn_object_created(player_spawn_object)
	local x, y = player_spawn_object.x, player_spawn_object.y

	local player_ball_1 = Concord.entity(self:getWorld())
		:give("position", x, y)
		:give("drawable")
		:give("circle")
		:give("player_controlled")
		:give("player_controllable")

	player_ball_1:give("physics_object", { userData = { is_player = true, entity = player_ball_1 } })

	local player_ball_2 = Concord.entity(self:getWorld())
		:give("position", x + 80, y)
		:give("drawable")
		:give("circle")
		:give("roped_to", player_ball_1)
		:give("player_controlled")
		:give("player_controllable")

	player_ball_2:give("physics_object", { userData = { is_player = true, entity = player_ball_2 } })
end

function MapSystem:collectable_object_created(collectable_object)
	local x, y = collectable_object.x, collectable_object.y

	local collectable = Concord.entity(self:getWorld())
		:give("position", x, y)
		:give("drawable", {
			sprite = "collectable.png"
		})
	
	collectable:give("physics_object", { userData = { is_collectable = true, entity = collectable }, type = "static", sensor = true })
end

function MapSystem:update(dt)
	for _, entity in ipairs(self.pool) do
		entity.map.loaded_map:update(dt)
	end
end

function MapSystem:resize(w, h)
	for _, entity in ipairs(self.pool) do
		entity.map.loaded_map:resize(w, h)
	end
end

return MapSystem
