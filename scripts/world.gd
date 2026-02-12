class_name World
extends YSort

## World scene containing the greenhouse with proper Y-sorting
## Ground is separate (below), structures and objects are sorted by Y position

signal player_entered_greenhouse
signal player_exited_greenhouse

const TILE_SIZE: int = 32
const GREENHOUSE_WIDTH: int = 16
const GREENHOUSE_HEIGHT: int = 12

var _entrance_position: Vector2 = Vector2.ZERO
var _entrance_area: Area2D = null

@onready var ground_layer: TileMapLayer = null
@onready var structure_layer: TileMapLayer = null
@onready var benches_layer: TileMapLayer = null


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
	var local_pos: Vector2 = pos - global_position
	var half_width: float = (GREENHOUSE_WIDTH * TILE_SIZE) / 2.0
	var half_height: float = (GREENHOUSE_HEIGHT * TILE_SIZE) / 2.0
	return (
		local_pos.x > -half_width
		and local_pos.x < half_width
		and local_pos.y > -half_height
		and local_pos.y < half_height
	)


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
