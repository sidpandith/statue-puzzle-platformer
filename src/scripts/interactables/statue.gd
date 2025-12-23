extends CharacterBody2D
class_name Statue

## Statue Interactable
## Created by player, affected by gravity, can be pushed.

# Physics parameters
@export var gravity: float = 1500.0 # Heavier than player (980)
@export var max_fall_speed: float = 1000.0
@export var push_friction: float = 800.0

# State
var is_statue: bool = true

func _physics_process(delta: float) -> void:
    # simple gravity
    if not is_on_floor():
        velocity.y = min(velocity.y + gravity * delta, max_fall_speed)
    
    # Apply friction to horizontal movement (from being pushed)
    if velocity.x != 0:
        velocity.x = move_toward(velocity.x, 0, push_friction * delta)
    
    move_and_slide()

# Interface for player to push statue
func push(force: Vector2) -> void:
    velocity.x = force.x
