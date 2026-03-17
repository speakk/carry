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
		print("Map loaded")
	end
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
