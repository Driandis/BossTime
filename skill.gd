extends Area2D
class_name Skill

var damage: int	
var cooldown: int
var current_cd: int = 0
var boss = null
#spezielle skills


#befehle
func _setCooldownBar() -> void: #cooldown Einstellung
	if current_cd == 0:
		$CooldownBar.visible = false
	else:
		$CooldownBar.visible = true
		$CooldownBar.max_value = cooldown
		$CooldownBar.value = current_cd
		$CooldownBar/CooldownText.text = str(current_cd) + " / " + str(cooldown)
	
func _ready():
	boss = get_node("/root/Main/Farmer")

func is_ready() -> bool:
	return current_cd == 0
	
func _run_effect(feldmultiplier := 1.0):
		print("Skill wurde ausgeführt: ", name)
		use(feldmultiplier)
		current_cd = cooldown
		_setCooldownBar()
		
func use(feldmultiplier := 1.0): #in den speziellen Skillskripten wird dann definiert, was die Skills machen
	pass
	
func tick_cooldown():
	if current_cd > 0:
		current_cd -= 1
	_setCooldownBar()
