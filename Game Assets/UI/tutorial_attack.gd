extends Sprite2D


func _physics_process(delta):
	#print_debug(Global.game.tutorial_attack)
	#print_debug(Global.game.player_stat["fairy_light"])
	#print_debug(Global.game.tutorial_attack || !Global.game.player_stat["fairy_light"])
	if Global.game.tutorial_attack || !Global.game.player_stat["fairy_light"]:
		queue_free()
