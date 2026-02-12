extends GutTest

## Tests for FanStation equipment.

var _fan: FanStation = null


func before_each() -> void:
	_fan = FanStation.new()
	add_child_autofree(_fan)
	_fan._ready()


func after_each() -> void:
	_fan = null


func test_fan_has_correct_type() -> void:
	assert_eq(_fan.equipment_type, EquipmentStation.EquipmentType.FAN)


func test_fan_has_correct_name() -> void:
	assert_eq(_fan.station_name, "Ventilation Fan")


func test_fan_has_correct_description() -> void:
	assert_eq(_fan.description, "Cools and dehumidifies the greenhouse")


func test_fan_has_correct_energy_cost() -> void:
	assert_eq(_fan.get_energy_cost(), 1.5)


func test_fan_has_default_cooling_rate() -> void:
	assert_eq(_fan.cooling_rate, 0.3)


func test_fan_has_default_dehumidify_rate() -> void:
	assert_eq(_fan.dehumidify_rate, 0.4)


func test_get_type_string_returns_fan() -> void:
	assert_eq(_fan.get_type_string(), "Fan")
