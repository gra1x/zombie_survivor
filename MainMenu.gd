extends Control

func _ready():
	setup_menu()

func setup_menu():
	# Get the VBoxContainer
	var vbox = get_node("VBoxContainer")
	
	# Set up the VBox layout
	vbox.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	vbox.position = Vector2(get_viewport().size.x / 2 - 300, get_viewport().size.y / 2 - 200)
	vbox.custom_minimum_size = Vector2(600, 400)
	
	# Configure title label
	var title = get_node("VBoxContainer/TitleLabel")
	title.text = "ZOMBIE ARENA"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 64)
	title.add_theme_color_override("font_color", Color.RED)
	
	# Configure play button
	var play_btn = get_node("VBoxContainer/PlayButton")
	play_btn.text = "START GAME"
	play_btn.add_theme_font_size_override("font_size", 32)
	play_btn.custom_minimum_size = Vector2(300, 60)
	play_btn.pressed.connect(_on_play_button_pressed)
	
	# Configure quit button
	var quit_btn = get_node("VBoxContainer/QuitButton")
	quit_btn.text = "QUIT"
	quit_btn.add_theme_font_size_override("font_size", 32)
	quit_btn.custom_minimum_size = Vector2(300, 60)
	quit_btn.pressed.connect(_on_quit_button_pressed)
	
	# Configure instructions
	var instructions = get_node("VBoxContainer/InstructionsLabel")
	instructions.text = "CONTROLS:\nWASD - Move\nMouse - Look\nLeft Click - Shoot\nR - Reload\nSpace - Jump\n\nSURVIVE 100 WAVES!\nZombies RUN FAST when close!"
	instructions.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	instructions.add_theme_font_size_override("font_size", 18)
	instructions.add_theme_color_override("font_color", Color.WHITE)

func _on_play_button_pressed():
	print("Starting game...")
	get_tree().change_scene_to_file("res://Main.tscn")

func _on_quit_button_pressed():
	print("Quitting game...")
	get_tree().quit()
