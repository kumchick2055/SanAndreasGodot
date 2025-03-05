class_name RwClump
extends RwChunk


var atomics: int
var lights: int
var cameras: int


func _init(file: File).(file) -> void:
	RwStruct.new(file)
	atomics = file.get_32()
	lights = file.get_32()
	cameras = file.get_32()

