extends Resource
class_name Skill

var name: String
var damage: int
var cooldown: int
var current_cd: int = 0

#spezielle skills

var feuerball_counter =3
var feuerball_counter_current =0


#befehle
func is_ready() -> bool:
	return current_cd == 0

func use():
	current_cd = cooldown

func tick_cooldown():
	if current_cd > 0:
		current_cd -= 1
