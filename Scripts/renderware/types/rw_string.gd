class_name RwString
extends RwChunk

var string: String

func _init(file: FileAccess):
	super(file)

	var chars: PackedByteArray
	while true:
		var ch := file.get_8()
		if ch == 0:
			break
		chars.append(ch)
		
	string = chars.get_string_from_ascii()
