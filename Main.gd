extends Node3D

@onready var player = $Player
@onready var ui = $UI/UIControl
@onready var spawn_timer = $SpawnTimer
@onready var wave_timer = $WaveTimer

# Audio nodes
@onready var background_music = $AudioSystem/BackgroundMusic
@onready var ambient_sounds = $AudioSystem/AmbientSounds
@onready var gunshot_sound = $AudioSystem/GunShotSound
@onready var reload_sound = $AudioSystem/ReloadSound
@onready var zombie_groan_sound = $AudioSystem/ZombieGroanSound
@onready var zombie_death_sound = $AudioSystem/ZombieDeathSound
@onready var wave_complete_sound = $AudioSystem/WaveCompleteSound

var zombie_scene = preload("res://Zombie.tscn")
var spawn_points = []
var current_wave = 1
var base_zombies_per_wave = 8
var zombies_remaining = 0
var zombies_killed = 0
var wave_active = false
var wave_break_time = 3.0
var max_waves = 100
var zombies_alive = 0
var max_zombies_alive = 50
var zombie_multiplier = 8  # Multiplier for zombie count per wave
var difficulty_scaling = 1.2  # Additional difficulty scaling per wave

signal wave_started(wave_number)
signal wave_completed(wave_number)
signal game_over

func get_current_wave():
	return current_wave

func _ready():
	setup_spawn_points()
	setup_ui()
	setup_audio()
	start_next_wave()

func setup_audio():
	# Create procedural audio streams
	create_background_music()
	create_ambient_sounds()
	create_sound_effects()

func create_background_music():
	# Create atmospheric background music
	create_and_play_sound(background_music, 110.0, 8.0, 0.12, "background")

func create_ambient_sounds():
	# Create eerie ambient sounds
	create_and_play_sound(ambient_sounds, 65.0, 6.0, 0.1, "ambient")

func create_sound_effects():
	# Initialize sound effect generators
	for sound_player in [gunshot_sound, reload_sound, zombie_groan_sound, zombie_death_sound, wave_complete_sound]:
		var generator = AudioStreamGenerator.new()
		generator.mix_rate = 44100.0
		generator.buffer_length = 0.1
		sound_player.stream = generator

func _on_background_music_finished():
	create_background_music()  # Loop with regenerated music

func _on_ambient_sounds_finished():
	create_ambient_sounds()  # Loop with regenerated ambient

func play_gunshot():
	# Create realistic gunshot with explosion and echo
	create_and_play_sound(gunshot_sound, 1200.0, 0.2, 0.4, "gunshot")

func play_reload():
	# Create detailed mechanical reload sound
	create_and_play_sound(reload_sound, 300.0, 0.8, 0.25, "reload")

func play_zombie_groan():
	# Create menacing zombie groan with vocal harmonics
	create_and_play_sound(zombie_groan_sound, 75.0, 1.5, 0.2, "zombie_groan")

func play_zombie_death():
	# Create dramatic death wail with fading effect
	create_and_play_sound(zombie_death_sound, 180.0, 1.2, 0.3, "zombie_death")

func play_wave_complete():
	# Create triumphant victory chord
	create_and_play_sound(wave_complete_sound, 440.0, 0.8, 0.5, "wave_complete")

func play_footstep():
	# Create realistic footstep sound
	create_and_play_sound(gunshot_sound, 150.0, 0.15, 0.15, "footstep")

