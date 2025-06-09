extends Resource
class_name WeaponData

@export var name : String
@export var damage_multiplier : float = 2
@export var description : String
@export var bonus_effect: StatusEffect
@export var weapon_texture: Texture2D

# Neue Funktion zur Generierung der Waffenbeschreibung
func get_description() -> String:
	var weapon_description_text = ""
	weapon_description_text += "Name: " + name + "\n" # Greife direkt auf 'name' zu
	weapon_description_text += "Beschreibung: " + description + "\n" # Greife direkt auf 'description' zu
	weapon_description_text += "Schaden-Multiplikator: " + str(damage_multiplier) + "\n"
	return weapon_description_text
