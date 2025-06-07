extends Resource
class_name BossData

@export var name: String
@export var skills: Array[PackedScene]
@export var max_health: int
@export var bossBlock: int	#greift das hier auf die aktuellen Variablen zu?
@export var bossArmor: int
@export var bossMagicRes: int
@export var boss_texture: Texture2D
#Skillreihenfolge und Skills:
@export var rounds: Array = []  # Jede Runde ist ein Array von Skill-Ressourcen
@export var passive: Resource
@export var passive_trigger : float	#Bei wieviel Prozent der MaxHP triggert die Passive?

func get_description() -> String:
	var hero_description_text = ""
	hero_description_text += "Name: " + name + "\n" # Greife direkt auf 'name' zu
	#weapon_description_text += "Multiplikator: " + str(damage_multiplier) + "\n" # vorher mit str()	Greife direkt auf 'damage_multiplier' zu
	hero_description_text += "Amor: " + str(GlobalVariables.bossArmor) + "\n"
	hero_description_text += "Block: " + str(GlobalVariables.bossBlock) + "\n"
	hero_description_text += "Magic Res: " + str(GlobalVariables.bossMagicRes) + "\n"
	return hero_description_text
