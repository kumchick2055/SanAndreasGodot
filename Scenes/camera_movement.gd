extends Spatial

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

func _ready() -> void:
	# Скрыть курсор и захватить его
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Проверяем, является ли событие движением мыши
	if event is InputEventMouseMotion and is_mode_captured:
		# Обновляем углы вращения
		yaw -= event.relative.x * rotation_speed
		pitch -= event.relative.y * rotation_speed
		
		# Ограничиваем угол наклона
		pitch = clamp(pitch, min_pitch, max_pitch)
		
		# Применяем вращение к узлу Spatial
		rotation_degrees = Vector3(pitch, yaw, 0)
	if event is InputEventKey:
		if event.is_action_released('esc_down'):
			is_mode_captured = !is_mode_captured
			if !is_mode_captured:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	# Сбрасываем скорость перед каждым обновлением
	velocity = Vector3()
	
	if Input.is_key_pressed(KEY_SHIFT):
		move_speed = 10.0
	else:
		move_speed = 5.0
	
	# Обработка ввода с клавиатуры
	if Input.is_action_pressed("ui_up"):
		velocity.z -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.z += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	
	
	# Нормализуем вектор скорости, чтобы движение по диагонали не было быстрее
	velocity = velocity.normalized()
	
	# Умножаем на скорость и время кадра для плавного движения
	velocity *= move_speed * delta
	
	# Преобразуем локальное направление в глобальное с учетом текущего поворота
	var direction = Vector3(velocity.x,velocity.y,velocity.z)

	# Перемещаем объект
	translate(direction)
