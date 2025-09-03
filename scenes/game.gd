extends Control

var count: float = 0 : set = set_count
var energy: int = 5 : set = set_energy

var total_cps: float = 0 : set = set_total_cps

@onready var trump : CompressedTexture2D = load("res://images/trump.png")

func set_total_cps(value):
	total_cps = value
	$CPS.text = str(total_cps) + " clicks per second"
	$CPS.show()

func woosh() -> void:
	$Whoosh.play(0.07)

func whoosh() -> void: # In case i spell it differently next time.
	woosh()
	
func set_count(value):
	count = value
	$Counter.text = str(int(floor(count)))

func set_energy(value):
	energy = value
	$HBoxContainer/MarginContainer/Energy.text = str(value)
	if energy == 0:
		Globals.send_sell("You've run out of energy. Spend 13 $$$ to get 129 energy. Click anywhere to buy.", trump, false, func ():
			energy += 129
			Globals.debt += 13
		)


func open_lootbox():
	$LootboxPopup/Item.texture = load("res://images/cursor.png")
	$LootboxPopup/YouGotALabel.text = "You got a cursor!"
	$LootboxPopup/CPS.text = "1 click per second"
	total_cps += 1
	Globals.debt += 20
	$LootboxPopup.show()
	$Lootbox/AnimationPlayer.play("lootbox")

func _process(delta):
	count += delta * total_cps

func _ready() -> void:
	$HBoxContainer/MarginContainer/Energy.text = str(energy)
	$LootboxPopup.hide()
	$Lootbox.hide()
	$LootboxPopup/TextureRect.custom_minimum_size = Vector2(128,128)
	$LootboxPopup/TextureRect.size = Vector2(128,128)
	$CPS.hide()
	
	$LootboxPopup/OK.gui_input.connect(func (event):
		if event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			$LootboxPopup.hide()
	)
	
	$Lootbox.gui_input.connect(func (event):
		if event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			open_lootbox()
	)
	
	$Click.gui_input.connect(func (event):
		if event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if energy <= 0:
				return
			self.woosh()
			count += 1
			energy -= 1
			if count == 15:
				Globals.send_dialog(["You got to 15! You just unlocked lootboxes!", "Each lootbox costs 20 $$$"], trump, false, func ():
					$Lootbox.show()
				)
	)
