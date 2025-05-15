class_name RwCamera
extends RwChunk


var frame_index: int
var radius: float
var color: Color
var dir_angle: float
var flags: int
var type: int 

func _init(file: FileAccess) -> void:
	super(file)
	RwStruct.new(file)
	
	frame_index = file.get_32()
	radius = file.get_float()
	
	var r := file.get_float()
	var g := file.get_float()
	var b := file.get_float()
	
	color = Color(r/255.0,g/255.0,b/255.0,1)
	dir_angle = file.get_float()
	
	flags = file.get_16()
	type = file.get_16()
