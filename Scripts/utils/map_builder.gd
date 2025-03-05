extends Node


func _ready() -> void:
	var path = GameManager.game_path
	
	
	
	var gta_data = path + '/data/gta.dat'
	var file = File.new()
	file.open(gta_data, File.READ)
	assert(file != null, "Error on open gta3.dat file")
	
	while not file.eof_reached():
		var line = file.get_line()
		if not line.begins_with('#'):
			var tokens = line.split(' ', false)
			if tokens.size() > 0:
				print(tokens)
				match tokens[0]:
					"IMG":
						var img_path: String = tokens[1] as String
						img_path = img_path.replace('\\', '/')
						img_path = path + '/' + img_path
						print(img_path)
					"IDE":
						pass
					"IPL":
						pass
					_:
						print('Warning implement %s' % tokens[0])
	
