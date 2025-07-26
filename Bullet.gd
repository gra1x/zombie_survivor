extends RigidBody3D

@onready var mesh_instance = $MeshInstance3D
@onready var collision_shape = $CollisionShape3D
@onready var lifetime_timer = $LifetimeTimer

var speed = 30.0
var damage = 25
var lifetime = 5.0
var direction = Vector3.FORWARD

func _ready():
	setup_bullet()
	
	# Set lifetime
	lifetime_timer.wait_time = lifetime
	lifetime_timer.start()
	
	# Connect signals only if not already connected
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not lifetime_timer.timeout.is_connected(_on_lifetime_timeout):
		lifetime_timer.timeout.connect(_on_lifetime_timeout)

func setup_bullet():
	# Create bullet mesh (small sphere)
	var sphere_mesh = SphereMesh.new()
	sphere_mesh.radius = 0.05
	sphere_mesh.height = 0.1
	mesh_instance.mesh = sphere_mesh
	
	# Create material
	var material = StandardMaterial3D.new()
	material.albedo_color = Color.YELLOW
	material.emission_enabled = true
	material.emission = Color.YELLOW
	mesh_instance.material_override = material
	
	# Setup collision
	var sphere_shape = SphereShape3D.new()
	sphere_shape.radius = 0.05
	collision_shape.shape = sphere_shape
	
	# Physics settings
	gravity_scale = 0.0
	collision_layer = 4  # Bullets layer
	collision_mask = 6   # Enemies + Environment layers
	contact_monitor = true
	max_contacts_reported = 10

func set_direction(new_direction: Vector3):
	direction = new_direction.normalized()
	linear_velocity = direction * speed

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	
	# Create impact effect
	create_impact_effect()
	
	# Destroy bullet
	queue_free()

func create_impact_effect():
	# Simple particle effect (could be expanded)
	for i in range(5):
		var particle = MeshInstance3D.new()
		var sphere = SphereMesh.new()
		sphere.radius = 0.02
		particle.mesh = sphere
		
		var material = StandardMaterial3D.new()
		material.albedo_color = Color.ORANGE
		particle.material_override = material
		
		get_parent().add_child(particle)
		particle.global_position = global_position
		
		# Animate particles
		var tween = create_tween()
		var random_dir = Vector3(
			randf_range(-1, 1),
			randf_range(-1, 1),
			randf_range(-1, 1)
		).normalized()
		
		tween.parallel().tween_property(particle, "global_position", 
			particle.global_position + random_dir * 2.0, 0.5)
		tween.parallel().tween_property(particle.material_override, "albedo_color", 
			Color.TRANSPARENT, 0.5)
		
		tween.finished.connect(func(): particle.queue_free())

func _on_lifetime_timeout():
	queue_free()
