extends TextureRect


var first_effect: StatusEffect = null


func _on_mouse_entered():
	TooltipManager.show_tooltip(GlobalVariables.active_player_status_effects[0], get_global_mouse_position())

func _on_mouse_exited():
	if is_instance_valid(TooltipManager):
		TooltipManager.hide_description()
