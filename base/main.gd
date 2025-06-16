extends Node

@export var player_scene: PackedScene
signal press
signal confirm

@onready var player = $Player #damit wir auf alles aus dem Player Node zugreifen können
@onready var boss = $Boss #damit wir auf alles aus dem Boss Node zugreifen können

@export var custom_cursor_texture: Texture2D = preload("res://sprites/rsz_120250607_1250_blutiger_mauszeiger_simple_compose_01jx5065dmfva897p1kv2w2yte.png")

func _ready(): #soll den Heldencharakter (je nach Auswahl) laden, verstehe ich noch nicht ganz
	# Stelle sicher, dass die Textur zugewiesen ist, bevor du versuchst, sie zu setzen
	if custom_cursor_texture:
		print("DEBUG: Setze benutzerdefinierten Mauszeiger.")
		# Setzt einen benutzerdefinierten Mauszeiger.
		# Dieser Cursor wird nun im gesamten Spiel sichtbar sein, es sei denn,
		# er wird explizit durch eine andere set_custom_mouse_cursor()-Anweisung überschrieben.
		Input.set_custom_mouse_cursor(custom_cursor_texture, Input.CURSOR_ARROW, Vector2(0, 0)) # Hotspot auf (0,0) für die obere linke Ecke
	else:
		printerr("FEHLER: Keine benutzerdefinierte Cursor-Textur zugewiesen oder gefunden. Verwende Standard-Cursor.")
		# Setzt den Cursor zurück auf den System-Cursor, falls keine benutzerdefinierte Textur verfügbar ist
		Input.set_custom_mouse_cursor(null) # Null setzt den System-Cursor zurück

	# Optionale Mausmodi können hier ebenfalls gesetzt werden, wenn gewünscht.
	# Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # Stellt sicher, dass der Cursor sichtbar ist (Standard)
	
	var selected_hero: HeroData
	GlobalVariables.main_node = self	#damit man immer gut auf die Main-Funktionen zugreifen kann
#Held laden
	if GlobalVariables.selected_hero != "":
		if ResourceLoader.exists(GlobalVariables.selected_hero):
			selected_hero = load(GlobalVariables.selected_hero)
			GlobalVariables.current_hero=selected_hero
		else:
			push_error("Pfad zu Heldendatei ungültig: " + GlobalVariables.selected_hero)
			return
	else:
		selected_hero = preload("res://Helden/Feuermage/Firemage.tres") #nur Backup-Tester

	player.init_hero(selected_hero)	#die Werte aus dem Heldenpaket des Pfades werden geladen (Name, HP, Skills)
	$Player/Charakterimage.texture = selected_hero.hero_texture	#könnte auch ins Player Skript

	var selected_boss: BossData
#Boss laden
	if GlobalVariables.selected_boss == "":
		if GlobalVariables.my_boss_data_resources[GlobalVariables.current_fight] != null:
	#	if ResourceLoader.exists(GlobalVariables.selected_boss):
#			selected_boss = load(GlobalVariables.selected_boss)
			selected_boss=GlobalVariables.my_boss_data_resources[GlobalVariables.current_fight] 
#		else:
#			push_error("Pfad zu Bossdatei ungültig: " + GlobalVariables.selected_boss)
#			return
		else:
			printerr("Bosspfad unpassend.")
			selected_boss = preload("res://bosses/Barbarianking/Barbarianking.tres")
	else:
		if ResourceLoader.exists(GlobalVariables.selected_boss):
			selected_boss = load(GlobalVariables.selected_boss)
	boss.init_boss(selected_boss)	#die Werte aus dem Bosspaket des Pfades werden geladen (Name, HP, Skills)
	# muss noch ausgearbeitet werden im boss.gd sobald die ersten Skills existieren
	#grob habe ich es schon gemacht, eventuell funktioniert es sogar einfach
	
	# Verbinde das Signal des Bosses, wenn Main.gd bereit ist
	if is_instance_valid(boss):
		boss.boss_died.connect(_on_boss_died)
	
	$Boss/Bossimage.texture = selected_boss.boss_texture
	
	#Items laden
	if GlobalVariables.equipped_items.size() >= 1 :
		$Player/ItemContainer/ItemIcon1.texture =GlobalVariables.equipped_items[0].Item_texture
	if GlobalVariables.equipped_items.size() >= 2 :
		$Player/ItemContainer/ItemIcon2.texture =GlobalVariables.equipped_items[1].Item_texture
	if GlobalVariables.equipped_items.size() >= 3 :
		$Player/ItemContainer/ItemIcon3.texture =GlobalVariables.equipped_items[2].Item_texture

	#Effekte der Items laden
	for item in GlobalVariables.equipped_items:
			item.use()
			print("Item ", item.name, " wurde benutzt.")
