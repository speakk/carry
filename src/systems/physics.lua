local PhysicsSystem = Concord.system({
	pool = {"position", "physics_object"},
	physics_world = {"physics_world"},
	player_pool = {"player_controlled", "physics_object"}
})

local function isPlayer(shape)
	local userData = shape:getUserData()
	return userData and userData.is_player
end

local function isCollectable(shape)
	local userData = shape:getUserData()
	return userData and userData.is_collectable
end

local function isMap(shape)
	return shape:getType() == "polygon"
end


-- TODO: Unused for now because we have positionOnGround in player_oontrols
local function beginContact(world, a, b, coll)
	if isPlayer(a) and isCollectable(b) then
		world:emit("collectable_collected", a:getUserData().entity, b:getUserData().entity)
	end

	if isPlayer(b) and isCollectable(a) then
		world:emit("collectable_collected", b:getUserData().entity, a:getUserData().entity)
	end
end

local function endContact(world, a, b, coll)
end

local function preSolve(a, b, coll)

end

local function postSolve(a, b, coll, normalimpulse, tangentimpulse)

end


function PhysicsSystem:init()
	love.physics.setMeter(32) -- 32px
	--create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81

	local physics_world = love.physics.newWorld(0, 9.81*64, true)
	physics_world:setCallbacks(
		function(a, b, coll)
			beginContact(self:getWorld(), a, b, coll)
		end,
		function(a, b, coll)
			endContact(self:getWorld(), a, b, coll)
		end, preSolve, postSolve)

	Concord.entity(self:getWorld())
	:give("physics_world", physics_world)

	self.pool.onAdded = function(_, entity)
		local physics_commponent = entity.physics_object
		local properties = physics_commponent.properties or {}

		local position = entity.position
		local type = properties.type or "dynamic"
		local radius = 10
		physics_commponent.body = love.physics.newCircleBody(physics_world, type, position.x, position.y, radius)
		physics_commponent.body:getShape():setRestitution(0.0)

		physics_commponent.body:getShape():setUserData(properties.userData)

		if properties.sensor then
			physics_commponent.body:getShape():setSensor(true)
		end

		physics_commponent.body:setMass(properties.mass or 0.2)
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
