extends Resource
@export var hero_name: String = "Feuermagier"
@export var max_health: int = 100
@export var skills: Array[PackedScene] = [
	preload("res://Skills/Feuerball.tscn")
]
