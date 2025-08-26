extends Control


func _debt_changed(value):
	$HBoxContainer/Label.text = str(value) + " SSS"
	$AudioStreamPlayer.play()

func _ready():
	Globals.connect("debt_changed", self._debt_changed)
	var dialog = $Dialog
	var image: CompressedTexture2D = load("res://images/shiba_bank.png")
	await dialog.send_multiple_dialogs(["Thank you for opening your credit card with Shiba bank.",\
	"Just, don't rack up too much debt."], image, func ():
		$Phone.show()
		var tween = create_tween()
		var center_pos = get_viewport_rect().size / 2
		center_pos -= $Phone.size/2
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property($Phone, "position", center_pos, 1.0)
	)
	$HBoxContainer.show()
