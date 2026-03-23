local baton = require 'libs.baton.baton'

return function()
	return baton.new {
		controls = {
			left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
			right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
			up = {'key:up'},
			down = {'key:down'},
			action = {'key:x', 'button:a'},
			hold = {'key:lshift', 'key:x'},
			jump = {'key:space', 'key:z'},
		},
		pairs = {
			move = {'left', 'right', 'up', 'down'}
		},
		joystick = love.joystick.getJoysticks()[1],
	}
end
