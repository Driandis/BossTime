extends Skill
#hier das script von Skills noch importieren?

var dragging := false
var offset := Vector2.ZERO
var dmg := -15 #negativer Wert für Heal
var player

func _ready():
	add_to_group("Skill") #damit er alle Skills Aspekte hat
	player = get_node("/root/Main/Player") #damit er mit dem Boss und seinen Funktionen interagieren kann
	cooldown = 5  # Fireball braucht 3 Runden Cooldown
	
	
func _input_event(viewport, event, shape_idx): #drag and drop
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			offset = get_global_mouse_position() - global_position
		else:
			dragging = false
func use(feldmultiplier := 1.0):
	player.damage(dmg*feldmultiplier)
	
	
	
func _process(_delta):
	if dragging:
		global_position = get_global_mouse_position() - offset
