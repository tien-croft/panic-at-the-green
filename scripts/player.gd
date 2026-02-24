class_name Player
extends CharacterBody2D

## The player character that walks around the greenhouse and interacts with objects.
## Handles movement input, collision detection, and interaction detection.

## Emitted when the player interacts with an object.
## Passes the object being interacted with.
signal interacted(object: Node2D)

## Emitted when a nearby interactable object is detected.
## Passes the object that can be interacted with.
signal interaction_available(object: Node2D)

## Emitted when no interactable objects are nearby.
signal interaction_unavailable

## Facing directions for player animations and interaction positioning.
enum Direction { DOWN, LEFT, RIGHT, UP }

## Movement speed in pixels per second.
@export var speed: float = 200.0

## Interaction radius in pixels.
@export var interaction_radius: float = 64.0

## Current facing direction.
var facing_direction: Direction = Direction.DOWN

## Current movement state.
var is_moving: bool = false

## Animation variables
var _animation_timer: float = 0.0
var _current_frame: int = 0
@export var animation_speed: float = 8.0

## Reference to the interaction detector area.
@onready var interaction_detector: Area2D = $InteractionDetector
@onready var sprite: Sprite2D = $Sprite2D
@onready var camera: Camera2D = $Camera2D


func _ready() -> void:
	if interaction_detector:
		interaction_detector.body_entered.connect(_on_interaction_detector_body_entered)
		interaction_detector.body_exited.connect(_on_interaction_detector_body_exited)
		_update_interaction_detector_shape()


func _physics_process(delta: float) -> void:
	var input_direction: Vector2 = _get_input_direction()

	if input_direction.length() > 0:
		_update_facing_direction(input_direction)
		is_moving = true
		_update_animation(delta)
	else:
		is_moving = false
		_reset_to_idle()

	velocity = input_direction * speed
	move_and_slide()
	_update_nearby_interactables()


func _update_animation(delta: float) -> void:
	_animation_timer += delta * animation_speed
	if _animation_timer >= 1.0:
		_animation_timer = 0.0
		_current_frame = (_current_frame + 1) % 4 # Assuming 4 walk frames
		_update_sprite_frame()


func _reset_to_idle() -> void:
	_current_frame = 0 # Assuming frame 0 is idle
	_update_sprite_frame()


func _update_sprite_frame() -> void:
	var row: int = 0
	match facing_direction:
		Direction.DOWN: row = 0
		Direction.UP: row = 1
		Direction.LEFT: row = 2
		Direction.RIGHT: row = 3

	sprite.frame = (row * sprite.hframes) + _current_frame


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		_try_interact()


## Gets the current input direction from WASD or arrow keys.
## Returns normalized Vector2 representing input direction.
func _get_input_direction() -> Vector2:
	var direction: Vector2 = Vector2.ZERO

	if Input.is_action_pressed("ui_up"):
		direction.y -= 1.0
	if Input.is_action_pressed("ui_down"):
		direction.y += 1.0
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1.0
	if Input.is_action_pressed("ui_right"):
		direction.x += 1.0

	if direction.length() > 0:
		direction = direction.normalized()

	return direction


## Updates the facing direction based on movement input.
func _update_facing_direction(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			facing_direction = Direction.RIGHT
		else:
			facing_direction = Direction.LEFT
	else:
		if direction.y > 0:
			facing_direction = Direction.DOWN
		else:
			facing_direction = Direction.UP


## Updates the interaction detector's collision shape to match interaction_radius.
func _update_interaction_detector_shape() -> void:
	if not interaction_detector:
		return

	var circle_shape: CircleShape2D = CircleShape2D.new()
	circle_shape.radius = interaction_radius

	var collision_shape: CollisionShape2D
	if interaction_detector.get_child_count() > 0:
		collision_shape = interaction_detector.get_child(0) as CollisionShape2D
	else:
		collision_shape = CollisionShape2D.new()
		interaction_detector.add_child(collision_shape)

	collision_shape.shape = circle_shape


## Called when a body enters the interaction detector area.
func _on_interaction_detector_body_entered(body: Node2D) -> void:
	if _is_interactable(body):
		_update_nearby_interactables()


## Called when a body exits the interaction detector area.
func _on_interaction_detector_body_exited(body: Node2D) -> void:
	if _is_interactable(body):
		_update_nearby_interactables()


## Checks if a node is interactable.
## Returns true if the node is in the "interactable" group or has an "interact" method.
func _is_interactable(node: Node2D) -> bool:
	return node.is_in_group("interactable") or node.has_method("interact")


## Updates the list of nearby interactable objects and emits signals.
func _update_nearby_interactables() -> void:
	var old_nearby: Array[Node2D] = _nearby_interactables.duplicate()
	_nearby_interactables.clear()

	if not interaction_detector:
		return

	var overlapping_bodies: Array[Node2D] = interaction_detector.get_overlapping_bodies()
	for body in overlapping_bodies:
		if _is_interactable(body):
			_nearby_interactables.append(body)

	# Sort by distance to player (closest first)
	_nearby_interactables.sort_custom(
		func(a: Node2D, b: Node2D) -> bool:
			var dist_a: float = global_position.distance_to(a.global_position)
			var dist_b: float = global_position.distance_to(b.global_position)
			return dist_a < dist_b
	)

	# Emit signals based on availability change
	if _nearby_interactables.size() > 0 and old_nearby.size() == 0:
		interaction_available.emit(_nearby_interactables[0])
	elif _nearby_interactables.size() == 0 and old_nearby.size() > 0:
		interaction_unavailable.emit()
	elif _nearby_interactables.size() > 0 and old_nearby.size() > 0:
		if _nearby_interactables[0] != old_nearby[0]:
			interaction_available.emit(_nearby_interactables[0])


## Attempts to interact with the closest nearby interactable object.
func _try_interact() -> void:
	if _nearby_interactables.size() == 0:
		return

	var target: Node2D = _nearby_interactables[0]
	if target.has_method("interact"):
		target.interact(self)
		interacted.emit(target)


## Gets the closest interactable object within range.
## Returns the closest interactable Node2D or null if none available.
func get_closest_interactable() -> Node2D:
	if _nearby_interactables.size() == 0:
		return null
	return _nearby_interactables[0]


## Returns true if there are interactable objects nearby.
func has_nearby_interactable() -> bool:
	return _nearby_interactables.size() > 0


## Gets the number of nearby interactable objects.
func get_nearby_interactable_count() -> int:
	return _nearby_interactables.size()


## Sets the interaction radius. Updates the collision shape immediately.
func set_interaction_radius(radius: float) -> void:
	interaction_radius = radius
	_update_interaction_detector_shape()
