# gdlint: disable=max-public-methods
extends GutTest

## Test suite for SimulationCore functionality

var simulation_core: SimulationCore = null


func before_each() -> void:
	simulation_core = SimulationCore.new()
	add_child_autofree(simulation_core)


func after_each() -> void:
	simulation_core = null


func test_initial_temperature() -> void:
	assert_eq(simulation_core.get_temperature(), 20.0, "Default temperature should be 20.0°C")


func test_initial_humidity() -> void:
	assert_eq(simulation_core.get_humidity(), 50.0, "Default humidity should be 50%")


func test_set_temperature() -> void:
	simulation_core.set_temperature(25.0)
	assert_eq(simulation_core.get_temperature(), 25.0, "Temperature should be set to 25.0°C")


func test_set_humidity() -> void:
	simulation_core.set_humidity(75.0)
	assert_eq(simulation_core.get_humidity(), 75.0, "Humidity should be set to 75%")


func test_temperature_signal_emitted() -> void:
	watch_signals(simulation_core)
	simulation_core.set_temperature(30.0)
	assert_signal_emitted(
		simulation_core, "temperature_changed", "temperature_changed signal should be emitted"
	)


func test_humidity_signal_emitted() -> void:
	watch_signals(simulation_core)
	simulation_core.set_humidity(80.0)
	assert_signal_emitted(
		simulation_core, "humidity_changed", "humidity_changed signal should be emitted"
	)


func test_temperature_signal_not_emitted_when_same() -> void:
	watch_signals(simulation_core)
	simulation_core.set_temperature(20.0)
	assert_signal_not_emitted(
		simulation_core, "temperature_changed", "Signal should not emit when unchanged"
	)


func test_humidity_signal_not_emitted_when_same() -> void:
	watch_signals(simulation_core)
	simulation_core.set_humidity(50.0)
	assert_signal_not_emitted(
		simulation_core, "humidity_changed", "Signal should not emit when unchanged"
	)


func test_humidity_clamped_to_max() -> void:
	simulation_core.set_humidity(150.0)
	assert_eq(simulation_core.get_humidity(), 100.0, "Humidity should be clamped to max 100%")


func test_humidity_clamped_to_min() -> void:
	simulation_core.set_humidity(-50.0)
	assert_eq(simulation_core.get_humidity(), 0.0, "Humidity should be clamped to min 0%")


func test_temperature_below_absolute_zero() -> void:
	var original_temp: float = simulation_core.get_temperature()
	simulation_core.set_temperature(-300.0)
	assert_push_error("below absolute zero")
	assert_eq(
		simulation_core.get_temperature(),
		original_temp,
		"Temperature should not change below absolute zero"
	)


func test_set_target_conditions() -> void:
	simulation_core.set_target_conditions(18.0, 60.0)
	assert_eq(simulation_core.get_target_temperature(), 18.0, "Target temperature should be set")
	assert_eq(simulation_core.get_target_humidity(), 60.0, "Target humidity should be set")


func test_set_decay_rates() -> void:
	simulation_core.set_decay_rates(0.5, 0.3)
	assert_eq(
		simulation_core.get_temperature_decay_rate(), 0.5, "Temperature decay rate should be set"
	)
	assert_eq(simulation_core.get_humidity_decay_rate(), 0.3, "Humidity decay rate should be set")


func test_temperature_decay_toward_target() -> void:
	simulation_core.set_temperature(30.0)
	simulation_core.set_target_conditions(20.0, 50.0)
	simulation_core.set_decay_rates(0.5, 0.5)

	simulation_core._apply_natural_decay(1.0)

	var new_temp: float = simulation_core.get_temperature()
	assert_true(new_temp < 30.0, "Temperature should decay toward target")
	assert_true(new_temp > 20.0, "Temperature should not reach target immediately")


func test_humidity_decay_toward_target() -> void:
	simulation_core.set_humidity(80.0)
	simulation_core.set_target_conditions(20.0, 50.0)
	simulation_core.set_decay_rates(0.5, 0.5)

	simulation_core._apply_natural_decay(1.0)

	var new_humid: float = simulation_core.get_humidity()
	assert_true(new_humid < 80.0, "Humidity should decay toward target")
	assert_true(new_humid > 50.0, "Humidity should not reach target immediately")


func test_temperature_reaches_target_without_overshoot() -> void:
	simulation_core.set_temperature(30.0)
	simulation_core.set_target_conditions(20.0, 50.0)
	simulation_core.set_decay_rates(1.0, 1.0)

	simulation_core._apply_natural_decay(1.0)

	var new_temp: float = simulation_core.get_temperature()
	assert_eq(new_temp, 20.0, "Temperature should reach target exactly without overshooting")


func test_humidity_reaches_target_without_overshoot() -> void:
	simulation_core.set_humidity(80.0)
	simulation_core.set_target_conditions(20.0, 50.0)
	simulation_core.set_decay_rates(1.0, 1.0)

	simulation_core._apply_natural_decay(1.0)

	var new_humid: float = simulation_core.get_humidity()
	assert_eq(new_humid, 50.0, "Humidity should reach target exactly without overshooting")


func test_temperature_property_setter() -> void:
	simulation_core.temperature = 28.0
	assert_eq(simulation_core.get_temperature(), 28.0, "Temperature property setter should work")


func test_humidity_property_setter() -> void:
	simulation_core.humidity = 65.0
	assert_eq(simulation_core.get_humidity(), 65.0, "Humidity property setter should work")


func test_temperature_decay_does_not_change_when_at_target() -> void:
	simulation_core.set_temperature(20.0)
	simulation_core.set_target_conditions(20.0, 50.0)

	watch_signals(simulation_core)
	simulation_core._apply_natural_decay(1.0)

	assert_signal_not_emitted(
		simulation_core, "temperature_changed", "No signal when temp at target"
	)
	assert_eq(simulation_core.get_temperature(), 20.0, "Temperature should stay at target")


func test_humidity_decay_does_not_change_when_at_target() -> void:
	simulation_core.set_humidity(50.0)
	simulation_core.set_target_conditions(20.0, 50.0)

	watch_signals(simulation_core)
	simulation_core._apply_natural_decay(1.0)

	assert_signal_not_emitted(
		simulation_core, "humidity_changed", "No signal when humidity at target"
	)
	assert_eq(simulation_core.get_humidity(), 50.0, "Humidity should stay at target")
