extends StatusEffect
class_name BlockEffect


func apply_effect(target: Node, caster: Node):
	GlobalVariables.bossBlock +=10
func remove_effect(target: Node, caster: Node):
	if GlobalVariables.bossBlock <=0:
		GlobalVariables.bossBlock -=1
	else:
		GlobalVariables.bossBlock == 0
	
