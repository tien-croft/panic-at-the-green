class_name SimulationCore
extends Node

## Simulation engine that tracks environmental conditions
## for the greenhouse. Emits signals when conditions change.

signal temperature_changed(new_temperature: float)
signal humidity_changed(new_humidity: float)

const ABSOLUTE_ZERO: float = -273.15
const MIN_HUMIDITY: float = 0.0
const MAX_HUMIDITY: float = 100.0

const DEFAULT_TEMPERATURE: float = 20.0
const DEFAULT_HUMIDITY: float = 50.0

@export var temperature: float = DEFAULT_TEMPERATURE:
	set(value):
		_set_temperature(value)

@export var humidity: float = DEFAULT_HUMIDITY:
	set(value):
		_set_humidity(value)

var _current_temperature: float = DEFAULT_TEMPERATURE
var _current_humidity: float = DEFAULT_HUMIDITY

var _temperature_decay_rate: float = 0.1
var _humidity_decay_rate: float = 0.1
var _target_temperature: float = DEFAULT_TEMPERATURE
var _target_humidity: float = DEFAULT_HUMIDITY


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	_apply_natural_decay(delta)


func get_temperature() -> float:
	return _current_temperature


func get_humidity() -> float:
	return _current_humidity


func set_temperature(value: float) -> void:
	_set_temperature(value)


func set_humidity(value: float) -> void:
	_set_humidity(value)


func set_target_conditions(target_temp: float, target_humid: float) -> void:
	_target_temperature = target_temp
	_target_humidity = target_humid


func set_decay_rates(temp_decay: float, humid_decay: float) -> void:
	_temperature_decay_rate = temp_decay
	_humidity_decay_rate = humid_decay


func get_target_temperature() -> float:
	return _target_temperature


func get_target_humidity() -> float:
	return _target_humidity


func get_temperature_decay_rate() -> float:
	return _temperature_decay_rate


func get_humidity_decay_rate() -> float:
	return _humidity_decay_rate


func _set_temperature(value: float) -> void:
	if value < ABSOLUTE_ZERO:
		push_error("Temperature cannot be below absolute zero")
		return

	var old_temp: float = _current_temperature
	_current_temperature = value

	if old_temp != _current_temperature:
		temperature_changed.emit(_current_temperature)


func _set_humidity(value: float) -> void:
	var clamped_value: float = clampf(value, MIN_HUMIDITY, MAX_HUMIDITY)

	var old_humid: float = _current_humidity
	_current_humidity = clamped_value

	if old_humid != _current_humidity:
		humidity_changed.emit(_current_humidity)


func _apply_natural_decay(delta: float) -> void:
	var temp_diff: float = _target_temperature - _current_temperature
	var temp_change: float = temp_diff * _temperature_decay_rate * delta
	if absf(temp_change) > 0.001:
		var new_temp: float = _current_temperature + temp_change
		if _target_temperature > _current_temperature:
			new_temp = minf(new_temp, _target_temperature)
		else:
			new_temp = maxf(new_temp, _target_temperature)
		_set_temperature(new_temp)

	var humid_diff: float = _target_humidity - _current_humidity
	var humid_change: float = humid_diff * _humidity_decay_rate * delta
	if absf(humid_change) > 0.001:
		var new_humid: float = _current_humidity + humid_change
		if _target_humidity > _current_humidity:
			new_humid = minf(new_humid, _target_humidity)
		else:
			new_humid = maxf(new_humid, _target_humidity)
		_set_humidity(new_humid)
