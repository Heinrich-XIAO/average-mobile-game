extends Node

signal debt_changed(newvalue)
var debt: int = 0 : set = set_debt

signal bought_game()
var bought_game_state: bool = false : set = set_bought_game_state

func set_debt(value):
	debt = value
	emit_signal("debt_changed", value)

func set_bought_game_state(value):
	bought_game_state = value
	if value:
		emit_signal("bought_game")
