extends Area2D
class_name Skill

var damage: int	
var cooldown: int
var current_cd: int = 0
var boss = null
var player = null
var start_position: Vector2	#damit man dahin zurückspringen kann
var dragging := false
var offset := Vector2.ZERO
#spezielle skills

#drag and drop und einreasten
func _input_event(viewport, event, shape_idx): #drag and drop
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			offset = get_global_mouse_position() - global_position
		elif not event.pressed and dragging:
			dragging = false
			check_snap()		#Zurückspringen an Anfangsort oder genau ins Feld
	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() + offset
		
func check_snap():	#Funktion zum Einrasten oder zurückspringen beim Ziehen der Skills
	var snapped = false
	for slot in get_tree().get_nodes_in_group("Felder"):
		if global_position.distance_to(slot.global_position) < 50:
			global_position = slot.global_position
			snapped = true
			break
	if not snapped:
		global_position = start_position # zurückspringen zur Ursprungsposition
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
	add_to_group("Skill")
	start_position = global_position	#für das Zurückspringen bei falschem Platzieren
	boss = get_node("/root/Main/Farmer")
	player=get_node("/root/Main/Player")

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
