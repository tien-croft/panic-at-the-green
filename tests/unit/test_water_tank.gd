extends GutTest

## Tests for WaterTank equipment.

var _water_tank: WaterTank = null


func before_each() -> void:
	_water_tank = WaterTank.new()
	add_child_autofree(_water_tank)
	_water_tank._ready()


func after_each() -> void:
	_water_tank = null


func test_water_tank_has_correct_type() -> void:
	assert_eq(_water_tank.equipment_type, EquipmentStation.EquipmentType.WATER_TANK)


func test_water_tank_has_correct_name() -> void:
	assert_eq(_water_tank.station_name, "Water Tank")


func test_water_tank_has_correct_description() -> void:
	assert_eq(_water_tank.description, "Stores water for irrigation and watering")


func test_water_tank_has_no_energy_cost() -> void:
	assert_eq(_water_tank.get_energy_cost(), 0.0)


func test_water_tank_starts_full() -> void:
	assert_eq(_water_tank.get_water_level(), 1000.0)
	assert_eq(_water_tank.get_water_percentage(), 100.0)


func test_water_tank_max_capacity_constant() -> void:
	assert_eq(WaterTank.MAX_CAPACITY, 1000.0)


func test_use_water_reduces_level() -> void:
	var used: float = _water_tank.use_water(100.0)
	assert_eq(used, 100.0)
	assert_eq(_water_tank.get_water_level(), 900.0)


func test_use_water_cannot_exceed_available() -> void:
	_water_tank.water_level = 50.0
	var used: float = _water_tank.use_water(100.0)
	assert_eq(used, 50.0)
	assert_eq(_water_tank.get_water_level(), 0.0)


func test_refill_adds_water() -> void:
	_water_tank.water_level = 500.0
	_water_tank.refill(200.0)
	assert_eq(_water_tank.get_water_level(), 700.0)


func test_refill_cannot_exceed_max() -> void:
	_water_tank.water_level = 900.0
	_water_tank.refill(200.0)
	assert_eq(_water_tank.get_water_level(), 1000.0)


func test_get_water_percentage_calculates_correctly() -> void:
	_water_tank.water_level = 500.0
	assert_eq(_water_tank.get_water_percentage(), 50.0)

	_water_tank.water_level = 250.0
	assert_eq(_water_tank.get_water_percentage(), 25.0)


func test_get_type_string_returns_water_tank() -> void:
	assert_eq(_water_tank.get_type_string(), "Water Tank")
