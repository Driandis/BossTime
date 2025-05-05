extends Effect
class_name DamageEffect

	#wo wird der Schaden angepasst? In den Tres Dateien der Skills?

	
func use(target, first_value, multiplier := 1.0):
	target.damage(ceil(first_value* multiplier))
