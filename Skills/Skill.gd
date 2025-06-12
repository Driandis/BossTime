extends Area2D
class_name Skill

var current_cd: int = 0
var boss = null
var player = null
var start_position: Vector2	#damit man dahin zurückspringen kann
var dragging := false
var offset := Vector2.ZERO
var previous_slot = null  # Zum Rauswerfem des Skills aus den Feldern
var target
var caster
@export var skill_sound: AudioStreamPlayer2D
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
func reset_skill():
		if is_inside_tree():
			get_parent().remove_child(self)
		
		if GlobalVariables.main_node:
			GlobalVariables.main_node.add_child(self)
			global_position = start_position   # 
		else:
			print("Fehler: main_node nicht gesetzt – konntest Skill nicht korrekt zurücksetzen.")
		previous_slot = null
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
		# Setze den z_index, um sicherzustellen, dass der Skill immer oben gezeichnet wird.
	# Wähle einen Wert, der höher ist als der z_index deiner "Felder".
	# Ein Wert wie 10 oder 100 ist oft ausreichend, aber wähle ihn basierend auf deinen anderen Elementen.
	z_index = 100 
func _on_mouse_entered():
	TooltipManager.show_tooltip(self, get_global_mouse_position())

#verschwindet wieder, wenn die Maus weg ist
func _on_mouse_exited():
	TooltipManager.hide_description()
	
func is_ready() -> bool:
	return current_cd == 0
	
	#neu für Effekte
enum TargetType { BOSS, PLAYER }	#damit man als Ziel Boss oder Player bei den Effekten auswählen kann

#Ist das alles was ein Skill braucht? Auf Discord deutlich mehr
@export var skill_name: String
@export var effect: StatusEffect	#Alle verschiedenen Effekte, wie magicdmg, 
@export var effect_value: float 
@export var target_type: TargetType 
@export var cooldown: int 
@export var caster_type: TargetType 
@export var physical_damage : int
@export var magic_damage : int
@export var apply_effect_to_caster: bool = false # Soll der Effekt auf den Anwender?
@export var apply_effect_to_target: bool = true  # Soll der Effekt auf das Ziel?

func _run_effect(feldmultiplier := 1.0) -> void:
	print("Skill wurde ausgeführt: ", name)
	var target = _get_target()
	var caster = _get_caster()
	if skill_sound !=null:
		skill_sound.play()
		printerr("Skillsound abgespielt")
	if caster != null and target != null: 
		use()	#Spezifische Effekte (zB Heal) des Skills anwenden
		if effect != null:
			print("Versuche Effekt anzuwenden...")
			var effect_instance =effect.duplicate(true) as StatusEffect
			if effect_instance != null:
				if apply_effect_to_target and target.has_method("apply_status_effect"):
					target.apply_status_effect(effect_instance, target, caster)
				if apply_effect_to_caster and caster.has_method("apply_status_effect"):
					caster.apply_status_effect(effect_instance,target, caster)
			else:
				push_warning("Die zugewiesene Ressource ist kein gültiger StatusEffect für Skill " + name)
	else:
		print("Target oder Caster Null")
	if caster != null and target != null:
	# Schadensmultiplikatoren anwenden (ALLE)
		if caster.has_method("apply_attack_modifiers"):
			var final_damage_values = {"physic": physical_damage, "magic": magic_damage}
			final_damage_values = caster.apply_attack_modifiers(
				physical_damage,
				magic_damage
		)
			target.damage(final_damage_values["physic"], final_damage_values["magic"], caster)
		else:
			push_warning("Caster hat keine 'apply_attack_modifiers' Methode für Skill " + name)

		use_end()
	else:
		push_warning("Target oder Effekt fehlt für Skill " + name)
	
	current_cd = cooldown
	_setCooldownBar()
	
func _get_caster():#Zugriff auf die Skripte für die Effekte der Skills auf den Caster
	match caster_type:
		TargetType.BOSS:
			return get_tree().get_root().get_node("Main/Boss")  # Pfad anpassen
		TargetType.PLAYER:
			return get_tree().get_root().get_node("Main/Player")  # Pfad anpassen
	return null
func _get_target():	#Zugriff auf die Skripte für die Effekte der Skills aufs Target
	match target_type:
		TargetType.BOSS:
			return get_tree().get_root().get_node("Main/Boss")  # Pfad anpassen
		TargetType.PLAYER:
			return get_tree().get_root().get_node("Main/Player")  # Pfad anpassen
	return null

		
func use(): #in den speziellen Skillskripten wird dann definiert, was die Skills machen
	pass
func use_end():	#Für Effekte der Skills, die erst nach der Schadensberechnung passieren sollen
	pass
#Cooldown reduzieren
func tick_cooldown():
	if current_cd > 0:
		current_cd -= 1
	_setCooldownBar()

#für die Skillbeschreibung
func _get_target_type_string(type: TargetType) -> String:
	match type:
		TargetType.BOSS:
			return "Boss"
		TargetType.PLAYER:
			return "Spieler"
		_:
			return "Unbekannt" # Für den Fall eines unerwarteten Werts

func get_skill_description() -> String:
	# Darstellung des Schadens
	var damage_string = ""
	if physical_damage > 0 and magic_damage > 0:
		damage_string = "Schaden: %d Phys / %d Mag" % [physical_damage, magic_damage]
	elif physical_damage > 0:
		damage_string = "Schaden: %d Phys" % physical_damage
	elif magic_damage > 0:
		damage_string = "Schaden: %d Mag" % magic_damage
	else:
		damage_string = "Kein direkter Schaden"
	var effect_description = "Kein Effekt"
	var effect_value_string = ""
	if effect != null:
		effect_description=effect.name
		
	return "Name: {name}\nCooldown: {cooldown}\n{damage_string}\nEffekt: {effect.name}\nZiel: {target_string}\nAusführender: {caster_string}".format({
	"name": name,
	"cooldown": cooldown,
	"damage_string": damage_string,
	"effect.name": effect_description,
	"target_string": _get_target_type_string(target_type),
	"caster_string": _get_target_type_string(caster_type)
})
	return "Keine Daten verfügbar"
