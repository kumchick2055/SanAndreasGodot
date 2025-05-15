extends Node3D

var world := Node3D.new()


func _ready() -> void:
	var start := Time.get_ticks_msec()
	
	for ipl in range(0,20):
		#var n = MeshInstance3D.new()
		var meshes = MapBuilder.spawn_placement(MapBuilder.placements[ipl])
		for i in meshes:
			add_child(
				i
			)

	
	
	#add_child(world)
	print("Map load completed in %f seconds" % ((Time.get_ticks_msec() - start) / 1000))
