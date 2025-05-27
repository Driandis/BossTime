extends Skill
class_name Feuerblitze

func use() -> void:
	var target = _get_target()
	var caster = _get_caster()
	print(self, " ausgelöst: ", target, caster)
