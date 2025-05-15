extends Label


func _process(delta):
	var debug_text := "FPS: " + str(Engine.get_frames_per_second()) + "\n" + \
	"Position: " + str($"../Head/Camera3D".global_position)
	text = debug_text
