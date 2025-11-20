extends Control

func _on_main_menu_pressed() -> void:
	SceneTransistor.start_transition_to("res://Interface/main_menu.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
