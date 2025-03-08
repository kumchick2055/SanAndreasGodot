class_name RwChunk
extends RefCounted


enum {
	CLUMP = 0x10,
	STRUCT = 0x1,
	FRAME_LIST = 0xe,
	EXTENSION = 0x3,
	FRAME = 0x253f2fe, # Node Name
	GEOMETRY_LIST = 0x1a,
	GEOMETRY = 0xf,
	MATERIAL_LIST = 0x8,
	MATERIAL = 0x7,
	TEXTURE = 0x6,
	STRING = 0x2,
	BIN_MESH_PLG = 0x50e,
	BREAKABLE = 0x253f2fd,
	EXTRA_VERT_COLOUR = 0x253f2f9,
	ATOMIC = 0x14,
	TWOD_EFFECT = 0x253f2f8,
	TEXTURE_DICTIONARY = 0x16,
	RASTER=0x15
}


var chunk_type: int
var size: int
var library_id: int

func _init(file: FileAccess) -> void:
	chunk_type = file.get_32()
	size = file.get_32()
	library_id = RWUtils.get_version(file.get_32())
	


func _to_string():
	return str(chunk_type) + "-" + str(size) + "-" + str(library_id)