func create_and_play_sound(audio_player: AudioStreamPlayer, frequency: float, duration: float, volume: float, sound_type: String = "default"):
	# Create ultra-realistic sound with advanced synthesis
	var samples = int(44100 * duration)
	var audio_data = PackedFloat32Array()
	
	for i in samples:
		var time = float(i) / 44100.0
		var progress = time / duration
		
		var sample = 0.0
		
		match sound_type:
			"gunshot":
				# Realistic gunshot with explosion and echo
				var explosion = exp(-time * 12.0) * sin(2.0 * PI * frequency * time)
				var crack = exp(-time * 25.0) * sin(2.0 * PI * frequency * 3.0 * time) * 0.7
				var echo = exp(-time * 3.0) * sin(2.0 * PI * frequency * 0.8 * time) * 0.3
				var noise = (randf() - 0.5) * 0.6 * exp(-time * 8.0)
				sample = explosion + crack + echo + noise
				
			"zombie_groan":
				# Deep, menacing zombie groan with vocal harmonics
				var base = sin(2.0 * PI * frequency * time)
				var growl = sin(2.0 * PI * frequency * 0.5 * time) * 0.8
				var rattle = sin(2.0 * PI * frequency * 1.8 * time) * 0.4
				var breath = sin(2.0 * PI * frequency * 0.3 * time) * 0.6
				var vocal_distortion = sin(2.0 * PI * frequency * 2.1 * time) * 0.3
				# Add breathing effect
				var breathing = sin(2.0 * PI * 2.0 * time) * 0.2
				sample = (base + growl + rattle + breath + vocal_distortion) * (1.0 + breathing)
				# Apply growling envelope
				var envelope = sin(PI * progress) * (1.0 - progress * 0.2) * (0.8 + 0.4 * sin(2.0 * PI * 8.0 * time))
				sample *= envelope
				
			"zombie_death":
				# Dramatic death wail with fading effect
				var wail = sin(2.0 * PI * frequency * time)
				var high_pitch = sin(2.0 * PI * frequency * 2.5 * time) * 0.6
				var gurgle = sin(2.0 * PI * frequency * 0.7 * time) * 0.8
				var rattle = (randf() - 0.5) * 0.4 * sin(2.0 * PI * 15.0 * time)
				sample = wail + high_pitch + gurgle + rattle
				# Fading death envelope
				var envelope = (1.0 - progress) * sin(PI * progress * 2.0)
				sample *= envelope
				
			"reload":
				# Mechanical reload with metal clicks and spring sounds
				var metal_click = sin(2.0 * PI * frequency * 4.0 * time) * exp(-time * 15.0)
				var spring = sin(2.0 * PI * frequency * 2.0 * time) * exp(-time * 8.0) * 0.6
				var slide = sin(2.0 * PI * frequency * 1.5 * time) * 0.4
				var noise = (randf() - 0.5) * 0.3 * exp(-time * 5.0)
				sample = metal_click + spring + slide + noise
				
			"footstep":
				# Realistic footstep with impact and texture
				var impact = exp(-time * 20.0) * sin(2.0 * PI * frequency * time)
				var scrape = (randf() - 0.5) * 0.4 * exp(-time * 10.0)
				var ground_texture = sin(2.0 * PI * frequency * 0.8 * time) * 0.3 * exp(-time * 5.0)
				sample = impact + scrape + ground_texture
				
			"wave_complete":
				# Triumphant victory chord
				var note1 = sin(2.0 * PI * frequency * time)
				var note2 = sin(2.0 * PI * frequency * 1.25 * time) * 0.8
				var note3 = sin(2.0 * PI * frequency * 1.5 * time) * 0.6
				var harmonic = sin(2.0 * PI * frequency * 2.0 * time) * 0.4
				sample = note1 + note2 + note3 + harmonic
				# Victory envelope
				var envelope = sin(PI * progress) * (1.0 - progress * 0.3)
				sample *= envelope
				
			"background":
				# Atmospheric background with multiple layers
				var drone = sin(2.0 * PI * frequency * time) * 0.3
				var wind = sin(2.0 * PI * frequency * 0.7 * time) * 0.4
				var distant = sin(2.0 * PI * frequency * 1.3 * time) * 0.2
				var subtle_noise = (randf() - 0.5) * 0.1
				sample = drone + wind + distant + subtle_noise
				
			"ambient":
				# Eerie ambient sounds
				var low_freq = sin(2.0 * PI * frequency * time) * 0.5
				var whistle = sin(2.0 * PI * frequency * 3.2 * time) * 0.3
				var distant_echo = sin(2.0 * PI * frequency * 0.6 * time) * 0.4
				var atmospheric = (randf() - 0.5) * 0.2
				sample = low_freq + whistle + distant_echo + atmospheric
				
			_:  # default
				sample = sin(2.0 * PI * frequency * time) * 0.8
				sample += sin(2.0 * PI * frequency * 2.0 * time) * 0.4
				sample += (randf() - 0.5) * 0.2
		
		# Apply volume
		sample *= volume
		
		# Clamp to prevent distortion
		sample = clamp(sample, -1.0, 1.0)
		audio_data.append(sample)
	
	# Create AudioStreamWAV and set the data
	var stream = AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = 44100
	stream.data = audio_data.to_byte_array()
	
	audio_player.stream = stream
	audio_player.play()
	
