extends Skill
class_name FeuerexplosionSkill

#func use():
#	var caster = _get_caster()
#	var target = _get_target()
#debug
#	if caster == null or target == null:
#		push_warning("Caster oder Target sind in 'use()' null für Skill: " + name)
#		return
#	# Überprüfe, ob der Boss brennt (Annahme: target ist der Boss-Node)
#	if target is Boss: # Überprüfe, ob das Ziel wirklich der Boss ist
#		print("Target ist der Boss")
#		var boss_is_burning = false
#		# Iteriere durch die globale Liste der aktiven Statuseffekte
#		for effect_data in GlobalVariables.active_boss_status_effects: # Oder GlobalVariables.active_boss_status_effects
#			if effect_data is BurnStatus :#and effect_target_node == target:
#				print("Bedingung: Boss brennt: Erfüllt")
#				boss_is_burning = true
#				break # Wir haben gefunden, wonach wir suchen
#		if boss_is_burning:
#			
#		return magic_damage
