class_name RwTexture
extends RwChunk


#var texture_filtering: int
#var uAddressing: int
#var vAddressing: int
#var useMipLevevels: bool
var texture_name: String
var mask_name: String

func _init(file: FileAccess) -> void:
	super(file)
	RwStruct.new(file)
	
#	texture_filtering = file.get_32()
#	uAddressing = file.get_32()
#	vAddressing = file.get_32()
#	useMipLevevels = file.get_32()
#	var struct = RwStruct.new(file)
#	file.get_buffer(struct.size)
	file.get_buffer(4)
	
	var data_struct = RwStruct.new(file)
	texture_name = file.get_buffer(data_struct.size).get_string_from_ascii()
	
	data_struct = RwStruct.new(file)
	mask_name = file.get_buffer(data_struct.size).get_string_from_ascii()
#	print(texture_name, '-Имя текстуры')
#	texture_name = 
#	texture_name = RwString.new(file).string
#	mask_name = RwString.new(file).string
