class_name RwClump
extends RwChunk


var atomics: int
var lights: int
var cameras: int

var frame_list: RwFrameList
var geometry_list: RwGeometryList


func _init(file: FileAccess) -> void:
	super(file)
	assert(chunk_type == CLUMP, 'Failed type of chunk - CLUMP')
	RwStruct.new(file)
	
	atomics = file.get_32()
	lights = file.get_32()
	cameras = file.get_32()

	frame_list = RwFrameList.new(file)
	geometry_list = RwGeometryList.new(file)
