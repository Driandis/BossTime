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
