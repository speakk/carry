local CollectableSystem = Concord.system({})

function CollectableSystem:collectable_collected(player_entity, collectable_entity)
	print("Collected")
	collectable_entity:destroy()
end

return CollectableSystem

