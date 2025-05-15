# https://gtamods.com/wiki/Extra_Vert_Colour_(RW_Section)
class_name RwExtraVertColour
extends RwChunk

var colors: Array
var magic_number: int

func _init(file: FileAccess, num_vertices: int) -> void:
	super(file)
	if chunk_type != EXTRA_VERT_COLOUR:
		file.seek(_start)
		return
		
		
	assert(chunk_type == EXTRA_VERT_COLOUR, 'Failed type of chunk - EXTRA_VERT_COLOUR')
	magic_number = file.get_32()
	
	if magic_number == 0:
		return
	
	for j in range(0, num_vertices):
		var color: Color
		color.r = file.get_8()
		color.g = file.get_8()
		color.b = file.get_8()
		color.a = file.get_8()

		colors.append(color)
