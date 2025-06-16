extends Item
class_name Amulette_der_Brücke

func use():
	GlobalVariables.playerMagicRes+= stat_bonus
	print("Magischer Widerstand um ", stat_bonus, " erhöht. Neuer Wert: ", GlobalVariables.playerMagicRes)
