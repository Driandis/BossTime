extends Node2D
class_name Boss
#const MAX_HEALTH = GlobalVariables.bossMaxHealth
signal action
signal restart
#var max_health: int
#var health =max_health	#zunächst gleicher Wert wie max_health, verändert sich aber während des spielens
#var Bossname: String
#var bossBlock: int	#greift das hier auf die aktuellen Variablen zu?
#var bossArmor: int
#var bossMagicRes: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Boss")
	print("boss_slots: ", boss_slots)

func setHealthLabel() -> void:
	$HealthBar/HealthLabel.text = "%s" % GlobalVariables.bossHealth;	

func setHealthBar() -> void:
	$HealthBar.value = GlobalVariables.bossHealth
	
func init_boss(boss_data): #um den Boss zu laden
	GlobalVariables.bossMaxHealth = boss_data.max_health
	GlobalVariables.bossHealth = boss_data.max_health
	GlobalVariables.bossName = boss_data.name
	GlobalVariables.bossBlock = boss_data.bossBlock
	GlobalVariables.bossArmor = boss_data.bossArmor
	GlobalVariables.bossMagicRes = boss_data.bossMagicRes
	skill_plan = boss_data.rounds # Zugriff auf den Skillplan aus den Daten
	print("Runden geladen:", skill_plan.size(), " Runden:", skill_plan) # ← Debug
	print("boss_slots.size(): ", boss_slots.size()) #Debug
	print("Verschiedene Boss-Skillrunden: ", skill_plan.size())
	print("Boss HP: ", GlobalVariables.bossHealth)
	print("Boss Name: ", GlobalVariables.bossName)
	print("Boss Armor: ", GlobalVariables.bossArmor)
	print("Boss Block: ", GlobalVariables.bossBlock)
	print("Boss Magic Resistence: ", GlobalVariables.bossMagicRes)
	load_skills_for_turn() # Optional: Lade die ersten Skills direkt
	setHealthLabel();	#hier werden die Lebensbalken gestartet und eingestellt
	$HealthBar.max_value = GlobalVariables.bossMaxHealth
	setHealthBar();

#Multiplikatoren beim DMG berücksichtigen
func apply_attack_modifiers(physic_value: int, magic_value: int) -> Dictionary:	#Dictionary damit man mit beiden Werten gleichzeitig arbeiten kann
	var modified_physic_value = physic_value
	var modified_magic_value = magic_value
	# Waffen-Effekt
	if GlobalVariables.equipped_weapon:
		modified_physic_value =modified_physic_value* GlobalVariables.equipped_weapon.damage_multiplier
		modified_magic_value =modified_magic_value* GlobalVariables.equipped_weapon.damage_multiplier
	# Buffs und Debuffs durch Statuseffekte (ausgehender Schaden)
	#for effect in active_status_effects:
	#	modified_value = effect.modify_outgoing_damage(modified_value)
	#Items
	# Feldeffekte evemtuell hierhin und raus aus dem Main?
	var slot_effect = GlobalVariables.slot_effect_multipliers[GlobalVariables.current_slot]
	modified_physic_value=modified_physic_value *slot_effect
	modified_magic_value=modified_magic_value*slot_effect
	return {"physic": modified_physic_value, "magic": modified_magic_value}
	

var is_defeated = false  # Tod?
func damage(physical_damage, magic_damage) -> void:
		# Berechnung des physischen Schadens unter Berücksichtigung der Rüstung
	var effective_physical_damage = max(0, physical_damage - GlobalVariables.bossArmor -GlobalVariables.bossBlock)
	# Berechnung des psychischen Schadens unter Berücksichtigung der mentalen Resistenz
	var effective_magic_damage = max(0, magic_damage - GlobalVariables.bossMagicRes)

 # Gesamt-Schaden (physisch + psychisch)
	var total_damage = effective_physical_damage + effective_magic_damage
	GlobalVariables.bossHealth -= ceil(total_damage)	#DMG wird aufgerundet und dann vom Leben abgezogen 
	#GlobalVariables.bossHealth = clamp(GlobalVariables.bossHealth, 0, GlobalVariables.bossMaxHealth) #damit man nicht über Maxleben heilt, 
	setHealthLabel();	
	setHealthBar();
	if GlobalVariables.bossHealth <= 0:
		print("Boss ist besiegt! Lade Loot-Szene...")
		# Verwende change_scene_to_file_async und 'await'
		# Dies pausiert die Ausführung hier, bis der Szenenwechsel abgeschlossen ist
		get_tree().change_scene_to_file("res://nodes/loot.tscn")
		print("Szenenwechsel zu Loot-Szene abgeschlossen.")
		# Nach dem Szenenwechsel wird dieser Teil des Codes nicht mehr relevant sein,
		# da die alte Szene entladen wird. Es ist keine 'return'-Anweisung mehr nötig,
		# da der 'await' die Ausführung effektiv blockiert, bis die neue Szene geladen ist.
		# Wenn du nach dem Szenenwechsel noch Code in der *alten* Szene ausführen müsstest,
		# wäre das ein komplexeres Problem (z.B. mit Signalen).
		# Aber in diesem Fall wollen wir einfach auf die neue Szene warten.
	#if GlobalVariables.bossHealth <= 0:
	#	get_tree().change_scene_to_file("res://nodes/loot.tscn")
				# WICHTIG: Beende die Funktion hier, damit kein weiterer Code ausgeführt wird
		return # <-- Diese Zeile ist der Schlüssel!
	print("Effective Boss Physical Damage: ", effective_physical_damage)
	print("Effective Boss Magic Damage: ", effective_magic_damage)
	print("Total Boss Damage: ", total_damage)

