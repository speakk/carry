local CollectableSystem = Concord.system({
	pool = { "collectable" }
})

function CollectableSystem:player_collided_with_collectable(player_entity, collectable_entity)
	print("Collected")
	self:getWorld():emit("collectable_collected", player_entity, collectable_entity)
	collectable_entity:destroy()
end

function CollectableSystem:collectable_collected(player_entity, collectable_entity)
	print(self.pool.size)
	if self.pool.size == 0 or (self.pool.size == 1 and self.pool:get(1) == collectable_entity) then
		print("All collected")
		self:getWorld():emit("all_collectables_collected")
	end
end

return CollectableSystem

