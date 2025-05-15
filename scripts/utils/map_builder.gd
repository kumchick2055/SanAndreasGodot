extends Node


var base_path = GameManager.game_path + '/'
var items: Dictionary
var placements: Array[ItemPL]


func normalize_path(path: String) -> String:
	
#	[IDE, DATA\TXDCUT.IDE]
#	[IPL, DATA\MAP.ZON]
#	[IPL, DATA\INFO.ZON]

	var val := path
	val = val \
	.replace("DATA","data") \
	.replace("MAPS","maps") \
	.replace("MODELS","models") \
	\
	.replace("TXDCUT", "txdcut") \
	.replace("MAP", "map") \
	.replace("INFO", "info") \
	\
	.replace(".IMG", ".img") \
	.replace(".IDE", ".ide") \
	.replace(".ZON", ".zon") \
	.replace(".IPL", ".ipl") 
	
	return val
 

func _ready() -> void:
	base_path = GameManager.game_path + '/'
	
	var path = GameManager.game_path
	var gta_data = path + '/data/gta.dat'
	var file := FileAccess.open(gta_data, FileAccess.READ)
	
	assert(file != null, "Error on open gta3.dat file")
	
	while not file.eof_reached():
		var line = file.get_line()
		
		# skip commentary
		if not line.begins_with('#'):
			var tokens = line.split(' ', false)
			
			if tokens.size() > 0:
				var img_path: String = tokens[1] as String
				img_path = img_path.replace('\\', '/')
				img_path = normalize_path(img_path)
				
				print(img_path)
				
				match tokens[0]:
					"IMG":
						AssetLoader.load_image(img_path)
					"IDE":
						_read_map_data(img_path, _read_ide_data)
					"IPL":
						_read_map_data(img_path, _read_ipl_data)
					_:
						print('Warning implement %s' % tokens[0])



func _read_map_data(path: String, line_handler: Callable) -> void:
	var file_path = base_path +  path
	
	var file := FileAccess.open(file_path, FileAccess.READ)
	assert(file != null, "Fail to open " + file_path + " file")
	
	var section: String
	while not file.eof_reached():
		var line := file.get_line()
		if line.length() == 0 or line.begins_with('#'):
			continue
		var tokens := line.replace(" ", "").split(",", false)
		if tokens.size() == 1:
			section = tokens[0]
		else:
			line_handler.call(section, tokens)
	
	
	
func _read_ide_data(section: String, tokens: Array):
	var model_name = tokens[1] as String
	if model_name.begins_with('LOD'):
		return
		
	var item := ItemDef.new()
	var id := int(tokens[0])
	match section:
		"objs":
			item.id = id
			item.model_name = model_name + ".dff"
			item.texture_name = tokens[2] + ".txd"
			item.draw_distance = float(tokens[3])
			item.flags = int(tokens[tokens.size() - 1])
			items[id] = item
			


func _read_ipl_data(section: String, tokens: Array):
	var model_name = tokens[1] as String
	if model_name.begins_with('LOD'):
		return
	match section:
		"inst":
			var placement := ItemPL.new()
			placement.id = int(tokens[0])
			placement.model_name = model_name
			
			placement.position = Vector3(
				int(tokens[2]),
				int(tokens[4]),
				-int(tokens[3])
			)
			
			placement.scale = Vector3(1,1,1)
			
			placement.rotation = Quaternion(
				-float(tokens[5]),
				-float(tokens[7]),
				-float(tokens[6]),
				float(tokens[8])
			)

			placements.append(placement)



func spawn_placement(ipl: ItemPL) -> Array[MeshInstance3D]:
	return spawn(ipl.id, ipl.model_name, ipl.position, ipl.scale, ipl.rotation)
	

func spawn(id: int, model_name: String, position: Vector3, scale: Vector3, rotation: Quaternion) -> Array[MeshInstance3D]:
	if not items.has(id):
		return []
	
	var item := items[id] as ItemDef
	if item.flags & 0x40:
		return []
		
	var instance := StreamedMesh.new(item)
	var model = instance.load_mesh()
	
	for i in range(0, len(model)):
		model[i].position = position
		model[i].scale = scale
		model[i].quaternion = rotation
		model[i].visibility_range_end = item.draw_distance
	
	
	return model
	
