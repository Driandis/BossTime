extends Node2D
class_name Boss
#const MAX_HEALTH = GlobalVariables.bossMaxHealth
signal action
signal restart
signal boss_died
var current_boss : BossData
signal was_attacked(attacker: Node, damage_taken: float)

# Referenz zum UI-Container, in den die StatusIcons geladen werden
@export var status_effect_ui_container: HBoxContainer
@export var status_effect_icon_scene: PackedScene # Eine Szene mit einem TextureRect als Root
@export var max_display_effects: int = 5 # Maximale Anzahl der anzuzeigenden Effekte
var ui_icon_map: Dictionary = {} # Map, um StatusEffect zu TextureRect zu verbinden (Effect -> UI_Node)
var ui_icon_slots: Array[TextureRect] = [] # Die vorgefertigten TextureRect-Slots

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Boss")
	print("boss_slots: ", boss_slots)
	if status_effect_ui_container:	#Für die Statuseffekte
		for child in status_effect_ui_container.get_children():
			if child is TextureRect:
				ui_icon_slots.append(child)
				child.texture = null # Sicherstellen, dass sie leer sind
				child.visible = false # Am Anfang unsichtbar

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
	current_boss=boss_data
#Multiplikatoren beim DMG berücksichtigen
func apply_attack_modifiers(physic_value: int, magic_value: int) -> Dictionary:	#Dictionary damit man mit beiden Werten gleichzeitig arbeiten kann
	var modified_physic_value = physic_value
	var modified_magic_value = magic_value
	#print_debug("Boss wendet Attack-Multiplikatoren an.")
	# Waffen-Effekt
	#if GlobalVariables.equipped_weapon:
	#	modified_physic_value =modified_physic_value* GlobalVariables.equipped_weapon.damage_multiplier
	#	modified_magic_value =modified_magic_value* GlobalVariables.equipped_weapon.damage_multiplier
	# Buffs und Debuffs durch Statuseffekte (ausgehender Schaden)
	#for effect in active_status_effects:
	#	modified_value = effect.modify_outgoing_damage(modified_value)
	#Items
	# Feldeffekte evemtuell hierhin und raus aus dem Main?
	var slot_effect = GlobalVariables.slot_effect_multipliers[GlobalVariables.current_slot]
	modified_physic_value=modified_physic_value *slot_effect
	modified_magic_value=modified_magic_value*slot_effect
	#print_debug("Neue Schadenswerte: ",modified_physic_value, modified_magic_value)
	return {"physic": modified_physic_value, "magic": modified_magic_value}

func truedmg(Amount: float):
	GlobalVariables.bossHealth -=Amount
	print("Boss erleidet ",Amount, " absoluten Schaden.")
	setHealthLabel();	
	setHealthBar();
	if Amount >=1:
		blink_red()
	if GlobalVariables.bossHealth <= 0:
		print("Boss ist besiegt! Lade Loot-Szene...")
		boss_died.emit()
		return

var is_defeated = false  # Tod?
func damage(physical_damage, magic_damage, attacker: Node = null) -> void:
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
	if total_damage >=1:
		blink_red()
	if GlobalVariables.bossHealth <= 0:
		print("Boss ist besiegt! Lade Loot-Szene...")
		boss_died.emit()
		return # <-- Diese Zeile ist der Schlüssel!
		
	if attacker != null:
		was_attacked.emit(attacker, total_damage)
	else:
		# Wenn der Angreifer nicht bekannt ist, sende nur den Schaden
		was_attacked.emit(null, total_damage)
		
	print("Effective Boss Physical Damage: ", effective_physical_damage)
	print("Effective Boss Magic Damage: ", effective_magic_damage)
	#print("Total Boss Damage: ", total_damage)
	if GlobalVariables.bossHealth <= current_boss.passive_trigger * GlobalVariables.bossMaxHealth:
			apply_status_effect(current_boss.passive, self, null) #.apply_effect(self, null)
			
			$PassiveIcon.texture = current_boss.passive.Effect_texture
				
