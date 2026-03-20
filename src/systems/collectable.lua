local CollectableSystem = Concord.system({})

function CollectableSystem:player_collided_with_collectable(player_entity, collectable_entity)
	print("Collected")
	self:getWorld():emit("collectable_collected", player_entity, collectable_entity)
	collectable_entity:destroy()
end

return CollectableSystem

