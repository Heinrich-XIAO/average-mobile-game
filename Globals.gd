extends Node

signal debt_changed(newvalue)
signal debt_increased(newvalue)
var debt: int = 0 : set = set_debt

var total_spent: int = 0

var shader_overlay

signal debt_limit_changed(newvalue)
var debt_limit: int = 100 : set = set_debt_limit
var click_goal: float = 100

signal bought_game()
var bought_game_state: bool = false : set = set_bought_game_state

signal send_dialog_signal(dialog, pfp, callback, skippable)
signal send_sell_signal(dialog, pfp, callback)

func set_debt_limit(value):
	debt_limit = value
	emit_signal("debt_limit_changed", value)

func set_debt(value):
	if debt < value:
		emit_signal("debt_increased", value)
		total_spent += value - debt
	debt = value
	emit_signal("debt_changed", value)

func inc_debt(value):
	if (debt + value) >= debt_limit:
		return false
	debt += value
	return true

func send_dialog(dialog: Array[String], pfp: Texture2D, skippable: bool = true, callable: Callable = func(): pass):
	emit_signal("send_dialog_signal", dialog, pfp, callable, skippable)
	
func send_sell(dialog, pfp, skippable, callback):
	emit_signal("send_sell_signal", dialog, pfp, callback, skippable)

func set_bought_game_state(value):
	bought_game_state = value
	if value:
		emit_signal("bought_game")
