extends Node2D

const MAX_HEALTH = GlobalVariables.bossMaxHealth
signal action
signal restart
var max_health: int
var health =max_health	#zunächst gleicher Wert wie max_health, verändert sich aber während des spielens
var Bossname: String
var bossBlock: int	#greift das hier auf die aktuellen Variablen zu?
var bossArmor: int
var bossMagicRes: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Boss")

func setHealthLabel() -> void:
	$HealthBar/HealthLabel.text = "%s" % health;	

func setHealthBar() -> void:
	$HealthBar.value = health
	
func init_boss(boss_data): #um den Boss zu laden
	max_health = boss_data.max_health
	health = boss_data.max_health
	Bossname = boss_data.name
	bossBlock = boss_data.bossBlock
	bossArmor = boss_data.bossArmor
	bossMagicRes = boss_data.bossMagicRes
	print("Boss HP: ", health)
	print("Boss Name: ", Bossname)
	print("Boss Armor: ", bossArmor)
	print("Boss Block: ", bossBlock)
	print("Boss Magic Resistence: ", bossMagicRes)
	
	#jetzt werden die Skills passend geladen
	for child in $Bosse/SkillContainer.get_children():
		child.queue_free()	#alle Skills werden gelöscht
	for skill_scene in boss_data.skills: 	#nur die passenden Skills aus heroData werden neu gelaedn
		var skill_instance = skill_scene.instantiate()
		$Bosse/SkillContainer.add_child(skill_instance)
	setHealthLabel();	#hier werden die Lebensbalken gestartet und eingestellt
	$HealthBar.max_value = max_health
	setHealthBar();

#Multiplikatoren beim DMG berücksichtigen
func apply_attack_modifiers(base_value: int) -> int:
	var modified_value = base_value
	# Waffen-Effekt
	if GlobalVariables.equipped_weapon:
		modified_value =modified_value* GlobalVariables.equipped_weapon.damage_multiplier
		
	# Buffs
	#for buff in active_buffs:
	#	modified_value = buff.modify_outgoing_damage(modified_value)

	# Feldeffekte evemtuell hierhin und raus aus dem Main?
	var slot_effect = GlobalVariables.slot_effect_multipliers[GlobalVariables.current_slot]
	modified_value=modified_value *slot_effect
	
	return modified_value

var is_defeated = false  # Tod?
func damage(physical_damage, mental_damage) -> void:
		# Berechnung des physischen Schadens unter Berücksichtigung der Rüstung
	var effective_physical_damage = max(0, physical_damage - bossArmor -bossBlock)
	# Berechnung des psychischen Schadens unter Berücksichtigung der mentalen Resistenz
	var effective_mental_damage = max(0, mental_damage - bossMagicRes)

 # Gesamt-Schaden (physisch + psychisch)
	var total_damage = effective_physical_damage + effective_mental_damage
	health -= ceil(total_damage)	#DMG wird aufgerundet und dann vom Leben abgezogen 
	health = clamp(health, 0, max_health) #damit man nicht über Maxleben heilt, 
	setHealthLabel();	
	setHealthBar();
	if health == 0:
		get_tree().change_scene_to_file("res://nodes/loot.tscn")
		#health=max_health
	print("Effective Boss Physical Damage: ", effective_physical_damage)
	print("Effective Boss Magic Damage: ", effective_mental_damage)
	print("Total Boss Damage: ", total_damage)



#func _on_main_press() -> void:
	#damage(0);


#func _on_button_pressed() -> void:
	#damage(0);
