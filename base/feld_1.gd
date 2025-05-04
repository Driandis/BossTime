extends Area2D

func _ready():
	add_to_group("Felder")
	
#func _on_body_entered(body):
#	if body.name == "Fireball":
#		print("Fireball wurde auf die Zone gelegt!")
#		# Optional: Aktion auslösen, z.B. Schaden machen
#		#eventuell nicht notwendig und einfach im Mainscript integrierbar
