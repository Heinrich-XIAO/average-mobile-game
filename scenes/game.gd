extends Control

var count: float = 0 : set = set_count
var energy: int = 5 : set = set_energy

var total_cps: float = 0 : set = set_total_cps
var start_time: float = 30
var time: float = start_time

var level_number: int = 0

var won: bool = false

var previous_loot: String = ""

@onready var trump : CompressedTexture2D = load("res://images/trump.png")
@onready var shiba_bank : CompressedTexture2D = load("res://images/shiba_bank.png")
@onready var loot_items := {
	"cursor": {
		"enabled": true,
		"texture": load("res://images/cursor.png"),
		"cps": 1.0,
		"display_name": "cursor",
		"caption": "1 click per second",
		"pre-display": func (): pass,
		"callback": func ():
	total_cps += 1
	loot_items["gamer"]["enabled"] = true
	},
	"gamer": {
		"enabled": false,
		"texture": load("res://images/average_gamer.png"),
		"cps": 10.0,
		"display_name": "gamer kid",
		"caption": "10 clicks per second",
		"pre-display": func (): pass,
		"callback": func (): total_cps += 10
	}
}

var level_data := [
	{
		"debt_limit": 100,
		"click_goal": 100,
		"start_time": 30
	},
	{
		"debt_limit": 150,
		"click_goal": 150, 
		"start_time": 15
	}
]

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
	
	if count >= Globals.click_goal and time > 0:
		$LootboxPopup.hide()
		$Congrats/VBoxContainer/MarginContainer/Label.text = "You got to %s in %s seconds with\n%s$$$ left!" % [str(int(Globals.click_goal)), str(round((start_time-time)*100.0)/100.0), str(Globals.debt_limit - Globals.debt)]
		$Congrats.show()
		Globals.click_goal = INF
		won = true
		$Congrats/OK.text = "Next"

func set_energy(value):
	energy = value
	$HBoxContainer/MarginContainer/Energy.text = str(value)
	if energy == 0:
		Globals.send_sell("You've run out of energy. \nSpend 13 $$$ to get 129 energy. \nClick anywhere to buy.", trump, true, func ():
			if not Globals.inc_debt(13):
				return
			energy += 50
		)

func open_lootbox():
	if not Globals.inc_debt(20):
		return
	
	var enabled_loot := {}

	for key in loot_items:
		var item = loot_items[key]
		if item["enabled"]:
			enabled_loot[key] = item
	
	var keys = enabled_loot.keys()
	var random_key = keys[randi() % keys.size()]
	
	while random_key == previous_loot:
		random_key = keys[randi() % keys.size()]
	
	previous_loot = random_key
	
	var loot_item = enabled_loot[random_key]
	
	
	
	loot_item["pre-display"].call()
	
	$LootboxPopup/Item.texture = loot_item["texture"]
	$LootboxPopup/YouGotALabel.text = "You got a %s!" % [loot_item["display_name"]]
	$LootboxPopup/CPS.text = loot_item["caption"]
	
	$LootboxPopup.show()
	$Lootbox/AnimationPlayer.play("lootbox")
	await $Lootbox/AnimationPlayer.animation_finished
	
	loot_item["callback"].call()

func _process(delta):
	count += delta * total_cps
	
	if self.visible and not $Congrats.visible and time > 0:
		time -= delta
		$stopwatch.text = str(int(time-floor(time/60)*60))\
		+"." + str(int(time*100-floor(time)*100)).pad_zeros(2)
		if time >= 60:
			$stopwatch.text = str(int(time/60)) + ":" + $stopwatch.text
		
		if time <= 0:
			$stopwatch.text = "0.00"
			$Congrats.show()
			$Congrats/VBoxContainer/MarginContainer/Label.text = "You ran out of time."
			won = false
			$Congrats/OK.text = "Retry"
			time = 0

func reset_level(current_level: int):
	var current_level_data = level_data[current_level]
	Globals.debt_limit = current_level_data["debt_limit"]
	
	var prev_click_goal = Globals.click_goal
	print(Globals.click_goal)
	Globals.click_goal = current_level_data["click_goal"]
	start_time = current_level_data["start_time"]
	
	print(prev_click_goal, Globals.click_goal)
	if prev_click_goal != Globals.click_goal:
		Globals.send_dialog(["Your goal is now %s. Click when you are ready." % str(int(Globals.click_goal))], trump, false, func ():
			time = start_time # Setting time to a non-zero value starts the count down
		)
	else:
		time = start_time

func _ready() -> void:
	$HBoxContainer/MarginContainer/Energy.text = str(energy)
	$LootboxPopup.hide()
	$Lootbox.hide()
	$LootboxPopup/TextureRect.custom_minimum_size = Vector2(128,128)
	$LootboxPopup/TextureRect.size = Vector2(128,128)
	$CPS.hide()
	
	$Congrats.hide()
	
	$LootboxPopup/OK.gui_input.connect(func (event):
		if event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			$LootboxPopup.hide()
	)
	
	$Congrats/OK.gui_input.connect(func (event):
		if event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			$Congrats.hide()
			$LootboxPopup.hide()
			count = 0
			energy = 5
			total_cps = 0
			Globals.debt = 0
			
			if won:
				level_number += 1
				
				if level_number == len(level_data):
					Globals.send_dialog(["We saw some suspicious activity on your account, so we'll be closing it."], shiba_bank, false, func ():
						Fade.fade_out(3)
					)
					return
			reset_level(level_number)
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
				Globals.send_dialog(["You got to 15! You just unlocked lootboxes!", "Each lootbox costs 20 $$$", "It's totally not gambling."], trump, true, func ():
					$Lootbox.show()
				)
	)
 
