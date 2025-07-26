extends CharacterBody3D

@onready var health_bar = $HealthBar3D
@onready var attack_timer = $AttackTimer
@onready var zombie_model = $ZombieModel
@onready var collision_shape = $CollisionShape3D

var target: CharacterBody3D
var base_speed = 2.0
var current_speed = 4.0
var max_health = 50
var current_health = 50
var attack_damage = 25
var attack_range = 2.5
var attack_cooldown = 1.0
var can_attack = true

# Simple AI states
enum State {
	CHASING,
	RUNNING,
	ATTACKING,
	DEAD
}

var current_state = State.CHASING
var detection_range = 15.0
var run_trigger_distance = 12.0
var run_speed_multiplier = 2.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

signal zombie_died
signal zombie_groan

func _ready():
	apply_wave_scaling()
	health_bar.max_value = max_health
	health_bar.value = current_health
	current_speed = base_speed

func apply_wave_scaling():
	var main_node = get_node("/root/Main")
	if main_node and main_node.has_method("get_current_wave"):
		var wave_number = main_node.get_current_wave()
		var scaling_factor = 1.0 + (wave_number - 1) * 0.15
		
		max_health = int(50 * scaling_factor)
		current_health = max_health
		attack_damage = int(25 * scaling_factor)
		base_speed = min(4.0 * scaling_factor, 8.0)
		current_speed = base_speed

func _physics_process(delta):
	if current_state == State.DEAD:
		return
		
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0
	
	update_ai_simple()
	move_and_slide()

func update_ai_simple():
	if not target:
		return
		
	var distance_to_target = global_position.distance_to(target.global_position)
	
	# State logic - VERY SIMPLE
	if distance_to_target <= attack_range:
		current_state = State.ATTACKING
	elif distance_to_target <= run_trigger_distance:
		current_state = State.RUNNING
	else:
		current_state = State.CHASING
	
	# Execute behavior based on state
	match current_state:
		State.CHASING:
			chase_target()
		State.RUNNING:
			run_to_target()
		State.ATTACKING:
			attack_target_if_possible()

func chase_target():
	current_speed = base_speed
	move_directly_to_target()

func run_to_target():
	# VERY OBVIOUS running behavior
	current_speed = base_speed * run_speed_multiplier
	move_directly_to_target()
	
	# Visual feedback - flash red constantly while running
	flash_red()
	
	# Audio feedback
	if randf() < 0.1:  # 10% chance per frame
		zombie_groan.emit()

func move_directly_to_target():
	if not target:
		return
		
	# Direct movement toward target - NO NAVIGATION AGENT
	var direction = (target.global_position - global_position).normalized()
	
	# Set velocity directly
	velocity.x = direction.x * current_speed
	velocity.z = direction.z * current_speed
	
	# Look at target
	if direction.length() > 0.1:
		var look_direction = Vector3(direction.x, 0, direction.z)
		if look_direction.length() > 0.1:
			look_at(global_position + look_direction, Vector3.UP)

func attack_target_if_possible():
	if not target:
		return
		
	# Stop moving when attacking
	velocity.x = 0
	velocity.z = 0
	
	# Look at target
	var direction = (target.global_position - global_position).normalized()
	if direction.length() > 0.1:
		var look_direction = Vector3(direction.x, 0, direction.z)
		if look_direction.length() > 0.1:
			look_at(global_position + look_direction, Vector3.UP)
	
	# Attack if we can
	if can_attack:
		attack_target()

func attack_target():
	can_attack = false
	
	# Deal damage to target
	if target and target.has_method("take_damage"):
		target.take_damage(attack_damage)
	
	# Visual attack effect
	flash_red()
	
	# Start attack cooldown
	attack_timer.wait_time = attack_cooldown
	attack_timer.start()

func flash_red():
	# Flash all zombie parts red
	var body_parts = [
		zombie_model.get_node("Body"),
		zombie_model.get_node("Head"),
		zombie_model.get_node("LeftArm"),
		zombie_model.get_node("RightArm"),
		zombie_model.get_node("LeftLeg"),
		zombie_model.get_node("RightLeg")
	]
	
	for part in body_parts:
		if part and part.material_override:
			var tween = create_tween()
			var original_color = part.material_override.albedo_color
			tween.tween_property(part.material_override, "albedo_color", Color.RED, 0.05)
			tween.tween_property(part.material_override, "albedo_color", original_color, 0.1)

func take_damage(damage):
	if current_state == State.DEAD:
		return
	
	current_health -= damage
	current_health = max(0, current_health)
	
	# Update health bar
	health_bar.value = current_health
	
	# Flash when hit
	flash_red()
	
	if current_health <= 0:
		die()

func die():
	current_state = State.DEAD
	zombie_died.emit()
	
	# Death animation
	var tween = create_tween()
	tween.parallel().tween_property(zombie_model, "rotation", Vector3(0, 0, PI/2), 1.0)
	
	# Fade zombie
	var body_parts = [
		zombie_model.get_node("Body"),
		zombie_model.get_node("Head"),
		zombie_model.get_node("LeftArm"),
		zombie_model.get_node("RightArm"),
		zombie_model.get_node("LeftLeg"),
		zombie_model.get_node("RightLeg")
	]
	
	for part in body_parts:
		if part and part.material_override:
			tween.parallel().tween_property(part.material_override, "albedo_color", Color(0.2, 0.2, 0.2), 1.0)
	
	# Remove after delay
	await tween.finished
	queue_free()

func _on_attack_timer_timeout():
	can_attack = true
