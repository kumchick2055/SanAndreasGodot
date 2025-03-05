extends Control

var textures: Array


func _load_image(index: int):
	
	
	var texture = textures[index]
	var img = texture.get_image()
	var parent_size = rect_size 

	$TextureRect.texture = null
	$TextureRect.rect_size = Vector2(texture.width, texture.height)
	$TextureRect.rect_position = Vector2((parent_size.x - texture.width) / 2, (parent_size.y - texture.height) / 2)
	$TextureRect.texture = img



func _select_txd():
	var file_dialog := FileDialog.new()
	file_dialog.window_title = "Select .txd file"
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.mode =FileDialog.MODE_OPEN_FILE
	file_dialog.add_filter("*.txd")
	add_child(file_dialog)
	file_dialog.popup_centered(Vector2(600,400))

	file_dialog.connect("file_selected", self, "_on_file_selected")
	

func _on_file_selected(path: String) -> void:
	assert(path != null)
	print('Select file - ', path)
	
	var file := File.new()
	file.open(path, File.READ)
	
	var chunk = RwTextureDict.new(file)
	
	textures = chunk.textures
	
	$OptionButton.clear()
	
	for i in len(chunk.textures):
		print(chunk.textures[i].raster_name)
		$OptionButton.add_item(chunk.textures[i].raster_name, i)
		
	$OptionButton.text = "Select texture"
