extends State

var move_timer : float
var move_dir_choices = [-1.0, 1.0]

func enter(host):
	host.move_dir = move_dir_choices[randi()%2]
	update_animation(host)
		
	move_timer = randf_range(host.move_time_min, host.move_time_max)
	return

func physics_update(host, delta):
	if Global.game.player == null:
		return
	accelerate(host, delta)
	host.ground_physics(delta)
	if host.wall_detectors["left"].is_colliding() || (!host.floor_detectors["left"].is_colliding() && host.floor_detectors["right"].is_colliding()):
		host.move_dir = 1.0
		update_animation(host)
	if host.wall_detectors["right"].is_colliding() || (!host.floor_detectors["right"].is_colliding() && host.floor_detectors["left"].is_colliding()):
		host.move_dir = -1.0
		update_animation(host)
	
	move_timer = Global.timer_countdown(move_timer, delta)
	if !host.is_on_floor():
		return 'air'
	if move_timer <= 0:
		return 'idle'

func accelerate(host, delta):
	host.velocity.x += delta*host.move_dir*host.ground_acceleration

func update_animation(host):
	match host.move_dir:
		-1.0:
			host.anim_state_machine.travel("Move_Left")
		1.0:
			host.anim_state_machine.travel("Move_Right")
