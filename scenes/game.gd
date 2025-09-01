extends Control

var count: int = 0 : set = set_count
var energy: int = 20 : set = set_energy

func woosh() -> void:
	$Whoosh.play(0.07)

func whoosh() -> void: # In case i spell it differently next time.
	woosh()
	
func set_count(value):
	count = value
	$Counter.text = str(count)

func set_energy(value):
	energy = value
	$HBoxContainer/MarginContainer/Energy.text = str(value)
	if energy == 0:
		var image: CompressedTexture2D = load("res://images/trump.png")
		Globals.send_dialog(["You ran out of energy! Buy more with SSS!", "This is all I have for now....... More is to come."], image)

func _ready() -> void:
	$HBoxContainer/MarginContainer/Energy.text = str(energy)
	
	$Click.gui_input.connect(func (event):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if energy <= 0:
				return
			self.woosh()
			count += 1
			energy -= 1
	)
