extends TextureRect

var weapon_data: WeaponData = null

func _ready():
	_update_weapon_display()
	GlobalVariables.player_equipped_weapon_changed.connect(_update_weapon_display)

func _update_weapon_display():
	weapon_data = GlobalVariables.equipped_weapon
	if weapon_data != null:
		texture = weapon_data.weapon_texture
	else:
		texture = null

func _on_mouse_entered():
	TooltipManager.show_tooltip(GlobalVariables.equipped_weapon, get_global_mouse_position())

func _on_mouse_exited():
	if is_instance_valid(TooltipManager):
		TooltipManager.hide_description()
		
