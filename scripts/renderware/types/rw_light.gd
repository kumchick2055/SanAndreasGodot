class_name RwLight
extends RwChunk


var hoz_fov: float
var ver_fox: float
var viewport_width: float
var viewport_height: float
var near_plane: float
var far_plane: float
var fog_distance: float
var projection_mode: float


func _init(file: FileAccess) -> void:
	super(file)
	RwStruct.new(file)
	
	hoz_fov = file.get_float()
	ver_fox = file.get_float()
	viewport_width = file.get_float()
	viewport_height = file.get_float()
	near_plane = file.get_float()
	far_plane = file.get_float()
	fog_distance = file.get_float()
	
	projection_mode = file.get_32()
