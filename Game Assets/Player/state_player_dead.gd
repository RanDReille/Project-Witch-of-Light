extends State

func enter(host):
	host.anim_state_machine.travel("Dead")
	Global.game.UI["Game_Over"].show()
