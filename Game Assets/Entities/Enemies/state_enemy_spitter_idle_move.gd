extends State

var idle_move_timer
var direction
var dir_vector

func enter(host):
	host.anim_state_machine.travel("Idle")
	direction = randf_range(-PI, PI)
	dir_vector = Vector2(cos(direction), sin(direction))
	if cos(direction) != 0.0: host.sprite.scale.x = -sign(cos(direction))
	idle_move_timer = randf_range(host.idle_move_timer_min, host.idle_move_timer_max)
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
	
	accelerate(host, delta)
	host.flying_air_physics(delta)
	
	if host.raycasts["down"].is_colliding() && dir_vector.y > 0:
		dir_vector.y *= -1
	elif host.raycasts["up"].is_colliding() && dir_vector.y < 0:
		dir_vector.y *= -1
	if host.raycasts["left"].is_colliding() && dir_vector.x < 0:
		dir_vector.x *= -1
		host.sprite.scale.x *= -1
	elif host.raycasts["right"].is_colliding() && dir_vector.x > 0:
		dir_vector.x *= -1
		host.sprite.scale.x *= -1
	
	idle_move_timer = Global.timer_countdown(idle_move_timer, delta)
	if idle_move_timer <= 0:
		return 'idle_stop'
	return

func handle_input(host, event):
	return

func accelerate(host, delta):
	host.velocity += delta*host.idle_move_acceleration*dir_vector
