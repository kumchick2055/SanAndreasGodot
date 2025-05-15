class_name RwAtomic
extends RwChunk

var frame_index: int
var geometry_index: int
var flags: int

func _init(file: FileAccess) -> void:
	super(file)
	RwStruct.new(file)
	assert(chunk_type == ATOMIC, 'Failed type of chunk - ATOMIC')
	
	frame_index = file.get_32()
	geometry_index = file.get_32()
	flags = file.get_32()
	
	# Unused
	file.get_32()
	
	RwExtension.new(file)
