extends GutTest

## Unit tests for EquipmentBase extending Interactable.
## Tests that equipment can be interacted with and responds correctly.

const InteractableScript = preload("res://scripts/interactable.gd")
const EquipmentBaseScript = preload("res://scripts/equipment_base.gd")

var equipment: Node


func before_each() -> void:
	equipment = EquipmentBaseScript.new()
	add_child_autofree(equipment)
	await get_tree().process_frame


func after_each() -> void:
	if is_instance_valid(equipment):
		equipment.queue_free()


# === Inheritance Tests ===


func test_equipment_extends_interactable() -> void:
	assert_true(equipment is Interactable, "Equipment should extend Interactable")
	assert_true(equipment.is_in_group("interactable"), "Should be in 'interactable' group")


func test_equipment_has_interactable_properties() -> void:
	assert_true("interaction_name" in equipment, "Should have interaction_name property")
	assert_true(
		"interaction_description" in equipment, "Should have interaction_description property"
	)
	assert_true("interaction_enabled" in equipment, "Should have interaction_enabled property")


func test_equipment_has_interact_method() -> void:
	assert_has_method(equipment, "interact", "Should have interact method")
	assert_has_method(equipment, "can_interact", "Should have can_interact method")


# === Interaction Behavior Tests ===


func test_interaction_toggles_equipment_on() -> void:
	assert_false(equipment.active, "Should be inactive initially")

	var interactor: Node2D = Node2D.new()
	add_child_autofree(interactor)

	equipment.interact(interactor)

	assert_true(equipment.active, "Should be active after interaction")


func test_interaction_toggles_equipment_off() -> void:
	var interactor: Node2D = Node2D.new()
	add_child_autofree(interactor)

	# First interaction activates
	equipment.interact(interactor)
	assert_true(equipment.active, "Should be active after first interaction")

	# Second interaction deactivates
	equipment.interact(interactor)
	assert_false(equipment.active, "Should be inactive after second interaction")


func test_interaction_emits_state_changed_signal() -> void:
	var signal_received: bool = false
	var new_state: bool = false

	equipment.state_changed.connect(
		func(state: bool) -> void:
			signal_received = true
			new_state = state
	)

	var interactor: Node2D = Node2D.new()
	add_child_autofree(interactor)
	equipment.interact(interactor)

	assert_true(signal_received, "state_changed signal should be emitted")
	assert_true(new_state, "Signal should indicate active state")


func test_interaction_emits_interacted_signal() -> void:
	var signal_received: bool = false
	var received_interactor: Node2D = null

	equipment.interacted.connect(
		func(obj: Node2D) -> void:
			signal_received = true
			received_interactor = obj
	)

	var interactor: Node2D = Node2D.new()
	add_child_autofree(interactor)
	equipment.interact(interactor)

	assert_true(signal_received, "interacted signal should be emitted")
	assert_eq(received_interactor, interactor, "Signal should pass the interactor")


func test_equipment_inherits_default_interaction_values() -> void:
	assert_eq(equipment.interaction_name, "Equipment", "Default name should be 'Equipment'")
	assert_eq(
		equipment.interaction_description,
		"Press E to toggle equipment",
		"Default description should match"
	)


func test_interaction_respects_enabled_state() -> void:
	equipment.interaction_enabled = false

	var interactor: Node2D = Node2D.new()
	add_child_autofree(interactor)

	equipment.interact(interactor)

	assert_false(equipment.active, "Should remain inactive when interaction disabled")
