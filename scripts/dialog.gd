extends CanvasLayer

var dialog_image: TextureRect = null
var dialog_label: Label = null
var panel: PanelContainer = null
var is_going_brrr: bool = false
var can_run_next_dialog: bool = false
var is_next_dialog: bool = false
var next_callback: Callable = Callable()
var can_skip: bool = true

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_going_brrr and can_skip:
			is_going_brrr = false
		elif is_next_dialog:
			can_run_next_dialog = true
		else:
			if is_going_brrr and not can_skip:
				return
			close_dialog()
			next_callback.call()
		
func close_dialog():
	panel.hide()
	self.hide()
	$Buy.hide()

func send_dialog(text, pfp):
	self.show()
	dialog_image.texture = pfp
	is_going_brrr = true
	$TypingSFX.play()
	var current_text: String = ""
	for i in range(len(text)):
		var j := i
		while current_text.ends_with(" "):
			current_text = current_text.substr(0, current_text.length() - 1)
		if not i == 0 and text[i-1] == " ":
			current_text += " "
		var c = text[j]
		current_text += c
		while j < len(text)-1 and text[j] != "\u00A0" and text[j] != " " and text[j+1] != "\u00A0" and text[j+1] != " ":
			j += 2
			current_text += " "
		
		dialog_label.text = current_text
		await get_tree().process_frame
		if not is_going_brrr:
			dialog_label.text = text
			$TypingSFX.stop()
			break
	is_going_brrr = false
	$TypingSFX.stop()

func send_multiple_dialogs(texts: Array, pfp, callback: Callable = func (): pass, skippable=true):
	panel.show()
	$Buy.hide()
	can_skip = skippable
	next_callback = func ():
		callback.call()
		next_callback = func (): pass
	for i in range(len(texts)):
		var text = texts[i]
		if i < len(texts) - 1:
			is_next_dialog = true
		else:
			is_next_dialog = false
		
		await send_dialog(text, pfp)
		
		if i == len(texts) - 1:
			return
		
		while not can_run_next_dialog:
			await get_tree().process_frame
		
		can_run_next_dialog = false

func sell(dialog, pfp, callback: Callable = func (): pass, skippable = false):
	panel.show()
	$Buy.hide()
	can_skip = skippable
	send_dialog(dialog, pfp)
	next_callback = func ():
		$Chaching.play()
		callback.call()
		next_callback = func (): pass

func _ready():
	Globals.connect("send_dialog_signal", self.send_multiple_dialogs)
	Globals.connect("send_sell_signal", self.sell)

	dialog_image = $PanelContainer/MarginContainer/HBoxContainer/TextureRect
	dialog_label = $PanelContainer/MarginContainer/HBoxContainer/Label
	panel = $PanelContainer
