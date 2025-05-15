extends Node3D

	
func _ready():
	#var file_txd = FileAccess.open('res://Models/landshaft_1.txd', FileAccess.READ)
	var file_txd := AssetLoader.open_asset('landshaft_1.txd')
	var chunk = RwTextureDict.new(file_txd)
	var textures = chunk.textures
	#print(textures)
	
	#var file = FileAccess.open('res://Models/island_mt01.dff', FileAccess.READ)
	var file := AssetLoader.open_asset('island_mt01.dff')
	var data = RwClump.new(file)
	
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


	#for i in geometry.twod_effects.effects:
#
		#var light := OmniLight3D.new()
		#light.omni_range = i.entity.coronaSize + 0.6
		#light.shadow_enabled = true
		#light.light_color = i.entity.color
		#light.light_energy = 50
		#light.light_indirect_energy = 1
		#light.translate(i.position)
		#add_child(light)
		#
		#if i.entry_type == 0:
			#pass

	rotate_x(deg_to_rad(-90))
	
