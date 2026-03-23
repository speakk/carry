local Sound = Concord.system({})

local music = love.audio.newSource("assets/sounds/speak-counter_a.mp3", "static")

local collect_sound = love.audio.newSource("assets/sounds/collect1.ogg", "static")

local hit_sounds = {
	love.audio.newSource("assets/sounds/hit1.ogg", "static"),
	love.audio.newSource("assets/sounds/hit2.ogg", "static")
}

local clink = love.audio.newSource("assets/sounds/clink1.ogg", "static")

function Sound:init()
	-- TODO: Do this on in-game start event (which doesn't exist yet)
	music:setVolume(0.14)
	music:play()
end

function Sound:update(_)
	if not music:isPlaying() then
		music:play()
	end
end

function Sound:player_collided_with_player(player_shape_a, player_shape_b)
	local vel_x, vel_y = player_shape_a:getBody():getLinearVelocity()
	local speed = vec2(vel_x, vel_y):length()
	local volume = math.clamp(speed * 0.001, 0.2, 1.0)
	clink:setVolume(volume)
	clink:setPitch(0.9 + love.math.random() * 0.2)
	clink:play()
end

function Sound:player_collided_with_map(player_shape, _, _)
	local vel_x, vel_y = player_shape:getBody():getLinearVelocity()
	local speed = vec2(vel_x, vel_y):length()
	local hit_sound = table.pick_random(hit_sounds)
	local volume = math.clamp(speed * 0.001, 0.2, 1.0)
	hit_sound:setVolume(volume)
	hit_sound:play()
end

function Sound:collectable_collected(_, _)
	collect_sound:play()
end

return Sound

