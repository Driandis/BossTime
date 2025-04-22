extends Skill


#hier das script von Skills noch importieren?

var dragging := false
var offset := Vector2.ZERO
var dmg := 150


func _ready():
	add_to_group("Skill") #damit er alle Skills Aspekte hat
	boss = get_node("/root/Main/Farmer") #damit er mit dem Boss und seinen Funktionen interagieren kann
	cooldown = 3  # Fireball braucht 3 Runden Cooldown
	
	
func _input_event(viewport, event, shape_idx): #drag and drop
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			offset = get_global_mouse_position() - global_position
		else:
			dragging = false
func use():
	boss.damage(dmg)
	
	
	
func _process(_delta):
	if dragging:
		global_position = get_global_mouse_position() - offset
