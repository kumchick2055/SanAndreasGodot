class_name RwFrameList
extends RwChunk


class Frame:
	var rotation_matrix: Array
	var position: Vector3
	var parent_index: int
	var matrix_flags: int
	
	func _to_string():
		return str(rotation_matrix)+"-"+str(position)+"-"+str(parent_index)+"-"+str(matrix_flags)
	

var frame_count: int
var frame_data: Array[Frame]
var frames: Array[RwFrame]

func _init(file: FileAccess) -> void:
	super(file)
	RwStruct.new(file)
	
	frame_count = file.get_32()
	frame_data.resize(frame_count)
	
	for i in frame_count:
		var frame = Frame.new()
		frame.rotation_matrix.resize(3)
		for j in 3:
			var x := file.get_float()
			var y := file.get_float()
			var z := file.get_float()
			frame.rotation_matrix[j] = Vector3(x,y,z)
			
		var x := file.get_float()
		var y := file.get_float()
		var z := file.get_float()
		
		frame.position.x = x
		frame.position.y = y
		frame.position.z = z
		
		frame.parent_index = file.get_32()
		frame.matrix_flags = file.get_32()
		
		frame_data[i] = frame
		
	
	for i in frame_count:
		RwExtension.new(file)
		var frame := RwFrame.new(file)
		frames.append(frame)
