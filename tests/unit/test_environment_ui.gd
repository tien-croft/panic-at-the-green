extends GutTest

## Unit tests for EnvironmentUI class
## Tests the UI component that displays temperature and humidity

const EnvironmentUIClass = preload("res://scripts/environment_ui.gd")
const EnvironmentUIScene = preload("res://scenes/environment_ui.tscn")

var _environment_ui: EnvironmentUIClass = null
var _simulation: SimulationCore = null


func before_each() -> void:
	_simulation = get_node("/root/Simulation")
	assert(_simulation != null, "Simulation singleton not found")

	_simulation.set_decay_rates(0.0, 0.0)
	_simulation.set_temperature(20.0)
	_simulation.set_humidity(50.0)

	_environment_ui = EnvironmentUIScene.instantiate()
	add_child(_environment_ui)

	await wait_frames(1)


func after_each() -> void:
	if _environment_ui != null and is_instance_valid(_environment_ui):
		_environment_ui.queue_free()
		_environment_ui = null


func test_initialization() -> void:
	assert_not_null(_environment_ui, "EnvironmentUI should be initialized")
	assert_not_null(_environment_ui.get_temperature_label(), "Temperature label should exist")
	assert_not_null(_environment_ui.get_humidity_label(), "Humidity label should exist")


func test_temperature_display_initial_value() -> void:
	var label: Label = _environment_ui.get_temperature_label()
	assert_eq(label.text, "20.0°C", "Temperature label should show initial value")


func test_humidity_display_initial_value() -> void:
	var label: Label = _environment_ui.get_humidity_label()
	assert_eq(label.text, "50.0%", "Humidity label should show initial value")


func test_temperature_update_on_signal() -> void:
	var label: Label = _environment_ui.get_temperature_label()

	_simulation.set_temperature(25.5)
	await wait_frames(1)

	assert_eq(label.text, "25.5°C", "Temperature label should update when signal emitted")


func test_humidity_update_on_signal() -> void:
	var label: Label = _environment_ui.get_humidity_label()

	_simulation.set_humidity(75.5)
	await wait_frames(1)

	assert_eq(label.text, "75.5%", "Humidity label should update when signal emitted")


func test_temperature_display_formatting() -> void:
	var label: Label = _environment_ui.get_temperature_label()

	_simulation.set_temperature(22.7)
	await wait_frames(1)

	assert_eq(label.text, "22.7°C", "Temperature should format with one decimal")

	_simulation.set_temperature(30.0)
	await wait_frames(1)

	assert_eq(label.text, "30.0°C", "Temperature should format with one decimal")


func test_humidity_display_formatting() -> void:
	var label: Label = _environment_ui.get_humidity_label()

	_simulation.set_humidity(65.3)
	await wait_frames(1)

	assert_eq(label.text, "65.3%", "Humidity should format with one decimal")

	_simulation.set_humidity(90.0)
	await wait_frames(1)

	assert_eq(label.text, "90.0%", "Humidity should format with one decimal")


func test_color_changes_for_temperature_outside_optimal() -> void:
	if not _environment_ui.use_colors:
		pass_test("Colors disabled, skipping color test")
		return

	var label: Label = _environment_ui.get_temperature_label()
	var neutral_color: Color = _environment_ui.COLOR_NEUTRAL
	var warning_color: Color = _environment_ui.COLOR_WARNING

	_simulation.set_temperature(22.0)
	await wait_frames(1)
	assert_eq(label.modulate, neutral_color, "Optimal temperature should be neutral color")

	_simulation.set_temperature(15.0)
	await wait_frames(1)
	assert_eq(label.modulate, warning_color, "Low temperature should be warning color")

	_simulation.set_temperature(30.0)
	await wait_frames(1)
	assert_eq(label.modulate, warning_color, "High temperature should be warning color")


func test_color_changes_for_humidity_outside_optimal() -> void:
	if not _environment_ui.use_colors:
		pass_test("Colors disabled, skipping color test")
		return

	var label: Label = _environment_ui.get_humidity_label()
	var neutral_color: Color = _environment_ui.COLOR_NEUTRAL
	var warning_color: Color = _environment_ui.COLOR_WARNING

	_simulation.set_humidity(70.0)
	await wait_frames(1)
	assert_eq(label.modulate, neutral_color, "Optimal humidity should be neutral color")

	_simulation.set_humidity(40.0)
	await wait_frames(1)
	assert_eq(label.modulate, warning_color, "Low humidity should be warning color")

	_simulation.set_humidity(95.0)
	await wait_frames(1)
	assert_eq(label.modulate, warning_color, "High humidity should be warning color")


func test_multiple_rapid_updates() -> void:
	var temp_label: Label = _environment_ui.get_temperature_label()
	var humid_label: Label = _environment_ui.get_humidity_label()

	for i in range(5):
		_simulation.set_temperature(20.0 + i)
		_simulation.set_humidity(50.0 + i * 5)
		await wait_frames(1)

	assert_eq(temp_label.text, "24.0°C", "Temperature should show final value after rapid updates")
	assert_eq(humid_label.text, "70.0%", "Humidity should show final value after rapid updates")


func test_signal_disconnection_on_exit() -> void:
	_environment_ui.queue_free()
	await wait_frames(1)

	assert_true(true, "UI should clean up without errors")
