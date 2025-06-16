extends Item
class_name Amulette_des_Gleichgewichts

func use():
	GlobalVariables.playerMagicRes+= stat_bonus
	GlobalVariables.playerArmor += stat_bonus
	print("Magischer und physischer Widerstand um ", stat_bonus, " erhöht. Neue Werte: ", GlobalVariables.playerMagicRes, " und ", GlobalVariables.playerArmor)
