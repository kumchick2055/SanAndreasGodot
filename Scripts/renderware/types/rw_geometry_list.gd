class_name RwGeometryList
extends RwChunk


var number_of_geometries: int


func _init(file: File).(file) -> void:
	RwStruct.new(file)
	
	number_of_geometries = file.get_32()
	
	