func setup_spawn_points():
	# Create spawn points around the much larger arena perimeter
	var arena_radius = 55.0
	var spawn_count = 20
	
	for i in spawn_count:
		var angle = (2.0 * PI * i) / spawn_count
		var spawn_point = Vector3(
			cos(angle) * arena_radius,
			0.5,
			sin(angle) * arena_radius
		)
		spawn_points.append(spawn_point)

func setup_ui():
	var initial_zombies = calculate_zombies_for_wave(current_wave)
	ui.update_wave(current_wave)
	ui.update_zombies_remaining(initial_zombies)
	
	# Connect player signals to UI
	player.health_changed.connect(ui.update_health)
	player.ammo_changed.connect(ui.update_ammo)
	
	# Connect player audio signals
	player.gunshot_fired.connect(play_gunshot)
	player.reload_started.connect(play_reload)
	player.footstep_made.connect(play_footstep)

func calculate_zombies_for_wave(wave: int) -> int:
	# More aggressive zombie scaling: base + (wave * multiplier)
	return base_zombies_per_wave + (wave - 1) * zombie_multiplier

func start_next_wave():
	if current_wave > max_waves:
		ui.show_wave_message("You Win! All waves completed!")
		return
		
	wave_active = true
	var zombies_this_wave = calculate_zombies_for_wave(current_wave)
	zombies_remaining = zombies_this_wave
	zombies_killed = 0
	zombies_alive = 0
	
	ui.update_wave(current_wave)
	ui.update_zombies_remaining(zombies_remaining)
	ui.show_wave_message("Wave " + str(current_wave) + " - " + str(zombies_this_wave) + " Zombies!")
	
	wave_started.emit(current_wave)
	
	# Start spawning zombies - much faster spawn rate in later waves
	spawn_timer.wait_time = max(0.2, 1.0 - (current_wave * 0.03))
	spawn_timer.start()

func spawn_zombie():
	if zombies_remaining <= 0:
		return
		
	var zombie = zombie_scene.instantiate()
	var spawn_point = spawn_points[randi() % spawn_points.size()]
	
	zombie.global_position = spawn_point
	zombie.target = player
	zombie.connect("zombie_died", _on_zombie_died)
	
	# Connect zombie audio signals
	zombie.connect("zombie_groan", play_zombie_groan)
	
	add_child(zombie)
	zombies_remaining -= 1
	zombies_alive += 1
	
	ui.update_zombies_remaining(zombies_remaining)
	
	# Play groan sound when zombie spawns
	play_zombie_groan()
	
	if zombies_remaining <= 0:
		spawn_timer.stop()

func _on_zombie_died():
	zombies_killed += 1
	zombies_alive -= 1
	
	# Play zombie death sound
	play_zombie_death()
	
	# Check if wave is complete
	var total_zombies_this_wave = calculate_zombies_for_wave(current_wave)
	if zombies_killed >= total_zombies_this_wave and zombies_remaining <= 0:
		complete_wave()

func complete_wave():
	wave_active = false
	wave_completed.emit(current_wave)
	
	ui.show_wave_message("Wave " + str(current_wave) + " Complete!")
	
	# Play wave complete sound
	play_wave_complete()
	
	current_wave += 1
	
	# Start break timer
	wave_timer.wait_time = wave_break_time
	wave_timer.start()

func _on_spawn_timer_timeout():
	spawn_zombie()

func _on_wave_timer_timeout():
	start_next_wave()

func _on_player_died():
	game_over.emit()
	ui.show_game_over()
	get_tree().paused = true
