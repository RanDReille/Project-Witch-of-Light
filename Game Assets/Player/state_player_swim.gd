extends State

var coyote_timer := 0.0

func enter(host):
	air_animation_control(host)
	if host.velocity.y >= 0 && !host.input_down && !host.input_jump: coyote_timer = host.coyote_time
	else: coyote_timer = 0.0

func physics_update(host, delta):
	air_animation_control(host)
	accelerate(host, delta, host.input_horizontal)
	air_physics(host, delta)
	
	host.jump_stamina = host.submerged_jump_stamina
	if host.input_jump && !host.input_down && host.jump_stamina > 0:
		host.jump_stamina -= delta
		
		host.velocity.y = -host.jump_speed*host.submerged_jump_speed_multiplier
		if host.is_on_ceiling(): host.jump_stamina = 0
		if coyote_timer > 0.0:
			Global.play_SFX("jump")
			coyote_timer = 0.0
	elif coyote_timer-delta > 0.0:
		coyote_timer -= delta
	else:
		coyote_timer = 0.0
		host.jump_stamina = 0
	
	if host.is_on_floor():
		if host.input_horizontal != 0:
			return 'run'
		else:
			return 'idle'
	if !host.head_submerged:
		return 'air'
	if host.input_horizontal != 0: host.body.scale.x = sign(host.input_horizontal)
	return

func accelerate(host, delta, input_horizontal):
	host.velocity.x += delta*input_horizontal*host.air_acceleration

func air_physics(host, delta):
	var velocity = host.velocity
	var friction: float
	match host.submerged:
		false:
			friction = host.submerged_static_friction + host.submerged_dynamic_friction*abs(velocity.x)
		true:
			friction = host.submerged_static_friction + host.submerged_dynamic_friction*abs(velocity.x)
	velocity.x = move_toward(
		velocity.x,
		0,
		delta*friction
	)
	host.velocity.x = velocity.x

func air_animation_control(host):
	if host.velocity.y  > 0:
		host.anim_state_machine.travel("Falling")
	else:
		host.anim_state_machine.travel("Rising")
