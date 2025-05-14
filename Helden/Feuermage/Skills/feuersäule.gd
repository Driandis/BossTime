extends Skill
class_name Feuersäule

@export var burn_effect_resource: Resource # Weise hier deine Brennend.tres Resource im Inspector zu

func _run_effect(feldmultiplier := 1.0) -> void:
	print("Skill wurde ausgeführt: ", name)
	var target = _get_target()
	var caster = _get_caster()

	if caster != null and target != null:
		# Wende den Brennen-Statuseffekt auf das Ziel an
		if target != null and burn_effect_resource:
			if target.has_method("apply_status_effect"):
				var burn_effect_instance = burn_effect_resource.duplicate(true) as StatusEffect
				target.apply_status_effect(burn_effect_instance, target)
				print(name, " hat ", target.name, " in Brand gesetzt!")
		else:
			printerr(target.name, " hat keine 'apply_status_effect'-Methode!")

		# Führe den primären Effekt des Skills aus (z.B. initialer Schaden)
		if effect != null:
			effect.use(caster, target, first_value, feldmultiplier)
		#	current_cd = cooldown
		#	_setCooldownBar()
