extends State

var hurt_timer

func enter(host):
	host.anim_state_machine.travel("Hurt")
	hurt_timer = host.hurt_time

func physics_update(host, delta):
	air_physics(host, delta)
	hurt_timer = Global.timer_countdown(hurt_timer, delta)
	if hurt_timer <= 0:
		if Global.game.player_HP > 0:
			return 'idle'
		else:
			return 'dead'

func exit(host):
	host.invulnerability_timer = host.invulnerability_time

func air_physics(host, delta):
	var velocity = host.velocity
	var friction: float
	match host.submerged:
		false:
			friction = host.air_static_friction + host.air_dynamic_friction*abs(velocity.x)
		true:
			friction = host.submerged_static_friction + host.submerged_dynamic_friction*abs(velocity.x)
	velocity.x = move_toward(
		velocity.x,
		0,
		delta*friction
	)
	host.velocity.x = velocity.x
