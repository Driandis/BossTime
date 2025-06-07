# Verwaltet die Generierung und Anzeige von Loot nach einem Kampf.
extends Node
class_name LootManager

@export var loot_scene_path: String = "res://nodes/loot.tscn" # Pfad zu deiner Loot-Szene

# Diese Funktion wird von Main.gd aufgerufen, wenn Loot generiert werden soll.
func generate_and_show_loot(number_of_items: int):
	print("LootManager: Generiere ", number_of_items, " Items.")
	GlobalVariables.generate_random_loot(number_of_items)
	
	# Verzögere den Szenenwechsel, um Timing-Probleme zu vermeiden.
	print("LootManager: Plane Szenenwechsel zu Loot-Szene.")
	get_tree().call_deferred("change_scene_to_file", loot_scene_path)
