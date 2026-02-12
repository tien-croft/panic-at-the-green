extends GutTest

## Tests for EquipmentStation base class functionality.

var _station: EquipmentStation = null


func before_each() -> void:
	_station = EquipmentStation.new()
	add_child_autofree(_station)

	# Create required child nodes for testing
	var sprite: Sprite2D = Sprite2D.new()
	sprite.name = "Sprite2D"
	_station.add_child(sprite)

	var collision: CollisionShape2D = CollisionShape2D.new()
	collision.name = "CollisionShape2D"
	_station.add_child(collision)

	_station._ready()


func after_each() -> void:
	_station = null


func test_station_initializes_with_default_values() -> void:
	assert_eq(_station.equipment_type, EquipmentStation.EquipmentType.HEAT_PUMP)
	assert_eq(_station.station_name, "Equipment")
	assert_eq(_station.description, "Greenhouse equipment")
	assert_not_null(_station.equipment)


func test_station_has_sprite_and_collision() -> void:
	# Check that the required nodes exist
	var sprite: Sprite2D = _station.get_node_or_null("Sprite2D")
	var collision: CollisionShape2D = _station.get_node_or_null("CollisionShape2D")

	assert_not_null(sprite, "Station should have Sprite2D")
	assert_not_null(collision, "Station should have CollisionShape2D")


func test_station_creates_equipment_base() -> void:
	assert_not_null(_station.equipment)
	assert_true(_station.equipment is EquipmentBase)


func test_interact_emits_signal() -> void:
	var signal_tracker: Dictionary = {"emitted": false, "station": null}

	_station.station_interacted.connect(
		func(station) -> void:
			signal_tracker.emitted = true
			signal_tracker.station = station
	)

	var mock_player: Node2D = Node2D.new()
	_station.interact(mock_player)

	assert_true(signal_tracker.emitted, "station_interacted signal should be emitted")
	assert_eq(signal_tracker.station, _station, "Signal should pass the station instance")

	mock_player.free()


func test_get_type_string_returns_correct_type() -> void:
	_station.equipment_type = EquipmentStation.EquipmentType.HEAT_PUMP
	assert_eq(_station.get_type_string(), "Heat Pump")

	_station.equipment_type = EquipmentStation.EquipmentType.FAN
	assert_eq(_station.get_type_string(), "Fan")

	_station.equipment_type = EquipmentStation.EquipmentType.VENT
	assert_eq(_station.get_type_string(), "Vent")

	_station.equipment_type = EquipmentStation.EquipmentType.IRRIGATION
	assert_eq(_station.get_type_string(), "Irrigation")

	_station.equipment_type = EquipmentStation.EquipmentType.WATER_TANK
	assert_eq(_station.get_type_string(), "Water Tank")


func test_is_active_returns_equipment_state() -> void:
	# Initially inactive
	assert_false(_station.is_active())

	# Activate
	_station.activate()
	assert_true(_station.is_active())

	# Deactivate
	_station.deactivate()
	assert_false(_station.is_active())


func test_toggle_switches_active_state() -> void:
	# Start inactive
	assert_false(_station.is_active())

	# Toggle on
	_station.toggle()
	assert_true(_station.is_active())

	# Toggle off
	_station.toggle()
	assert_false(_station.is_active())


func test_get_energy_cost_returns_equipment_cost() -> void:
	assert_eq(_station.get_energy_cost(), 1.0)

	_station.equipment.energy_cost = 2.5
	assert_eq(_station.get_energy_cost(), 2.5)


func test_state_change_updates_visual() -> void:
	var sprite: Sprite2D = _station.sprite
	assert_not_null(sprite)

	# Inactive color (should be gray)
	assert_eq(sprite.modulate, Color(0.6, 0.6, 0.6, 1.0))

	# Activate
	_station.activate()

	# Active color (should be white)
	assert_eq(sprite.modulate, Color(1.0, 1.0, 1.0, 1.0))


func test_equipment_emits_state_changed() -> void:
	var signal_tracker: Dictionary = {"emitted": false, "state": false}

	_station.equipment.state_changed.connect(
		func(is_active: bool) -> void:
			signal_tracker.emitted = true
			signal_tracker.state = is_active
	)

	_station.activate()
	assert_true(signal_tracker.emitted)
	assert_true(signal_tracker.state)
