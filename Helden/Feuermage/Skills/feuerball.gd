extends Skill #hier wird script von Skills importiert


var dmg := 15
	

func use(feldmultiplier := 1.0):
	boss.damage(ceil(dmg * feldmultiplier)) #gerundeter DMG insgesamt
	cooldown = 3  # Fireball braucht 3 Runden Cooldown
	
func _process(_delta):	#führt irgendwie dazu, dass man sauberer ziehen kann
	if dragging:
		global_position = get_global_mouse_position() - offset
