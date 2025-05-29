# DoubleAttackEffect.gd
extends StatusEffect
class_name Multihit

# Diese Variablen definieren den Schaden pro Treffer
@export var multi_physic_damage_per_hit: int = 0 # Basisschaden pro Treffer (vom Skill)
@export var multi_magic_damage_per_hit: int = 0  # Basismagieschaden pro Treffer (vom Skill)
@export var multihit_Count: int
#var _caster: Node # Referenz zum Anwender des Skills (wird von _init gesetzt)
func use(caster: Node, target: Node):
		print("Effekt wird aufgerufen")

func apply_effect(target: Node): # Rufe die Basis-Implementierung auf
	var caster = self.get_caster()
		# Führe den Schaden ZWEIMAL aus
	print("Apply Effect läuft")
	for i in range(multihit_Count): # Schleife für die zwei Angriffe
			print("DoubleAttackEffect: Führe Angriff ", i + 1, " von 2 aus.")
			# 1. Schadensmodifikatoren vom Anwender (_caster) anwenden
			var final_damage_values = {"physic": multi_physic_damage_per_hit, "magic": multi_magic_damage_per_hit}
			if caster.has_method("apply_attack_modifiers"):
				final_damage_values = caster.apply_attack_modifiers(
					multi_physic_damage_per_hit,
					multi_magic_damage_per_hit
				)
			
			# 2. Schaden auf das Ziel anwenden
			if target.has_method("damage"):
				target.damage(final_damage_values["physic"], final_damage_values["magic"], caster)
				print("DoubleAttackEffect: ", target.name, " nimmt ", final_damage_values["physic"] + final_damage_values["magic"], " Schaden.")
			else:
				printerr("DoubleAttackEffect: Ziel '", target.name, "' hat keine 'damage'-Methode!")
			
			# Optional: Eine kleine Verzögerung zwischen den Schlägen für visuellen/auditiven Effekt
			# await get_tree().create_timer(0.1).timeout # Nur wenn die apply-Funktion async wäre

# Die decrease_duration Methode aus der Basisklasse wird weiterhin die 'duration' reduzieren.
# Da duration = 0 ist, wird is_expired() sofort true sein.
