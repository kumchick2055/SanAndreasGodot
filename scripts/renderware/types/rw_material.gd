class_name RwMaterial
extends RwChunk


var flags: int
var color: Color
var isTextured: bool
var surface: Surface
var texture: RwTexture
#var material: Material

class Surface:
	var ambient: float
	var specular: float
	var diffuse: float

func get_material() -> StandardMaterial3D:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
#	mat.set_blend_mode(SpatialMaterial.BLEND_MODE_)
	
	
#	if library_id > 0x30400:
#		mat.roughness = 1.0 - surface.specular
#	print(color)
	return mat




func _init(file: FileAccess) -> void:
	super(file)
	RwStruct.new(file)
	assert(chunk_type == MATERIAL, 'Failed type of chunk - MATERIAL')
	
	
	flags = file.get_32()
	var r := file.get_8()
	var g := file.get_8()
	var b := file.get_8()
	var a := file.get_8()
	
	color = Color(r/255.0,g/255.0,b/255.0,a/255.0)

	# unused
	file.get_32()
	
	isTextured =  true if file.get_32() else false
	
	if library_id > 0x30400:
		surface = Surface.new()
		
		surface.ambient = file.get_float()
		surface.specular = file.get_float()
		surface.diffuse = file.get_float()

	if isTextured:
		texture = RwTexture.new(file)

		# Extension
		RwStruct.new(file)
		# Extension
		RwStruct.new(file)
