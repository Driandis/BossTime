extends Skill
class_name HealSkill

func use():
	GlobalVariables.playerHealth +=50
#hier das script von Skills noch importieren?


#var dmg := -30 #negativer Wert für Heal



	
#func use(feldmultiplier := 1.0):
#	player.damage(ceil(dmg*feldmultiplier))
#	cooldown = 5  # Fireball braucht 3 Runden Cooldown

#func _process(_delta):	#führt irgendwie dazu, dass man sauberer ziehen kann
#	if dragging:
#		global_position = get_global_mouse_position() - offset
