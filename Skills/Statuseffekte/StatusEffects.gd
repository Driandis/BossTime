class_name StatusEffect
extends Resource

@export var name: String = "Basis-Effekt"
@export var duration: float = 3.0 # Dauer in Turns
var remaining_duration: float
var target: Node # Der Knoten, der den Effekt hat

func _init(target_node: Node = null):
	target = target_node
	remaining_duration = duration

func _ready():
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

func modify_incoming_damage(damage: float) -> float:
	return damage

func modify_outgoing_damage(damage: float) -> float:
	return damage

#Funktioniert so vermutlich nicht
func modify_attribute(attribute_name: String, base_value: float) -> float:
	return base_value

func _on_effect_end():
	pass # Optionale Logik, wenn der Effekt endet
