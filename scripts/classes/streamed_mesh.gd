class_name StreamedMesh
extends MeshInstance3D

var _idef: ItemDef
var _mesh_buf: Array[MeshInstance3D]
#var _thread := Thread.new()


func _init(idef: ItemDef):
	_idef = idef
	#load_mesh()
	
	
#func _exit_tree() -> void:
	#if _thread.is_alive():
		#_thread.wait_to_finish()
		
		
#func _process(delta: float) -> void:
	#if _thread.is_started() == false:
		#if get_viewport().get_camera_3d() != null:
			#var dist := get_viewport().get_camera_3d().global_position.distance_to(global_position)
			#if dist < visibility_range_end and mesh == null:
				#_thread.start(_load_mesh)
				#while _thread.is_alive():
					#await get_tree().process_frame
				#_thread.wait_to_finish()
				#mesh = _mesh_buf
			#elif dist > visibility_range_end and mesh != null:
				#mesh = null
	
	
func load_mesh() -> Array[MeshInstance3D]:
	#AssetLoader.mutex.lock()
	if _idef.flags & 0x40:
		return []
		
	var access := AssetLoader.open_asset(_idef.model_name)
	if access == null:
		print("Не нашёл: ", _idef.model_name)
		return []
	
	print("Нашел: ", _idef.model_name)
	
	#var file_txd = FileAccess.open('res://Models/mentovka_int.txd', FileAccess.READ)
	#
	
	#var texture_access := AssetLoader.open_asset(_idef.texture_name)
	#var texture_dict := RwTextureDict.new(texture_access)
	#var textures = texture_dict.textures
	#
	
	#print(textures)
	#
	#var file = FileAccess.open('res://Models/mentovka_int.dff', FileAccess.READ)

	var data := RwClump.new(access).geometry_list
	
	for geometry in data.geometries:
		var geometry_mesh := geometry.get_mesh()

		
		for material_index in geometry.material_list.materials.size():
			var current_geometry = geometry_mesh[material_index]
			var hui = MeshInstance3D.new()
			hui.mesh = current_geometry
			_mesh_buf.append(hui)
			
			
			# ------------------------------------
			# TODO: Сделать поддержку текстур
			
			
			#var m = MeshInstance3D.new()
			#m.mesh = current_geometry
			#
			#var rw_material = geometry.material_list.materials[material_index]
			#var godot_material = rw_material.get_material()
			#m.material_override = godot_material

#
			#if  rw_material.isTextured:
				#for raster in textures:
					#var texName = rw_material.texture.texture_name
#
					#if texName.to_lower() == raster.raster_name:
						#
						#var texture = raster.get_image()
						#if texture:
							#if raster.is_transparent:
								#godot_material.flags_transparent = true
							#
							#godot_material.albedo_texture = texture
			# ------------------------------------
	
	#AssetLoader.mutex.unlock()
	
	return _mesh_buf
	#return _mesh_buf
