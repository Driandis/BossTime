extends Skill
class_name FeuerexplosionSkill

@export var base_damage: int = 20
@export var damage_type: String = "physical" # Oder "mental", etc.

func _run_effect(feldmultiplier := 1.0) -> void:
	print("Skill wurde ausgeführt: ", name)
	var target = _get_target()
	var caster = _get_caster()

	if caster != null and target != null:
		var final_damage = base_damage

		# Überprüfe, ob der Boss brennt
		if _is_target_burning(target):
			final_damage *= 2
			print(target.name, " brennt! Doppelter Schaden angewendet: ", final_damage)
		else:
			print(target.name, " brennt nicht. Normaler Schaden angewendet: ", final_damage)

		# Wende den Schaden an
		if target.has_method("damage"):
			target.damage(0, final_damage)
		else:
			printerr(target.name, " hat keine 'take_damage'-Methode!")

		current_cd = cooldown
		_setCooldownBar()

func _is_target_burning(target):
	if target.has_method("has_status_effect"):
		return target.has_status_effect("Burn") # Annahme: Dein Boss hat eine solche Funktion
	else:
		# Fallback, falls der Boss keine has_status_effect-Methode hat
		# Dies ist weniger robust, da es auf der Existenz eines bestimmten Effekttyps in der Liste basiert
		if is_instance_valid(target) and "active_status_effects" in target:
			for effect in target.active_status_effects:
				if effect.get_class() == "BurnBoss":
					return target.has_status_effect("Burn")
		return false