#Statuseffekte
func apply_status_effect(effect_resource: StatusEffect, target: Node, caster: Node):
	var already_has_effect_of_this_type = false
	for existing_effect in GlobalVariables.active_boss_status_effects:
		if existing_effect.name == effect_resource.name:
			already_has_effect_of_this_type=true
			break
			
	if not already_has_effect_of_this_type:
		printerr("Apply fängt an")
		var effect_instance = effect_resource.duplicate(true) as StatusEffect
		effect_instance.target = target
		effect_instance.remaining_duration=effect_instance.duration
		GlobalVariables.active_boss_status_effects.append(effect_instance)
		effect_instance.apply_effect(target, caster)
		print("Apply-Status-Effekt beim Boss ausgeführt.", effect_instance, target)
		_update_status_effect_ui() # UI aktualisieren
	else:
		printerr("Boss hat diesen Statuseffekt bereits. ", effect_resource.name)
				# Optional: Wenn du Effekte mit gleicher Klasse "auffrischen" willst (Dauer zurücksetzen):
		# for existing_effect in active_status_effects:
		#    if existing_effect.get_class() == effect_resource.get_class():
		#        existing_effect.remaining_duration = effect_resource.duration # Setze Dauer zurück
		#        print("Dauer von '", existing_effect.name, "' aktualisiert.")
		#        break
func modify_attribute(attribute_name: String, amount: float):
	match attribute_name:
		"Armor":	#Als erstes Beispiel wegen "Brennen"
			GlobalVariables.bossArmor += amount
			print(name, "'s Rüstung geändert um: ", amount, ". Neue Rüstung: ", GlobalVariables.bossArmor)
			print("Aktuelle Bossrüstung", GlobalVariables.bossArmor)
		# Füge hier weitere Attribute hinzu, die modifiziert werden können
		"MagicRes":
			GlobalVariables.bossMagicRes +=amount
			print(name, "'s magischer Widerstand geändert um: ", amount, ". Neuer magischer Widerstand: ", GlobalVariables.bossMagicRes)
		_:
			print_debug("Versuch, unbekanntes Attribut zu modifizieren: ", attribute_name)
#Zum Abarbeiten der Statuseffekte
func on_turn_ended(): # KEIN 'target: Node' Parameter hier
	var effects_to_remove: Array[StatusEffect] = [] # Annahme: Liste von Statuseffekten {effect: StatusEffect, target: Node}
	
	# Gehe alle aktiven Effekte DIESES SPIELERS durch
	# WICHTIG: Hier gehen wir davon aus, dass GlobalVariables.active_player_status_effects
	# NUR Effekte enthält, die auf DIESEN Spieler angewendet wurden.
	for effect_data in GlobalVariables.active_boss_status_effects:
		var effect: StatusEffect = effect_data
		var effect_target_node: Node = effect_data.target # Das ist der Node, auf den der Effekt angewendet wurde

		# Prüfe, ob der Effekt und sein Ziel noch gültig sind
		# Und ob dieser Effekt tatsächlich auf DIESEN Spieler angewendet wurde (redundant, aber sicher)
		if is_instance_valid(effect) and is_instance_valid(effect_target_node) and effect_target_node == self:
			# Reduziere die Dauer des Effekts
			if effect.has_method("on_turn_tick"):
				print_debug("Bosseffekt tick Turn")
				effect.on_turn_tick(self, effect.caster) # Übergib 'self' (den Spieler) als Ziel und null als Caster für den Tick
		
			effect.decrease_duration()
			_update_status_effect_ui() # UI aktualisieren
#				print_debug("Decrease über Boss.gd gestartet")
#				effects_to_remove.append(effect_data) # Füge das gesamte Dictionary zur Entfernen-Liste hinzu
			#else:
				# Wenn der Effekt noch aktiv ist, führe seine Runden-Logik aus (z.B. Schaden pro Runde)
			#	if effect.has_method("on_turn_tick"):
			#		print_debug()
			#		effect.on_turn_tick(self, effect.caster) # Übergib 'self' (den Spieler) als Ziel und null als Caster für den Tick
#		elif not is_instance_valid(effect) or not is_instance_valid(effect_target_node):
			# Wenn der Effekt oder sein Ziel ungültig geworden ist, füge ihn zur Entfernen-Liste hinzu
#			effects_to_remove.append(effect_data)

	# Entferne die abgelaufenen Effekte
#	for effect_data in effects_to_remove:
#		var effect: StatusEffect = effect_data
#		var effect_target_node: Node = effect_data.target
#
#		if is_instance_valid(effect) and is_instance_valid(effect_target_node):
			# Rufe die remove_effect-Methode des Effekts auf und übergib 'self' (den Spieler)
