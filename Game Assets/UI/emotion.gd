extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_anim(name: String):
	$anim.play(name)

func play_SFX(SFX_name: String):
	Global.play_SFX("emotion_" + SFX_name)
