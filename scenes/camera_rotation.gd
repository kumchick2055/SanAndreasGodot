extends Node3D

var is_mode_captured = true
# Настройки вращения
var rotation_speed = 0.1
var min_pitch = -80.0
var max_pitch = 80.0

# Переменные для хранения углов
var yaw = 180.0
var pitch = 0.0

# Настройки движения
var move_speed = 5.0
var velocity = Vector3()


func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			is_mode_captured = true
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			is_mode_captured = false
	# Проверяем, является ли событие движением мыши
	if event is InputEventMouseMotion and is_mode_captured:
		# Обновляем углы вращения
		yaw -= event.relative.x * rotation_speed
		pitch -= event.relative.y * rotation_speed
		
		# Ограничиваем угол наклона
		pitch = clamp(pitch, min_pitch, max_pitch)
		
		# Применяем вращение к узлу Spatial
		rotation_degrees = Vector3(-pitch, yaw, 0)
	if event is InputEventKey:
		if event.is_action_released('esc_down'):
			is_mode_captured = !is_mode_captured
			if !is_mode_captured:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
