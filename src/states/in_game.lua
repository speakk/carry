local in_game = {}

function in_game:enter(_)
	print("Initializing world")
	self.world = Concord.world()

	self.world:addSystems(
		Systems.draw_system,
		Systems.physics,
		Systems.map,
		Systems.player_controls,
		Systems.roped_to
	)

	local player = Concord.entity(self.world)
		:give("position", 200, 100)
		:give("drawable")
		:give("physics_object")
		:give("player_controlled")
		:give("player_controllable")

	Concord.entity(self.world)
		:give("position", 200, 200)
		:give("drawable")
		:give("physics_object")
		:give("roped_to", player)
		:give("player_controlled")
		:give("player_controllable")

	Concord.entity(self.world)
		:give("map", "map01")
		:give("position", 0, 0)
end

function in_game:update(dt)
	self.world:emit("update", dt)
end

function in_game:draw()
	self.world:emit("draw")
end

function in_game:resize(w, h)
	self.world:emit("resize", w, h)
end

return in_game
