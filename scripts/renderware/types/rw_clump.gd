class_name RwClump
extends RwChunk


var atomics_count: int
var lights_count: int
var cameras_count: int

var frame_list: RwFrameList
var geometry_list: RwGeometryList

var atomics: Array[RwAtomic]
var lights: Array[RwLight]
var cameras: Array[RwCamera]


func _init(file: FileAccess) -> void:
	super(file)
	assert(chunk_type == CLUMP, 'Failed type of chunk - CLUMP')
	RwStruct.new(file)
	
	atomics_count = file.get_32()
	lights_count = file.get_32()
	cameras_count = file.get_32()

	frame_list = RwFrameList.new(file)
	geometry_list = RwGeometryList.new(file)
	
	for i in atomics_count:
		var atomic := RwAtomic.new(file)
		
		atomics.append(atomic)
		RwExtension.new(file)

	for i in lights_count:
		var light := RwLight.new(file)
		
		lights.append(light)
		RwExtension.new(file)

	for i in cameras_count:
		var camera := RwCamera.new(file)
		
		cameras.append(camera)
		RwExtension.new(file)
	
