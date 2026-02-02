class_name EquipmentBase
extends Node

## Base class for all greenhouse equipment.
## Provides a consistent interface for equipment activation/deactivation.
## Subclasses should override can_activate(), _on_activate(), and _on_deactivate().

## Emitted when the equipment's active state changes.
## Passes the new active state (true if activated, false if deactivated).
signal state_changed(is_active: bool)

## Energy cost per second when equipment is active (in energy units).
@export var energy_cost: float = 1.0

## Whether the equipment is currently active (read-only, use activate()/deactivate()).
var active: bool = false


func _ready() -> void:
	pass


## Attempts to activate the equipment.
## Only succeeds if can_activate() returns true.
## Emits state_changed signal if activation succeeds.
func activate() -> void:
	if not can_activate():
		return
	if not active:
		_set_active(true)
		_on_activate()


## Deactivates the equipment.
## Always succeeds. Emits state_changed signal.
func deactivate() -> void:
	if active:
		_set_active(false)
		_on_deactivate()


## Checks if the equipment can be activated.
## Override in subclasses to add activation conditions.
## Returns: true if equipment can activate, false otherwise.
func can_activate() -> bool:
	return true


## Called when the equipment is successfully activated.
## Override in subclasses to implement activation behavior.
func _on_activate() -> void:
	pass


## Called when the equipment is deactivated.
## Override in subclasses to implement deactivation behavior.
func _on_deactivate() -> void:
	pass


## Internal method to change active state.
## Emits state_changed signal when the value changes.
func _set_active(value: bool) -> void:
	var old_value: bool = active
	active = value
	if old_value != active:
		state_changed.emit(active)


## Set active state directly (use with caution).
## Prefer using activate()/deactivate() for proper callback handling.
## Emits state_changed signal if value changes.
func set_active(value: bool) -> void:
	_set_active(value)
