extends TextureRect

var weapon_data: HeroData = null

#func _ready():
#	_update_weapon_display()
#	GlobalVariables.player_equipped_weapon_changed.connect(_update_weapon_display)

func _update_weapon_display():
	weapon_data = GlobalVariables.current_hero
	if weapon_data != null:
		texture = weapon_data.hero_texture
	else:
		texture = null

func _on_mouse_entered():
	TooltipManager.show_tooltip(GlobalVariables.current_hero, get_global_mouse_position())

func _on_mouse_exited():
	if is_instance_valid(TooltipManager):
		TooltipManager.hide_description()
		
