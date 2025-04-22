extends Node

@export var player_scene: PackedScene
signal press
signal confirm

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func input(event: InputEvent) -> void:
		if event.is_action_pressed("ui_accept") || event.is_action_pressed("ui_right"):
			var damage = RandomNumberGenerator.new();
			press.emit();


func _on_player_dead() -> void:
	$GameOver.visible = true;
	

func _on_turn_counter_pressed() -> void: #Haupthandlung passiert wenn der Knopf gedrückt wird
		for area in get_tree().get_nodes_in_group("Skill"): #cooldown reduzieren
			area.tick_cooldown()
		
		#Felder und Effekt der Skills
		var felder = get_node("Felder").get_children()

		for feld in felder:
			if feld is Area2D and feld.monitoring:
				var overlapping_areas = feld.get_overlapping_areas()
				for area in overlapping_areas:
					if area.is_in_group("Skill"):
						print(area.name, " liegt in ", feld.name)
						feld_reagiert(feld.name, area)  # unterschiedliche Reaktion pro Feld


func feld_reagiert(feld_name: String, skill):	#das müsste noch verbessert werden
	match feld_name:
		"Feld1":
			skill._run_effect()  # Skill nutzen
			skill._run_effect()  # Skill nutzen
		"Feld2":
			skill._run_effect()
		"Feld3":
			print("Kein spezieller Effekt")


				
func _on_button_pressed() -> void:
		$GameOver.visible = false;
		GlobalVariables.playerHealth = GlobalVariables.playerMaxHealth;
		GlobalVariables.bossHealth = GlobalVariables.bossMaxHealth;
