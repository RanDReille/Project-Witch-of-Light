extends AnimationPlayer

@export var event_name : String = ""
@export var save_event : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if event_name == "" || !Global.game.event_data.has(event_name) || (Global.game.event_data[event_name]):
		queue_free()
	else:
		Global.game.player.change_state('event')
		play(event_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_animation_finished(anim_name):
	Global.game.event_data[event_name] = true
	if save_event: Global.game.savepoint_event_data = Global.game.event_data.duplicate()
	Global.game.player.change_state('air')

func play_BGM(BGM_name : String):
	Global.game.play_BGM(BGM_name)
