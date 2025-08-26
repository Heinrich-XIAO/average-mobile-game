extends Node

signal debt_changed(newvalue)
var debt: int = 0 : set = set_debt

func set_debt(value):
	debt = value
	emit_signal("debt_changed", value)
