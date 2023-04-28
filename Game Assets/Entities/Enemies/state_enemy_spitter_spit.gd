extends State

var spit_event_delay = 1.0
var spit_event_timer = 0.0

func enter(host):
	host.anim_state_machine.travel("Spit")
	spit_event_timer = spit_event_delay

#called upon exiting the state
func exit(host):
	return

#parallel to _process
func update(host, delta):
	return

#parallel to _physics_update
func physics_update(host, delta):
	spit_event_timer = Global.timer_countdown(spit_event_timer, delta)
	
	host.flying_air_physics(delta)
	
	if spit_event_timer <= 0:
		return 'alert'

func handle_input(host, event):
	return

