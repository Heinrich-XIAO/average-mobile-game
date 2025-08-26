extends Control

func button_animation(button: Button):
	var tween = create_tween()
	button.pivot_offset = button.size / 2
	for i in range(10000):
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_SINE)
		tween.tween_property(button, "scale", Vector2.ONE * 1.05, 0.5)
		tween.tween_property(button, "scale", Vector2.ONE, 0.5)
		

func _ready():
	var buy_button = $Panel/Button
	$PanelContainer.mouse_filter = Control.MOUSE_FILTER_IGNORE

	buy_button.connect("gui_input", func (event):
		if event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			Globals.debt += 5
			buy_button.hide()
			$Panel/Downloads.show()
	)
	button_animation(buy_button)
