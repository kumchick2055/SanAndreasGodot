class_name RwGeometry
extends RwChunk


enum {
	rpGEOMETRYTRISTRIP = 0x00000001,
	rpGEOMETRYPOSITIONS = 0x00000002,
	rpGEOMETRYTEXTURED = 0x00000004,
	rpGEOMETRYPRELIT = 0x00000008,
	rpGEOMETRYNORMALS = 0x00000010,
	rpGEOMETRYLIGHT = 0x00000020,
	rpGEOMETRYMODULATEMATERIALCOLOR = 0x00000040,
	rpGEOMETRYTEXTURED2 = 0x00000080,
	rpGEOMETRYNATIVE = 0x01000000,
}

var flag_value: int

var num_triangles: int
var geometry_num_vertices: int
var num_morph_target: int

var uvs: Array
var tris: Array
var morph_targets: Array

var material_list: RwMaterialList
var material_split: RwBinMeshPLG

var breakable: RwBreakable
var vert_colour: RwExtraVertColour
var twod_effects: RwTwoDEffect


func _init(file: FileAccess) -> void:
	super(file)
	assert(chunk_type == GEOMETRY, 'Failed type of chunk - GEOMETRY')
	RwStruct.new(file)
	
	flag_value = file.get_32()
	
	num_triangles = file.get_32()
	geometry_num_vertices = file.get_32()
	num_morph_target = file.get_32()
	
	if flag_value & rpGEOMETRYNATIVE == 0:
		if flag_value & rpGEOMETRYPRELIT:
			file.seek(file.get_position() + (geometry_num_vertices*4))
			pass
			
		var numTexSets = (flag_value & 0x00FF0000) >> 16
		
		if numTexSets == 0:
			if flag_value & rpGEOMETRYTEXTURED2:
				numTexSets = 2
			elif flag_value & rpGEOMETRYTEXTURED:
				numTexSets = 1
				
		for i in numTexSets:
			
			var coords = []
			
			for j in geometry_num_vertices:
				var u = file.get_float()
				var v = file.get_float()

				coords.append(Vector2(u,v))
			uvs.append(coords)
			
		for i in num_triangles:
			var tri = Triangle.new()
			tri.vertex_2 = file.get_16()
			tri.vertex_1 = file.get_16()
			tri.material_id = file.get_16()
			tri.vertex_3 = file.get_16()
			
			tris.append(tri)
		
		
	for i in num_morph_target:
		var morph_t = MorphTarget.new()
		var sphere = Sphere.new()
		
		sphere.x = file.get_float()
		sphere.y = file.get_float()
		sphere.z = file.get_float()
		sphere.radius = file.get_float()
		
		morph_t.bounding_sphere = sphere
		
		var has_vertices = file.get_32() != 0
		var has_normals = file.get_32() != 0
		
		morph_t.has_vertices = has_vertices
		morph_t.has_normals = has_normals
		
		if has_vertices:
			for j in geometry_num_vertices:
				var vert = Vector3()
				vert.x = file.get_float()
				vert.y = file.get_float()
				vert.z = file.get_float()	
				
				morph_t.vertices.append(vert)
				
		if has_normals:
			for j in geometry_num_vertices:
				var norm = Vector3()
				norm.x = file.get_float()
				norm.y = file.get_float()
				norm.z = file.get_float()	
				
				morph_t.normals.append(norm)
		
		morph_targets.append(morph_t)
		
	material_list = RwMaterialList.new(file)
	
	# TODO: разобраться с extension
	
	## Extension
	#RwExtension.new(file)
	## Extension
	#RwExtension.new(file)
	var extension = RwExtension.new(file)
	# if material split
	if flag_value & rpGEOMETRYTRISTRIP == 0:
		material_split = RwBinMeshPLG.new(file)
		print('IS MATERIAL SPLIT')
		
	breakable = RwBreakable.new(file)
	vert_colour = RwExtraVertColour.new(file, geometry_num_vertices)
	twod_effects = RwTwoDEffect.new(file)

		
	

func get_mesh() -> Dictionary:
#	var mesh: ArrayMesh
	
	if morph_targets[0].has_vertices == false:
#		return ArrayMesh.new()
		return {}
		
	var morph_t = morph_targets[0]
	var meshes_dict: Dictionary
	
	for j in material_split.meshesList:
		var mesh: ArrayMesh
		
		var st := SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		
		var meshData = j
		var meshIndices = meshData.indices
		
		for i in range(0,meshIndices.size()-2,3):
			for x in [1,0,2]:

				if morph_t.has_normals:
					st.set_normal(morph_t.normals[meshIndices[i+x]])
				if uvs.size() > 0:
					st.set_uv(uvs[0][meshIndices[i+x]])
				st.add_vertex(morph_t.vertices[meshIndices[i+x]])
				

		if flag_value & rpGEOMETRYTRISTRIP == 0 and morph_t.has_normals == false:
			st.generate_normals()
	
		if mesh == null:
			mesh = st.commit()
		else:
			st.commit(mesh)
			
		meshes_dict[j.material_indx] = mesh
		
	return meshes_dict



class MorphTarget:
	var bounding_sphere: Sphere
	var has_vertices: bool
	var has_normals: bool
	var vertices: Array
	var normals: Array
	
	
class Sphere:
	var x: float
	var y: float
	var z: float
	var radius: float


class Triangle:
	var vertex_2: int
	var vertex_1: int
	var material_id: int
	var vertex_3: int
