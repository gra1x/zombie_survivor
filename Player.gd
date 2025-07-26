extends CharacterBody3D

@onready var camera = $Camera3D
@onready var weapon_point = $Camera3D/WeaponPoint

var bullet_scene = preload("res://Bullet.tscn")

# Movement
var speed = 8.0
var jump_velocity = 12.0
var sensitivity = 0.003
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Health system
var max_health = 100
var current_health = 100

# Shooting
var can_shoot = true
var shoot_cooldown = 0.1
var ammo = 30
var max_ammo = 30
var reload_time = 2.0
var is_reloading = false

# Footstep system
var footstep_timer = 0.0
var footstep_interval = 0.4
var last_position = Vector3.ZERO

signal health_changed(health)
signal died
signal ammo_changed(current_ammo, max_ammo)
signal gunshot_fired
signal reload_started
signal footstep_made

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	health_changed.emit(current_health)
	ammo_changed.emit(ammo, max_ammo)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

func _physics_process(delta):
	handle_movement(delta)
	handle_shooting()
	handle_reload()

func handle_movement(delta):
	# Add gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get input direction
	var input_dir = Vector2.ZERO
	if Input.is_action_pressed("move_forward"):
		input_dir.y -= 1
	if Input.is_action_pressed("move_backward"):
		input_dir.y += 1
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1

	# Calculate movement direction relative to player rotation
	var direction = Vector3.ZERO
	if input_dir != Vector2.ZERO:
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Apply movement
	if direction != Vector3.ZERO:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
	
	# Handle footsteps
	if is_on_floor() and direction != Vector3.ZERO:
		footstep_timer += delta
		if footstep_timer >= footstep_interval:
			footstep_timer = 0.0
			footstep_made.emit()

func handle_shooting():
	if Input.is_action_pressed("shoot") and can_shoot and ammo > 0 and not is_reloading:
		shoot()

func handle_reload():
	if Input.is_action_just_pressed("reload") and not is_reloading and ammo < max_ammo:
		reload()

func shoot():
	if ammo <= 0:
		return
		
	can_shoot = false
	ammo -= 1
	ammo_changed.emit(ammo, max_ammo)
	
	# Emit gunshot sound signal
	gunshot_fired.emit()
	
	# Create bullet
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	
	bullet.global_position = weapon_point.global_position
	bullet.global_rotation = weapon_point.global_rotation
	
	# Set bullet direction
	var direction = -weapon_point.global_transform.basis.z
	bullet.set_direction(direction)
	
	# Start cooldown
	await get_tree().create_timer(shoot_cooldown).timeout
	can_shoot = true

func reload():
	if is_reloading:
		return
		
	is_reloading = true
	
	# Emit reload sound signal
	reload_started.emit()
	
	# Wait for reload time
	await get_tree().create_timer(reload_time).timeout
	
	ammo = max_ammo
	is_reloading = false
	ammo_changed.emit(ammo, max_ammo)

func take_damage(damage):
	current_health -= damage
	current_health = max(0, current_health)
	health_changed.emit(current_health)
	
	if current_health <= 0:
		die()

func heal(amount):
	current_health += amount
	current_health = min(max_health, current_health)
	health_changed.emit(current_health)

func die():
	died.emit()
	# Disable movement and shooting
	set_physics_process(false)
	set_process_input(false)
