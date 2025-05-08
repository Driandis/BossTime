extends Node2D

#const MAX_HEALTH = GlobalVariables.playerMaxHealth
signal action
signal dead
# erstmal raus von Maxi var health = MAX_HEALTH
var max_health: int
var health =max_health	#zunächst gleicher Wert wie max_health, verändert sich aber während des spielens
var Spielername: String
var playerBlock: int
var playerMagicRes: int
var playerArmor: int
var physical_damage: int
var mental_damage: int
var equipped_weapon: WeaponData

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#setHealthLabel();
	#$HealthBar.max_value = max_health
	#setHealthBar();

func setHealthLabel() -> void:
	$HealthLabel.text = "%s" % health;

func setHealthBar() -> void:
	$HealthBar.value = health;

func init_hero(hero_data): #um den Heldencharkter zu laden lädt er die Werte aus dem Hero-Data
	max_health = hero_data.max_health
	health = hero_data.max_health	#zunächst auch max
	Spielername = hero_data.name
	playerBlock = hero_data.playerBlock
	playerArmor = hero_data.playerArmor
	playerMagicRes = hero_data.playerMagicRes
	equipped_weapon = hero_data.equipped_weapon
	print("HP: ", health)
	print("Name: ", Spielername)
	print("Armor: ", playerArmor)
	print("Block: ", playerBlock)
	print("Magic Resistence: ", playerMagicRes)
	print("Weapon: ", equipped_weapon)
		#jetzt werden die Skills passend geladen
	for child in $Helden/SkillContainer.get_children():
		child.queue_free()	#alle Skills werden gelöscht
	for skill_scene in hero_data.skills: 	#nur die passenden Skills aus heroData werden neu gelaedn
		var skill_instance = skill_scene.instantiate()
		$Helden/SkillContainer.add_child(skill_instance)
	setHealthLabel();	#hier werden die Lebensbalken gestartet und eingestellt
	$HealthBar.max_value = max_health
	setHealthBar();

#Waffe des Spielers laden und berücksichtigen
func apply_weapon_multiplier(damage: int) -> int:
	if equipped_weapon:
		return int(damage * equipped_weapon.damage_multiplier)
	return damage




func damage(physical_damage, mental_damage) -> void:
		# Berechnung des physischen Schadens unter Berücksichtigung der Rüstung
	var effective_physical_damage = max(0, physical_damage - playerArmor -playerBlock)
	# Berechnung des psychischen Schadens unter Berücksichtigung der mentalen Resistenz
	var effective_mental_damage = max(0, mental_damage - playerMagicRes)

 # Gesamt-Schaden (physisch + psychisch)
	var total_damage = effective_physical_damage + effective_mental_damage
	health -= ceil(total_damage)	#DMG wird aufgerundet und dann vom Leben abgezogen 
	health = clamp(health, 0, max_health) #damit man nicht über Maxleben heilt, 
	setHealthLabel();	
	setHealthBar();
	if health == 0:
		dead.emit()
	
	print("Effective Player Physical Damage: ", effective_physical_damage)
	print("Effective Player Magic Damage: ", effective_mental_damage)
	print("Total Player Damage: ", total_damage)


func heal(amount): #Heal Funktion
	health = min(health + amount, max_health)
	
func _on_main_press() -> void:
	damage(0,0);


func _on_button_pressed() -> void:
	damage(12,0);


func _on_game_over_button_pressed() -> void:
	health = max_health;
	$HealthBar.value = health;
	$HealthLabel.text = "%s" % health;
	
