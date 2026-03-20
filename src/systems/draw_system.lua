local moonshine = require 'libs.moonshine'

local background = love.graphics.newImage("assets/backgrounds/mountains.png")
background:setWrap("mirroredrepeat")

local function create_bg_quad(window_w, window_h)
	local window_w, window_h = love.graphics.getDimensions()
	local image_w, image_h = background:getWidth(), background:getHeight()
	local sx = 4
	local sy = sx * window_h / window_w
	--return love.graphics.newQuad(0, 0, window_w, window_h, background)
	return love.graphics.newQuad(0, 0, sx * image_w, sy * image_h, image_w, image_h)
end

local window_w, window_h = love.graphics.getDimensions()
local bg_quad = create_bg_quad(window_w, window_h)

function create_effect(width, height)
	local new_effect = moonshine(width, height, moonshine.effects.filmgrain)
		.chain(moonshine.effects.glow)
		.chain(moonshine.effects.vignette)
		--.chain(moonshine.effects.crt)
	new_effect.filmgrain.size = 1
	new_effect.filmgrain.opacity = 0.4
	new_effect.vignette.opacity = 0.05
	--new_effect.crt.distortionFactor = { 1.01, 1.01 }
	new_effect.glow.min_luma = 0.67
	new_effect.glow.strength = 1

	return new_effect
end


local effect = create_effect(600, 600)

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
		if vec2(cameraX, cameraY):distance(vec2(player_position.x, player_position.y)) < 500 then
			cameraX, cameraY = damp(previous_camera_x, player_position.x, cam_speed, dt),
			damp(previous_camera_y, player_position.y, cam_speed, dt)
		else
			cameraX, cameraY = player_position.x, player_position.y
		end

		local camera_move_amount = vec2(cameraX, cameraY):distance(vec2(previous_camera_x, previous_camera_y))
		local camera_zoom_speed_multiplier = 0.03
		camera_zoom = math.clamp(max_zoom - camera_move_amount * camera_zoom_speed_multiplier, min_zoom, max_zoom)
		previous_camera_x, previous_camera_y = cameraX, cameraY
	end
end

function DrawSystem:draw()
	local window_width, window_height = love.graphics.getDimensions()
	local final_camera_x = -cameraX + window_width / 2 / camera_zoom
	local final_camera_y = -cameraY + window_height / 2 / camera_zoom

	effect(function()
		--local camera_zoom = 2.3
		love.graphics.clear(0.20, 0.14, 0.1, 1)

		love.graphics.push()
		local quad_scale = 0.94
		love.graphics.scale(quad_scale, quad_scale)
		--love.graphics.translate(final_camera_x, final_camera_y)
		love.graphics.setColor(0.7, 0.7, 0.7, 1.0)
		local player_pos = self.pool:get(1).position
		local h_offset = 1200 -- Should be map height
		local w_offset = 500 -- Dont even know, just manual
		--love.graphics.draw(background, player_pos.x * 0.05 + w_offset, -player_pos.y * 0.2 + h_offset, 0, 1, 1, background:getWidth() / 2, background:getHeight() / 2)

		bg_quad:setViewport(player_pos.x * 0.05, -player_pos.y * 0.02 + h_offset, window_width / quad_scale, window_height / quad_scale)
		--love.graphics.draw(background, bg_quad, 0, 0, 0, 0.6, 0.6)
		love.graphics.draw(background, bg_quad)
		love.graphics.pop()
		love.graphics.setColor(1, 1, 1, 1)

		--love.graphics.clear(0.20, 0.14, 0.1, 0.2)

		love.graphics.push()
		love.graphics.scale(camera_zoom, camera_zoom)
		love.graphics.translate(final_camera_x, final_camera_y)

		for _, e in ipairs(self.pool) do
			local final_x = e.position.x
			local final_y = e.position.y

			if e.drawable.offset then
				final_x = final_x + e.drawable.offset.x
				final_y = final_y + e.drawable.offset.y
			end

			if e.drawable.sprite then
				love.graphics.setColor(1, 1, 1, 1)
				love.graphics.draw(e.drawable.loaded_sprite, final_x, final_y,
				0, 1, 1, e.drawable.loaded_sprite:getWidth() / 2, e.drawable.loaded_sprite:getHeight() / 2)
			end
			if e.circle then
				love.graphics.setColor(1, 1, 1, 1)

				if e:has("player_controlled") then
					love.graphics.setColor(1, 0.5, 0.5, 1)
				end
				love.graphics.circle("fill", final_x, final_y, 10)
			end
			if e.particle_emitter then
				love.graphics.draw(e.particle_emitter.system, final_x, final_y)
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



		-- if ll then love.graphics.setColor(0, 1, 1, 1) else love.graphics.setColor(1,0,0,1) end
		-- love.graphics.circle("fill", lx * 32, ly * 32, 4)
		-- -- if aa then love.graphics.setColor(0, 1, 1, 1) else love.graphics.setColor(1,0,0,1) end
		-- -- love.graphics.circle("fill", ax * 32, ay * 32, 4)
		-- if bb then love.graphics.setColor(0, 1, 1, 1) else love.graphics.setColor(1,0,0,1) end
		-- love.graphics.circle("fill", bx * 32, by * 32, 4)
		-- if rr then love.graphics.setColor(0, 1, 1, 1) else love.graphics.setColor(1,0,0,1) end
		-- love.graphics.circle("fill", rx * 32, ry * 32, 4)

		love.graphics.pop()
	end)
end

function DrawSystem:resize(w, h)
	effect = create_effect(w, h)
	bg_quad = create_bg_quad(w, h)
end

return DrawSystem
