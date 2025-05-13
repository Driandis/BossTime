extends StatusEffect
class_name Burn

@export var damage_per_turn: int = 3
@export var armor_reduction: int = 5

func on_turn_ended():
	if target:
		# Füge direkten Schaden zu
		if target.has_method("health"):
			target.health -= damage_per_turn
			target.health = clamp(target.health, 0, target.max_health)
			target.setHealthLabel()
			target.setHealthBar()
			print(target.name, " erleidet ", damage_per_turn, " Brennschaden (ignoriert Rüstung).")
			if target.health <= 0 and target.has_signal("dead"):
				target.dead.emit()

		# Reduziere die Rüstung über modify_attribute
		if target.has_method("modify_attribute"):
			target.modify_attribute("bossArmor", -armor_reduction) # Negativer Wert für Reduktion
			print(target.name, " Rüstung um ", armor_reduction, " reduziert durch Brennen (modify_attribute).")

	var effect_end = decrease_duration()
	return effect_end

func apply_effect():
	if target:
		print(target.name, " fängt an zu brennen!")
		# Reduziere die Rüstung sofort beim Anwenden
		if target.has_method("modify_attribute"):
			target.modify_attribute("playerArmor", -armor_reduction)
			print(target.name, " Rüstung um ", armor_reduction, " reduziert durch Einsetzen von Brennen (modify_attribute).")

func remove_effect():
	if target:
		print(target.name, " hört auf zu brennen.")
		# Stelle die Rüstung wieder her
		if target.has_method("modify_attribute"):
			target.modify_attribute("playerArmor", armor_reduction) # Positiver Wert für Wiederherstellung
			print(target.name, " Rüstung durch Ende von Brennen wiederhergestellt (modify_attribute).")
