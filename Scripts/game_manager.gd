extends Node


var game_path: String = ""

func _ready():
	var data = ProjectSettings.get_setting("global/gta_path")
	if data == "Null" or data == "" or data == null:
		game_path = "./GtaSource"
	else:
		game_path = data
	
	game_path = "res://" + game_path
