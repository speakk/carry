Concord.component("position", function(self, x, y)
    self.x = x or 0
    self.y = y or 0
end)

Concord.component("drawable")

Concord.component("physics_object", function(self, shape)
	self.shape = shape
end)

Concord.component("physics_world", function(self, physics_world)
	self.physics_world = physics_world
end)

Concord.component("map", function(self, name)
	self.name = name
	self.loaded_map = nil
end)

Concord.component("player_controlled")
