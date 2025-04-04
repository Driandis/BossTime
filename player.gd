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


func damage() -> void:
	health -= 10 # -damage
	setHealthLabel();	
	setHealthBar();
	if health == 0:
		dead.emit()
		
	

func _on_main_press() -> void:
	damage();


func _on_button_pressed() -> void:
	damage();


func _on_game_over_button_pressed() -> void:
	health = GlobalVariables.playerMaxHealth;
	$HealthBar.value = health;
	$HealthLabel.text = "%s" % health;
	
