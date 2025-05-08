extends Panel
@onready var label = $DescriptionLabel

func show_tooltip(skill: Skill, position: Vector2):
	var text = skill.get_skill_description()
	$DescriptionLabel.text = text
	global_position = position+ Vector2(0, -20)  # Offset zur Maus
	visible = true

func hide_description():
	visible = false
