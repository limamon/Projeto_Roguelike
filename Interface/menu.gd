extends Control

@onready var main_buttons: VBoxContainer = $Main_buttons
@onready var credits: Panel = $Credits


func _ready() -> void:
	main_buttons.visible = true
	credits.visible = false

func _on_start_game_pressed() -> void:
	SavedData.reset_data()
	SceneTransistor.start_transition_to("res://Game.tscn")

func _on_back_options_pressed() -> void:
	main_buttons.visible = true
	credits.visible = false

func _on_credits_pressed() -> void:
	main_buttons.visible = false
	credits.visible = true

func _on_exit_pressed() -> void:
	get_tree().quit()
