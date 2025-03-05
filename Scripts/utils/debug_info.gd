extends Label


func _process(delta):
	var debug_text := "FPS: " + str(Engine.get_frames_per_second()) + "\n"
	text = debug_text
