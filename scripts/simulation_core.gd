class_name SimulationCore
extends Node

## Simulation engine that tracks environmental conditions
## for the greenhouse. Emits signals when conditions change.

signal temperature_changed(new_temperature: float)
signal humidity_changed(new_humidity: float)
signal light_changed(new_light: float)
signal day_phase_changed(phase: String)

const ABSOLUTE_ZERO: float = -273.15
const MIN_HUMIDITY: float = 0.0
const MAX_HUMIDITY: float = 100.0
const MIN_LIGHT: float = 0.0

const DEFAULT_TEMPERATURE: float = 22.0
const DEFAULT_HUMIDITY: float = 50.0
const DEFAULT_LIGHT: float = 500.0

const OUTSIDE_TEMPERATURE: float = 15.0
const BASE_HUMIDITY: float = 60.0
const BASE_LIGHT: float = 300.0

const TEMPERATURE_DECAY_RATE: float = 0.5
const HUMIDITY_DECAY_RATE: float = 0.3
const LIGHT_DECAY_RATE: float = 0.8

var _current_temperature: float = DEFAULT_TEMPERATURE
var _current_humidity: float = DEFAULT_HUMIDITY
var _current_light: float = DEFAULT_LIGHT

var _temperature_decay_rate: float = 0.1
var _humidity_decay_rate: float = 0.1
var _target_temperature: float = OUTSIDE_TEMPERATURE
var _target_humidity: float = BASE_HUMIDITY
var _target_light: float = BASE_LIGHT

var _simulation_paused: bool = false
var _day_night_cycle_active: bool = true
var _day_duration: float = 120.0
var _day_time: float = 0.0

@export var temperature: float = DEFAULT_TEMPERATURE:
	set(value):
		_set_temperature(value)

@export var humidity: float = DEFAULT_HUMIDITY:
	set(value):
		_set_humidity(value)


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if not _simulation_paused:
		_apply_natural_decay(delta)
		_process_day_night_cycle(delta)


func _process_day_night_cycle(delta: float) -> void:
	if not _day_night_cycle_active:
		return

	var old_phase: String = _get_day_phase()
	_day_time += delta / _day_duration
	if _day_time >= 1.0:
		_day_time = 0.0

	var new_phase: String = _get_day_phase()
	if old_phase != new_phase:
		day_phase_changed.emit(new_phase)

	if new_phase == "day":
		_current_light = minf(_current_light + 50.0 * delta, DEFAULT_LIGHT)
		_current_temperature = minf(_current_temperature + 2.0 * delta, 35.0)
		return

	if new_phase == "night":
		_current_light = maxf(_current_light - 30.0 * delta, MIN_LIGHT)
		_current_temperature = maxf(_current_temperature - 1.5 * delta, ABSOLUTE_ZERO + 1.0)


func get_temperature() -> float:
	return _current_temperature


func get_humidity() -> float:
	return _current_humidity


func get_light() -> float:
	return _current_light


func get_target_temperature() -> float:
	return _target_temperature


func get_target_humidity() -> float:
	return _target_humidity


func get_target_light() -> float:
	return _target_light


func get_temperature_decay_rate() -> float:
	return _temperature_decay_rate


func get_humidity_decay_rate() -> float:
	return _humidity_decay_rate


func get_day_phase() -> String:
	return _get_day_phase()


func get_simulation_state() -> Dictionary:
	return {
		"temperature": _current_temperature,
		"humidity": _current_humidity,
		"light_intensity": _current_light,
		"day_phase": _get_day_phase(),
		"day_time": _day_time,
		"paused": _simulation_paused
	}


func set_temperature(value: float) -> void:
	_set_temperature(value)


func set_humidity(value: float) -> void:
	_set_humidity(value)


func set_light(value: float) -> void:
	_current_light = maxf(value, MIN_LIGHT)
	light_changed.emit(_current_light)


func set_target_conditions(target_temp: float, target_humid: float) -> void:
	_target_temperature = target_temp
	_target_humidity = target_humid


func set_target_light(target_light: float) -> void:
	_target_light = maxf(target_light, MIN_LIGHT)


func set_decay_rates(temp_decay: float, humid_decay: float) -> void:
	_temperature_decay_rate = temp_decay
	_humidity_decay_rate = humid_decay


func adjust_temperature(amount: float) -> void:
	_set_temperature(_current_temperature + amount)


func adjust_humidity(amount: float) -> void:
	_set_humidity(_current_humidity + amount)


func adjust_light(amount: float) -> void:
	_current_light = maxf(_current_light + amount, MIN_LIGHT)
	light_changed.emit(_current_light)


func pause_simulation() -> void:
	_simulation_paused = true


func resume_simulation() -> void:
	_simulation_paused = false


func reset_simulation() -> void:
	_current_temperature = DEFAULT_TEMPERATURE
	_current_humidity = DEFAULT_HUMIDITY
	_current_light = DEFAULT_LIGHT
	_day_time = 0.0
	_target_temperature = OUTSIDE_TEMPERATURE
	_target_humidity = BASE_HUMIDITY
	_target_light = BASE_LIGHT

	temperature_changed.emit(_current_temperature)
	humidity_changed.emit(_current_humidity)
	light_changed.emit(_current_light)


func debug_print_state() -> void:
	print("--- Simulation State ---")
	print("Temperature: %.1f°C" % _current_temperature)
	print("Humidity: %.1f%%" % _current_humidity)
	print("Light: %.1f lux" % _current_light)
	print("Day Phase: %s (%.2f)" % [_get_day_phase(), _day_time])
	print("Paused: %s" % _simulation_paused)
	print("------------------------")


func _get_day_phase() -> String:
	if _day_time < 0.25:
		return "dawn"

	if _day_time < 0.5:
		return "day"

	if _day_time < 0.75:
		return "dusk"

	return "night"


func _set_temperature(value: float) -> void:
	if value < ABSOLUTE_ZERO:
		push_error("Temperature cannot be below absolute zero")
		return

	var clamped_value: float = clampf(value, -10.0, 50.0)
	var old_temp: float = _current_temperature
	_current_temperature = clamped_value

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

	var light_diff: float = _target_light - _current_light
	var light_change: float = light_diff * LIGHT_DECAY_RATE * delta
	if absf(light_change) > 0.001:
		var new_light: float = _current_light + light_change
		if _target_light > _current_light:
			new_light = minf(new_light, _target_light)
		else:
			new_light = maxf(new_light, _target_light)
		_current_light = new_light
		light_changed.emit(_current_light)
