local PhysicsSystem = Concord.system({
	pool = {"position", "physics_object"}
})

function PhysicsSystem:init()
	love.physics.setMeter(64) -- 64px
	--create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
	self.physics_world = love.physics.newWorld(0, 9.81*64, true)

	print("Are we init")
	self.pool.onAdded = function(_, entity)
		print("Added to pool")
		local physics_commponent = entity.physics_object
		local position = entity.position
		local type = "dynamic"
		local radius = 10
		physics_commponent.body = love.physics.newCircleBody(self.physics_world, type, position.x, position.y, radius)
	end
end

function PhysicsSystem:update(dt)
	self.physics_world:update(dt)

	for _, entity in ipairs(self.pool) do
		local position = entity.position
		local physics_object = entity.physics_object
		local physics_x, physics_y = physics_object.body:getPosition()

		position.x = physics_x
		position.y = physics_y
	end
end

return PhysicsSystem
