local DrawSystem = Concord.system({
	pool = {"position", "drawable"},
	camera_follow = { "player_controlled" },
	map = { "map" }
})

function DrawSystem:draw()
	local window_width, window_height = love.graphics.getDimensions()

	local player_position = self.camera_follow:get(1).position
	local cameraX, cameraY = player_position.x - window_width / 2, player_position.y - window_height / 2

	love.graphics.push()
	love.graphics.translate(-cameraX, -cameraY)

	-- Map draw
	love.graphics.setColor(1, 1, 1, 1)
	for _, entity in ipairs(self.map) do
		entity.map.loaded_map:draw(-cameraX, -cameraY)
		--entity.map.loaded_map:box2d_draw()
	end
	-- Map draw end

	-- Players draw
	for _, e in ipairs(self.pool) do
		love.graphics.setColor(1, 1, 1, 1)

		if e:has("player_controlled") then
			love.graphics.setColor(1, 0.5, 0.5, 1)
		end
		love.graphics.circle("fill", e.position.x, e.position.y, 10)
	end
	-- Player draw end

	love.graphics.pop()
end

return DrawSystem
