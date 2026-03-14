local DrawSystem = Concord.system({
	pool = {"position", "drawable"}
})

function DrawSystem:draw()
	for _, e in ipairs(self.pool) do
		love.graphics.setColor(1, 1, 1, 1)

		if e:has("player_controlled") then
			love.graphics.setColor(1, 0.5, 0.5, 1)
		end
		love.graphics.circle("fill", e.position.x, e.position.y, 5)
	end
end

return DrawSystem
