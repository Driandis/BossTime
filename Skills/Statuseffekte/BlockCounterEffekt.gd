class_name BlockCounterEffect
extends StatusEffect


@export var block_amount: int = 10
@export var counter_damage: int = 10 # Absoluter Schaden, der dem Boss zugefügt wird

var _applied_to_node: Node # Referenz zum Node, auf den der Effekt angewendet wurde

#func _init():
	#name = "Block & Konter"
	#description = "Gewährt Block und verursacht Schaden bei Angriff."
	#duration = 2 # Hält für 2 Runden

# Wird aufgerufen, wenn der Effekt auf ein Ziel angewendet wird
func apply_effect(target: Node,caster: Node): # Rufe die Basis-Implementierung auf
	
	_applied_to_node = target # Speichere die Referenz zum Ziel

	# Block-Wert des Spielers erhöhen
	if target is Player: # Stelle sicher, dass es der Spieler ist
		GlobalVariables.playerBlock += block_amount
		print("Spieler erhält ", block_amount, " Block. Neuer Block: ", GlobalVariables.playerBlock)
	elif target is Boss:
		GlobalVariables.bossBlock += block_amount
		print("Boss erhält ", block_amount, " Block. Neuer Block: ", GlobalVariables.bossBlock)

		# Signal verbinden: Wenn der Spieler angegriffen wird, soll der Effekt reagieren
		if target.has_signal("was_attacked"):
			target.was_attacked.connect(on_target_attacked)
			print("BlockCounterEffect: 'was_attacked' Signal verbunden.")
	else:
		push_warning("BlockCounterEffect kann nur auf den Spieler angewendet werden. Ziel: " + target.name)


# Wird aufgerufen, wenn der Effekt von einem Ziel entfernt wird
func remove_effect(target: Node,caster: Node):
	super.remove_effect(target, caster) # Rufe die Basis-Implementierung auf

	# Block-Wert des Spielers reduzieren
	if target is Player:
		GlobalVariables.playerBlock -= block_amount
		print("Spieler verliert ", block_amount, " Block. Neuer Block: ", GlobalVariables.playerBlock)
	elif target is Boss:
		GlobalVariables.playerBlock -= block_amount
		print("Boss verliert ", block_amount, " Block. Neuer Block: ", GlobalVariables.playerBlock)
		# Signal trennen: Wichtig, um Speicherlecks zu vermeiden!
	if target.has_signal("was_attacked") and target.was_attacked.is_connected(on_target_attacked):
		target.was_attacked.disconnect(on_target_attacked)
		print("BlockCounterEffect: 'was_attacked' Signal getrennt.")
	
	_applied_to_node = null # Referenz bereinigen

# Diese Funktion wird aufgerufen, wenn das 'was_attacked'-Signal des Spielers ausgelöst wird
func on_target_attacked(attacker: Node, damage_taken: float):
	print("BlockCounterEffect: Spieler wurde angegriffen! Schaden: ", damage_taken)
	# Nur Konterschaden auf den Boss, wenn der Angreifer der Boss ist
	if attacker is Boss and GlobalVariables.active_player_status_effects.has(BlockCounterEffect):
		attacker.truedmg(counter_damage)
		print("Boss erleidet ", counter_damage, " Blockschaden.")
	elif attacker is Player and GlobalVariables.active_boss_status_effects.has(BlockCounterEffect):
		attacker.truedmg(counter_damage)
		print("Player erleidet ", counter_damage, " Blockschaden.")
