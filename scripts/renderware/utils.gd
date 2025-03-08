class_name RWUtils
extends Node



static func get_version(library_id: int) -> int:
	if library_id & 0xffff0000:
		return (library_id >> 14 & 0x3ff00) + 0x30000 | (library_id >> 16 & 0x3f)
	return library_id << 8


#static func make_fourcc(ch1, ch2, ch3, ch4):
	#return (ord(ch1) & 0xFF) | ((ord(ch2) & 0xFF) << 8) | ((ord(ch3) & 0xFF) << 16) | ((ord(ch4) & 0xFF) << 24)
