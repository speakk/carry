local in_game = require("src.states.in_game")

local states_table = {
	in_game = in_game
}

local states = state_machine(states_table, "in_game")

return states
