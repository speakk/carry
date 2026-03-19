local ParticleSystem = Concord.system({
	pool = { "position", "particle_emitter", "drawable" }
})

local particle_img = love.graphics.newImage("assets/sprites/particle.png")

function ParticleSystem:init()
	self.pool.onAdded = function(_, entity)
		local particle_system = love.graphics.newParticleSystem(particle_img, 100)
		particle_system:setParticleLifetime(2, 5) -- Particles live at least 2s and at most 5s.
		particle_system:setEmissionRate(5)
		particle_system:setSizeVariation(1)
		particle_system:setLinearAcceleration(-20, -20, 20, 20) -- Random movement in all directions.
		particle_system:setColors(1, 1, 1, 1, 1, 1, 1, 0) -- Fade to transparency.

		entity.particle_emitter.system = particle_system
	end
end

return ParticleSystem
