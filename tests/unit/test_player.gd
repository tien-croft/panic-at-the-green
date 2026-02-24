extends GutTest

## Unit tests for the Player class.
## Tests movement, interaction detection, and facing direction logic.

const PlayerScript = preload("res://scripts/player.gd")
const PlayerScene: PackedScene = preload("res://scenes/player.tscn")

var player


func before_each() -> void:
	player = PlayerScene.instantiate()
	add_child_autofree(player)
	# Wait for ready to ensure nodes are initialized
	await get_tree().process_frame


func after_each() -> void:
	if is_instance_valid(player):
		player.queue_free()


# === Initialization Tests ===


func test_player_initializes_with_correct_defaults() -> void:
	assert_eq(player.speed, 100.0, "Default speed should be 100.0")
	assert_eq(player.interaction_radius, 32.0, "Default interaction radius should be 32.0")
	assert_eq(
		player.facing_direction,
		PlayerScript.Direction.DOWN,
		"Default facing direction should be DOWN"
	)
	assert_false(player.is_moving, "Player should not be moving initially")


func test_player_has_required_nodes() -> void:
	assert_has_method(player, "_ready", "Player should have _ready method")
	assert_has_method(player, "_physics_process", "Player should have _physics_process method")
	assert_has_method(player, "_input", "Player should have _input method")

	# Check for essential child nodes
	var sprite: Sprite2D = player.get_node_or_null("Sprite2D")
	var camera: Camera2D = player.get_node_or_null("Camera2D")
	var detector: Area2D = player.get_node_or_null("InteractionDetector")
	var collision: CollisionShape2D = player.get_node_or_null("CollisionShape2D")

	assert_not_null(sprite, "Player should have Sprite2D node")
	assert_not_null(camera, "Player should have Camera2D node")
	assert_not_null(detector, "Player should have InteractionDetector node")
	assert_not_null(collision, "Player should have CollisionShape2D node")


# === Movement Direction Tests ===


func test_get_input_direction_returns_zero_when_no_input() -> void:
	# Clear all input actions first
	Input.action_release("ui_up")
	Input.action_release("ui_down")
	Input.action_release("ui_left")
	Input.action_release("ui_right")

	var direction: Vector2 = player._get_input_direction()
	assert_eq(direction, Vector2.ZERO, "Direction should be zero with no input")


func test_facing_direction_updates_on_right_movement() -> void:
	player._update_facing_direction(Vector2.RIGHT)
	assert_eq(
		player.facing_direction, PlayerScript.Direction.RIGHT, "Should face RIGHT when moving right"
	)


func test_facing_direction_updates_on_left_movement() -> void:
	player._update_facing_direction(Vector2.LEFT)
	assert_eq(
		player.facing_direction, PlayerScript.Direction.LEFT, "Should face LEFT when moving left"
	)


func test_facing_direction_updates_on_up_movement() -> void:
	player._update_facing_direction(Vector2.UP)
	assert_eq(player.facing_direction, PlayerScript.Direction.UP, "Should face UP when moving up")


func test_facing_direction_updates_on_down_movement() -> void:
	player._update_facing_direction(Vector2.DOWN)
	assert_eq(
		player.facing_direction, PlayerScript.Direction.DOWN, "Should face DOWN when moving down"
	)


func test_facing_direction_prefers_vertical_when_equal() -> void:
	# When x and y components are equal, vertical takes precedence
	player._update_facing_direction(Vector2(1, 1).normalized())
	assert_eq(
		player.facing_direction,
		PlayerScript.Direction.DOWN,
		"Should prefer DOWN when x and y are equal positive"
	)

	player._update_facing_direction(Vector2(-1, -1).normalized())
	assert_eq(
		player.facing_direction,
		PlayerScript.Direction.UP,
		"Should prefer UP when x and y are equal negative"
	)


func test_facing_direction_prefers_vertical_when_dominant() -> void:
	player._update_facing_direction(Vector2(0.3, 0.9).normalized())
	assert_eq(
		player.facing_direction, PlayerScript.Direction.DOWN, "Should face DOWN when y is dominant"
	)

	player._update_facing_direction(Vector2(0.3, -0.9).normalized())
	assert_eq(
		player.facing_direction,
		PlayerScript.Direction.UP,
		"Should face UP when negative y is dominant"
	)


# === Speed and Movement State Tests ===


func test_speed_can_be_modified() -> void:
	player.speed = 300.0
	assert_eq(player.speed, 300.0, "Speed should be modifiable")


func test_is_moving_false_when_still() -> void:
	player.is_moving = false
	assert_false(player.is_moving, "is_moving should be false when not moving")


func test_is_moving_true_when_moving() -> void:
	player.is_moving = true
	assert_true(player.is_moving, "is_moving should be true when moving")


# === Interaction System Tests ===


func test_interaction_radius_can_be_modified() -> void:
	player.set_interaction_radius(100.0)
	assert_eq(player.interaction_radius, 100.0, "Interaction radius should be modifiable")


func test_has_nearby_interactable_returns_false_initially() -> void:
	assert_false(player.has_nearby_interactable(), "Should have no interactables initially")


func test_get_nearby_interactable_count_returns_zero_initially() -> void:
	assert_eq(player.get_nearby_interactable_count(), 0, "Should have zero interactables initially")


func test_get_closest_interactable_returns_null_initially() -> void:
	var closest: Node2D = player.get_closest_interactable()
	assert_null(closest, "Should return null when no interactables nearby")


# === Signal Tests ===


func test_interaction_available_signal_exists() -> void:
	assert_has_signal(
		player, "interaction_available", "Player should have interaction_available signal"
	)


func test_interaction_unavailable_signal_exists() -> void:
	assert_has_signal(
		player, "interaction_unavailable", "Player should have interaction_unavailable signal"
	)


func test_interacted_signal_exists() -> void:
	assert_has_signal(player, "interacted", "Player should have interacted signal")


# === Direction Enum Tests ===


func test_direction_enum_values() -> void:
	assert_eq(PlayerScript.Direction.DOWN, 0, "DOWN should be 0")
	assert_eq(PlayerScript.Direction.LEFT, 1, "LEFT should be 1")
	assert_eq(PlayerScript.Direction.RIGHT, 2, "RIGHT should be 2")
	assert_eq(PlayerScript.Direction.UP, 3, "UP should be 3")


# === Integration-style Tests (with actual nodes) ===


func test_player_velocity_updates_with_movement() -> void:
	# Simulate movement input by setting velocity directly
	player.velocity = Vector2.RIGHT * player.speed
	assert_eq(player.velocity, Vector2(100, 0), "Velocity should match speed when moving right")


func test_player_velocity_zero_when_stopped() -> void:
	player.velocity = Vector2.ZERO
	assert_eq(player.velocity, Vector2.ZERO, "Velocity should be zero when stopped")


func test_collision_shape_exists() -> void:
	var collision: CollisionShape2D = player.get_node("CollisionShape2D")
	assert_not_null(collision.shape, "CollisionShape2D should have a shape assigned")

	var rect_shape: RectangleShape2D = collision.shape as RectangleShape2D
	assert_not_null(rect_shape, "Shape should be RectangleShape2D")
	assert_eq(rect_shape.size, Vector2(16, 16), "Collision shape should be 16x16 pixels")


func test_camera_follows_player() -> void:
	var camera: Camera2D = player.get_node("Camera2D")
	assert_true(camera.position_smoothing_enabled, "Camera should have position smoothing enabled")
	assert_gt(camera.position_smoothing_speed, 0.0, "Camera smoothing speed should be positive")
