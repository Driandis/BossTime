extends Effect
class_name PhysicalDamageEffect

	#wo wird der Schaden angepasst? In den Tres Dateien der Skills?

	
func use(target, first_value, feldmultiplier := 1.0) ->void:
	target.damage(ceil(first_value* feldmultiplier),0)
