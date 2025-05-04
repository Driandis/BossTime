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
var previous_slot = null  # Zum Rauswerfem des Skills aus den Feldern
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
		
#Funktion zum Einrasten oder zurückspringen beim Ziehen der Skills
#Mitlerweile aber auch dafür da, zu erkennen, dass Skills nicht mehr in Feldern liegen, damit sie nicht mehr
#aktiviert werden, wenn sie auf keinem Feld liegen
func check_snap():	
	var snapped = false
	for slot in get_tree().get_nodes_in_group("Felder"):	#Die Felder sind jetzt slots
		if global_position.distance_to(slot.global_position) < 50:	#Distanz zum Einrasten
			if previous_slot != null and previous_slot != slot and is_a_parent(previous_slot):# Vorherigen Slot aufräumen (falls Skill rausgezogen wurde)
				previous_slot.remove_child(self)
			if is_a_parent(get_parent()):
				get_parent().remove_child(self)	
			slot.add_child(self)
			global_position = slot.global_position
			snapped = true
			previous_slot = slot  # neuer vorheriger Slot
			break
	if not snapped:
		if is_inside_tree():
			get_parent().remove_child(self)
		
		if GlobalVariables.main_node:
			GlobalVariables.main_node.add_child(self)
			global_position = start_position   # 
		else:
			
			print("Fehler: main_node nicht gesetzt – konntest Skill nicht korrekt zurücksetzen.")
		previous_slot = null
	
#befehle
func is_a_parent(node):	#Zum Entfernen der Skills: Prüft, ob an etwas noch andere Nodes dran hängen?
	return node != null and node.has_method("remove_child") and is_instance_valid(node)
	
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
	boss = get_node("/root/Main/Boss")
	player=get_node("/root/Main/Player")
	previous_slot = get_parent() # if is_inside_tree() else null	#fürs Rauswerfen der Skills aus den Feldern

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
