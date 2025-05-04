extends Node2D

#doppelt sich komplett mit den buttonskripts

func _on_barbarianking_pressed() -> void:
		GlobalVariables.selected_boss = "res://bosses/Barbarianking/Barbarianking.tres"
		get_tree().change_scene_to_file("res://nodes/Start_fight.tscn")  # Startbildschirm starten
		print("Barbarianking ausgewählt.")
