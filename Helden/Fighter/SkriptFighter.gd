extends Resource
@export var hero_name: String = "Fighter"
@export var max_health: int = 300
@export var skills: Array[PackedScene] = [
	preload("res://nodes/heal.tscn")
]
