extends Node2D

#doppelt sich komplett mit den buttonskripts

func _on_feuermage_pressed() -> void:
		GlobalVariables.hero_path = "res://Helden/Feuermage/Feuermage.tres"
		get_tree().change_scene_to_file("res://main.tscn")  # Main-Spiel starten
		print("Feuermage ausgewählt.")

func _on_fighter_pressed() -> void:
		GlobalVariables.hero_path = "res://Helden/Fighter/Fighter.tres"
		get_tree().change_scene_to_file("res://main.tscn")  # Main-Spiel starten
		print("Fighter ausgewählt.")
