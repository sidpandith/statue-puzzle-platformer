extends Node
class_name StatueManager

## Manages active statue instances in the level
## Enforces a maximum limit and provides reset functionality

@export var max_statues: int = 15

var _active_statues: Array[Statue] = []

func add_statue(statue: Statue) -> void:
	# Add to our local tracking list
	_active_statues.append(statue)
	
	# Check limit
	if _active_statues.size() > max_statues:
		var oldest = _active_statues.pop_front()
		if is_instance_valid(oldest):
			oldest.queue_free()

func clear_statues() -> void:
	for statue in _active_statues:
		if is_instance_valid(statue):
			statue.queue_free()
	_active_statues.clear()
