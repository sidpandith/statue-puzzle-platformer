extends Node2D
## Test Level script
## Test scene for Phase 1 - Core Character Controller

func _ready() -> void:
	print("=== Phase 1 Test Level ===")
	print("Testing player movement and physics")
	print("Controls:")
	print("  WASD/Arrows - Move")
	print("  W/Up - Jump (hold for higher jump)")
	print("  Wall Jump - Jump while touching red walls")
	print("  ESC - Return to menu")
	print("")
	print("Test Features:")
	print("  - Horizontal movement with acceleration")
	print("  - Gravity and max fall speed")
	print("  - Jump with coyote time (grace period after leaving ledge)")
	print("  - Variable jump height (release early for shorter jump)")
	print("  - Wall sliding and wall jump")


func _process(_delta: float) -> void:
	# ESC to return to menu
	if Input.is_action_just_pressed("ui_cancel"):
		print("Returning to main menu...")
		SceneLoader.load_scene("res://scenes/ui/main_menu.tscn")
