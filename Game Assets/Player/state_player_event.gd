extends State


# Called when the node enters the scene tree for the first time.
func enter(host):
	host.anim_tree.active = false

func physics_update(host, delta):
	pass

func exit(host):
	host.anim_tree.active = true
