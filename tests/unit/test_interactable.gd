extends GutTest

## Unit tests for the Interactable base class.
## Tests basic interaction functionality and signals.

const InteractableScript = preload("res://scripts/interactable.gd")

var interactable: Node2D


func before_each() -> void:
	interactable = InteractableScript.new()
	add_child_autofree(interactable)
	await get_tree().process_frame


func after_each() -> void:
	if is_instance_valid(interactable):
		interactable.queue_free()


# === Initialization Tests ===


func test_interactable_initializes_with_correct_defaults() -> void:
	assert_eq(
		interactable.interaction_name, "Object", "Default interaction name should be 'Object'"
	)
	assert_eq(
		interactable.interaction_description,
		"Press E to interact",
		"Default description should be 'Press E to interact'"
	)
	assert_true(interactable.interaction_enabled, "Interaction should be enabled by default")


func test_interactable_added_to_group() -> void:
	assert_true(interactable.is_in_group("interactable"), "Should be in 'interactable' group")


func test_interactable_has_required_signals() -> void:
	assert_has_signal(interactable, "interacted", "Should have 'interacted' signal")
	assert_has_signal(
		interactable, "player_entered_range", "Should have 'player_entered_range' signal"
	)
	assert_has_signal(
		interactable, "player_exited_range", "Should have 'player_exited_range' signal"
	)


# === Interaction Tests ===


func test_interact_emits_signal() -> void:
	var interactor: Node2D = Node2D.new()
	add_child_autofree(interactor)

	watch_signals(interactable)
	interactable.interact(interactor)

	assert_signal_emitted(interactable, "interacted", "interacted signal should be emitted")


func test_interact_does_nothing_when_disabled() -> void:
	interactable.interaction_enabled = false

	var signal_received: bool = false
	interactable.interacted.connect(func(_obj: Node2D) -> void: signal_received = true)

	var interactor: Node2D = Node2D.new()
	add_child_autofree(interactor)
	interactable.interact(interactor)

	assert_false(signal_received, "Signal should not be emitted when disabled")


func test_can_interact_returns_true_when_enabled() -> void:
	assert_true(interactable.can_interact(), "can_interact() should return true when enabled")


func test_can_interact_returns_false_when_disabled() -> void:
	interactable.interaction_enabled = false
	assert_false(interactable.can_interact(), "can_interact() should return false when disabled")


# === Enable/Disable Tests ===


func test_enable_interaction_enables_interaction() -> void:
	interactable.interaction_enabled = false
	interactable.enable_interaction()
	assert_true(interactable.interaction_enabled, "Should be enabled after enable_interaction()")


func test_disable_interaction_disables_interaction() -> void:
	interactable.disable_interaction()
	assert_false(interactable.interaction_enabled, "Should be disabled after disable_interaction()")


# === Setter Tests ===


func test_set_interaction_name_updates_name() -> void:
	interactable.set_interaction_name("New Name")
	assert_eq(interactable.interaction_name, "New Name", "Name should be updated")


func test_set_interaction_description_updates_description() -> void:
	interactable.set_interaction_description("New Description")
	assert_eq(
		interactable.interaction_description, "New Description", "Description should be updated"
	)
