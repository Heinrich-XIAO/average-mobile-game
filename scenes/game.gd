extends Control

func woosh() -> void:
	$Whoosh.play(0.07)

func whoosh() -> void: # In case i spell it differently next time.
	woosh()

func _ready() -> void:
	$Start.gui_input.connect(func (event):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			self.woosh()
	)
