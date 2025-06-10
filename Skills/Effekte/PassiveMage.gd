extends StatusEffect
class_name PassiveMage

func apply_effect(target: Node, caster: Node):
	target.truedmg(25)
