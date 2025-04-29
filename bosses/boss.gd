extends Node2D

const MAX_HEALTH = GlobalVariables.bossMaxHealth
signal action
signal restart
var max_health: int
var health =max_health	#zunächst gleicher Wert wie max_health, verändert sich aber während des spielens
var Bossname: String

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	setHealthLabel();
#	health = GlobalVariables.bossHealth;
#	$HealthBar.max_value = 300;
#	setHealthBar();

func setHealthLabel() -> void:
	$HealthBar/HealthLabel.text = "%s" % health;

func setHealthBar() -> void:
	$HealthBar.value = health
	
func init_boss(boss_data): #um den Boss zu laden
	max_health = boss_data.max_health
	health = boss_data.max_health
	Bossname = boss_data.name
	for child in $Bosse/SkillContainer.get_children():
		child.queue_free()	#alle Skills werden gelöscht
	for skill_scene in boss_data.skills: 	#nur die passenden Skills aus heroData werden neu gelaedn
		var skill_instance = skill_scene.instantiate()
		$Bosse/SkillContainer.add_child(skill_instance)
	setHealthLabel();	#hier werden die Lebensbalken gestartet und eingestellt
	$HealthBar.max_value = max_health
	setHealthBar();

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