func _process(delta: float) -> void:
	pass


func input(event: InputEvent) -> void: #von Beginn an von Maxi da
		if event.is_action_pressed("ui_accept") || event.is_action_pressed("ui_right"):
			var damage = RandomNumberGenerator.new();
			press.emit();

func _on_player_dead() -> void:
	$GameOver.visible = true;

func _on_boss_died():
	player.can_take_turn = false 
	boss.can_take_turn = false 
	$Win.visible = true
	GlobalVariables.current_fight +=1
	print("Nächster Kampf: Kampf Nummer ", GlobalVariables.current_fight)

func _on_turn_counter_pressed() -> void: #Haupthandlung passiert wenn der Knopf gedrückt wird
		print("Turn ",GlobalVariables.current_round)
		print("Mini-Turn ",GlobalVariables.current_turn)
		for area in get_tree().get_nodes_in_group("Skill"): #cooldown reduzieren
			if GlobalVariables.freezetimer ==0:
				area.tick_cooldown()
			#else:
			#	print("Skillcooldown eingeforen. Freezetimer ", GlobalVariables.freezetimer)
	#Freeze reduzieren
		if GlobalVariables.freezetimer > 0:
			GlobalVariables.freezetimer -=1
	#Zug des Spielers
		player.take_turn()
		await get_tree().create_timer(0.5).timeout 
		if is_instance_valid(player):
			player.on_turn_ended()
	#Zug des Boss
		if GlobalVariables.bossHealth >= 0:
			boss.take_turn()
		if is_instance_valid(boss):
			boss.on_turn_ended()

	# Nächster Slot vorbereiten
		GlobalVariables.current_slot += 1	#Slotzahl erhöhen für die nächste Runde
		if GlobalVariables.current_slot >= 3:	#player_slots.size():	#wenn mehr als 2 wieder zu 0 werden
			GlobalVariables.current_slot = 0
			
		GlobalVariables.current_turn += 1
		if GlobalVariables.current_turn % 3 == 0 and GlobalVariables.current_turn>0:
			GlobalVariables.current_round += 1

			
func _on_button_pressed() -> void:
		$GameOver.visible = false;
		GlobalVariables.playerHealth = GlobalVariables.playerMaxHealth;

@onready var loot_manager: LootManager = $LootManager
func _on_win_pressed() -> void:
	print("Main.gd: Signal 'boss_died' empfangen. Leite Szenenwechsel zur Loot-Szene ein.")
	#get_tree().call_deferred("change_scene_to_file", "res://nodes/loot.tscn")
	loot_manager.generate_and_show_loot(3) # Generiere 3 Items
	pass # Replace with function body.

func reset_all_skills():
	for slot_node in get_tree().get_nodes_in_group("PlayerSkillfelder"):
		# Jeder Slot-Knoten (also jedes Skill-Feld)
		# Durchlaufe alle Kinder dieses Slot-Knotens
		for skill_instance in slot_node.get_children():
			# Überprüfe, ob das Kind tatsächlich ein Skill ist und die Methode 'reset_skill' hat
			# Das ist wichtig, falls du andere Dinge in den Slots hast, die keine Skills sind
			if skill_instance.has_method("reset_skill"):
				skill_instance.reset_skill()
func reset_all_skills_in_slots():
	for slot_node in get_tree().get_nodes_in_group("Felder"):
		# Jeder Slot-Knoten (also jedes Skill-Feld)
		# Durchlaufe alle Kinder dieses Slot-Knotens
		for skill_instance in slot_node.get_children():
			# Überprüfe, ob das Kind tatsächlich ein Skill ist und die Methode 'reset_skill' hat
			# Das ist wichtig, falls du andere Dinge in den Slots hast, die keine Skills sind
			if skill_instance.has_method("reset_skill"):
				skill_instance.reset_skill()

func _on_autobattle_pressed() -> void:
	_on_turn_counter_pressed()
	await get_tree().create_timer(0.5).timeout 
	_on_turn_counter_pressed()
	await get_tree().create_timer(0.5).timeout 
	_on_turn_counter_pressed()
	await get_tree().create_timer(0.5).timeout 
	reset_all_skills_in_slots()
		
