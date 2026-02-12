class_name EquipmentStation
extends StaticBody2D

## Physical equipment station that can be placed in the world and interacted with.
## Extends EquipmentBase for functionality and StaticBody2D for physics/collision.

## Emitted when player interacts with this equipment.
signal station_interacted(station: EquipmentStation)

## The type of equipment (for identification and UI).
enum EquipmentType { HEAT_PUMP, FAN, VENT, IRRIGATION, WATER_TANK }

## The equipment type.
@export var equipment_type: EquipmentType = EquipmentType.HEAT_PUMP

## Display name for UI.
@export var station_name: String = "Equipment"

## Description shown in interaction UI.
@export var description: String = "Greenhouse equipment"

## Color modulation when active (for visual feedback).
@export var active_color: Color = Color(1.0, 1.0, 1.0, 1.0)

## Color modulation when inactive (for visual feedback).
@export var inactive_color: Color = Color(0.6, 0.6, 0.6, 1.0)

## The underlying equipment logic.
var equipment: EquipmentBase

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	_create_equipment()
	_update_visual_state()
	if equipment:
		equipment.state_changed.connect(_on_equipment_state_changed)


## Creates the appropriate equipment logic based on type.
## Override in subclasses for specific equipment behavior.
func _create_equipment() -> void:
	equipment = EquipmentBase.new()
	equipment.name = "EquipmentLogic"
	add_child(equipment)
	_setup_equipment()


## Sets up equipment-specific properties.
## Override in subclasses to configure the equipment.
func _setup_equipment() -> void:
	pass


## Called when player interacts with this station.
func interact(player: Node2D) -> void:
	station_interacted.emit(self)


## Toggle the equipment on/off.
func toggle() -> void:
	if not equipment:
		return
	if equipment.active:
		equipment.deactivate()
	else:
		equipment.activate()


## Activate the equipment.
func activate() -> void:
	if equipment:
		equipment.activate()


## Deactivate the equipment.
func deactivate() -> void:
	if equipment:
		equipment.deactivate()


## Returns whether the equipment is currently active.
func is_active() -> bool:
	if not equipment:
		return false
	return equipment.active


## Returns the equipment type as a string.
func get_type_string() -> String:
	match equipment_type:
		EquipmentType.HEAT_PUMP:
			return "Heat Pump"
		EquipmentType.FAN:
			return "Fan"
		EquipmentType.VENT:
			return "Vent"
		EquipmentType.IRRIGATION:
			return "Irrigation"
		EquipmentType.WATER_TANK:
			return "Water Tank"
		_:
			return "Unknown"


## Called when equipment state changes.
func _on_equipment_state_changed(_is_active: bool) -> void:
	_update_visual_state()


## Updates the sprite color based on active state.
func _update_visual_state() -> void:
	if not sprite:
		return
	if is_active():
		sprite.modulate = active_color
	else:
		sprite.modulate = inactive_color


## Gets the energy cost per second.
func get_energy_cost() -> float:
	if not equipment:
		return 0.0
	return equipment.energy_cost
