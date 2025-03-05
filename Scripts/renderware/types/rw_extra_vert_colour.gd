# https://gtamods.com/wiki/Extra_Vert_Colour_(RW_Section)
class_name RwExtraVertColour
extends RwChunk

var colors: Array
var magic_number: int

func _init(file: File, num_vertices: int).(file) -> void:
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
	
	print('Magic-Number:',magic_number)
