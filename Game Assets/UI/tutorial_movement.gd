extends Sprite2D

var activated := false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Global.game.tutorial_movement:
		queue_free()
	Global.game.tutorial_movement_timer = Global.timer_countdown(Global.game.tutorial_movement_timer, delta)
	if Global.game.tutorial_movement_timer <= 0 && !activated:
		activated = true
		$AnimationPlayer.play("tutorial_movement")