#			effect.remove_effect(self, effect.caster) # Übergib 'self' als den Node, von dem der Effekt entfernt wird
#			print("Status-Effekt '", effect.name, "' von ", effect_target_node.name," entfernt.")
			# Optional: Sende ein globales Signal, dass der Effekt entfernt wurde
#			GlobalVariables.status_effect_removed.emit(effect, self)
			
			
		
		# Entferne den Effekt aus der globalen Liste
		#GlobalVariables.active_player_status_effects.erase(effect_data)

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
	#	else: #debug
	#		printerr("Ungültiger Rundenindex oder falscher Datentyp in skill_plan!")
var can_take_turn: bool = true
func take_turn():
	if not can_take_turn:
		return # Frühzeitiger Exit: Die Funktion wird nicht ausgeführt
	if GlobalVariables.current_turn % 3 == 0:# and  #if GlobalVariables.current_round > 0: #damit nicht zu früh erhöht wird, der zweite Teil
		if GlobalVariables.current_turn>0:
			current_round_index = (current_round_index + 1) % skill_plan.size()
		
		load_skills_for_turn()
	#Farbeffekt
	var current_slot = GlobalVariables.current_slot
	var bossskill = get_skill_from_slot(boss_slots[current_slot])

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


	#else:
	#	print("Kein Skill in Bossslot ", GlobalVariables.current_slot)
	print("Aktive Boss Statuseffekte: ",GlobalVariables.active_boss_status_effects)

func _update_status_effect_ui():
	print("Aktualisiere UI für ", self.name, ". Aktive Effekte: ", GlobalVariables.active_boss_status_effects.size())

	# Zuerst alle alten Icons ausblenden/leeren
	for slot in ui_icon_slots:
		slot.texture = null
		slot.visible = false
	ui_icon_map.clear() # Map leeren

	# Gehe die aktiven Effekte durch und zeige sie an
	for i in range(min(GlobalVariables.active_boss_status_effects.size(), max_display_effects)):
		var effect = GlobalVariables.active_boss_status_effects[i]
		if i < ui_icon_slots.size(): # Sicherstellen, dass ein Slot verfügbar ist
			var icon_slot = ui_icon_slots[i]
			
			if effect.Effect_texture != null:
				icon_slot.texture = effect.Effect_texture
				icon_slot.visible = true
				ui_icon_map[effect] = icon_slot # Effekt zu seinem UI-Slot mappen
			else:
				print("Warnung: StatusEffect '", effect.name, "' hat keine Effect_texture zugewiesen.")
				icon_slot.texture = null
				icon_slot.visible = false # Oder ein Platzhalter-Icon anzeigen
		else:
			print("Nicht genügend UI-Slots für alle Effekte verfügbar.")
			break # Keine weiteren Slots zum Anzeigen
@onready var sprite: TextureRect = $Bossimage # Pfad zu deinem Bild-Node
var hit_tween: Tween = null
func blink_red():
		# Wenn ein alter Tween läuft, beende ihn zuerst
	if hit_tween != null and hit_tween.is_valid():
		hit_tween.kill() # Beendet vorherige Tweens sofort
# Erstelle einen NEUEN Tween
	# Man kann create_tween() auf jedem Node aufrufen, um den Tween an diesen Node zu binden.
	# Wenn der Node aus der Szene entfernt wird, wird auch der Tween gekillt.
	hit_tween = create_tween()
	# Setze die Startfarbe auf Rot
	# Setze flash_amount auf 1.0 (vollständig rot) sofort
	# Greife auf den Shader-Parameter über sprite.material zu
	sprite.material.set_shader_parameter("flash_amount", 0.6)
	# Optional: Setze die Farbe des Blitzes, falls du sie dynamisch ändern möchtest
	sprite.material.set_shader_parameter("flash_color", Color(1.0, 0.0, 0.0, 1.0)) # Reines Rot

	# Tween flash_amount von 1.0 (voll rot) zurück auf 0.0 (normal) über 0.2 Sekunden
	hit_tween.tween_property(sprite.material, "shader_parameter/flash_amount", 0.0, 0.5)
 	# Tween die modulate-Eigenschaft des Sprites von Rot zu Weiß über 0.2 Sekunden
	hit_tween.tween_property(sprite, "modulate", Color(1, 1, 1, 1), 0.2)
	
