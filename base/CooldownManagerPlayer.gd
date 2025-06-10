extends Node

var registered_skills: Array[Skill] = []
var cooldown_reduction_multiplier = 1.0 # 0.0 für Einfrieren, 1.0 für normal

func _process(delta):
	for skill in registered_skills:
		skill.update_cooldown(delta, cooldown_reduction_multiplier)

func register_skill(skill_instance: Node):
	if skill_instance != null and not registered_skills.has(skill_instance):
		registered_skills.append(skill_instance)
		print("Skill '%s' registriert beim CooldownManager." % skill_instance.name)

func unregister_skill(skill_instance: Node):
	if registered_skills.has(skill_instance):
		registered_skills.erase(skill_instance)
		print("Skill '%s' deregistriert." % skill_instance.name)

func set_freeze_cooldowns(freezetime: int):
	if freezetime >0:
		cooldown_reduction_multiplier = 0.0
		print("Cooldowns eingefroren!")
	else:
		cooldown_reduction_multiplier = 1.0
		print("Cooldowns wieder normal!")
