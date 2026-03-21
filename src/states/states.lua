local in_game = require("src.states.in_game")
local main_menu = require("src.states.main_menu")

local states_table = {
	in_game = in_game,
	main_menu = main_menu
}

local states = state_machine(states_table, "main_menu")

return states
