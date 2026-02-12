class_name HeatPump
extends EquipmentStation

## Heat pump equipment that increases greenhouse temperature.
## Placed outside the greenhouse.

## Rate at which temperature increases per second when active (Celsius).
@export var heating_rate: float = 0.5

## Target temperature to maintain (Celsius).
@export var target_temperature: float = 22.0


func _init() -> void:
	equipment_type = EquipmentType.HEAT_PUMP
	station_name = "Heat Pump"
	description = "Increases greenhouse temperature"


func _setup_equipment() -> void:
	if equipment:
		equipment.energy_cost = 2.0


func _process(delta: float) -> void:
	if not is_active():
		return

	var sim: SimulationCore = Engine.get_singleton("Simulation")
	if sim == null:
		return

	var current_temp: float = sim.get_temperature()
	if current_temp < target_temperature:
		var increase: float = heating_rate * delta
		sim.set_temperature(current_temp + increase)
