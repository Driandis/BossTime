class_name StatusEffect
extends Resource

@export var name: String
@export var duration: float = 3.0 # Dauer in Turns
var remaining_duration: float
var target: Node # Der Knoten, der den Effekt hat/bekommt

func _init(target_node: Node = null): #vermutlich nicht notwendig
	target = target_node
	remaining_duration = duration
	#target.apply_status_effect(effect_resource: Resource=N, target: Node)
	
func _ready(): 	#Wird direkt nach dem bestimmen des Targets aufgerufen
	pass # Optionale Initialisierung beim Anwenden des Effekts

func decrease_duration():
	remaining_duration -= 1
	if remaining_duration <= 0:
		_on_effect_end()
		return true # Effekt ist abgelaufen
	return false # Effekt ist noch aktiv

func apply_effect():
		pass # Spezifische Logik beim Anwenden des Effekts

func remove_effect():
	pass # Spezifische Logik beim Entfernen des Effekts

#Bisher unnötig
func modify_incoming_damage(damage: float) -> float:
	return damage
#Bisher unnötig
func modify_outgoing_damage(damage: float) -> float:
	return damage

#Funktioniert so vermutlich nicht
func modify_attribute(attribute_name: String, base_value: float) -> float:
	return base_value

func _on_effect_end():
	pass # Optionale Logik, wenn der Effekt endet
