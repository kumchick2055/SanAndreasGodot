extends Node

var assets: Dictionary[String, DirEntry] = {}


func _ready():
	load_image("models/gta3.img")


#func open(path: String) -> File:
#	var file = File.new()
#	return file

	
func load_image(path: String) -> void:
	path = GameManager.game_path + '/' +  path
	var file = FileAccess.open(path, FileAccess.READ)
	#file.open(path, File.READ)
	assert(file != null, 'Not open ' + path + ' file')
	
	var version = file.get_buffer(4).get_string_from_ascii()
	var files_count = file.get_32()
	
	for i in files_count:
		var offset = int(file.get_32()) * 2048
		var size = int(file.get_32()) * 2048
		var image_name = file.get_buffer(24).get_string_from_ascii()
		
		var entry := DirEntry.new()
		entry.img = path
		entry.offset = offset
		entry.size = size
		
		assets[image_name] = entry



func open_asset(name: String) -> FileAccess:
	var asset_name = name.to_lower()
	if asset_name in assets:
		var asset = assets[asset_name] as DirEntry
		var file = FileAccess.open(asset.img,FileAccess.READ)
		return file
		
	return null

class DirEntry:
	var img: String
	var offset: int
	var size: int
