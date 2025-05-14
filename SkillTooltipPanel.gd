extends Panel
@onready var description_label = $DescriptionLabel
	
func show_tooltip(item, position: Vector2):
	var tooltip_text = ""
	if item is Skill:
		tooltip_text = item.get_skill_description()
	elif item is WeaponData:
		print("Waffe sollte angezeigt werden")
		tooltip_text = get_weapon_description(item)
	#else:
	#	tooltip_text = "Keine Beschreibung verfügbar." # Fallback
	if is_instance_valid(description_label):
		print("Instance valid erfolgreich")
		description_label.text = tooltip_text
		global_position = position + Vector2(0, -20) # Offset zur Maus
		visible = true
	else:
		printerr("Fehler: description_label ist immer noch null!")
		visible = false

func hide_description():
	visible = false

func get_weapon_description(weapon: WeaponData) -> String:
	print("Sucht Waffenbeschreibung")
	var description_text = ""
	description_text += "Name: " + weapon.name + "\n"
	description_text += "Multiplikator: " + str(weapon.damage_multiplier) + "\n"
	#if weapon.bonus_effect != null and weapon.bonus_effect.effect_name != "":
	#	description_text += "Effekt: " + weapon.bonus_effect.effect_name + "\n"
	#	if weapon.bonus_effect.effect_description != "":
	#		description_text += "Effektbeschreibung: " + weapon.bonus_effect.effect_description + "\n"
	#else:
	#	description_text += "Effekt: Keiner\n"
	#description_text += "Beschreibung: " + weapon.description + "\n"
	print("Generierter Tooltip-Text: ", description_text) # Hinzugefügt
	return description_text
