class_name PassiveBarbar
extends StatusEffect


var damage_buff := 3
var incoming_damage_buff := 5

func modify_incoming_damage(physical_dmg: float, magic_dmg: float) -> Dictionary:
	
	# Hier wird der spezifische damage_multiplier DIESES Effekts angewendet
	var result_p =physical_dmg
	var result_m =magic_dmg
	if GlobalVariables.active_boss_status_effects != null: # Immer gute Praxis, auf null zu prüfen
		for effect_data in GlobalVariables.active_player_status_effects:
			var effect_instance = effect_data	#.effect	 # Hole die StatusEffect-Instanz
			var effect_target_node = effect_data.target # Hole das Ziel, auf das der Effekt wirkt
		# Überprüfe, ob es eine Instanz von BurnStatusEffect ist
		# und ob es tatsächlich auf den Boss wirkt (falls effect_target_node vorhanden ist und geprüft werden muss)
			if effect_instance is PassiveBarbar and is_instance_valid(effect_instance):
				print("Passive vom Boss ist aktiv, inc. Damage wird erhöht.")				
				result_p= physical_dmg +incoming_damage_buff
				#result_m= magic_dmg - damage_debuff
	return{"physic": int(result_p ), "magic": int(result_m)}
	
func modify_outgoing_damage(physical_dmg: float, magic_dmg: float) -> Dictionary:
	# Hier wird der spezifische damage_multiplier DIESES Effekts angewendet
	var result_p =physical_dmg
	var result_m =magic_dmg
	if GlobalVariables.active_boss_status_effects != null: # Immer gute Praxis, auf null zu prüfen
		for effect_data in GlobalVariables.active_boss_status_effects:
			var effect_instance = effect_data	#.effect	 # Hole die StatusEffect-Instanz
			var effect_target_node = effect_data.target # Hole das Ziel, auf das der Effekt wirkt
		# Überprüfe, ob es eine Instanz von BurnStatusEffect ist
		# und ob es tatsächlich auf den Boss wirkt (falls effect_target_node vorhanden ist und geprüft werden muss)
			if effect_instance is PassiveBarbar and is_instance_valid(effect_instance):
				print("Passive vom Boss ist aktiv, outg. Damage wird erhöht.")				
				result_p= physical_dmg +damage_buff
				result_m= magic_dmg + damage_buff

	return{"physic": int(result_p ), "magic": int(result_m)}
