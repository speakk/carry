local sti = require 'libs.sti'

local TILE_SIZE = 32

local grasses = {
	"grass01.png",
	"grass02.png",
	"grass03.png",
	"grass04.png",
}

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

		self:generate_grass(map.loaded_map)
	end
end

function MapSystem:generate_grass(loaded_map)
	local tile_layer = loaded_map.layers["tiles"]
	local layer_data = tile_layer.data
	for y = 1,tile_layer.height+1 do
	--print("length x", (#layer_data[y]))
		for x = 1,tile_layer.width+1 do
			local final_x = x-1
			local final_y = y-1
			if layer_data[final_y] and layer_data[final_y][final_x] then
				if not layer_data[final_y-1] or not layer_data[final_y-1][final_x] then
					if love.math.random() > 0.5 then
						Concord.entity(self:getWorld())
							:give("position", (final_x) * TILE_SIZE, (final_y-2) * TILE_SIZE)
							:give("drawable", {
								sprite = table.pick_random(grasses),
								offset = { x = -16, y = 16 } }
							)
					end
				end
			end
		end
	end
end

function MapSystem:player_spawn_object_created(player_spawn_object)
	local x, y = player_spawn_object.x, player_spawn_object.y

	local player_ball_1 = Concord.entity(self:getWorld())
		:give("position", x, y)
		:give("drawable", { sprite = "player_ball.png" })
		:give("player_controlled")
		:give("player_controllable")

	player_ball_1:give("physics_object", { userData = { is_player = true, entity = player_ball_1 } })

	local player_ball_2 = Concord.entity(self:getWorld())
		:give("position", x + 80, y)
		:give("drawable", { sprite = "player_ball.png" })
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
		:give("particle_emitter")
	
	collectable:give("physics_object", { userData = { is_collectable = true, entity = collectable }, type = "static", sensor = true, radius = 20 })
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
