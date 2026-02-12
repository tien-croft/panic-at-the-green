class_name WaterTank
extends EquipmentStation

## Water tank that stores water for irrigation and manual watering.
## Placed outside the greenhouse.

## Maximum water capacity.
const MAX_CAPACITY: float = 1000.0

## Current water level.
var water_level: float = 1000.0

## Whether the tank is being refilled.
var is_refilling: bool = false


func _init() -> void:
	equipment_type = EquipmentType.WATER_TANK
	station_name = "Water Tank"
	description = "Stores water for irrigation and watering"


func _setup_equipment() -> void:
	if equipment:
		equipment.energy_cost = 0.0


## Gets the current water level.
func get_water_level() -> float:
	return water_level


## Gets the water level as a percentage.
func get_water_percentage() -> float:
	return (water_level / MAX_CAPACITY) * 100.0


## Uses water from the tank.
## Returns the amount actually used (may be less than requested if tank is low).
func use_water(amount: float) -> float:
	var available: float = min(amount, water_level)
	water_level -= available
	_update_visual_state()
	return available


## Refills the tank by a certain amount.
func refill(amount: float) -> void:
	water_level = min(water_level + amount, MAX_CAPACITY)
	_update_visual_state()


## Override to change visual based on water level.
func _update_visual_state() -> void:
	if not sprite:
		return

	var percentage: float = get_water_percentage()
	if percentage > 50.0:
		# Full - blue tint
		sprite.modulate = Color(0.7, 0.7, 1.0, 1.0)
	elif percentage > 25.0:
		# Medium - yellow tint
		sprite.modulate = Color(1.0, 1.0, 0.7, 1.0)
	else:
		# Low - red tint
		sprite.modulate = Color(1.0, 0.7, 0.7, 1.0)


## Override toggle to prevent normal activation (water tank is always "on").
func toggle() -> void:
	# Water tank doesn't toggle on/off like other equipment
	# Instead, player can check water level when interacting
	pass
