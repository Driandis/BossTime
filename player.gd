extends Node2D

const MAX_HEALTH = GlobalVariables.playerMaxHealth
signal action
signal dead
var health = MAX_HEALTH

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setHealthLabel();
	health = GlobalVariables.playerHealth;
	$HealthBar.max_value = GlobalVariables.playerHealth;
	setHealthBar();

func setHealthLabel() -> void:
	$HealthLabel.text = "%s" % health;

func setHealthBar() -> void:
	$HealthBar.value = health;




func damage(amount: int) -> void:
	health -= amount 
	health = clamp(health, 0, MAX_HEALTH) #damit man nicht über Maxleben heilt
	setHealthLabel();	
	setHealthBar();
	if health == 0:
		dead.emit()
		
	

func _on_main_press() -> void:
	damage(0);


func _on_button_pressed() -> void:
	damage(10);


func _on_game_over_button_pressed() -> void:
	health = GlobalVariables.playerMaxHealth;
	$HealthBar.value = health;
	$HealthLabel.text = "%s" % health;
	
