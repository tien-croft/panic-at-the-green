extends GutTest

## Tests for VentStation equipment.

var _vent: VentStation = null


func before_each() -> void:
	_vent = VentStation.new()
	add_child_autofree(_vent)
	_vent._ready()


func after_each() -> void:
	_vent = null


func test_vent_has_correct_type() -> void:
	assert_eq(_vent.equipment_type, EquipmentStation.EquipmentType.VENT)


func test_vent_has_correct_name() -> void:
	assert_eq(_vent.station_name, "Vent")


func test_vent_has_correct_description() -> void:
	assert_eq(_vent.description, "Passive ventilation to regulate temperature")


func test_vent_has_correct_energy_cost() -> void:
	assert_eq(_vent.get_energy_cost(), 0.5)


func test_vent_has_default_cooling_rate() -> void:
	assert_eq(_vent.cooling_rate, 0.2)


func test_vent_has_default_min_effectiveness() -> void:
	assert_eq(_vent.min_effectiveness, 0.3)


func test_get_type_string_returns_vent() -> void:
	assert_eq(_vent.get_type_string(), "Vent")
