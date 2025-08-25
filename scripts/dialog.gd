extends Control

var dialog_image: TextureRect = null
var dialog_label: Label = null
var panel: PanelContainer = null
var is_going_brrr: bool = false
var can_run_next_dialog: bool = false
var is_next_dialog: bool = false

# Example: in Main.gd or a singleton
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_going_brrr:
			is_going_brrr = false
		elif is_next_dialog:
			can_run_next_dialog = true
		else:
			close_dialog()
		
func close_dialog():
	panel.hide()

func send_dialog(text, pfp):
	dialog_image.texture = pfp
	is_going_brrr = true
	var current_text: String = ""
	for i in range(len(text)):
		while current_text.ends_with("\u3000"):
			current_text = current_text.substr(0, current_text.length() - 1)
		var c = text[i]
		current_text += c
		while i < len(text)-1 and text[i] != " " and text[i+1] != " ":
			i += 2
			current_text += "\u3000"
		
		dialog_label.text = current_text
		await get_tree().create_timer(0.02).timeout
		if not is_going_brrr:
			dialog_label.text = text
			break
	is_going_brrr = false
	
func send_multiple_dialogs(texts: Array, pfp):
	for i in range(len(texts)):
		var text = texts[i]
		if i < len(texts) - 1:
			is_next_dialog = true
		else:
			is_next_dialog = false
		send_dialog(text, pfp)
		while not can_run_next_dialog:
			await get_tree().create_timer(0.02).timeout

func _ready():
	dialog_image = $PanelContainer/MarginContainer/HBoxContainer/TextureRect
	dialog_label = $PanelContainer/MarginContainer/HBoxContainer/Label
	panel = $PanelContainer
