extends CharacterBody2D
## Player character controller
## Handles movement, jumping, wall jumping, and coyote time

# Movement parameters
@export var speed: float = 150.0
@export var acceleration: float = 800.0
@export var friction: float = 1000.0

# Jump parameters
@export var jump_velocity: float = -300.0
@export var gravity: float = 980.0
@export var max_fall_speed: float = 500.0

# Coyote time (grace period after leaving ledge)
@export var coyote_time: float = 0.15  # seconds

# Wall jump parameters
@export var wall_jump_velocity: Vector2 = Vector2(250, -300)
@export var wall_slide_speed: float = 50.0

# Internal state
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var jump_buffer_time: float = 0.1
var was_on_floor: bool = false
var facing_direction: int = 1  # 1 = right, -1 = left

# Wall detection
@onready var wall_ray_left: RayCast2D = $WallRayLeft
@onready var wall_ray_right: RayCast2D = $WallRayRight
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	print("Player initialized")


func _physics_process(delta: float) -> void:
	# Get input direction
	var input_direction = Input.get_axis("move_left", "move_right")
	
	# Update facing direction
	if input_direction != 0:
		facing_direction = sign(input_direction)
		sprite.flip_h = facing_direction < 0
	
	# Handle horizontal movement
	_handle_horizontal_movement(input_direction, delta)
	
	# Handle gravity and vertical movement
	_handle_gravity(delta)
	
	# Handle jumping
	_handle_jump(delta)
	
	# Handle wall sliding and wall jump
	_handle_wall_mechanics(delta)
	
	# Update coyote time
	_update_coyote_time(delta)
	
	# Move the character
	move_and_slide()
	
	# Track floor state for coyote time
	was_on_floor = is_on_floor()


func _handle_horizontal_movement(input_direction: float, delta: float) -> void:
	"""Handle horizontal movement with acceleration and friction"""
	if input_direction != 0:
		# Accelerate towards target speed
		velocity.x = move_toward(velocity.x, input_direction * speed, acceleration * delta)
	else:
		# Apply friction when no input
		velocity.x = move_toward(velocity.x, 0, friction * delta)


func _handle_gravity(delta: float) -> void:
	"""Apply gravity, respecting max fall speed"""
	if not is_on_floor():
		# Check if sliding on wall
		if _is_on_wall() and velocity.y > 0:
			# Slower fall when sliding on wall
			velocity.y = move_toward(velocity.y, wall_slide_speed, gravity * delta * 0.3)
		else:
			# Normal gravity
			velocity.y = min(velocity.y + gravity * delta, max_fall_speed)
	else:
		# Reset vertical velocity when on floor
		if velocity.y > 0:
			velocity.y = 0


func _handle_jump(delta: float) -> void:
	"""Handle jump input with coyote time and jump buffering"""
	# Jump buffer - remember jump input for a short time
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
	
	# Check if we can jump (on floor or coyote time active)
	var can_jump = is_on_floor() or coyote_timer > 0
	
	if jump_buffer_timer > 0 and can_jump:
		# Perform jump
		velocity.y = jump_velocity
		coyote_timer = 0  # Reset coyote time
		jump_buffer_timer = 0  # Reset jump buffer
		print("Jump!")


func _handle_wall_mechanics(delta: float) -> void:
	"""Handle wall sliding and wall jumping"""
	if not is_on_floor() and _is_on_wall():
		# Wall jump
		if Input.is_action_just_pressed("jump"):
			var wall_normal = _get_wall_normal()
			# Jump away from wall
			velocity.x = wall_normal.x * wall_jump_velocity.x
			velocity.y = wall_jump_velocity.y
			print("Wall jump!")


func _update_coyote_time(delta: float) -> void:
	"""Update coyote time timer"""
	if is_on_floor():
		coyote_timer = coyote_time
	elif was_on_floor and not is_on_floor():
		# Just left the ground, start coyote time
		coyote_timer = coyote_time
	elif coyote_timer > 0:
		coyote_timer -= delta


func _is_on_wall() -> bool:
	"""Check if player is touching a wall"""
	return wall_ray_left.is_colliding() or wall_ray_right.is_colliding()


func _get_wall_normal() -> Vector2:
	"""Get the normal vector of the wall we're touching"""
	if wall_ray_left.is_colliding():
		return Vector2.RIGHT  # Wall is on the left, push right
	elif wall_ray_right.is_colliding():
		return Vector2.LEFT   # Wall is on the right, push left
	return Vector2.ZERO


func _input(event: InputEvent) -> void:
	"""Handle input events"""
	# Variable jump height - release jump early for shorter jump
	if event.is_action_released("jump") and velocity.y < 0:
		velocity.y *= 0.5  # Cut jump short
