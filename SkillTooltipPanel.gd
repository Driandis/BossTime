extends PanelContainer
@onready var description_label = $VBoxContainer/DescriptionLabel

#debug
func _ready():
	self.z_index = 1000
	self.modulate = Color(1,1,1,1) # Sicherstellen, dass es nicht transparent ist
	if not is_instance_valid(description_label):
		printerr("description_label ist auch in _ready() NULL! Pfadproblem?")

func show_tooltip(item, position: Vector2):
	#print("show_tooltip aufgerufen. Instanz ID des Panels: ", get_instance_id())
	var tooltip_text = ""

	if item is Skill:
		#print("Item ist Skill")
		tooltip_text = item.get_skill_description()
	elif item is WeaponData:
		#print("Item ist WeaponData")
		tooltip_text = item.get_description()
	elif item is HeroData:
		tooltip_text=item.get_description()
	elif item is BossData:
		tooltip_text=item.get_description()
	elif item is StatusEffect:
		tooltip_text=item.get_description()
	else:
		#print("Item ist unbekannt")
		tooltip_text = "Keine Beschreibung verfügbar."

	if is_instance_valid(description_label):
		#print("Instance valid erfolgreich (TRUE-Zweig betreten)")
		description_label.text = tooltip_text
		global_position = position + Vector2(0, -20)
		visible = true
		#print("Tooltip sollte jetzt sichtbar sein. Panel Visible: ", visible, " Label Text: ", description_label.text)
	else:
		printerr("FEHLER: description_label ist NULL in show_tooltip! Dieser Fehler sollte bei gültigen Instanzen nicht erscheinen. TooltipPanel Instanz ID: ", get_instance_id())
		visible = false

func hide_description():
	visible = false
