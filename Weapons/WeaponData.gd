extends Resource
class_name WeaponData

@export var name : String
@export var damage_multiplier : float = 2
@export var description : String
@export var bonus_effect: Effect
@export var weapon_texture: Texture2D

# Neue Funktion zur Generierung der Waffenbeschreibung
func get_description() -> String:
	print("get_description aufgerufen")
	var weapon_description_text = ""
	weapon_description_text += "Name: " + name + "\n" # Greife direkt auf 'name' zu
	#weapon_description_text += "Multiplikator: " + str(damage_multiplier) + "\n" # vorher mit str()	Greife direkt auf 'damage_multiplier' zu
	weapon_description_text += "Beschreibung: " + description + "\n" # Greife direkt auf 'description' zu
	
#	if bonus_effect != null:
#		var effect_instance_name = ""
#		var effect_instance_description = ""

		# Zuerst versuchen, die direkten Eigenschaften des Effekts zu nutzen
#		if "effect_name" in bonus_effect:
#			effect_instance_name = bonus_effect.effect_name

#		if "effect_description" in bonus_effect:
#			effect_instance_description = bonus_effect.effect_description

		# Wenn der Effektname leer ist, versuchen wir, ihn aus dem Resource-Pfad zu holen
#		if effect_instance_name == "":
#			var effect_script = bonus_effect.get_script()
#			if effect_script:
#				effect_instance_name = effect_script.resource_path.get_file().get_basename()
#			else:
#				effect_instance_name = "Unbekannter Effekt" # Fallback
#
#		weapon_description_text += "Effekt: " + effect_instance_name + "\n"
#		if effect_instance_description != "":
#			weapon_description_text += "Effektbeschreibung: " + effect_instance_description + "\n"
	#else:
	#	weapon_description_text += "Effekt: Keiner\n"
	#return weapon_description_text

#test
	return "Name: {name}\nDamage Multiplyer: {cooldown}\ng}".format({
	"name": name,
	"cooldown": damage_multiplier})
