extends Resource
class_name  Items

@export var name: String
var target: Node # Der Knoten, der den Effekt hat/bekommt
var caster: Node
@export var Item_texture: Texture2D

@export var stat_multiplier: float
@export var stat_bonus: float

func _init(target_node: Node = null, caster_node: Node = null): #nervig
	target = target_node
	caster = caster_node
	
func _ready(): 	#Wird direkt nach dem bestimmen des Targets aufgerufen, Starteffekt
	pass # Optionale Initialisierung beim Anwenden des Effekts
	
func get_caster():
	return caster
func get_target():
	return target
func modify_incoming_damage(physical_dmg: float, magic_dmg: float) -> Dictionary:
	return {"physic": physical_dmg, "magic": magic_dmg}
#Bisher unnötig
func modify_outgoing_damage(physical_dmg: float, magic_dmg: float) -> Dictionary:
	return {"physic": physical_dmg, "magic": magic_dmg}

#Funktioniert so vermutlich nicht
func modify_attribute(attribute_name: String, base_value: float) -> float:
	return base_value	
