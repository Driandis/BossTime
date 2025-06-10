extends StatusEffect
class_name PassiveMage

func apply_effect(target: Node, caster: Node):
	GlobalVariables.playerHealth -=25
	#target.truedmg(25)
