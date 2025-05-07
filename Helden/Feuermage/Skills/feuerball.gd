extends Skill
class_name FireballSkill

#neue Version
#@export var target_path: NodePath # optional: wo der Boss ist

#eigentlich nicht notwendig
#func _run_effect(feldmultiplier := 1.0):
#	var target = get_node_or_null(target_path)
#	if target and effect:
#		effect.use(target, first_value,feldmultiplier)

#alt
#extends Skill #hier wird script von Skills importiert


#var dmg := 8
	
	
#func use(feldmultiplier := 1.0):

	#boss.damage(0, ceil(dmg * feldmultiplier)) #gerundeter DMG insgesamt
#	cooldown = 3  # Fireball braucht 3 Runden Cooldown
	
