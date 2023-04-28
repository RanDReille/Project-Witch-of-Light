extends State

var idle_timer : float

func enter(host):
	host.anim_state_machine.travel("Idle")
	idle_timer = randf_range(host.idle_time_min, host.idle_time_max)
	return

func physics_update(host, delta):
	if Global.game.player == null:
		return
	host.ground_physics(delta)
	idle_timer = Global.timer_countdown(idle_timer, delta)
	if !host.is_on_floor():
		return 'air'
	if idle_timer <= 0:
		return 'move'
