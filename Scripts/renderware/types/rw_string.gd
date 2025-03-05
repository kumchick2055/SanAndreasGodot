class_name RwString
extends RwChunk

var string: String

func _init(file: File).(file):

	var chars: PoolByteArray
	while true:
		var ch := file.get_8()
		if ch == 0:
			break
		chars.append(ch)
		
	string = chars.get_string_from_ascii()
