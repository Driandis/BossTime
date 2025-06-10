class_name Burn
extends StatusEffect



@export var damage_per_turn: int = 3
@export var armor_reduction: int = 5

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
	print(target.name, " erleidet ", damage_per_turn, " Brennschaden (ignoriert Rüstung).")
#	if target.health <= 0 and target.has_signal("dead"):
#		target.dead.emit()

	#var effect_end = decrease_duration()
	return #effect_end

func apply_effect(target: Node,caster: Node):
	if target:
		print(target.name, " fängt an zu brennen!")
		# Reduziere die Rüstung sofort beim Anwenden
		if target.has_method("modify_attribute"):
			target.modify_attribute("Armor", -armor_reduction)
			print(target.name, " Rüstung um ", armor_reduction, " reduziert durch Einsetzen von Brennen (modify_attribute).")
	
func remove_effect(target: Node,caster: Node):
	if target:
		print(target.name, " hört auf zu brennen.")
		# Stelle die Rüstung wieder her
		if target.has_method("modify_attribute"):
			target.modify_attribute("Armor", armor_reduction) # Positiver Wert für Wiederherstellung
			print(target.name, " Rüstung durch Ende von Brennen wiederhergestellt (modify_attribute).")
