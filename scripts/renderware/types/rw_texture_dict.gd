class_name RwTextureDict
extends RwChunk

var texture_count: int
var device_id: int
var textures: Array[RwRaster]

func _init(file: FileAccess) -> void:
	super(file)
	RwStruct.new(file)
	assert(chunk_type == TEXTURE_DICTIONARY, 'Failed type of chunk - TEXTURE_DICTIONARY')
	
	texture_count = file.get_16()
	device_id = file.get_16() # unused
	
	for i in texture_count:
		var raster := RwRaster.new(file)
		textures.append(raster)
	
