extends Node

@export var player_scene: PackedScene
signal press
signal confirm

# Called every frame. 'delta' is the elapsed time since the previous frame.
@onready var player = $Player #damit wir auf alles aus dem Player Node zugreifen können
@onready var boss = $Boss #damit wir auf alles aus dem Boss Node zugreifen können

#Felder importieren für die Abarbeitung der Slots später
#@onready var player_slots = [
#	$Felder/Feld1,
#	$Felder/Feld2,
#	$Felder/Feld3
#]
#neu im Bossskript
#@onready var boss_slots = [
#	$Boss/BossFelder/Boss/BossFeld1,
#	$Boss/BossFelder/Boss/BossFeld2,
#	$Boss/BossFelder/Boss/BossFeld3
#]
func _ready(): #soll den Heldencharakter (je nach Auswahl) laden, verstehe ich noch nicht ganz
	var selected_hero: HeroData
	GlobalVariables.main_node = self	#damit man immer gut auf die Main-Funktionen zugreifen kann
#Held laden
	if GlobalVariables.selected_hero != "":
		if ResourceLoader.exists(GlobalVariables.selected_hero):
			selected_hero = load(GlobalVariables.selected_hero)
		else:
			push_error("Pfad zu Heldendatei ungültig: " + GlobalVariables.selected_hero)
			return
	else:
		selected_hero = preload("res://Helden/Feuermage/Firemage.tres") #nur Backup-Tester

	player.init_hero(selected_hero)	#die Werte aus dem Heldenpaket des Pfades werden geladen (Name, HP, Skills)
	$Player/Charakterimage.texture = selected_hero.hero_texture

	var selected_boss: BossData
#Boss laden
	if GlobalVariables.selected_boss != "":
		if ResourceLoader.exists(GlobalVariables.selected_boss):
			selected_boss = load(GlobalVariables.selected_boss)
		else:
			push_error("Pfad zu Bossdatei ungültig: " + GlobalVariables.selected_boss)
			return
	else:
		selected_boss = preload("res://bosses/Barbarianking/Barbarianking.tres")

	boss.init_boss(selected_boss)	#die Werte aus dem Bosspaket des Pfades werden geladen (Name, HP, Skills)
	# muss noch ausgearbeitet werden im boss.gd sobald die ersten Skills existieren
	#grob habe ich es schon gemacht, eventuell funktioniert es sogar einfach
	
	# Verbinde das Signal des Bosses, wenn Main.gd bereit ist
	if is_instance_valid(boss):
		boss.boss_died.connect(_on_boss_died)
	
	$Boss/Bossimage.texture = selected_boss.boss_texture


func _process(delta: float) -> void:
	pass


func input(event: InputEvent) -> void: #von Beginn an von Maxi da
		if event.is_action_pressed("ui_accept") || event.is_action_pressed("ui_right"):
			var damage = RandomNumberGenerator.new();
			press.emit();


func _on_player_dead() -> void:
	$GameOver.visible = true;

#func get_skill_from_slot(slot: Node) -> Skill: #soll glaube den richtigen Skill holen aus dem Slot
#			for child in slot.get_children():
#				if child is Skill:
#					return child
#			return null
func _on_boss_died():
	print("Main.gd: Signal 'boss_died' empfangen. Leite Szenenwechsel zur Loot-Szene ein.")
	get_tree().call_deferred("change_scene_to_file", "res://nodes/loot.tscn")

func _on_turn_counter_pressed() -> void: #Haupthandlung passiert wenn der Knopf gedrückt wird
		print("Turn ",GlobalVariables.current_round)
		print("Mini-Turn ",GlobalVariables.current_turn)
		for area in get_tree().get_nodes_in_group("Skill"): #cooldown reduzieren
			area.tick_cooldown()
		
		#Felder und Effekt der Skills
		#var player_slots = $Felder/Player.get_children()	#für das Abarbeiten der entsprechenden Felder
		#var boss_slots = $Felder/Boss.get_children()
		#var felder = get_node("Felder").get_children()	#notwendig?
		
		
		#Skills des Spielers
		player.take_turn()
		if GlobalVariables.bossHealth >= 0:
					#Zug des Boss
			boss.take_turn()
		
		#player.on_turn_ended()
		#boss.on_turn_ended()
		if is_instance_valid(player):
			player.on_turn_ended()
#			print("Spieler: on_turn_ended aufgerufen.")

		if is_instance_valid(boss):
			boss.on_turn_ended()
#			print("Boss: on_turn_ended aufgerufen.") # Stelle sicher, dass dies passiert!

	# Nächster Slot vorbereiten
		GlobalVariables.current_slot += 1	#Slotzahl erhöhen für die nächste Runde
		if GlobalVariables.current_slot >= 3:	#player_slots.size():	#wenn mehr als 2 wieder zu 0 werden
			GlobalVariables.current_slot = 0
			
		GlobalVariables.current_turn += 1
		if GlobalVariables.current_turn % 3 == 0 and GlobalVariables.current_turn>0:
			GlobalVariables.current_round += 1
			#boss.load_skills_for_turn()
func _on_button_pressed() -> void:
		$GameOver.visible = false;
		GlobalVariables.playerHealth = GlobalVariables.playerMaxHealth;
		#GlobalVariables.bossHealth = GlobalVariables.bossMaxHealth;
