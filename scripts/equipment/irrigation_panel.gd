class_name IrrigationPanel
extends EquipmentStation

## Irrigation control panel that manages watering and humidity.
## Placed inside the greenhouse.

## Rate at which humidity increases per second when active (percentage).
@export var humidity_rate: float = 0.5

## Target humidity level to maintain (percentage).
@export var target_humidity: float = 70.0


func _init() -> void:
	equipment_type = EquipmentType.IRRIGATION
	station_name = "Irrigation Control"
	description = "Controls watering and humidity"


func _setup_equipment() -> void:
	if equipment:
		equipment.energy_cost = 1.0


func _process(delta: float) -> void:
	if is_active() and Simulation:
		var current_humidity: float = Simulation.get_humidity()
		if current_humidity < target_humidity:
			var increase: float = humidity_rate * delta
			Simulation.set_humidity(current_humidity + increase)
