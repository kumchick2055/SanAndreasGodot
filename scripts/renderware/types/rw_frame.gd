class_name RwFrame
extends RwChunk


var node_name: String

func _init(file: FileAccess) -> void:
	super(file)
	var raw_buffer = file.get_buffer(size)
	node_name = raw_buffer.get_string_from_ascii()
