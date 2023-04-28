extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_start_pressed():
	Global.game.reset_progress()
	Global.game.transition_stage_name = "w0"
	Global.game.transition_start_pos = 0
	Global.game.stage_transition.play("Transition")
