extends Node


# General
var current_turn :=0	#trackt die einzelnen kleinen Züge
var current_round := 0 #trackt die vollständigen Runden
var current_slot := 0 #trackt welches Feld gerade an der Reihe ist, Code dazu vermutlich im Main
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
#Skills (vermutlich nicht notwendig)
var skillDamage
var skillAttributes

#var array[skill] -> used spell cd gesammelt, sinnvoll für Spells, die die cd reduzieren

# Board 
var multiplyer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
