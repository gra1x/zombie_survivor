extends Control

@onready var wave_label = $WaveInfo/WaveLabel
@onready var zombies_label = $WaveInfo/ZombiesLabel
@onready var health_bar = $PlayerInfo/HealthBar
@onready var health_label = $PlayerInfo/HealthLabel
@onready var ammo_label = $PlayerInfo/AmmoLabel
@onready var wave_message = $WaveMessage
@onready var game_over_panel = $GameOverPanel
@onready var restart_button = $GameOverPanel/VBoxContainer/RestartButton
@onready var quit_button = $GameOverPanel/VBoxContainer/QuitButton

func _ready():
	setup_ui()
	
	# Connect buttons
	restart_button.pressed.connect(_on_restart_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func setup_ui():
	# Hide game over panel initially
	game_over_panel.visible = false
	
	# Setup health bar
	health_bar.max_value = 100
	health_bar.value = 100
	
	# Setup wave message
	wave_message.visible = false

func update_wave(wave_number: int):
	wave_label.text = "Wave: " + str(wave_number)

func update_zombies_remaining(zombies: int):
	zombies_label.text = "Zombies: " + str(zombies)

func update_health(health: int):
	health_bar.value = health
	health_label.text = "Health: " + str(health) + "/100"
	
	# Change health bar color based on health
	if health > 70:
		health_bar.modulate = Color.GREEN
	elif health > 30:
		health_bar.modulate = Color.YELLOW
	else:
		health_bar.modulate = Color.RED

func update_ammo(current: int, max_ammo: int):
	ammo_label.text = "Ammo: " + str(current) + "/" + str(max_ammo)
	
	# Change color based on ammo level
	if current == 0:
		ammo_label.modulate = Color.RED
	elif current <= max_ammo * 0.3:
		ammo_label.modulate = Color.YELLOW
	else:
		ammo_label.modulate = Color.WHITE

func show_wave_message(message: String):
	wave_message.text = message
	wave_message.visible = true
	
	# Animate message
	var tween = create_tween()
	wave_message.modulate.a = 0.0
	tween.tween_property(wave_message, "modulate:a", 1.0, 0.5)
	tween.tween_interval(2.0)
	tween.tween_property(wave_message, "modulate:a", 0.0, 0.5)
	tween.finished.connect(func(): wave_message.visible = false)

func show_game_over():
	game_over_panel.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_restart_pressed():
	print("Restart button pressed!")
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().quit()
