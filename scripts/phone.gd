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
	var buy_button = $Panel/Buy
	var open_button = $Panel/Open
	$PanelContainer.mouse_filter = Control.MOUSE_FILTER_IGNORE

	buy_button.connect("gui_input", func (event):
		if event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			Globals.debt += 5
			buy_button.hide()
			$Panel/Downloads.show()
			$Panel/ProgressBar.show()
			var tween = create_tween()
			tween.set_ease(Tween.EASE_IN_OUT)
			tween.set_trans(Tween.TRANS_EXPO)
			tween.tween_property($Panel/ProgressBar, "value", 100, 5)
			await tween.finished
			$Panel/Downloads.hide()
			$Panel/ProgressBar.hide()
			$Panel/Open.show()
	)

	open_button.connect("gui_input", func (event):
		if event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("opened")
			Globals.bought_game_state = true
	)

	button_animation(buy_button)
