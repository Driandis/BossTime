extends Node2D
class_name Player
#const MAX_HEALTH = GlobalVariables.playerMaxHealth
signal action
signal dead

@onready var skill_felder = $Skillfelder.get_children()	#damit man auf die Skillfelder zugreifen kann
signal was_attacked(attacker: Node, damage_taken: float)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Player")

func setHealthLabel() -> void:
	$HealthLabel.text = "%s" % GlobalVariables.playerHealth;

func setHealthBar() -> void:
	$HealthBar.value = GlobalVariables.playerHealth;

func init_hero(hero_data): #um den Heldencharkter zu laden lädt er die Werte aus dem Hero-Data
	GlobalVariables.playerMaxHealth = hero_data.max_health
	GlobalVariables.playerHealth = hero_data.max_health	#zunächst auch max
	GlobalVariables.playerName = hero_data.name
	GlobalVariables.playerBlock = hero_data.playerBlock
	GlobalVariables.playerArmor = hero_data.playerArmor
	GlobalVariables.playerMagicRes = hero_data.playerMagicRes
	GlobalVariables.equipped_weapon = hero_data.equipped_weapon
	print("HP: ", GlobalVariables.playerHealth)
	print("Name: ", GlobalVariables.playerName)
	print("Armor: ", GlobalVariables.playerArmor)
	print("Block: ", GlobalVariables.playerBlock)
	print("Magic Resistence: ", GlobalVariables.playerMagicRes)
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
	$HealthBar.max_value = GlobalVariables.playerMaxHealth
	setHealthBar();

#Für die Verarbeitung von Statuseffekte
#var active_status_effects: Array[StatusEffect] = []

func apply_status_effect(effect_resource: Resource, target: Node):
	var effect_instance = effect_resource.duplicate(true) as StatusEffect
	effect_instance.target = target
	#effect_instance._ready() # Rufe _ready auf, nachdem target gesetzt wurde
	GlobalVariables.active_player_status_effects.append(effect_instance)
	effect_instance.apply_effect(target)
	
func modify_attribute(attribute_name: String, amount: float):
	match attribute_name:
		"playerArmor":	#Als erstes Beispiel wegen "Brennen"
			GlobalVariables.playerArmor += amount
			print(name, "'s Rüstung geändert um: ", amount, ". Neue Rüstung: ", GlobalVariables.playerArmor)
		# Füge hier weitere Attribute hinzu, die modifiziert werden können
		_:
			print_debug("Versuch, unbekanntes Attribut zu modifizieren: ", attribute_name)
#Zum Abarbeiten der Statuseffekte am Ende des Zuges (Im Main passiert das nach take_turn
func on_turn_ended(): # KEIN 'target: Node' Parameter hier
	var effects_to_remove: Array[Dictionary] = [] # Annahme: Liste von Dictionaries {effect: StatusEffect, target: Node}
	
	# Gehe alle aktiven Effekte DIESES SPIELERS durch
	# WICHTIG: Hier gehen wir davon aus, dass GlobalVariables.active_player_status_effects
	# NUR Effekte enthält, die auf DIESEN Spieler angewendet wurden.
	for effect_data in GlobalVariables.active_player_status_effects:
		var effect: StatusEffect = effect_data
		var effect_target_node: Node = effect_data.target # Das ist der Node, auf den der Effekt angewendet wurde

		# Prüfe, ob der Effekt und sein Ziel noch gültig sind
		# Und ob dieser Effekt tatsächlich auf DIESEN Spieler angewendet wurde (redundant, aber sicher)
		if is_instance_valid(effect) and is_instance_valid(effect_target_node) and effect_target_node == self:
			# Reduziere die Dauer des Effekts
			if effect.decrease_duration():
				effects_to_remove.append(effect_data) # Füge das gesamte Dictionary zur Entfernen-Liste hinzu
			else:
				# Wenn der Effekt noch aktiv ist, führe seine Runden-Logik aus (z.B. Schaden pro Runde)
				if effect.has_method("on_turn_tick"):
					effect.on_turn_tick(self) # Übergib 'self' (den Spieler) als Ziel für den Tick
		elif not is_instance_valid(effect) or not is_instance_valid(effect_target_node):
			# Wenn der Effekt oder sein Ziel ungültig geworden ist, füge ihn zur Entfernen-Liste hinzu
			effects_to_remove.append(effect_data)

	# Entferne die abgelaufenen Effekte
	for effect_data in effects_to_remove:
		var effect: StatusEffect = effect_data.effect
		var effect_target_node: Node = effect_data.target

		if is_instance_valid(effect) and is_instance_valid(effect_target_node):
			# Rufe die remove_effect-Methode des Effekts auf und übergib 'self' (den Spieler)
			effect.remove_effect(self) # Übergib 'self' als den Node, von dem der Effekt entfernt wird
			print("Status-Effekt '", effect.effect_name, "' von Spieler entfernt.")
			# Optional: Sende ein globales Signal, dass der Effekt entfernt wurde
			GlobalVariables.status_effect_removed.emit(effect, self)
		
		# Entferne den Effekt aus der globalen Liste
		GlobalVariables.active_player_status_effects.erase(effect_data)

