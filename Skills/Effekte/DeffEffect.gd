class_name DeffEffect
extends StatusEffect

@export var block_amount: int = 0
@export var armor_amount: int = 0
@export var magic_res_amount: int = 10 

func apply_effect(target: Node, caster: Node):
	if target is Boss:
		GlobalVariables.bossBlock +=block_amount
		GlobalVariables.bossArmor+=armor_amount
		GlobalVariables.bossMagicRes +=magic_res_amount
	if target is Player:
		GlobalVariables.playerBlock +=block_amount
		GlobalVariables.playerArmor+=armor_amount
		GlobalVariables.playerMagicRes +=magic_res_amount
func remove_effect(target: Node, caster: Node):
	if target is Boss:
		if GlobalVariables.bossBlock >=0:
			GlobalVariables.bossBlock -=block_amount
			if GlobalVariables.bossBlock >=0:
				GlobalVariables.bossBlock ==0
		else:
			GlobalVariables.bossBlock == 0
			
		if GlobalVariables.bossArmor >=0:
			GlobalVariables.bossArmor -=armor_amount
			if GlobalVariables.bossArmor >=0:
				GlobalVariables.bossArmor ==0
		else:
			GlobalVariables.bossArmor == 0
			
		if GlobalVariables.bossMagicRes >=0:
			GlobalVariables.bossMagicRes -=magic_res_amount
			if GlobalVariables.bossMagicRes >=0:
				GlobalVariables.bossMagicRes ==0
		else:
			GlobalVariables.bossMagicRes == 0
	if target is Player:
		if GlobalVariables.playerBlock >=0:
			GlobalVariables.playerBlock -=block_amount
			if GlobalVariables.playerBlock >=0:
				GlobalVariables.playerBlock ==0
		else:
			GlobalVariables.playerBlock == 0
			
		if GlobalVariables.playerArmor >=0:
			GlobalVariables.playerArmor -=armor_amount
			if GlobalVariables.playerArmor >=0:
				GlobalVariables.playerArmor ==0
		else:
			GlobalVariables.playerArmor == 0
			
		if GlobalVariables.playerMagicRes >=0:
			GlobalVariables.playerMagicRes -=magic_res_amount
			if GlobalVariables.playerMagicRes >=0:
				GlobalVariables.playerMagicRes ==0
		else:
			GlobalVariables.playerMagicRes == 0
