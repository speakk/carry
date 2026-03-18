local DrawSystem = Concord.system({
	pool = {"position", "drawable"},
	camera_follow = { "player_controlled" },
	map = { "map" }
})

local function damp(a, b, lambda, dt)
	return math.lerp(a, b, 1 - math.exp(-lambda * dt))
end

local previous_camera_x, previous_camera_y = 0, 0
local cameraX, cameraY = 0, 0
local camera_zoom = 1
local max_zoom = 2.0
local min_zoom = 1.0

function DrawSystem:init()
	self.pool.onAdded = function(_, e)
		if e.drawable.sprite then
			e.drawable.loaded_sprite = love.graphics.newImage("assets/sprites/" .. e.drawable.sprite)
		end
	end
end

function DrawSystem:update(dt)
	--local window_width, window_height = love.graphics.getDimensions()

	local cam_speed = 3
	local player_entity = self.camera_follow:get(1)
	if player_entity then
		local player_position = player_entity.position
		cameraX, cameraY = damp(previous_camera_x, player_position.x, cam_speed, dt),
		damp(previous_camera_y, player_position.y, cam_speed, dt)

		local camera_move_amount = vec2(cameraX, cameraY):distance(vec2(previous_camera_x, previous_camera_y))
		local camera_zoom_speed_multiplier = 0.03
		camera_zoom = math.clamp(max_zoom - camera_move_amount * camera_zoom_speed_multiplier, min_zoom, max_zoom)
		previous_camera_x, previous_camera_y = cameraX, cameraY
	end
end

function DrawSystem:draw()
	--local camera_zoom = 2.3
	love.graphics.clear(0.20, 0.14, 0.1, 1)
	love.graphics.push()
	local window_width, window_height = love.graphics.getDimensions()
	local final_camera_x = -cameraX + window_width / 2 / camera_zoom
	local final_camera_y = -cameraY + window_height / 2 / camera_zoom
	love.graphics.scale(camera_zoom, camera_zoom)
	love.graphics.translate(final_camera_x, final_camera_y)

	for _, e in ipairs(self.pool) do
		if e.drawable.sprite then
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.draw(e.drawable.loaded_sprite, e.position.x, e.position.y)
		else
			love.graphics.setColor(1, 1, 1, 1)

			if e:has("player_controlled") then
				love.graphics.setColor(1, 0.5, 0.5, 1)
			end
			love.graphics.circle("fill", e.position.x, e.position.y, 10)
		end
	end
	-- Player draw end
	
	-- Map draw
	love.graphics.setColor(1, 1, 1, 1)
	for _, entity in ipairs(self.map) do
		entity.map.loaded_map:drawTileLayer("tiles")
		--entity.map.loaded_map:draw(-cameraX, -cameraY, camera_zoom, camera_zoom)
		--entity.map.loaded_map:draw(final_camera_x, final_camera_y)
		--entity.map.loaded_map:box2d_draw()
	end
	-- Map draw end



-- 	if ll then love.graphics.setColor(0, 1, 1, 1) else love.graphics.setColor(1,0,0,1) end
-- 	love.graphics.circle("fill", lx * 32, ly * 32, 4)
-- 	if aa then love.graphics.setColor(0, 1, 1, 1) else love.graphics.setColor(1,0,0,1) end
-- 	love.graphics.circle("fill", ax * 32, ay * 32, 4)
-- 	if bb then love.graphics.setColor(0, 1, 1, 1) else love.graphics.setColor(1,0,0,1) end
-- 	love.graphics.circle("fill", bx * 32, by * 32, 4)
-- 	if rr then love.graphics.setColor(0, 1, 1, 1) else love.graphics.setColor(1,0,0,1) end
-- 	love.graphics.circle("fill", rx * 32, ry * 32, 4)

	love.graphics.pop()
end

return DrawSystem
