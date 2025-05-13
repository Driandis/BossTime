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
	#load_skills_for_turn()
	print("boss_slots: ", boss_slots)

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
	skill_plan = boss_data.rounds # Zugriff auf den Skillplan aus den Daten
	print("Runden geladen:", skill_plan.size(), " Runden:", skill_plan) # ← Debug
	print("boss_slots.size(): ", boss_slots.size()) #Debug
	
	load_skills_for_turn() # Optional: Lade die ersten Skills direkt
	print("Boss HP: ", health)
	print("Boss Name: ", Bossname)
	print("Boss Armor: ", bossArmor)
	print("Boss Block: ", bossBlock)
	print("Boss Magic Resistence: ", bossMagicRes)
	
	#veraltet
	#jetzt werden die Skills passend geladen
#	for child in $Bosse/SkillContainer.get_children():
#		child.queue_free()	#alle Skills werden gelöscht
#	for skill_scene in boss_data.skills: 	#nur die passenden Skills aus heroData werden neu gelaedn
#		var skill_instance = skill_scene.instantiate()
#		$Bosse/SkillContainer.add_child(skill_instance)

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
	
	#Items
	
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
	#print("load_skills_for_turn aufgerufen, current_round_index: ", current_round_index)
	#print("skill_plan: ", skill_plan)
	#print("boss_slots.size(): ", boss_slots.size())
	#if skill_plan is Array:
		#print("skill_plan.size(): ", skill_plan.size())
		#if not skill_plan.is_empty():
			#print("skill_plan[0]: ", skill_plan[0]) # Überprüfe das erste Element
			#if skill_plan[0] is Array:
				#print("skill_plan[0].size(): ", skill_plan[0].size())
	if not skill_plan or not skill_plan is Array or skill_plan.is_empty():
		printerr("Skill-Plan leer oder nicht gesetzt!")
		return
	if current_round_index >= 3:	#skill_plan.size():
		current_round_index = 0  # Zurück zum Anfang

	var current_round_skills: Array = skill_plan[current_round_index]	#Skills der entsprechenden Runde
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
	print("bossskill in take_turn(): ", bossskill)
	if bossskill != null:
		print("bossskill hat _run_effect: ", bossskill.has_method("_run_effect"))
		if bossskill.has_method("_run_effect"):
			var slot_effect = GlobalVariables.slot_effect_multipliers[GlobalVariables.current_slot]
			bossskill._run_effect(slot_effect)
			print("Effekt von ", bossskill.name, " ausgeführt mit Multiplikator: ", slot_effect)
		else:
			print("FEHLER: bossskill hat keine _run_effect Methode")
	else:
		print("FEHLER: Kein bossskill im Slot ", current_slot)

	if GlobalVariables.current_turn % 3 == 0 and GlobalVariables.current_turn>0: #if GlobalVariables.current_round > 0: #damit nicht zu früh erhöht wird, der zweite Teil
		current_round_index = (current_round_index + 1) % skill_plan.size()
		
		load_skills_for_turn()
	else:
		print("Kein Skill in Bossslot ", GlobalVariables.current_slot)

#func _on_main_press() -> void:
	#damage(0);


#func _on_button_pressed() -> void:
	#damage(0);
