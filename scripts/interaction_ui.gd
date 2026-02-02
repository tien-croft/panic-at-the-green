class_name InteractionUI
extends Control

## UI component that displays interaction prompts when player is near interactable objects.
## Shows the interaction key (E) and object name/description.

## The player node that this UI tracks for interactions.
@export var player: Node2D

## Currently targeted interactable object.
var _current_interactable: Node2D = null

## The label showing the interaction prompt text.
@onready var prompt_label: Label = %PromptLabel
@onready var key_label: Label = %KeyLabel
@onready var panel: Panel = %Panel


func _ready() -> void:
	hide_prompt()
	if player:
		player.interaction_available.connect(_on_interaction_available)
		player.interaction_unavailable.connect(_on_interaction_unavailable)


func _exit_tree() -> void:
	if player:
		player.interaction_available.disconnect(_on_interaction_available)
		player.interaction_unavailable.disconnect(_on_interaction_unavailable)


## Called when an interactable object comes into range.
func _on_interaction_available(object: Node2D) -> void:
	_current_interactable = object
	_update_prompt_text(object)
	show_prompt()


## Called when no interactable objects are in range.
func _on_interaction_unavailable() -> void:
	_current_interactable = null
	hide_prompt()


## Updates the prompt text based on the interactable object.
func _update_prompt_text(object: Node2D) -> void:
	if not object:
		return

	var object_name: String = object.name
	var description: String = ""

	if object.has_method("get_interaction_name"):
		object_name = object.get_interaction_name()
	elif "interaction_name" in object:
		object_name = object.interaction_name

	if object.has_method("get_interaction_description"):
		description = object.get_interaction_description()
	elif "interaction_description" in object:
		description = object.interaction_description

	if prompt_label:
		# Show name + description (if description exists and is not default)
		if description and description != "Press E to interact":
			prompt_label.text = object_name + " - " + description
		else:
			prompt_label.text = object_name


## Shows the interaction prompt UI.
func show_prompt() -> void:
	visible = true


## Hides the interaction prompt UI.
func hide_prompt() -> void:
	visible = false


## Returns true if the prompt is currently visible.
func is_prompt_visible() -> bool:
	return visible


## Gets the currently targeted interactable object.
func get_current_interactable() -> Node2D:
	return _current_interactable
