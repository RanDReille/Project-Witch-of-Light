@tool
extends GPUParticles2D

func _physics_process(delta):
	if Engine.is_editor_hint():
		$Timer.wait_time = lifetime

func _on_timer_timeout():
	queue_free()
