class_name World
extends Node2D

## World scene containing the greenhouse with proper Y-sorting
## Ground is separate (below), structures and objects are sorted by Y position

signal player_entered_greenhouse
signal player_exited_greenhouse

const TILE_SIZE: int = 32
const GREENHOUSE_WIDTH: int = 16
const GREENHOUSE_HEIGHT: int = 12

var _entrance_position: Vector2 = Vector2.ZERO
var _entrance_area: Area2D = null

@onready var ground_layer: Node = null
@onready var structure_layer: Node = null
@onready var benches_layer: Node = null
@onready var floor_rect: ColorRect = $Floor


func _ready() -> void:
	if has_node("GroundLayer"):
		ground_layer = $GroundLayer
	if has_node("StructureLayer"):
		structure_layer = $StructureLayer
	if has_node("BenchesLayer"):
		benches_layer = $BenchesLayer
	if has_node("EntranceArea"):
		_entrance_area = $EntranceArea

	_setup_world()


func _setup_world() -> void:
	# Set up greenhouse entrance position
	var entrance_marker: Node2D = $EntranceArea.get_node_or_null("EntranceMarker")
	if entrance_marker:
		_entrance_position = entrance_marker.global_position

	# Connect entrance area signals
	if _entrance_area:
		_entrance_area.body_entered.connect(_on_entrance_area_body_entered)


func get_entrance_position() -> Vector2:
	return _entrance_position


func is_position_inside_greenhouse(pos: Vector2) -> bool:
	if not floor_rect:
		return false
	return floor_rect.get_rect().has_point(floor_rect.to_local(pos))


func get_floor_type_at(pos: Vector2) -> String:
	if is_position_inside_greenhouse(pos):
		return "concrete"
	return "grass"


func _on_entrance_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var inside: bool = is_position_inside_greenhouse(body.global_position)
		if inside:
			player_entered_greenhouse.emit()
		else:
			player_exited_greenhouse.emit()
