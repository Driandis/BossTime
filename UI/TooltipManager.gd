extends Node

var skill_tooltip_panel_scene = preload("res://nodes/skill_tooltip.tscn") # Passe den Pfad an!
var skill_tooltip_instance = null

func _ready():
	# Instanziiere das TooltipPanel, wenn der Manager bereit ist
	skill_tooltip_instance = skill_tooltip_panel_scene.instantiate()
	add_child(skill_tooltip_instance) 
	#get_tree().get_root().add_child(skill_tooltip_instance)
	skill_tooltip_instance.hide() # Standardmäßig versteckt
	#print_debug("TooltipManager bereit.")

func show_tooltip(skill_data, global_mouse_position):
	if skill_tooltip_instance:
		skill_tooltip_instance.show_tooltip(skill_data, global_mouse_position)
		# Optional: Stelle sicher, dass es ganz oben gezeichnet wird
		#skill_tooltip_instance.raise() 
	else:
		push_error("SkillTooltipPanel Instanz ist NULL in TooltipManager!")

func hide_description():
	if skill_tooltip_instance:
		skill_tooltip_instance.hide()
