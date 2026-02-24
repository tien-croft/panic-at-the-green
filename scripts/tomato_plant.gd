class_name TomatoPlant
extends Node2D

## Modular Tomato Plant system using stackable segments.

enum GrowthState {
	PRUNED,
	VEGETATIVE,
	FLOWERING,
	FRUITING_GREEN,
	FRUITING_RED
}

enum TopState {
	LEAFY,
	FLOWERING
}

@export var segment_height: int = 32
@export var max_segments: int = 5
@export var current_segments: int = 1
@export var plant_state: GrowthState = GrowthState.VEGETATIVE
@export var top_state: TopState = TopState.LEAFY

@onready var base_sprite: Sprite2D = $Base
@onready var middle_container: Node2D = $MiddleSegments
@onready var top_sprite: Sprite2D = $Top

const ATLAS_PATH = "res://assets/sprites/tomato_lego_system.png"

# Placeholder regions (to be adjusted for actual spritesheet layout)
const REGIONS = {
	"base": Rect2(0, 0, 32, 32),
	"middle": {
		GrowthState.PRUNED: Rect2(32, 0, 32, 32),
		GrowthState.VEGETATIVE: Rect2(64, 0, 32, 32),
		GrowthState.FLOWERING: Rect2(96, 0, 32, 32),
		GrowthState.FRUITING_GREEN: Rect2(128, 0, 32, 32),
		GrowthState.FRUITING_RED: Rect2(160, 0, 32, 32),
	},
	"top": {
		TopState.LEAFY: Rect2(192, 0, 32, 32),
		TopState.FLOWERING: Rect2(224, 0, 32, 32),
	}
}


func _ready() -> void:
	update_plant_visuals()


func update_plant_visuals() -> void:
	# Update base
	base_sprite.region_rect = REGIONS["base"]

	# Clear existing middle segments
	for child in middle_container.get_children():
		child.queue_free()

	# Add middle segments
	for i in range(current_segments):
		var segment: Sprite2D = Sprite2D.new()
		segment.texture = load(ATLAS_PATH)
		segment.region_enabled = true
		segment.region_rect = REGIONS["middle"][plant_state]
		segment.centered = false
		segment.position = Vector2(0, -(i + 1) * segment_height)
		middle_container.add_child(segment)

	# Update top segment
	top_sprite.region_rect = REGIONS["top"][top_state]
	top_sprite.position = Vector2(0, -(current_segments + 1) * segment_height)


func grow() -> void:
	if current_segments < max_segments:
		current_segments += 1
		update_plant_visuals()


func set_state(new_state: GrowthState) -> void:
	plant_state = new_state
	update_plant_visuals()
