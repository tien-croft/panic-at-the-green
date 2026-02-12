class_name Interactable
extends Node2D

## Base class for all interactable objects in the game.
## Inherit from this class and override interact() to implement specific behavior.
## Add this to objects that the player can interact with by pressing 'E'.

## Emitted when this object is interacted with.
## Passes the Node2D that interacted with this object (usually the player).
signal interacted(interactor: Node2D)

## Emitted when the player enters interaction range.
signal player_entered_range

## Emitted when the player exits interaction range.
signal player_exited_range

## Name shown in interaction prompts.
@export var interaction_name: String = "Object"

## Description shown in interaction UI.
@export var interaction_description: String = "Press E to interact"

## Whether this object can currently be interacted with.
@export var interaction_enabled: bool = true


func _ready() -> void:
	add_to_group("interactable")


## Called when the player interacts with this object.
## Override this method in subclasses to implement specific interaction behavior.
## Parameters:
##   interactor - The Node2D that interacted with this object (usually the player)
func interact(interactor: Node2D) -> void:
	if not interaction_enabled:
		return
	interacted.emit(interactor)
	_on_interact(interactor)


## Override this in subclasses to implement interaction behavior.
## Called automatically when interact() is called.
func _on_interact(_interactor: Node2D) -> void:
	pass


## Returns true if this object can be interacted with.
func can_interact() -> bool:
	return interaction_enabled


## Enable interaction with this object.
func enable_interaction() -> void:
	interaction_enabled = true


## Disable interaction with this object.
func disable_interaction() -> void:
	interaction_enabled = false


## Set the interaction name shown in prompts.
func set_interaction_name(name: String) -> void:
	interaction_name = name


## Set the interaction description shown in UI.
func set_interaction_description(description: String) -> void:
	interaction_description = description
