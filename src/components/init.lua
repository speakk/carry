Concord.component("position", function(self, x, y)
    self.x = x or 0
    self.y = y or 0
end)

Concord.component("drawable", function(self, properties)
	if properties then
		self.sprite = properties.sprite
	end
end)

Concord.component("circle")
Concord.component("particle_emitter")

Concord.component("physics_object", function(self, properties)
	self.properties = properties
	self.userData = properties.userData
end)

Concord.component("physics_world", function(self, physics_world)
	self.physics_world = physics_world
end)

Concord.component("map", function(self, name)
	self.name = name
	self.loaded_map = nil
end)

-- Currently under player control
Concord.component("player_controlled", function(self)
	self.on_ground = false
end)

-- Can be controlled by a player when activated
Concord.component("player_controllable")

Concord.component("collectable")

Concord.component("roped_to", function(self, rope_target_entity)
	self.rope_target_entity = rope_target_entity
end)
