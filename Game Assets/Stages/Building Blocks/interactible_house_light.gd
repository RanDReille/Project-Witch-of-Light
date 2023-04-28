extends "res://Game Assets/Stages/Building Blocks/interactibles.gd"


func interact():
	if !Global.game.player_stat["fairy_light"]:
		Global.game.player_stat["fairy_light"] = true
		Global.game.player_mana = Global.game.player_stat["max_mana"]
		Global.game.current_stage_node.show_fairy()
		Global.play_SFX("fairy_get")
