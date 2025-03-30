extends Node

@export var player_scene: PackedScene
signal press


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


	
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func input(event: InputEvent) -> void:
		if event.is_action_pressed("ui_accept") || event.is_action_pressed("ui_right"):
			var damage = RandomNumberGenerator.new();
			press.emit();                      
			
