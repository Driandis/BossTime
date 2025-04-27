extends Node2D

const MAX_HEALTH = GlobalVariables.playerMaxHealth
signal action
signal dead
# erstmal raus von Maxi var health = MAX_HEALTH
var max_health: int
var health =max_health	#zunächst gleicher Wert wie max_health, verändert sich aber während des spielens
var Spielername: String

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#setHealthLabel();
	#$HealthBar.max_value = max_health
	#setHealthBar();

func setHealthLabel() -> void:
	$HealthLabel.text = "%s" % health;

func setHealthBar() -> void:
	$HealthBar.value = health;

func init_hero(hero_data): #um den Heldencharkter zu laden
	max_health = hero_data.max_health
	health = hero_data.max_health
	Spielername = hero_data.name
	for child in $Helden/SkillContainer.get_children():
		child.queue_free()	#alle Skills werden gelöscht
	for skill_scene in hero_data.skills: 	#nur die passenden Skills aus heroData werden neu gelaedn
		var skill_instance = skill_scene.instantiate()
		$Helden/SkillContainer.add_child(skill_instance)
	setHealthLabel();	#hier werden die Lebensbalken gestartet und eingestellt
	$HealthBar.max_value = max_health
	setHealthBar();


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
	health = max_health;
	$HealthBar.value = health;
	$HealthLabel.text = "%s" % health;
	
