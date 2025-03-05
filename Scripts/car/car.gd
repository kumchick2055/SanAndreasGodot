extends VehicleBody

var max_rpm = 500
var max_torque = 200

func _physics_process(delta):
	steering = lerp(steering,Input.get_axis("ui_right","ui_left") * 0.7, 5 * delta)

	var acceleration = Input.get_axis("ui_down", "ui_up")
	var rpm = $back_left_wheel.get_rpm()
	$back_left_wheel.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)
	rpm = $back_right_wheel.get_rpm()
	$back_right_wheel.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)
	
	var camera_transform = $"../camera_pivot".global_transform.origin
	var car_transform = global_transform.origin
	car_transform.y += 1
	$"../camera_pivot".transform.origin = lerp(camera_transform, car_transform, delta * 20.0)
