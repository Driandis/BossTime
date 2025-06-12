class_name BlockEffect
extends StatusEffect



func apply_effect(target: Node, caster: Node):
	GlobalVariables.bossBlock +=10
func remove_effect(target: Node, caster: Node):
	if GlobalVariables.bossBlock >=0:
		GlobalVariables.bossBlock -=10
		if GlobalVariables.bossBlock >=0:
			GlobalVariables.bossBlock ==0
	else:
		GlobalVariables.bossBlock == 0
	