#Multiplikatoren beim DMG berücksichtigen
func apply_attack_modifiers(physic_value: int, magic_value: int) -> Dictionary:	#Dictionary damit man mit beiden Werten gleichzeitig arbeiten kann
	var modified_physic_value = physic_value
	var modified_magic_value = magic_value
	# Waffen-Effekt
	if GlobalVariables.equipped_weapon:
		modified_physic_value =modified_physic_value* GlobalVariables.equipped_weapon.damage_multiplier
		modified_magic_value =modified_magic_value* GlobalVariables.equipped_weapon.damage_multiplier
	# Buffs und Debuffs durch Statuseffekte (ausgehender Schaden)
	   # --- NEU: Wende Modifikatoren von aktiven Statuseffekten des Casters an ---
	# Iteriere durch die Effekte, die auf DIESEN Spieler wirken
	for effect in GlobalVariables.active_player_status_effects:
		if effect.has_method("modify_outgoing_damage"):
			print("Versucht DMG anzupassen")
			var modified_values = effect.modify_outgoing_damage(
			modified_physic_value, modified_magic_value)
			modified_physic_value = modified_values.physic
			modified_magic_value = modified_values.magic
	#Items
	
	# Feldeffekte evemtuell hierhin und raus aus dem Main?
	var slot_effect = GlobalVariables.slot_effect_multipliers[GlobalVariables.current_slot]
	modified_physic_value=modified_physic_value *slot_effect
	modified_magic_value=modified_magic_value*slot_effect
	return {"physic": modified_physic_value, "magic": modified_magic_value}
	
func damage(physical_damage, magic_damage, attacker: Node = null) -> void:
	
# Modifiziere eingehenden Schaden durch Statuseffekte
	var incoming_physical_damage= physical_damage
	var incoming_magic_damage= magic_damage
	
	for effect in GlobalVariables.active_player_status_effects:
		var incoming_damage = effect.modify_incoming_damage(incoming_physical_damage, incoming_magic_damage)
		incoming_physical_damage=incoming_damage.physic
		incoming_magic_damage=incoming_damage.magic
		# Berechnung des physischen Schadens unter Berücksichtigung der Rüstung
	var effective_physical_damage = max(0, incoming_physical_damage - GlobalVariables.playerArmor - GlobalVariables.playerBlock)
	# Berechnung des psychischen Schadens unter Berücksichtigung der mentalen Resistenz
	var effective_magic_damage = max(0, incoming_magic_damage - GlobalVariables.playerMagicRes)

 # Gesamt-Schaden (physisch + psychisch)
	var total_damage = effective_physical_damage + effective_magic_damage
	GlobalVariables.playerHealth -= ceil(total_damage)	#DMG wird aufgerundet und dann vom Leben abgezogen 
	setHealthLabel();	
	setHealthBar();
	if GlobalVariables.playerHealth <= 0:
		dead.emit()
	
	print("Effective Player Physical Damage: ", effective_physical_damage)
	print("Effective Player Magic Damage: ", effective_magic_damage)
	print("Total Player Damage: ", total_damage)
		# Signal aussenden, dass der Spieler angegriffen wurde
	if attacker != null:
		was_attacked.emit(attacker, total_damage)
	else:
		# Wenn der Angreifer nicht bekannt ist, sende nur den Schaden
		was_attacked.emit(null, total_damage)
		
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
	print("Aktive Player Statuseffekte: ",GlobalVariables.active_player_status_effects)
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
#func _on_main_press() -> void:
#	damage(0,0);


#func _on_button_pressed() -> void:
#	damage(12,0);


func _on_game_over_button_pressed() -> void:
	GlobalVariables.playerHealth = GlobalVariables.playerMaxHealth;
	$HealthBar.value = GlobalVariables.playerHealth;
	$HealthLabel.text = "%s" % GlobalVariables.playerHealth;
	
