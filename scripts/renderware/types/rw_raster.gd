class_name RwRaster
extends RwChunk




enum RasterFormat {
	FORMAT_DEFAULT         = 0x000,
	FORMAT_1555            = 0x100,
	FORMAT_565             = 0x200,
	FORMAT_4444            = 0x300,
	FORMAT_LUM8            = 0x400,
	FORMAT_8888            = 0x500,
	FORMAT_888             = 0x600,
	FORMAT_555             = 0x0A00,
	FORMAT_EXT_AUTO_MIPMAP = 0x1000,
	FORMAT_EXT_PAL8        = 0x2000,
	FORMAT_EXT_PAL4        = 0x4000,
	FORMAT_EXT_MIPMAP      = 0x8000
}

enum FilterMode {
	FILTER_NONE                = 0x00,
	FILTER_NEAREST             = 0x01,
	FILTER_LINEAR              = 0x02,
	FILTER_MIP_NEAREST         = 0x03,
	FILTER_MIP_LINEAR          = 0x04,
	FILTER_LINEAR_MIP_NEAREST  = 0x05,
	FILTER_LINEAR_MIP_LINEAR   = 0x06
	
}


enum CompressionMode {
	NONE = 0,
	D3D_8888 = 21,
	D3D_888 = 22,
	DXT1 = 827611204, # make_fourcc('D', 'X', 'T', '1')
	DXT3 = 861165636  # make_fourcc('D', 'X', 'T', '3')
}

enum AddressingMode {
	WRAP_NONE     = 0x00,
	WRAP_WRAP     = 0x01,
	WRAP_MIRROR   = 0x02,
	WRAP_CLAMP    = 0x03
}


var platform_id: int
var filter_mode: int
var UAddressing: int
var VAddressing: int
var pad_texture_format: int

var raster_name: String
var mask_name: String
var raster_format: int
var d3dformat: int

var width: int
var height: int

var depth: int
var num_levels: int
var raster_type: int
var alpha: int
var cube_texture: int
var auto_mip_maps: int
var compressed: int
var pad_raster_format: int

var _image_start: int
var _file: FileAccess
var _size: int
var is_transparent: bool = false


func _init(file: FileAccess) -> void:
	super(file)
	assert(chunk_type == RASTER, 'Failed type of chunk - RASTER')
	var extension = RwStruct.new(file)
	_size = extension.size
	
	platform_id = file.get_16()
	filter_mode = file.get_16()
	pad_texture_format = file.get_16()
	
	UAddressing = file.get_8()
	VAddressing = file.get_8()
	
	raster_name = file.get_buffer(32).get_string_from_ascii()
	mask_name = file.get_buffer(32).get_string_from_ascii()
	
	raster_format = file.get_32()
	d3dformat  = file.get_32()
	
	width = file.get_16()
	height = file.get_16()
	
	depth = file.get_8()
	num_levels = file.get_8()
	raster_type = file.get_8()
	alpha = file.get_8()
	cube_texture = file.get_8()
	auto_mip_maps = file.get_8()
	compressed = file.get_8()
	pad_raster_format = file.get_8()
	
	_file = file
	_image_start = _file.get_position()

	file.seek(_image_start + _size - 68 - 12)

	

func get_image() -> ImageTexture:
	_file.seek(_image_start)
	
	var result: Image = Image.new()
	
	var bytes: PackedByteArray
	var read_size := _size - 92


	if d3dformat == CompressionMode.DXT1:
		bytes = _file.get_buffer(read_size)
		
		result = Image.create_from_data(width, height, false, Image.FORMAT_DXT1, bytes)
		result.decompress()
	elif d3dformat == CompressionMode.DXT3:
		bytes = _file.get_buffer(read_size)
		
		result = Image.create_from_data(width, height, false, Image.FORMAT_DXT3, bytes)
		is_transparent = true
		result.decompress()
	elif d3dformat == CompressionMode.D3D_8888:
		bytes = _file.get_buffer(read_size)
		
		result = Image.create_from_data(width, height, false, Image.FORMAT_RGBA8, bytes)
		result.decompress()
	elif d3dformat == CompressionMode.NONE:
		bytes = _file.get_buffer(read_size)
		
		result.create_from_data(width, height, false, Image.FORMAT_DXT1, bytes)
		result.decompress()
	else:
		var format
		var read: int
		
		match raster_format & 0x0f00:
			RasterFormat.FORMAT_8888:
				format = Image.FORMAT_RGBA8
				read = 4
			RasterFormat.FORMAT_888:
				format = Image.FORMAT_RGB8
				read = 3
			_:
				assert(false)
			
		if raster_format & (RasterFormat.FORMAT_EXT_PAL8 | RasterFormat.FORMAT_EXT_PAL4):
			pass
#			var psize := (16 if raster_format & RasterFormat.FORMAT_EXT_PAL4 else 256)
#			var pallete := Image.new()
#
#			pallete.create_from_data(psize, 1, false, format, _unpad(psize, read, bytes))
#			result.create(width, height, raster_format & 0x8000, format)
#
#			for i in width * height:
#				var x := int(i % width)
#				var y := int(i / width)
#				var color := pallete.get_pixel(bytes[i], 0)
#				result.set_pixel(x,y, color)
#
#			pass
		else:
			var data: PackedByteArray
			var mip_width := width
			var mip_height := height
			
			for i in num_levels:
				var raster_size := _file.get_32()
				data.append_array(_unpad(mip_width * mip_height, read))
				mip_height /= 2
				mip_width /= 2
			
			result.create_from_data(width, height, raster_format & RasterFormat.FORMAT_EXT_MIPMAP, format, data)
			
			if raster_format & RasterFormat.FORMAT_EXT_AUTO_MIPMAP:
				result.generate_mipmaps()
			false # result.lock() # TODOConverter3To4, Image no longer requires locking, `false` helps to not break one line if/else, so it can freely be removed
			for i in width * height:
				var x := int(i % width)
				var y := int(i / width)
				
				var old := result.get_pixel(x,y)
				result.set_pixel(x,y,Color(old.b, old.g, old.r, old.a))
			false # result.unlock() # TODOConverter3To4, Image no longer requires locking, `false` helps to not break one line if/else, so it can freely be removed
				

	
	var imgTexture = ImageTexture.create_from_image(result)
	
	
	return imgTexture
	


func _unpad(length: int, read: int) -> PackedByteArray:
	var result: PackedByteArray
	
	for i in length:
		for j in read:
			result.append(_file.get_8())
		for j in 4 - read:
			_file.get_8()
	return result

#func _unpad(length: int, read: int, bytes: PoolByteArray) -> PoolByteArray:
#	var result := PoolByteArray()
#	var index := 0
#
#	for i in length:
#		for j in read:
#			result.append(bytes[index])
#			index += 1
#		for j in 4 - read:
#			index += 1
##			_file.get_8()
#	return result
