extends TextureRect

var weapon_data: Item = null


func _on_mouse_entered():
	if GlobalVariables.equipped_items.size() >=2:
		TooltipManager.show_tooltip(GlobalVariables.equipped_items[1], get_global_mouse_position())

func _on_mouse_exited():
	if is_instance_valid(TooltipManager):
		TooltipManager.hide_description()
		
