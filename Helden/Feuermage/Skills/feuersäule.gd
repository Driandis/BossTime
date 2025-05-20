extends Skill
class_name Feuersäule


func use() -> void:
	var target = _get_target()
	var caster = _get_caster()
	print("Test", target, caster)
