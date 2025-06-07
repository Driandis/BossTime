extends Node


# General
var current_turn :=0	#trackt die einzelnen kleinen Züge
var current_round := 0 #trackt die vollständigen Runden
var current_slot := 0 #trackt welches Feld gerade an der Reihe ist, Code dazu vermutlich im Main
var current_fight:=0 	#trackt die Zahl der Bosskämpfe
var slot_effect_multipliers = [2.5, 2.0, 1.5]	#Multiplikatoren der Felder
var timer #wofür?

var main_node = null #zum Hinzufügen der Skills nachdem sie raus gezogen wurden

# Boss
var selected_boss: String =""
var bossName : String
var bossMaxHealth : int
var bossHealth  : int	#= bossMaxHealth
var bossBlock : int
var bossArmor : int
var bossMagicRes : int
 
# Player 
var selected_hero: String = "" #für Heldenauswahl
var current_hero: HeroData =null
var current_boss: BossData =null
var playerName : String
var playerMaxHealth : int
var playerHealth : int #= playerMaxHealth
var playerBlock : int
var playerArmor : int
var playerMagicRes : int
#Ausgerüstete Waffe: Änderungen werden weitergegeben per Signal
signal player_equipped_weapon_changed
var equipped_weapon: WeaponData = null:
	set(new_weapon):
		equipped_weapon = new_weapon
		player_equipped_weapon_changed.emit()
		
#Statuseffekte
var active_boss_status_effects: Array[StatusEffect] = []
var active_player_status_effects: Array[StatusEffect] = []
signal status_effect_removed(effect: StatusEffect, target_node: Node)
#Skills (vermutlich nicht notwendig)
var skillDamage
var skillAttributes

# NEU: Der Pool aller möglichen Item-Ressourcen
# Fülle dieses Array im Godot-Editor mit deinen Item.tres-Dateien!
@export var item_pool_resources: Array[Item] = []

# NEU: Ein temporäres Array, um die nach dem Kampf generierten Items zu speichern.
# Die Loot-Szene wird dann auf dieses Array zugreifen.
var generated_loot_items: Array[Item] = []
# Board 
var multiplyer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
# NEU: Funktion zum Generieren von zufälligem Loot
func generate_random_loot(count: int) -> Array[Item]:
	generated_loot_items.clear() # Alte Loot-Items löschen
	
	if item_pool_resources.is_empty():
		printerr("GlobalVariables: Item-Pool ist leer! Kann keinen Loot generieren.")
		return []
		
	for i in range(count):
		# Wähle ein zufälliges Item aus dem Pool
		var random_item_resource: Item = item_pool_resources[randi() % item_pool_resources.size()]
		
		# Dupliziere die Item-Ressource, um eine neue Instanz zu erhalten.
		# Das ist wichtig, damit Änderungen an einem Item nicht die Original-Ressource beeinflussen.
		var new_item_instance: Item = random_item_resource.duplicate(true) as Item
		
		if new_item_instance != null:
			generated_loot_items.append(new_item_instance)
			print("GlobalVariables: Zufälliges Item generiert: ", new_item_instance.item_name)
		else:
			printerr("GlobalVariables: Fehler beim Duplizieren eines Items aus dem Pool.")
			
	return generated_loot_items
