extends Control


func _debt_increased(value):
	$HBoxContainer/Label.text = str(value) + " $$$"
	$Dialog/Chaching.play()

func _debt_changed(value):
	$HBoxContainer/Label.text = str(value) + " $$$"

func _debt_limit_changed(value):
	$"HBoxContainer/Limit and Debt".text = "Card Limit: %s $$$  Debt:" % str(value)

func _game_starts():
	$Intro.hide()
	$Game.show()
	$Game.shown()
	$Game/Background.play()

func _ready():
	Globals.connect("debt_increased", self._debt_increased)
	Globals.connect("debt_changed", self._debt_changed)
	Globals.connect("debt_limit_changed", self._debt_limit_changed)
	Globals.connect("bought_game", self._game_starts)
	
	$HBoxContainer.hide()
	
	
	var dialog = $Dialog
	var image: CompressedTexture2D = load("res://images/shiba_bank.png")
	await dialog.send_multiple_dialogs(["Thank you for opening your \ncredit card with Shiba bank.",\
	"Just, don't rack up too much debt."], image, func ():
		$Intro.show()
		var tween = create_tween()
		var center_pos = get_viewport_rect().size / 2
		center_pos -= $Intro.size/2
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property($Intro, "position", center_pos, 1.0)
		$HBoxContainer.show()
	)
