local RopedTo = Concord.system({
	pool = {"roped_to", "physics_object"},
})

function RopedTo:init()
	self.pool.onAdded = function(_, entity)
		local roped_to = entity.roped_to
		local target_entity = roped_to.rope_target_entity
		local x1, y1 = entity.position.x, entity.position.y
		local x2, y2 = target_entity.position.x, target_entity.position.y
		local max_length = vec2(x1, y1):distance(vec2(x2, y2))
		local collide_connected = false
		local joint = love.physics.newRopeJoint(entity.physics_object.body, target_entity.physics_object.body, x1, y1, x2, y2, max_length, collide_connected)
		roped_to.joint = joint
	end
end

return RopedTo
