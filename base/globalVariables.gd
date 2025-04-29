extends Node


# General
var current_slot := 0 #trackt welches Feld gerade an der Reihe ist, Code dazu vermutlich im Main
var timer 

# Boss
var selected_boss: String =""
const bossMaxHealth = 300
var bossHealth = bossMaxHealth
var bossBlock
var bossArmor
var bossMagicRes
 
# Player 
var selected_hero: String = "" #für Heldenauswahl
const playerMaxHealth = 100
var playerHealth = playerMaxHealth
var playerBlock
var playerAmor
var playerMagicRes
#Skills
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
