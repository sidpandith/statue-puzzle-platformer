extends Control
## Main Menu script
## Handles navigation from the main menu

func _ready() -> void:
	print("Main Menu loaded")
	print("GameState total stars: ", GameState.get_total_stars())


func _on_play_button_pressed() -> void:
	print("Loading test level...")
	SceneLoader.load_scene("res://scenes/levels/test_level.tscn")


func _on_quit_button_pressed() -> void:
	print("Quitting game...")
	get_tree().quit()
