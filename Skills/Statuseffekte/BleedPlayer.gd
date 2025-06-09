class_name Bleed
extends StatusEffect


var damage_per_turn: int = 3

func on_turn_tick(target: Node, caster: Node):
	# Truedmg durch Burn	
	if target is Player:
		GlobalVariables.playerHealth -= damage_per_turn
		GlobalVariables.playerHealth = clamp(GlobalVariables.playerHealth, 0, GlobalVariables.playerMaxHealth) #Statt target.max_health

	elif target is Boss:
		GlobalVariables.bossHealth -= damage_per_turn
		GlobalVariables.bossHealth = clamp(GlobalVariables.bossHealth, 0, GlobalVariables.bossMaxHealth) #Statt target.max_health
	
	target.setHealthLabel()
	target.setHealthBar()
	print(target.name, " erleidet ", damage_per_turn, " Blutungsschaden (ignoriert Rüstung).")
#	if target.health <= 0 and target.has_signal("dead"):
#		target.dead.emit()

	#var effect_end = decrease_duration()
	return #effect_end
