extends GutTest

## Tests for IrrigationPanel equipment.

var _irrigation: IrrigationPanel = null


func before_each() -> void:
	_irrigation = IrrigationPanel.new()
	add_child_autofree(_irrigation)
	_irrigation._ready()


func after_each() -> void:
	_irrigation = null


func test_irrigation_has_correct_type() -> void:
	assert_eq(_irrigation.equipment_type, EquipmentStation.EquipmentType.IRRIGATION)


func test_irrigation_has_correct_name() -> void:
	assert_eq(_irrigation.station_name, "Irrigation Control")


func test_irrigation_has_correct_description() -> void:
	assert_eq(_irrigation.description, "Controls watering and humidity")


func test_irrigation_has_correct_energy_cost() -> void:
	assert_eq(_irrigation.get_energy_cost(), 1.0)


func test_irrigation_has_default_humidity_rate() -> void:
	assert_eq(_irrigation.humidity_rate, 0.5)


func test_irrigation_has_default_target_humidity() -> void:
	assert_eq(_irrigation.target_humidity, 70.0)


func test_get_type_string_returns_irrigation() -> void:
	assert_eq(_irrigation.get_type_string(), "Irrigation")
