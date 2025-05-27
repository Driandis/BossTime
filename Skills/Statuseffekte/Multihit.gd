# DoubleAttackEffect.gd
extends StatusEffect
class_name Multihit

# Diese Variablen definieren den Schaden pro Treffer
@export var base_physic_damage_per_hit: int = 0 # Basisschaden pro Treffer (vom Skill)
@export var base_magic_damage_per_hit: int = 0  # Basismagieschaden pro Treffer (vom Skill)
@export var multihit_Count: int
var _caster: Node # Referenz zum Anwender des Skills (wird von _init gesetzt)

func use(caster: Node, target: Node):
		print("Effekt wird aufgerufen")
func _init(caster_node: Node, physic_dmg: int = 0, magic_dmg: int = 0):
#	effect_name = "Doppelschlag"
#	description = "Verursacht zwei Mal Schaden direkt hintereinander."
#	duration = 0 # Dieser Effekt ist sofort und hat keine Dauer über Runden
	
	_caster = caster
	#base_physic_damage_per_hit = physic_dmg
	#base_magic_damage_per_hit = magic_dmg
#	
	print("DoubleAttackEffect initialisiert. Caster: ", _caster.name if _caster else "N/A", " PhysDmg/Hit: ", base_physic_damage_per_hit, " MagDmg/Hit: ", base_magic_damage_per_hit)
#
# Diese Methode wird aufgerufen, wenn der Effekt auf ein Ziel angewendet wird
func apply_effect(target: Node): # Rufe die Basis-Implementierung auf
		# Führe den Schaden ZWEIMAL aus
		print("Apply Effect läuft")
		for i in range(multihit_Count): # Schleife für die zwei Angriffe
			print("DoubleAttackEffect: Führe Angriff ", i + 1, " von 2 aus.")
			# 1. Schadensmodifikatoren vom Anwender (_caster) anwenden
			var final_damage_values = {"physic": base_physic_damage_per_hit, "magic": base_magic_damage_per_hit}
			if _caster.has_method("apply_attack_modifiers"):
				final_damage_values = _caster.apply_attack_modifiers(
					base_physic_damage_per_hit,
					base_magic_damage_per_hit
				)
			
			# 2. Schaden auf das Ziel anwenden
			if target.has_method("damage"):
				target.damage(final_damage_values["physic"], final_damage_values["magic"], _caster)
				print("DoubleAttackEffect: ", target.name, " nimmt ", final_damage_values["physic"] + final_damage_values["magic"], " Schaden.")
			else:
				printerr("DoubleAttackEffect: Ziel '", target.name, "' hat keine 'damage'-Methode!")
			
			# Optional: Eine kleine Verzögerung zwischen den Schlägen für visuellen/auditiven Effekt
			# await get_tree().create_timer(0.1).timeout # Nur wenn die apply-Funktion async wäre

# Die decrease_duration Methode aus der Basisklasse wird weiterhin die 'duration' reduzieren.
# Da duration = 0 ist, wird is_expired() sofort true sein.