#Statuseffekte
#var active_status_effects: Array[StatusEffect] = []

func apply_status_effect(effect_resource: Resource, target: Node):
	var effect_instance = effect_resource.duplicate(true) as StatusEffect
	effect_instance.target = target
	#Das sollte nicht gut sein, weil Ressourcen kein Ready haben
	#effect_instance._ready() # Rufe _ready auf, nachdem target gesetzt wurde
	GlobalVariables.active_boss_status_effects.append(effect_instance)
	effect_instance.apply_effect()
func modify_attribute(attribute_name: String, amount: float):
	match attribute_name:
		"bossArmor":	#Als erstes Beispiel wegen "Brennen"
			GlobalVariables.bossArmor += amount
			print(name, "'s Rüstung geändert um: ", amount, ". Neue Rüstung: ", GlobalVariables.bossArmor)
			print("Aktuelle Bossrüstung", GlobalVariables.bossArmor)
		# Füge hier weitere Attribute hinzu, die modifiziert werden können
		_:
			print_debug("Versuch, unbekanntes Attribut zu modifizieren: ", attribute_name)
#Zum Abarbeiten der Statuseffekte
func on_turn_ended():
	var effects_to_remove: Array[StatusEffect] = []
	for effect in GlobalVariables.active_boss_status_effects:
		print("Effekt: ",effect)
		effect.on_turn_ended()
		print("Statuseffekt ", effect.name, " ausgeführt.")
		if effect.decrease_duration():#Dauer reduzieren, wenn sie noch nicht abgelaufen sind
			effects_to_remove.append(effect)

	for effect in effects_to_remove:#Entfernen, wenn sie abgelaufen sind
		effect.remove_effect()	#Optionaler Effekt, wenn der Status ausläuft
		GlobalVariables.active_boss_status_effects.erase(effect)	#Status wird entfernt

#Skill-Reihenfolge
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
var boss_data: BossData
var skill_plan= Array()



@onready var boss_slots = $BossFelder/Boss.get_children()	#Funktioniert das so??
var current_round_index := 0
func load_skills_for_turn():
	if not skill_plan or not skill_plan is Array or skill_plan.is_empty():
		printerr("Skill-Plan leer oder nicht gesetzt!")
		return
	#Damit er wieder von vorn anfängt, wenn er mit seinen Skillrunden durch ist
	if current_round_index >= skill_plan.size():
		current_round_index = 0  # Zurück zum Anfang

	var current_round_skills: Array = skill_plan[current_round_index]	#Skills der entsprechenden Runde
	#Skills laden, zuerst Felder leeren
	print("current_round_skills.size(): ", current_round_skills.size())
	for i in boss_slots.size():
		print("Versuche Slot ", i, " (", boss_slots[i].name, ")")
			# Entferne alle Kinder des aktuellen Slots manuell
		for child in boss_slots[i].get_children():
				boss_slots[i].remove_child(child)
				if is_instance_valid(child):
					child.queue_free() # Gibt die Instanz frei, um Speicherlecks zu vermeiden
	#Neue Skills reinladen
		if i < current_round_skills.size() and current_round_skills[i] is PackedScene:
			var skill_instance = current_round_skills[i].instantiate()
			#debug
			if is_instance_valid(skill_instance): print("Skill-Instanz erstellt: ", skill_instance.name) 
			else: print("Fehler beim Instanziieren des Skills an Index ", i)
			#
			boss_slots[i].add_child(skill_instance)
			print("Skill ", skill_instance.name, " zu Slot ", boss_slots[i].name, " hinzugefügt")
		else: #debug
			printerr("Ungültiger Rundenindex oder falscher Datentyp in skill_plan!")
func take_turn():
	var current_slot = GlobalVariables.current_slot
	var bossskill = get_skill_from_slot(boss_slots[current_slot])
	#Farbeffekt
	for e in boss_slots.size():	
			boss_slots[e].modulate = Color(1, 1, 1)  # Reset Farbe
			boss_slots[GlobalVariables.current_slot].modulate = Color(1, 0.8, 0.5)  # Aktives Feld hervorheben
	#Aktivierung Bossskill im passenden Feld	
	#print("bossskill in take_turn(): ", bossskill)
	if bossskill != null:
		#print("bossskill hat _run_effect: ", bossskill.has_method("_run_effect"))
		if bossskill.has_method("_run_effect"):
			var slot_effect = GlobalVariables.slot_effect_multipliers[GlobalVariables.current_slot]
			bossskill._run_effect(slot_effect)
			#print("Effekt von ", bossskill.name, " ausgeführt mit Multiplikator: ", slot_effect)
		else:
			print("FEHLER: bossskill hat keine _run_effect Methode")
	else:
		print("FEHLER: Kein bossskill im Slot ", current_slot)

	if GlobalVariables.current_turn % 3 == 0 and GlobalVariables.current_turn>0: #if GlobalVariables.current_round > 0: #damit nicht zu früh erhöht wird, der zweite Teil
		current_round_index = (current_round_index + 1) % skill_plan.size()
		
		load_skills_for_turn()
	else:
		print("Kein Skill in Bossslot ", GlobalVariables.current_slot)
	print("Aktive Boss Statuseffekte: ",GlobalVariables.active_boss_status_effects)
