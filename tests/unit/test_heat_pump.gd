extends GutTest

## Tests for HeatPump equipment.

var _heat_pump: HeatPump = null


func before_each() -> void:
	_heat_pump = HeatPump.new()
	add_child_autofree(_heat_pump)
	_heat_pump._ready()


func after_each() -> void:
	_heat_pump = null


func test_heat_pump_has_correct_type() -> void:
	assert_eq(_heat_pump.equipment_type, EquipmentStation.EquipmentType.HEAT_PUMP)


func test_heat_pump_has_correct_name() -> void:
	assert_eq(_heat_pump.station_name, "Heat Pump")


func test_heat_pump_has_correct_description() -> void:
	assert_eq(_heat_pump.description, "Increases greenhouse temperature")


func test_heat_pump_has_correct_energy_cost() -> void:
	assert_eq(_heat_pump.get_energy_cost(), 2.0)


func test_heat_pump_has_default_heating_rate() -> void:
	assert_eq(_heat_pump.heating_rate, 0.5)


func test_heat_pump_has_default_target_temperature() -> void:
	assert_eq(_heat_pump.target_temperature, 22.0)


func test_get_type_string_returns_heat_pump() -> void:
	assert_eq(_heat_pump.get_type_string(), "Heat Pump")
