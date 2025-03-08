extends Node3D

	
func _ready():
	var file_txd = FileAccess.open('res://Models/izbushka_lshnk.txd', FileAccess.READ)
	
	var chunk = RwTextureDict.new(file_txd)
	var textures = chunk.textures
	print(textures)
	
	var file = FileAccess.open('res://Models/izbushka_psx.dff', FileAccess.READ)

	var data = RwClump.new(file)
	
	#print(data)
	#print(data.atomics)
	#print(data.lights)
	#print(data.cameras)
	#print('----')
#
	#data = RwFrameList.new(file)
	#print(data)
	#
	#for i in data.frame_data:
		#print(i)
#
	#for i in data.frame_count:
		#var a := RwExtension.new(file)
		#var frame := RwFrame.new(file)
#
	#var geometry_list = RwGeometryList.new(file)
	#print(geometry_list)
	#print(geometry_list.number_of_geometries, '')
	#
#
	#var geometry = RwGeometry.new(file)
	#var geometry_mesh = geometry.get_mesh()
	var geometry = data.geometry_list.geometries[0]
	var geometry_mesh = geometry.get_mesh()

	
	for material_index in geometry.material_list.materials.size():
		var current_geometry = geometry_mesh[material_index]
		var m = MeshInstance3D.new()
		m.mesh = current_geometry
#		print(current_geometry.get_meta_list())
		
		var rw_material = geometry.material_list.materials[material_index]
		var godot_material = rw_material.get_material()
		m.material_override = godot_material
#		m.material_override.al
		
		print(rw_material.texture.texture_name)
		if  rw_material.isTextured:
			for raster in textures:
				var texName = rw_material.texture.texture_name
#				if raster.raster_name == "iz_moh":
				if texName.to_lower() == raster.raster_name:
					
					var texture = raster.get_image()
					if texture:
						if raster.is_transparent:
							godot_material.flags_transparent = true
						
						godot_material.albedo_texture = texture

		add_child(m)

	print(RwBreakable.new(file))
	print(RwExtraVertColour.new(file, geometry.geometry_num_vertices))
	var twoDEffects := RwTwoDEffect.new(file)
	for i in twoDEffects.effects:
#		var cube := MeshInstance.new()
#		cube.mesh = create_cube(i.position, Vector3(0.01, 0.01, 0.01))
#		cube.scale = Vector3(0.1,0.1,0.1)
#
#		add_child(cube)
		var light := OmniLight3D.new()
		light.omni_range = i.entity.coronaSize + 0.6
		light.shadow_enabled = true
		light.light_color = i.entity.color
		light.light_energy = 50
		light.light_indirect_energy = 1
		light.translate(i.position)
#		light.look_at_from_position(i.position, i.entity.lookDirection, Vector3.UP)
		add_child(light)
		
		if i.entry_type == 0:
			pass
#	print(RwChunk.new(file))

	rotate_x(deg_to_rad(-90))
	
