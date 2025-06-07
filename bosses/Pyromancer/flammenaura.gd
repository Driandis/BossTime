extends Skill
class_name Flammenaura

func use() -> void:
	var target = _get_target()
	var caster = _get_caster()
	print(self, " ausgelöst: ", target, caster)
