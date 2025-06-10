extends Skill
class_name Schmettern

func use():
	GlobalVariables.playerArmor -= 3
	if GlobalVariables.playerArmor <=0:
		GlobalVariables.playerArmor =0
	print("Rüstung des Spielers wurde zerstört. Neue Rüstung: ", GlobalVariables.playerArmor)
