class_name StatusEffect
extends Resource

@export var name: String
@export var duration: int # Dauer in Turns
var remaining_duration: int
var target: Node # Der Knoten, der den Effekt hat/bekommt
var caster: Node
@export var Effect_texture: Texture2D

func _init(target_node: Node = null, caster_node: Node = null): #nervig
	target = target_node
	caster = caster_node
	remaining_duration = duration
	#target.apply_status_effect(effect_resource: Resource=N, target: Node)
	#print("DEBUG_BASE_INIT: Base StatusEffect Init: Name=", self.name, ", Duration=", duration, ", Remaining=", remaining_duration, ", Target=", target, ", Caster=", caster)

func _ready(): 	#Wird direkt nach dem bestimmen des Targets aufgerufen
	pass # Optionale Initialisierung beim Anwenden des Effekts

func on_turn_tick(target: Node,caster: Node): 	#hier passiert alles
	
	pass
func get_caster():
	return caster
func get_target():
	return target
func decrease_duration():	
	print("Timer von ", name, remaining_duration)
	remaining_duration -= 1
	print("Reduzierter Timer für ", name, remaining_duration)
	if remaining_duration <= 0:
		_on_effect_end()
		return true # Effekt ist abgelaufen
	return false # Effekt ist noch aktiv

func apply_effect(target: Node, caster: Node):
		#print("DEBUG_BASE_APPLY: Base StatusEffect apply: Name=", name, ", Target=", target.name)
			#print("Effekt '", name, "' auf ", target.name, " angewendet.")
		remaining_duration = duration
		#print("DEBUG_BASE_APPLY: Base StatusEffect apply: Set remaining_duration to ", remaining_duration)
		pass # Spezifische Logik beim Anwenden des Effekts

func remove_effect(target: Node, caster: Node):
	#print("Effekt '", name, "' von ", target.name, " entfernt.")
	pass # Spezifische Logik beim Entfernen des Effekts

#Bisher unnötig
func modify_incoming_damage(physical_dmg: float, magic_dmg: float) -> Dictionary:
	return {"physic": physical_dmg, "magic": magic_dmg}
#Bisher unnötig
func modify_outgoing_damage(physical_dmg: float, magic_dmg: float) -> Dictionary:
	return {"physic": physical_dmg, "magic": magic_dmg}

#Funktioniert so vermutlich nicht
func modify_attribute(attribute_name: String, base_value: float) -> float:
	return base_value

func _on_effect_end():
	#Spezielle Abschlusseffekte hier möglich
	print("Versucht Effekt von ",target.name," zu entfernen")
	if target is Player:
		remove_effect(target,caster)
		GlobalVariables.active_player_status_effects.erase(self)
		
	if target is Boss:
		#if
		remove_effect(target, caster)
		GlobalVariables.active_boss_status_effects.erase(self)
	print("Aktuelle Statuseffekte nach dem Clean-up ", GlobalVariables.active_boss_status_effects, " (Boss)",GlobalVariables.active_player_status_effects, "(Player)")
	pass # Optionale Logik, wenn der Effekt endet
