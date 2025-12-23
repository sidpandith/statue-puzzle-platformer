extends Node2D
## Test Level script
## Simple test scene to verify Phase 0 setup

func _ready() -> void:
	print("Test Level loaded")
	print("Testing autoloads...")
	print("  - GameState: ", GameState)
	print("  - SceneLoader: ", SceneLoader)
	print("  - Total stars: ", GameState.get_total_stars())


func _process(_delta: float) -> void:
	# Test input mappings
	if Input.is_action_just_pressed("move_left"):
		print("Move Left pressed")
	if Input.is_action_just_pressed("move_right"):
		print("Move Right pressed")
	if Input.is_action_just_pressed("move_up"):
		print("Move Up pressed")
	if Input.is_action_just_pressed("move_down"):
		print("Move Down pressed")
	if Input.is_action_just_pressed("jump"):
		print("Jump pressed")
	if Input.is_action_just_pressed("interact"):
		print("Interact pressed")
	if Input.is_action_just_pressed("statue"):
		print("Statue pressed")
	if Input.is_action_just_pressed("restart_level"):
		print("Restart Level pressed")
	
	# ESC to return to menu
	if Input.is_action_just_pressed("ui_cancel"):
		print("Returning to main menu...")
		SceneLoader.load_scene("res://scenes/ui/main_menu.tscn")
