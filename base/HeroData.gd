extends Resource
class_name HeroData

@export var name: String
@export var skills: Array[PackedScene]
@export var max_health: int
@export var hero_texture: Texture2D
@export var playerBlock: int
@export var playerArmor: int
@export var playerMagicRes: int
@export var equipped_weapon: WeaponData

func get_description() -> String:
	#rint("get_description aufgerufen")
	var hero_description_text = ""
	hero_description_text += "Name: " + name + "\n" # Greife direkt auf 'name' zu
	#weapon_description_text += "Multiplikator: " + str(damage_multiplier) + "\n" # vorher mit str()	Greife direkt auf 'damage_multiplier' zu
	hero_description_text += "Amor: " + str(GlobalVariables.playerArmor) + "x\n"
	hero_description_text += "Block: " + str(GlobalVariables.playerBlock) + "x\n"
	hero_description_text += "Magic Res: " + str(GlobalVariables.playerMagicRes) + "x\n"
	return hero_description_text
