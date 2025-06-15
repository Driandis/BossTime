extends Node2D

#doppelt sich komplett mit den buttonskripts

func _on_barbarianking_pressed() -> void:
		GlobalVariables.selected_boss = "res://bosses/Barbarianking/Barbarianking.tres"
		get_tree().change_scene_to_file("res://nodes/Start_fight.tscn")  # Startbildschirm starten
		print("Barbarianking ausgewählt.")


func _on_pyromancer_pressed() -> void:
	GlobalVariables.selected_boss = "res://bosses/Pyromancer/Pyromancer.tres"
	get_tree().change_scene_to_file("res://nodes/Start_fight.tscn")  # Startbildschirm starten
	print("Pyromancer ausgewählt.")

func _on_wolfsalpha_pressed() -> void:
	GlobalVariables.selected_boss = "res://bosses/Wolfsalpha/Wolfsalpha.tres"
	get_tree().change_scene_to_file("res://nodes/Start_fight.tscn")  # Startbildschirm starten
	print("Wolfsalpha ausgewählt.")
	
func _on_run_easy_pressed() -> void:
		get_tree().change_scene_to_file("res://nodes/Start_fight.tscn")  # Startbildschirm starten
		print("Run (easy) ausgewählt.")
