class_name Weakend
extends StatusEffect


var damage_debuff = 10
func _init():
	duration = 2 # Hält für 3 Runden
func modify_incoming_damage(physical_dmg: float, magic_dmg: float) -> Dictionary:
	
	# Hier wird der spezifische damage_multiplier DIESES Effekts angewendet
	var result_p =physical_dmg
	var result_m =magic_dmg
	if target is Player:
		#if GlobalVariables.active_boss_status_effects != null: # Immer gute Praxis, auf null zu prüfen
			for effect_data in GlobalVariables.active_player_status_effects:
				var effect_instance = effect_data	#.effect	 # Hole die StatusEffect-Instanz
				var effect_target_node = effect_data.target # Hole das Ziel, auf das der Effekt wirkt
		# Überprüfe, ob es eine Instanz von BurnStatusEffect ist
		# und ob es tatsächlich auf den Boss wirkt (falls effect_target_node vorhanden ist und geprüft werden muss)
				if effect_instance is Weakend and is_instance_valid(effect_instance):
					print("Boss wurde als geschwächt erkannt.")				
					result_p= physical_dmg - damage_debuff
					result_m= magic_dmg - damage_debuff
				else:
					print("Boss wurde als nicht geschwächt erkannt.")
	if target is Boss:
		#if GlobalVariables.active_boss_status_effects != null: # Immer gute Praxis, auf null zu prüfen
			for effect_data in GlobalVariables.active_boss_status_effects:
				var effect_instance = effect_data	#.effect	 # Hole die StatusEffect-Instanz
				var effect_target_node = effect_data.target # Hole das Ziel, auf das der Effekt wirkt
		# Überprüfe, ob es eine Instanz von BurnStatusEffect ist
		# und ob es tatsächlich auf den Boss wirkt (falls effect_target_node vorhanden ist und geprüft werden muss)
				if effect_instance is Weakend and is_instance_valid(effect_instance):
					print("Player wurde als geschwächt erkannt.")				
					result_p= physical_dmg - damage_debuff
					result_m= magic_dmg - damage_debuff
				else:
					print("Player wurde als nicht geschwächt erkannt.")
	return{"physic": int(result_p ), "magic": int(result_m)}
