extends State


# Called when the node enters the scene tree for the first time.
func enter(host):
	host.anim_state_machine.travel("Idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(host, delta):
	host.air_physics(delta)
	if host.is_on_floor():
		return 'idle'
