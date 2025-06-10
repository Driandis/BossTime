extends Skill
class_name Feuerwirbel

func use():
	if GlobalVariables.playerMagicRes >=0:
		GlobalVariables.playerMagicRes -= 3
		if GlobalVariables.playerMagicRes <=0:
			GlobalVariables.playerMagicRes = 0
		print("Magischer Widerstand des Spielers wurde zerstört. Neuer Wert: ", GlobalVariables.playerMagicRes)
