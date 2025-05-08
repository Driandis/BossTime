extends Effect
class_name MagicDamageEffect

	#wo wird der Schaden angepasst? In den Tres Dateien der Skills?

	
func use(target, first_value, feldmultiplier := 1.0) ->void:
	target.damage(0, ceil(first_value* feldmultiplier))
