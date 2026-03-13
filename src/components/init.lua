Concord.component("position", function(self, x, y)
    self.x = x or 0
    self.y = y or 0
end)

Concord.component("drawable")

Concord.component("physics_object", function(self, shape)
	self.shape = shape
end)
