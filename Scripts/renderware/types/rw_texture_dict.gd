class_name RwTextureDict
extends RwChunk

var texture_count: int
var device_id: int
var textures: Array

func _init(file: File).(file) -> void:
	RwExtension.new(file)
	
	texture_count = file.get_16()
	device_id = file.get_16() # unused
	
	for i in texture_count:
		var raster := RwRaster.new(file)
		textures.append(raster)
	
