extends Item
class_name Steinamulette

func use():
	GlobalVariables.playerArmor += stat_bonus
	print("Rüstung um ", stat_bonus, " erhöht. Neue Rüstung: ", GlobalVariables.playerArmor)
