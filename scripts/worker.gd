class_name Worker
extends CharacterBody2D

## Worker NPC that can be hired to automate tasks.

enum WorkerType { TECHNICIAN, GARDENER, MANAGER }

const ATLAS_PATH = "res://assets/sprites/npcs_and_ui.png"

# Placeholder regions for different workers
const REGIONS = {
	WorkerType.TECHNICIAN: Rect2(0, 0, 64, 64),
	WorkerType.GARDENER: Rect2(64, 0, 64, 64),
	WorkerType.MANAGER: Rect2(128, 0, 64, 64),
}

@export var worker_type: WorkerType = WorkerType.GARDENER
@export var worker_name: String = "Worker"

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	update_worker_visuals()


func update_worker_visuals() -> void:
	sprite.texture = load(ATLAS_PATH)
	sprite.region_enabled = true
	sprite.region_rect = REGIONS[worker_type]


func interact(_player: Player) -> void:
	print("Hello, I am %s, the %s." % [worker_name, WorkerType.keys()[worker_type]])
