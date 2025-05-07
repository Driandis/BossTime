extends Node2D

#doppelt sich komplett mit den buttonskripts

func _on_feuermage_pressed() -> void:
		GlobalVariables.selected_hero = "res://Helden/Feuermage/Firemage.tres"
		get_tree().change_scene_to_file("res://nodes/boss_selection.tscn")  # Main-Spiel starten
		print("Feuermage ausgewählt.")

func _on_fighter_pressed() -> void:
		GlobalVariables.selected_hero = "res://Helden/Fighter/Fighter.tres"
		get_tree().change_scene_to_file("res://nodes/boss_selection.tscn")  # Main-Spiel starten
		print("Zweihandkämpfer ausgewählt.")
