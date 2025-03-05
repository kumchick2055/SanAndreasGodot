class_name RwBreakable
extends RwChunk

var magic_number: int

func _init(file: File).(file) -> void:
	magic_number = file.get_32()
	
	print('Magic Number-', magic_number)
	
	if magic_number == 0:
		return
		
	# TODO: 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
