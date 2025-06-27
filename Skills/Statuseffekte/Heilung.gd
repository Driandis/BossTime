class_name HealEffect
extends StatusEffect


@export var heal_amount: int = 20

var _applied_to_node: Node # Referenz zum Node, auf den der Effekt angewendet wurde

# Wird aufgerufen, wenn der Effekt auf ein Ziel angewendet wird
func apply_effect(target: Node,caster: Node): # Rufe die Basis-Implementierung auf
	
	_applied_to_node = target # Speichere die Referenz zum Ziel

	# Health-Wert des Charakters erhöhen
	if target is Player: # Stelle sicher, dass es der Spieler ist
		GlobalVariables.playerHealth += heal_amount
		print("Spieler erhält ", heal_amount, " Heal. Neuer Health: ", GlobalVariables.playerHealth)
	elif target is Boss:
		GlobalVariables.bossHealth += heal_amount
		print("Boss erhält ", heal_amount, " Heal. Neuer Health: ", GlobalVariables.bossHealth)


# Wird aufgerufen, wenn der Effekt von einem Ziel entfernt wird
func remove_effect(target: Node,caster: Node):
	super.remove_effect(target, caster)
