class_name FanStation
extends EquipmentStation

## Fan equipment that decreases temperature and humidity.
## Mounted on greenhouse walls.

## Rate at which temperature decreases per second when active (Celsius).
@export var cooling_rate: float = 0.3

## Rate at which humidity decreases per second when active (percentage).
@export var dehumidify_rate: float = 0.4


func _init() -> void:
	equipment_type = EquipmentType.FAN
	station_name = "Ventilation Fan"
	description = "Cools and dehumidifies the greenhouse"


func _setup_equipment() -> void:
	if equipment:
		equipment.energy_cost = 1.5


func _process(delta: float) -> void:
	if not is_active():
		return

	var sim: SimulationCore = Engine.get_singleton("Simulation")
	if sim == null:
		return

	var current_temp: float = sim.get_temperature()
	var current_humidity: float = sim.get_humidity()

	var temp_decrease: float = cooling_rate * delta
	var humidity_decrease: float = dehumidify_rate * delta

	sim.set_temperature(current_temp - temp_decrease)
	sim.set_humidity(current_humidity - humidity_decrease)
