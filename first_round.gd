extends Node2D

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://nodes/main.tscn")
	print("Round ", GlobalVariables.current_round)
	pass # Replace with function body.
