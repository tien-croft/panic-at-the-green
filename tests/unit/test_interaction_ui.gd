extends GutTest

## Unit tests for the InteractionUI class.
## Tests UI visibility, text updates, and signal handling.

const InteractionUIScript = preload("res://scripts/interaction_ui.gd")
const InteractionUIScene: PackedScene = preload("res://scenes/interaction_ui.tscn")
const PlayerScene: PackedScene = preload("res://scenes/player.tscn")
const InteractableScript = preload("res://scripts/interactable.gd")

var interaction_ui: Control
var player: Node2D


func before_each() -> void:
	player = PlayerScene.instantiate()
	add_child_autofree(player)

	interaction_ui = InteractionUIScene.instantiate()
	interaction_ui.player = player
	add_child_autofree(interaction_ui)

	await get_tree().process_frame


func after_each() -> void:
	if is_instance_valid(interaction_ui):
		interaction_ui.queue_free()
	if is_instance_valid(player):
		player.queue_free()


# === Initialization Tests ===


func test_interaction_ui_initializes_hidden() -> void:
	assert_false(interaction_ui.visible, "UI should be hidden initially")
	assert_false(interaction_ui.is_prompt_visible(), "is_prompt_visible should return false")


func test_interaction_ui_has_required_nodes() -> void:
	assert_has_method(interaction_ui, "show_prompt", "Should have show_prompt method")
	assert_has_method(interaction_ui, "hide_prompt", "Should have hide_prompt method")

	var prompt_label: Label = interaction_ui.get_node_or_null("Panel/HBoxContainer/PromptLabel")
	var key_label: Label = interaction_ui.get_node_or_null("Panel/HBoxContainer/KeyLabel")
	var panel: Panel = interaction_ui.get_node_or_null("Panel")

	assert_not_null(prompt_label, "Should have PromptLabel node")
	assert_not_null(key_label, "Should have KeyLabel node")
	assert_not_null(panel, "Should have Panel node")


# === Visibility Tests ===


func test_show_prompt_makes_ui_visible() -> void:
	interaction_ui.show_prompt()
	assert_true(interaction_ui.visible, "UI should be visible after show_prompt()")
	assert_true(interaction_ui.is_prompt_visible(), "is_prompt_visible should return true")


func test_hide_prompt_makes_ui_invisible() -> void:
	interaction_ui.show_prompt()
	interaction_ui.hide_prompt()
	assert_false(interaction_ui.visible, "UI should be invisible after hide_prompt()")
	assert_false(interaction_ui.is_prompt_visible(), "is_prompt_visible should return false")


# === Signal Handling Tests ===


func test_shows_prompt_when_interaction_available_signal_emitted() -> void:
	var interactable: Node2D = InteractableScript.new()
	add_child_autofree(interactable)

	player.interaction_available.emit(interactable)
	await get_tree().process_frame

	assert_true(interaction_ui.visible, "UI should be visible after interaction_available signal")
	assert_eq(
		interaction_ui.get_current_interactable(), interactable, "Should track current interactable"
	)


func test_hides_prompt_when_interaction_unavailable_signal_emitted() -> void:
	var interactable: Node2D = InteractableScript.new()
	add_child_autofree(interactable)

	player.interaction_available.emit(interactable)
	player.interaction_unavailable.emit()
	await get_tree().process_frame

	assert_false(interaction_ui.visible, "UI should be hidden after interaction_unavailable signal")
	assert_null(interaction_ui.get_current_interactable(), "Current interactable should be null")


# === Text Update Tests ===


func test_prompt_shows_interaction_name() -> void:
	var interactable: Node2D = InteractableScript.new()
	interactable.interaction_name = "Test Object"
	add_child_autofree(interactable)

	player.interaction_available.emit(interactable)
	await get_tree().process_frame

	var prompt_label: Label = interaction_ui.get_node("Panel/HBoxContainer/PromptLabel")
	assert_eq(prompt_label.text, "Test Object", "Label should show interaction name")


func test_prompt_shows_interaction_description_when_available() -> void:
	var interactable: Node2D = InteractableScript.new()
	interactable.interaction_name = "Test Object"
	interactable.interaction_description = "Custom Description"
	add_child_autofree(interactable)

	player.interaction_available.emit(interactable)
	await get_tree().process_frame

	var prompt_label: Label = interaction_ui.get_node("Panel/HBoxContainer/PromptLabel")
	assert_eq(
		prompt_label.text,
		"Test Object - Custom Description",
		"Label should show name and description"
	)
