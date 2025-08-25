extends Control

func _ready():
	var dialog = $Control
	var image: CompressedTexture2D = load("res://images/trump.png")
	dialog.send_multiple_dialogs(["I'm Tonald Drump and I've partnered with Shaid Radow Legends to make a mobile game.", "Would you like to play?"], image)
