local ParticleSystem = Concord.system({
	pool = { "position", "particle_emitter", "drawable" }
})

local particle_img = love.graphics.newImage("assets/sprites/particle.png")

local particle_system_creators = {
	["collectable"] = function()
		local particle_system = love.graphics.newParticleSystem(particle_img, 100)
		particle_system:setParticleLifetime(2, 5) -- Particles live at least 2s and at most 5s.
		particle_system:setEmissionRate(5)
		particle_system:setSizeVariation(1)
		particle_system:setLinearAcceleration(-20, -20, 20, 20) -- Random movement in all directions.
		particle_system:setColors(1, 1, 1, 1, 1, 1, 1, 0) -- Fade to transparency.
		return particle_system
	end
}

function ParticleSystem:init()
	self.pool.onAdded = function(_, entity)
		local type = entity.particle_emitter.type or "collectable"
		entity.particle_emitter.system = particle_system_creators[type]()
	end
end

function ParticleSystem:update(dt)
	for _, entity in ipairs(self.pool) do
		entity.particle_emitter.system:update(dt)
	end
end

return ParticleSystem
