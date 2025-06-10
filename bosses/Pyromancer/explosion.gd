extends Skill
class_name Explosion

func use() -> void:
	var target = _get_target()
	var caster = _get_caster()
	print(self, " ausgelöst: ", target, caster)
	GlobalVariables.freezetimer =1
	printerr("Freezetimer gesetzt: ",GlobalVariables.freezetimer)
