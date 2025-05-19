extends Skill
class_name Feuersäule
@export var burn_effect_resource: Resource #

func use() -> void:
	print("Skill wurde ausgeführt: ", name)
	#var target = _get_target()
	#var caster = _get_caster()

	if caster != null and target != null:
		print("Caster und Target ungleich 0")
		# Wende den Brennen-Statuseffekt auf das Ziel an
		if target.has_method("apply_status_effect"):
			print("Versucht Burn anzuwenden")
			var burn_effect_instance = burn_effect_resource.duplicate(true) as StatusEffect
			target.apply_status_effect(burn_effect_instance, target)
			print(name, " hat ", target.name, " in Brand gesetzt!")
		else:
			printerr(target.name, " hat keine 'apply_status_effect'-Methode!")

		# Führe den primären Effekt des Skills aus (z.B. initialer Schaden)
	#	skill.use(caster, target, first_value, feldmultiplier)
		#	current_cd = cooldown
		#	_setCooldownBar()
