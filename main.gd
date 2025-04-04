extends Node

@export var player_scene: PackedScene
signal press
signal confirm

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func input(event: InputEvent) -> void:
		if event.is_action_pressed("ui_accept") || event.is_action_pressed("ui_right"):
			var damage = RandomNumberGenerator.new();
			press.emit();


func _on_player_dead() -> void:
	$GameOver.visible = true;
	

func _on_button_pressed() -> void:
		$GameOver.visible = false;
		GlobalVariables.playerHealth = GlobalVariables.playerMaxHealth;
		GlobalVariables.bossHealth = GlobalVariables.bossMaxHealth;
