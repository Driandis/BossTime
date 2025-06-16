extends Node2D


func _ready() -> void:
	$"Itemauswahl/Item 1/VBoxContainer/Item1Label".text=GlobalVariables.generated_loot_items[0].name
	$"Itemauswahl/Item 1/VBoxContainer/Item1Icon".texture =GlobalVariables.generated_loot_items[0].Item_texture
	$"Itemauswahl/Item 2/VBoxContainer/Item2Label".text=GlobalVariables.generated_loot_items[1].name
	$"Itemauswahl/Item 2/VBoxContainer/Item2Icon".texture =GlobalVariables.generated_loot_items[1].Item_texture
	$"Itemauswahl/Item 3/VBoxContainer/Item3Label".text=GlobalVariables.generated_loot_items[2].name
	$"Itemauswahl/Item 3/VBoxContainer/Item3Icon".texture =GlobalVariables.generated_loot_items[2].Item_texture
	
	
	
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://nodes/main.tscn")
	


func _on_item_1_button_pressed() -> void:
	GlobalVariables.equipped_items.append(GlobalVariables.generated_loot_items[0]) #wurde bereits gelöscht
	GlobalVariables.item_pool_resources.append(GlobalVariables.generated_loot_items[1])	#wieder hinzufügen nachdem sie vorher gelöscht wurden
	GlobalVariables.item_pool_resources.append(GlobalVariables.generated_loot_items[2])#wieder hinzufügen nachdem sie vorher gelöscht wurden
	get_tree().change_scene_to_file("res://nodes/main.tscn")
	print("Item ", GlobalVariables.generated_loot_items[0].name, " picked.")
	

func _on_item_2_button_pressed() -> void:
	GlobalVariables.equipped_items.append(GlobalVariables.generated_loot_items[1]) #wurde bereits gelöscht
	GlobalVariables.item_pool_resources.append(GlobalVariables.generated_loot_items[0])	#wieder hinzufügen nachdem sie vorher gelöscht wurden
	GlobalVariables.item_pool_resources.append(GlobalVariables.generated_loot_items[2])#wieder hinzufügen nachdem sie vorher gelöscht wurden
	get_tree().change_scene_to_file("res://nodes/main.tscn")
	print("Item ", GlobalVariables.generated_loot_items[1].name, " picked.")
	
func _on_item_3_button_pressed() -> void:
	GlobalVariables.equipped_items.append(GlobalVariables.generated_loot_items[2]) #wurde bereits gelöscht
	GlobalVariables.item_pool_resources.append(GlobalVariables.generated_loot_items[1])	#wieder hinzufügen nachdem sie vorher gelöscht wurden
	GlobalVariables.item_pool_resources.append(GlobalVariables.generated_loot_items[0])#wieder hinzufügen nachdem sie vorher gelöscht wurden
	get_tree().change_scene_to_file("res://nodes/main.tscn")
	print("Item ", GlobalVariables.generated_loot_items[2].name, " picked.")
