extends StatusEffect
class_name BurnAttackMult

@export var damage_multiplier: float = 2.0 # Wie viel Bonus-Schaden (2.0 für doppelt)

func _init():
	duration=-1	#Effekt läuft nicht ab, triggert aber nur bei dem Skill Feuerexplosion
	
# Diese Funktion wird vom Caster aufgerufen, um den ausgehenden Schaden zu modifizieren
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
			if effect_instance is BurnStatus and is_instance_valid(effect_instance):
				print("Boss wurde als brennend erkannt")				
				result_p= physical_dmg * damage_multiplier
				result_m= magic_dmg * damage_multiplier
			
	return{"physic": int(result_p ), "magic": int(result_m)}
	
