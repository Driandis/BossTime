extends Effect
class_name HealEffect

func use(caster, target, first_value: float, feldmultiplier: float = 1.0) -> void:
	if target.has_method("heal"):
		target.heal(first_value * feldmultiplier)
