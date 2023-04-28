extends Node
class_name State

#called upon entering the state
func enter(host):
	return

#called upon exiting the state
func exit(host):
	return

#parallel to _process
func update(host, delta):
	return

#parallel to _physics_update
func physics_update(host, delta):
	return

func handle_input(host, event):
	return
