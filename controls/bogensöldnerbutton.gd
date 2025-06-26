extends Control

func _on_bogensöldner_button_pressed():
	# HeroData-Pfad speichern zum entsprechenden Helden
	GlobalVariables.selected_hero = "res://Helden/Bogensöldner/Bogensöldner.tres"
	
	# Szene wechseln
	get_tree().change_scene_to_file("res://Main.tscn")


func _on_pressed() -> void:
	pass # Replace with function body.
