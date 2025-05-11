extends Effect
class_name PhysicalDamageEffect

	#wo wird der Schaden angepasst? In den Tres Dateien der Skills?

	
func use(caster, target, first_value, feldmultiplier := 1.0) ->void:
	var modified_value = first_value
	if caster.has_method("apply_attack_modifiers"):
		modified_value = caster.apply_attack_modifiers(modified_value)

	target.damage(modified_value, 0)
