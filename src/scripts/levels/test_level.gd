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
	print("  R - Restart Level")
	print("  ESC - Return to menu")
	print("")
	print("Test Features:")
	print("  - Horizontal movement with acceleration")
	print("  - Gravity and max fall speed")
	print("  - Jump with coyote time (grace period after leaving ledge)")
	print("  - Variable jump height (release early for shorter jump)")
	print("  - Level reset functionality")


var has_moved: bool = false
@onready var info_label: Label = $UI/InfoLabel


func _process(_delta: float) -> void:
	# Hide instructions on first movement
	if not has_moved:
		if Input.is_action_pressed("move_left") or \
		   Input.is_action_pressed("move_right") or \
		   Input.is_action_pressed("jump"):
			has_moved = true
			var tween = create_tween()
			tween.tween_property(info_label, "modulate:a", 0.0, 1.0)
	
	# ESC to return to menu
	if Input.is_action_just_pressed("ui_cancel"):
		print("Returning to main menu...")
		SceneLoader.load_scene("res://scenes/ui/main_menu.tscn")
	
	# Restart level
	if Input.is_action_just_pressed("restart_level"):
		print("Restarting level...")
		SceneLoader.reload_current_scene()
