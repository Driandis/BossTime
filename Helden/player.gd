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
@onready var skill_felder = $Skillfelder.get_children()	#damit man auf die Skillfelder zugreifen kann

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Player")

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
	GlobalVariables.equipped_weapon = hero_data.equipped_weapon
	print("HP: ", health)
	print("Name: ", Spielername)
	print("Armor: ", playerArmor)
	print("Block: ", playerBlock)
	print("Magic Resistence: ", playerMagicRes)
	print("Weapon: ", GlobalVariables.equipped_weapon.name)
		#jetzt werden die Skills passend geladen
	for i in hero_data.skills.size():
		if i < skill_felder.size():
			var skill_scene = hero_data.skills[i]
			var skill_instance = skill_scene.instantiate()
			skill_felder[i].add_child(skill_instance)
		else:
				printerr("Nicht genügend Skill-Felder vorhanden, um alle Helden-Skills zu laden!")
				break
	setHealthLabel();	#hier werden die Lebensbalken gestartet und eingestellt
	$HealthBar.max_value = max_health
	setHealthBar();

#Für die Verarbeitung von Statuseffekte
var active_status_effects: Array[StatusEffect] = []

func apply_status_effect(effect_resource: Resource, target: Node):
	var effect_instance = effect_resource.duplicate(true) as StatusEffect
	effect_instance.target = target
	effect_instance._ready() # Rufe _ready auf, nachdem target gesetzt wurde
	active_status_effects.append(effect_instance)
	effect_instance.apply_effect()
func modify_attribute(attribute_name: String, amount: float):
	match attribute_name:
		"playerArmor":	#Als erstes Beispiel wegen "Brennen"
			playerArmor += amount
			print(name, "'s Rüstung geändert um: ", amount, ". Neue Rüstung: ", playerArmor)
		# Füge hier weitere Attribute hinzu, die modifiziert werden können
		_:
			print_debug("Versuch, unbekanntes Attribut zu modifizieren: ", attribute_name)
#Zum Abarbeiten der Statuseffekte am Ende des Zuges (Im Main passiert das nach take_turn
func on_turn_ended():
	var effects_to_remove: Array[StatusEffect] = []
	for effect in active_status_effects:
		if effect.decrease_duration():#Dauer reduzieren, wenn sie noch nicht abgelaufen sind
			effects_to_remove.append(effect)

	for effect in effects_to_remove:#Entfernen, wenn sie abgelaufen sind
		effect.remove_effect()	#Optionaler Effekt, wenn der Status ausläuft
		active_status_effects.erase(effect)	#Status wird entfernt

#Multiplikatoren beim DMG berücksichtigen
func apply_attack_modifiers(base_value: int) -> int:
	var modified_value = base_value
	# Waffen-Effekt
	if GlobalVariables.equipped_weapon:
		modified_value =modified_value* GlobalVariables.equipped_weapon.damage_multiplier
		
	# Buffs und Debuffs durch Statuseffekte (ausgehender Schaden)
	for effect in active_status_effects:
		modified_value = effect.modify_outgoing_damage(modified_value)
	#Items
	# Feldeffekte evemtuell hierhin und raus aus dem Main?
	var slot_effect = GlobalVariables.slot_effect_multipliers[GlobalVariables.current_slot]
	modified_value=modified_value *slot_effect
	
	return modified_value

func damage(physical_damage, mental_damage) -> void:
	
# Modifiziere eingehenden Schaden durch Statuseffekte
	var incoming_physical_damage= physical_damage
	var incoming_mental_damage= mental_damage
	
	for effect in active_status_effects:
		incoming_physical_damage = effect.modify_incoming_damage(incoming_physical_damage)
		incoming_mental_damage = effect.modify_incoming_damage(incoming_mental_damage) # Annahme: Effekte wirken auf beide Schadensarten
	# Berechnung des physischen Schadens unter Berücksichtigung der Rüstung
	var effective_physical_damage = max(0, incoming_physical_damage - playerArmor - playerBlock)
	# Berechnung des psychischen Schadens unter Berücksichtigung der mentalen Resistenz
	var effective_mental_damage = max(0, incoming_mental_damage - playerMagicRes)

 # Gesamt-Schaden (physisch + psychisch)
	var total_damage = effective_physical_damage + effective_mental_damage
	health -= ceil(total_damage)	#DMG wird aufgerundet und dann vom Leben abgezogen 
	setHealthLabel();	
	setHealthBar();
	if health == 0:
		dead.emit()
	
	print("Effective Player Physical Damage: ", effective_physical_damage)
	print("Effective Player Magic Damage: ", effective_mental_damage)
	print("Total Player Damage: ", total_damage)

@onready var player_slots = $Felder/Player.get_children()
func take_turn():
	for i in player_slots.size():	#Farbeffekt
		player_slots[i].modulate = Color(1, 1, 1)  # Reset Farbe
		player_slots[GlobalVariables.current_slot].modulate = Color(0.8, 0.7, 0.5)  # Aktives Feld hervorheben
			
	if GlobalVariables.current_slot < player_slots.size():	#kontrollbefehl
			var player_slot = player_slots[GlobalVariables.current_slot] #holt die aktuelle Slotzahl (Start:0)
			if player_slot.get_child_count() > 0:	#kein Plan? Vielleicht: Wenn mehr als ein Skill in dem Slot liegt
				var skill = get_skill_from_slot(player_slot) #holt den ersten Skill aus dem entsprechenden Slot
				if skill != null and skill.has_method("_run_effect"):	#Skill wird mit Multiplikator aktiviert
					var slot_effect = GlobalVariables.slot_effect_multipliers[GlobalVariables.current_slot]	#Holt den passenden Multiplikator für das aktuelle Feld
					skill._run_effect(slot_effect)	#aktiviert den Skill mit dem entsprechenden Multiplikator
				else:
					print("Kein Skill in Slot ", GlobalVariables.current_slot)
#Skills aus den Feldern erkennen
func get_skill_from_slot(slot: Node) -> Skill: #soll glaube den richtigen Skill holen aus dem Slot
	for child in slot.get_children():
		if child is Skill:
			return child
		# Untersuche Enkelkinder (die Skill-Instanz sollte ein Kind des Area2D sein)
		for grandchild in child.get_children():
			if grandchild is Skill:
				return grandchild
	return null
func _on_main_press() -> void:
	damage(0,0);


func _on_button_pressed() -> void:
	damage(12,0);


func _on_game_over_button_pressed() -> void:
	health = max_health;
	$HealthBar.value = health;
	$HealthLabel.text = "%s" % health;
	
