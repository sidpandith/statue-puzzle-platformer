extends Node
## SceneLoader autoload singleton
## Handles scene transitions and loading/unloading with optional fade effects

signal scene_loaded(scene_path: String)
signal scene_unloaded(scene_path: String)

var current_scene: Node = null
var is_transitioning: bool = false

# Fade overlay for transitions
var fade_overlay: ColorRect = null
var fade_duration: float = 0.3


func _ready() -> void:
	print("SceneLoader initialized")
	
	# Get the current scene
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	
	# Create fade overlay
	_create_fade_overlay()


## Create a fullscreen fade overlay for transitions
func _create_fade_overlay() -> void:
	fade_overlay = ColorRect.new()
	fade_overlay.color = Color.BLACK
	fade_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Make it cover the entire screen
	fade_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	fade_overlay.z_index = 100  # Ensure it's on top
	fade_overlay.modulate.a = 0.0  # Start invisible
	
	# Add to the scene tree (as a CanvasLayer for proper layering)
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100
	canvas_layer.name = "FadeOverlay"
	canvas_layer.add_child(fade_overlay)
	add_child(canvas_layer)


## Load a new scene with optional fade transition
func load_scene(scene_path: String, use_fade: bool = true) -> void:
	if is_transitioning:
		print("Already transitioning, ignoring load request")
		return
	
	if use_fade:
		await _fade_out()
	
	_change_scene(scene_path)
	
	if use_fade:
		await _fade_in()


## Change the current scene (internal)
func _change_scene(scene_path: String) -> void:
	is_transitioning = true
	
	# Free the current scene
	if current_scene:
		scene_unloaded.emit(current_scene.scene_file_path)
		current_scene.queue_free()
		await current_scene.tree_exited
	
	# Load the new scene
	var new_scene = load(scene_path).instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	current_scene = new_scene
	
	scene_loaded.emit(scene_path)
	is_transitioning = false


## Reload the current scene
func reload_current_scene(use_fade: bool = true) -> void:
	if current_scene and current_scene.scene_file_path:
		load_scene(current_scene.scene_file_path, use_fade)
	else:
		print("Cannot reload: no current scene path")


## Fade out (to black)
func _fade_out() -> void:
	if not fade_overlay:
		return
	
	fade_overlay.mouse_filter = Control.MOUSE_FILTER_STOP  # Block input during fade
	
	var tween = create_tween()
	tween.tween_property(fade_overlay, "modulate:a", 1.0, fade_duration)
	await tween.finished


## Fade in (from black)
func _fade_in() -> void:
	if not fade_overlay:
		return
	
	var tween = create_tween()
	tween.tween_property(fade_overlay, "modulate:a", 0.0, fade_duration)
	await tween.finished
	
	fade_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE  # Re-enable input


## Quick scene change without fade
func quick_load_scene(scene_path: String) -> void:
	load_scene(scene_path, false)


## Set fade duration for transitions
func set_fade_duration(duration: float) -> void:
	fade_duration = duration
