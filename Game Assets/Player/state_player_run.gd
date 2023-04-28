extends State

#called upon entering the state
func enter(host):
	if !Global.game.tutorial_movement:
		Global.game.tutorial_movement = true
	host.anim_state_machine.travel("Run")
	host.jump_stamina = host.max_jump_stamina
	return

#parallel to _physics_update
func physics_update(host, delta):
	accelerate(host, delta)
	ground_physics(host, delta)
	if host.input_down:
		if host.input_jump:
			host.platform_disable()
	elif host.input_jump || host.input_jump_memory > 0:
		if host.velocity.y == 0: Global.play_SFX("jump")
		host.velocity.y = -host.jump_speed
	
	if !host.is_on_floor():
		return 'air'
	if host.input_horizontal == 0:
		return 'idle'
	host.body.scale.x = host.input_horizontal
	return

func accelerate(host, delta):
	host.velocity.x += delta*host.input_horizontal*host.ground_acceleration

func ground_physics(host, delta):
	var velocity = host.velocity
	var friction: float
	match host.submerged:
		false:
			friction = host.ground_static_friction + host.ground_dynamic_friction*abs(velocity.x)
		true:
			friction = host.ground_submerged_static_friction + host.ground_submerged_dynamic_friction*abs(velocity.x)
	velocity.x = move_toward(
		velocity.x,
		0,
		delta*friction
	)
	host.velocity.x = velocity.x
