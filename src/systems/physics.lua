local PhysicsSystem = Concord.system({
	pool = {"position", "physics_object"},
	physics_world = {"physics_world"}
})

local function beginContact(a, b, coll)

end

local function endContact(a, b, coll)

end

local function preSolve(a, b, coll)

end

local function postSolve(a, b, coll, normalimpulse, tangentimpulse)

end


function PhysicsSystem:init()
	love.physics.setMeter(32) -- 32px
	--create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81

	local physics_world = love.physics.newWorld(0, 9.81*64, true)
	physics_world:setCallbacks(beginContact, endContact, preSolve, postSolve)

	Concord.entity(self:getWorld())
	:give("physics_world", physics_world)

	print("Are we init")
	self.pool.onAdded = function(_, entity)
		print("Added to pool")
		local physics_commponent = entity.physics_object
		local position = entity.position
		local type = "dynamic"
		local radius = 10
		physics_commponent.body = love.physics.newCircleBody(physics_world, type, position.x, position.y, radius)

		local properties = physics_commponent.properties
		if properties then
			if properties.mass then
				physics_commponent.body:setMass(properties.mass)
			end
		end
	end
end

function PhysicsSystem:update(dt)
	for _, entity in ipairs(self.physics_world) do
		entity.physics_world.physics_world:update(dt)
	end

	for _, entity in ipairs(self.pool) do
		local position = entity.position
		local physics_object = entity.physics_object
		local physics_x, physics_y = physics_object.body:getPosition()

		position.x = physics_x
		position.y = physics_y
	end
end

return PhysicsSystem
