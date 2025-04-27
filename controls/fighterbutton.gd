extends Control

func _on_fighter_button_pressed():
	# HeroData-Pfad speichern zum entsprechenden Helden
	GlobalVariables.hero_path = "res://Helden/Fighter/Fighter.tres"
	
	# Szene wechseln
	get_tree().change_scene_to_file("res://Main.tscn")


func _on_pressed() -> void:
	pass # Replace with function body.
