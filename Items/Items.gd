extends Resource
class_name  Item

@export var name: String
var target: Node # Der Knoten, der den Effekt hat/bekommt
var caster: Node
@export var Item_texture: Texture2D
@export var stackable: bool = false		#notwendig?
@export var stat_multiplier: float	#Dazu multipliziert
@export var stat_bonus: float	#Flat dazuaddiert
@export var item_count: int	#wie oft das Item im Pool ist
@export var equip_count: int	#wie oft das Item gleichzeitig ausgerüstet werden kann
@export var description: String
@export var stat: String

func _init(target_node: Node = null, caster_node: Node = null): #nervig
	target = target_node
	caster = caster_node
	
func _ready(): 	#Wird direkt nach dem bestimmen des Targets aufgerufen, Starteffekt
	pass # Optionale Initialisierung beim Anwenden des Effekts
func use():	#Zu Beginn des Kampfes wird das Item benutzt
	pass
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
	
func get_description() -> String:
	var weapon_description_text = ""
	weapon_description_text += "Name: " + name + "\n" # Greife direkt auf 'name' zu
	weapon_description_text += "Beschreibung: " + description + "\n" # Greife direkt auf 'description' zu
	
	weapon_description_text += "Betroffener Wert: " + stat + "\n"
	weapon_description_text += "Erhöhung um: " + str(stat_bonus) + "\n"
	
	return weapon_description_text
