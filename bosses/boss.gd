extends Node2D

const MAX_HEALTH = GlobalVariables.bossMaxHealth
signal action
signal restart
var health = MAX_HEALTH


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setHealthLabel();
	health = GlobalVariables.bossHealth;
	$HealthBar.max_value = 300;
	setHealthBar();

func setHealthLabel() -> void:
	$HealthBar/HealthLabel.text = "%s" % health;

func setHealthBar() -> void:
	$HealthBar.value = health


func damage(amount: int) -> void:
	health -= amount # -damage (Zeitnah ändern zu "Amount")
	health = clamp(health, 0, MAX_HEALTH) #damit man nicht über Maxleben heilt
	setHealthLabel();	
	setHealthBar();
	print("Boss erleidet ", amount, "Schaden. Neue HP:", health) #nervt etwas. Vielleicht lieber in die Skillskripte?
	if health <= 0:
		health = MAX_HEALTH;
	

func _on_main_press() -> void:
	damage(0);


func _on_button_pressed() -> void:
	damage(0);
