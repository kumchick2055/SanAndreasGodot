class_name RwMaterialList
extends RwChunk


var number_of_materials: int
var array_of_material_indices: Array
var materials: Array


func _init(file: FileAccess) -> void:
	super(file)
	RwStruct.new(file)
	assert(chunk_type == MATERIAL_LIST, 'Failed type of chunk - MATERIAL_LIST')
	
	number_of_materials = file.get_32()
	
	for i in number_of_materials:
		var material_index = file.get_32()
#		
		array_of_material_indices.append(
			(material_index + (1 << 31)) % (1 << 32) - (1 << 31) 
		)
	
	for i in array_of_material_indices:

		if i == -1:
			materials.append(RwMaterial.new(file))
		else:
			assert(false, "Implement")
