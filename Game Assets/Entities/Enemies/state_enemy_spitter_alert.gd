extends State

var alert_move_acceleration = 750.0

var to_player_dir : Vector2
var alert_max_speed

func enter(host):
	host.anim_state_machine.travel("Idle")
	to_player_dir = host.to_player.normalized()
	alert_max_speed = (host.alert_move_acceleration - host.air_static_friction) / host.air_dynamic_friction
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
	if host.distance_to_player_squared > host.lose_player_distance*host.lose_player_distance:
		host.emotion.play_anim("Confused")
		return 'idle_stop'
	
	to_player_dir = host.to_player.normalized()
	if host.to_player.length() > host.chase_player_distance:
		accelerate_toward_player(host, delta)
	else:
		if host.spit_timer <= 0.0:
			return 'spit'
		if host.to_player.length() < host.flee_from_player_distance:
			accelerate_away_from_player(host, delta)
	
	host.flying_air_physics(delta)
	
	if to_player_dir.x != 0.0: host.sprite.scale.x = -sign(to_player_dir.x)
	
	return

func handle_input(host, event):
	return

func accelerate_toward_player(host, delta):
	var accel_dir = (alert_max_speed*to_player_dir - host.velocity).normalized()
	host.velocity += delta*host.alert_move_acceleration*accel_dir

func accelerate_away_from_player(host, delta):
	var accel_dir = (-alert_max_speed*to_player_dir - host.velocity).normalized()
	host.velocity += delta*host.alert_move_acceleration*accel_dir
