extends State

var idle_stop_timer

func enter(host):
	host.anim_state_machine.travel("Idle")
	host.velocity = Vector2(0.0, 0.0)
	idle_stop_timer = randf_range(host.idle_stop_timer_min, host.idle_stop_timer_max)
	return

#called upon exiting the state
func exit(host):
	return

#parallel to _process
func update(host, delta):
	return

#parallel to _physics_update
func physics_update(host, delta):
	if Global.game.player == null:
		return
	host.to_player = Global.game.player.global_position - host.global_position
	host.distance_to_player_squared = host.to_player.x*host.to_player.x + host.to_player.y*host.to_player.y
	if host.distance_to_player_squared < host.detect_player_distance*host.detect_player_distance:
		host.emotion.play_anim("Surprised")
		return 'alert'
	
	host.flying_air_physics(delta)
	
	idle_stop_timer = Global.timer_countdown(idle_stop_timer, delta)
	if idle_stop_timer <= 0:
		return 'idle_move'
	return

func handle_input(host, event):
	return
