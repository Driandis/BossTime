extends Item
class_name Elixier_der_Körperkraft

func use():
	GlobalVariables.playerMaxHealth+= stat_bonus
	GlobalVariables.playerHealth +=stat_bonus
	print("HP um ", stat_bonus, " erhöht. Neuer Max-HP Wert: ", GlobalVariables.playerMaxHealth)
