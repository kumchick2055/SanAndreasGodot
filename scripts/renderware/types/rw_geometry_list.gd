class_name RwGeometryList
extends RwChunk


var number_of_geometries: int
var geometries: Array[RwGeometry]

func _init(file: FileAccess) -> void:
	super(file)
	RwStruct.new(file)
	
	number_of_geometries = file.get_32()
	
	for i in number_of_geometries:
		var geometry := RwGeometry.new(file)
		geometries.append(geometry)
