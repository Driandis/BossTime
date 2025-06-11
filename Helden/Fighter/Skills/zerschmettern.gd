extends Skill
class_name zerschmettern

func use():
	GlobalVariables.bossArmor -=5
	print("Bossrüstung zerstört. Neuer Rüstungswert des Boss: ", GlobalVariables.bossArmor)
	if GlobalVariables.bossArmor <= 0:
		GlobalVariables.bossArmor == 0
