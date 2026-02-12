class_name VentStation
extends EquipmentStation

## Vent equipment that helps regulate temperature through passive/active ventilation.
## Mounted on greenhouse walls, often works with fans.

## Rate at which temperature decreases per second when active (Celsius).
@export var cooling_rate: float = 0.2

## Minimum effectiveness (when temperature is close to outside).
@export var min_effectiveness: float = 0.3


func _init() -> void:
	equipment_type = EquipmentType.VENT
	station_name = "Vent"
	description = "Passive ventilation to regulate temperature"


func _setup_equipment() -> void:
	if equipment:
		equipment.energy_cost = 0.5


func _process(delta: float) -> void:
	if is_active() and Simulation:
		var current_temp: float = Simulation.get_temperature()

		# Calculate effectiveness based on temperature difference from outside
		var outside_temp: float = Simulation.OUTSIDE_TEMPERATURE
		var temp_diff: float = abs(current_temp - outside_temp)
		var effectiveness: float = clamp(temp_diff / 20.0, min_effectiveness, 1.0)

		var temp_decrease: float = cooling_rate * effectiveness * delta
		Simulation.set_temperature(current_temp - temp_decrease)
