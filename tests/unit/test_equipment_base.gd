# gdlint: disable=max-public-methods
extends GutTest

## Test suite for EquipmentBase functionality

const EquipmentBaseScript := preload("res://scripts/equipment_base.gd")

var equipment: EquipmentBaseScript = null


func before_each() -> void:
	equipment = EquipmentBaseScript.new()
	add_child_autofree(equipment)


func after_each() -> void:
	equipment = null


func test_initial_active_state() -> void:
	assert_false(equipment.active, "Equipment should start inactive")


func test_initial_energy_cost() -> void:
	assert_eq(equipment.energy_cost, 1.0, "Default energy cost should be 1.0")


func test_activate_sets_active_true() -> void:
	equipment.activate()
	assert_true(equipment.active, "Equipment should be active after activate()")


func test_deactivate_sets_active_false() -> void:
	equipment.activate()
	equipment.deactivate()
	assert_false(equipment.active, "Equipment should be inactive after deactivate()")


func test_can_activate_returns_true_by_default() -> void:
	assert_true(equipment.can_activate(), "can_activate() should return true by default")


func test_activate_emits_state_changed_signal() -> void:
	watch_signals(equipment)
	equipment.activate()
	assert_signal_emitted(
		equipment, "state_changed", "state_changed signal should be emitted on activate"
	)


func test_deactivate_emits_state_changed_signal() -> void:
	equipment.activate()
	watch_signals(equipment)
	equipment.deactivate()
	assert_signal_emitted(
		equipment, "state_changed", "state_changed signal should be emitted on deactivate"
	)


func test_activate_does_not_emit_when_already_active() -> void:
	equipment.activate()
	watch_signals(equipment)
	equipment.activate()
	assert_signal_not_emitted(
		equipment, "state_changed", "Signal should not emit when already active"
	)


func test_deactivate_does_not_emit_when_already_inactive() -> void:
	watch_signals(equipment)
	equipment.deactivate()
	assert_signal_not_emitted(
		equipment, "state_changed", "Signal should not emit when already inactive"
	)


func test_activate_fails_if_can_activate_returns_false() -> void:
	var test_equipment := TestEquipmentCannotActivate.new()
	add_child_autofree(test_equipment)

	test_equipment.activate()
	assert_false(
		test_equipment.active, "Equipment should not activate when can_activate() returns false"
	)


func test_on_activate_called_when_activated() -> void:
	var test_equipment := TestEquipmentWithCallbacks.new()
	add_child_autofree(test_equipment)

	test_equipment.activate()
	assert_true(test_equipment.on_activate_called, "_on_activate() should be called when activated")


func test_on_deactivate_called_when_deactivated() -> void:
	var test_equipment := TestEquipmentWithCallbacks.new()
	add_child_autofree(test_equipment)

	test_equipment.activate()
	test_equipment.deactivate()
	assert_true(
		test_equipment.on_deactivate_called, "_on_deactivate() should be called when deactivated"
	)


func test_on_activate_not_called_if_can_activate_fails() -> void:
	var test_equipment := TestEquipmentCannotActivateWithCallback.new()
	add_child_autofree(test_equipment)

	test_equipment.activate()
	assert_false(
		test_equipment.on_activate_called,
		"_on_activate() should not be called if can_activate() fails"
	)


func test_active_property_can_be_set_directly() -> void:
	equipment.active = true
	assert_true(equipment.active, "Equipment active property can be set directly")


func test_set_active_emits_signal() -> void:
	watch_signals(equipment)
	equipment.set_active(true)
	assert_signal_emitted(equipment, "state_changed", "set_active() should emit signal")


func test_energy_cost_can_be_modified() -> void:
	equipment.energy_cost = 5.0
	assert_eq(equipment.energy_cost, 5.0, "Energy cost should be modifiable")


## Test equipment that cannot activate (always returns false)
class TestEquipmentCannotActivate:
	extends EquipmentBaseScript

	func can_activate() -> bool:
		return false


## Test equipment that tracks callback invocations
class TestEquipmentWithCallbacks:
	extends EquipmentBaseScript
	var on_activate_called: bool = false
	var on_deactivate_called: bool = false

	func _on_activate() -> void:
		on_activate_called = true

	func _on_deactivate() -> void:
		on_deactivate_called = true


## Test equipment that cannot activate but tracks if _on_activate was called
class TestEquipmentCannotActivateWithCallback:
	extends EquipmentBaseScript
	var on_activate_called: bool = false

	func can_activate() -> bool:
		return false

	func _on_activate() -> void:
		on_activate_called = true
