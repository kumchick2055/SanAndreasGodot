class_name RwAtomic
extends RwChunk


func _init(file: FileAccess) -> void:
	super(file)
	assert(chunk_type == ATOMIC, 'Failed type of chunk - ATOMIC')
	pass
	
