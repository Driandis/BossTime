extends Skill
class_name Schmettern

func use():
	GlobalVariables.playerArmor -= 3
	print("Rüstung des Spielers wurde zerstört. Neue Rüstung: ", GlobalVariables.playerArmor)
