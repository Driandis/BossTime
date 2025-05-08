extends Area2D
class_name Skill

#var damage: int	
var current_cd: int = 0
var boss = null
var player = null
var start_position: Vector2	#damit man dahin zurückspringen kann
var dragging := false
var offset := Vector2.ZERO
var previous_slot = null  # Zum Rauswerfem des Skills aus den Feldern
#@export var description: String = "Starker Angriff mit Feuerschaden"	#Bescbreibung des Skills
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

func _process(_delta):	#führt irgendwie dazu, dass man sauberer ziehen kann
	if dragging:
		global_position = get_global_mouse_position() - offset
		var tooltip = get_node_or_null("/root/Main/SkillTooltip")#Tipps werden versteckt, wenn der Skill gezogen wird
		if tooltip:
			tooltip.hide()
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
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
func _on_mouse_entered():
	var tooltip = get_tree().get_root().get_node("Main/SkillTooltip")  # Mauszeiger löst Skillerklärung aus
	tooltip.show_tooltip(self, get_global_mouse_position())

#verschwindet wieder, wenn die Maus weg ist
func _on_mouse_exited():
	var tooltip = get_tree().get_root().get_node("Main/SkillTooltip")
	tooltip.hide()
	
func is_ready() -> bool:
	return current_cd == 0
	
#für die Hinweise zu den Skills
@export var skill_data: SkillData
	#für die SkillTooltips (Hinweise zu den Skills) wichtig
	#zeigt aber auch generell in der tres-Datei jetzt die eigene Ressource als Skill Data
func get_skill_description() -> String:
	if skill_data:
		#damit die Effektnamen rausgesucht werden
		var effect_script = skill_data.effect.get_script()
		var effect_name = effect_script.resource_path.get_file().get_basename() if effect_script else "Kein Effekt"
		#hiermit kommt die Beschreibung der Skills
		return "Name: %s\nCooldown: %d\nEffekt: %s\nWert: %d" % [
			skill_data.skill_name,
			skill_data.cooldown,
			effect_name,
			skill_data.first_value
		]
	return "Keine Daten verfügbar"
	
	#neu für Effekte
@export var skill_name: String
@export var effect: Effect
@export var first_value: float = 10.0
enum TargetType { BOSS, PLAYER }	#damit man als Ziel Boss oder Player bei den Effekten auswählen kann
@export var target_type: TargetType 
@export var cooldown: float = 10.0

func _run_effect(feldmultiplier := 1.0) -> void:
	print("Skill wurde ausgeführt: ", name)
	var target = _get_target()
	if target != null and effect != null:
		effect.use(target, first_value, feldmultiplier)	#neu: Wenn es ein Effekt ist, soll der Effekt ausgeführt werden 
		current_cd = cooldown
		_setCooldownBar()
func _get_target():
	match target_type:
		TargetType.BOSS:
			return get_tree().get_root().get_node("Main/Boss")  # Pfad anpassen
		TargetType.PLAYER:
			return get_tree().get_root().get_node("Main/Player")  # Pfad anpassen
	return null
	#Alt: 
		#use(feldmultiplier)
		#

		
func use(feldmultiplier := 1.0): #in den speziellen Skillskripten wird dann definiert, was die Skills machen
	var target = null

	match target_type:
		TargetType.BOSS:
			target = get_tree().get_root().get_node("res://bosses/boss.gd")  # oder anderer Pfad
		TargetType.PLAYER:
			target = get_tree().get_root().get_node("res://Helden/player.gd")

	if target != null and effect != null:
		effect.use(target, first_value, feldmultiplier)
	else:
		push_warning("Target oder Effekt fehlt für Skill " + name)
		pass
	
func tick_cooldown():
	if current_cd > 0:
		current_cd -= 1
	_setCooldownBar()
