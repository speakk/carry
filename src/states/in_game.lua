local in_game = {}

function in_game:enter(state)	
	print("Initializing world")	
	self.world = Concord.world()

	self.world:addSystems(
		Systems.draw_system,
		Systems.physics
	)

	local player = Concord.entity(self.world)
		:give("position", 100, 100)
		:give("drawable")
		:give("physics_object")
end

function in_game:update(dt)
	self.world:emit("update", dt)
end

function in_game:draw()
	self.world:emit("draw")
end

return in_game
