extends Node2D

const MAX_HEALTH = 100
signal action
var health = MAX_HEALTH

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setHealthLabel();
	$HealthBar.max_value = 100;
	setHealthBar();

func setHealthLabel() -> void:
	$HealthBar/HealthLabel.text = "%s" % health;

func setHealthBar() -> void:
	$HealthBar.value = health


func damage() -> void:
	health -= 1 # -damage
	setHealthLabel();	
	setHealthBar();
	if health <= 0:
		health = MAX_HEALTH;
	

func _on_main_press() -> void:
	damage();


func _on_button_pressed() -> void:
	damage();
