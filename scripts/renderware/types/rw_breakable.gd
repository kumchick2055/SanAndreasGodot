class_name RwBreakable
extends RwChunk

var magic_number: int

func _init(file: FileAccess) -> void:
	super(file)
	
	# TODO: Затычка вонючая, нужно по норму сделать в vert colour и 2d effect
	if chunk_type != BREAKABLE:
		file.seek(_start)
		return
		
	assert(chunk_type == BREAKABLE, 'Failed type of chunk - BREAKABLE')
	
	magic_number = file.get_32()
	
	if magic_number == 0:
		return
		
	# TODO: сделать breakable
