class_name RwGeometryList
extends RwChunk


var number_of_geometries: int
var geometries: Array[RwGeometry]

func _init(file: FileAccess) -> void:
	super(file)
	assert(chunk_type == GEOMETRY_LIST, 'Failed type of chunk - GEOMETRY_LIST')
	RwStruct.new(file)
	
	number_of_geometries = file.get_32()
	
	for i in number_of_geometries:
		var geometry := RwGeometry.new(file)
		geometries.append(geometry)
