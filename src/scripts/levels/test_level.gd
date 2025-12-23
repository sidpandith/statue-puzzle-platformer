extends Node2D
## Test Level script
## Test scene for Phase 2 - Statue Creation and Management

var has_moved: bool = false

@onready var info_label: Label = $UI/InfoLabel
@onready var player: CharacterBody2D = $Player
@onready var statue_manager: StatueManager = $StatueManager
@onready var spawn_point: Marker2D = $SpawnPoint

func _ready() -> void:
	print("=== Phase 2 Test Level ===")
	print("Testing Statue Mechanics")
	print("Controls:")
	print("  WASD/Arrows - Move")
	print("  W/Up - Jump")
	print("  C/X - Turn into Statue")
	print("  R - Restart Level")
	print("  ESC - Return to menu")
	print("")
	print("Test Features:")
	print("  - Statue creation (turn into stone)")
	print("  - Statue physics (heavy gravity)")
	print("  - Pushable interaction")
	print("  - Soft reset (player respawn, keep statues)")
	print("  - Hard reset (R key clears statues)")

	# Pass dependencies to player
	player.statue_manager = statue_manager
	player.spawn_point = spawn_point.global_position


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
		statue_manager.clear_statues()
		_reset_player()


func _reset_player() -> void:
	player.global_position = spawn_point.global_position
	player.velocity = Vector2.ZERO
	print("Level Reset (Statues Cleared)")
