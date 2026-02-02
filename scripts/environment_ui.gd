class_name EnvironmentUI
extends Control

## UI component that displays current environmental conditions
## (temperature and humidity) from the Simulation singleton.
## Updates in real-time when conditions change.

const OPTIMAL_TEMP_MIN: float = 18.0
const OPTIMAL_TEMP_MAX: float = 25.0
const OPTIMAL_HUMID_MIN: float = 60.0
const OPTIMAL_HUMID_MAX: float = 80.0

const COLOR_OPTIMAL: Color = Color(0.2, 0.8, 0.2, 1.0)
const COLOR_WARNING: Color = Color(0.9, 0.7, 0.1, 1.0)
const COLOR_CRITICAL: Color = Color(0.9, 0.2, 0.2, 1.0)
const COLOR_NEUTRAL: Color = Color(0.9, 0.9, 0.9, 1.0)

@export var use_colors: bool = true

var _simulation: SimulationCore

@onready var _temperature_label: Label = %TemperatureLabel
@onready var _humidity_label: Label = %HumidityLabel
@onready var _temperature_icon: TextureRect = %TemperatureIcon
@onready var _humidity_icon: TextureRect = %HumidityIcon


func _ready() -> void:
	_simulation = get_node("/root/Simulation")
	assert(_simulation != null, "Simulation singleton not found")

	_update_temperature_display(_simulation.get_temperature())
	_update_humidity_display(_simulation.get_humidity())

	_simulation.temperature_changed.connect(_on_temperature_changed)
	_simulation.humidity_changed.connect(_on_humidity_changed)


func _exit_tree() -> void:
	if _simulation != null:
		_simulation.temperature_changed.disconnect(_on_temperature_changed)
		_simulation.humidity_changed.disconnect(_on_humidity_changed)


func _on_temperature_changed(new_temperature: float) -> void:
	_update_temperature_display(new_temperature)


func _on_humidity_changed(new_humidity: float) -> void:
	_update_humidity_display(new_humidity)


func _update_temperature_display(temperature: float) -> void:
	_temperature_label.text = "%.1f°C" % temperature
	if use_colors:
		_temperature_label.modulate = _get_temperature_color(temperature)


func _update_humidity_display(humidity: float) -> void:
	_humidity_label.text = "%.1f%%" % humidity
	if use_colors:
		_humidity_label.modulate = _get_humidity_color(humidity)


func _get_temperature_color(temperature: float) -> Color:
	if temperature < OPTIMAL_TEMP_MIN or temperature > OPTIMAL_TEMP_MAX:
		return COLOR_WARNING
	return COLOR_NEUTRAL


func _get_humidity_color(humidity: float) -> Color:
	if humidity < OPTIMAL_HUMID_MIN or humidity > OPTIMAL_HUMID_MAX:
		return COLOR_WARNING
	return COLOR_NEUTRAL


func get_temperature_label() -> Label:
	return _temperature_label


func get_humidity_label() -> Label:
	return _humidity_label
