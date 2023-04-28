extends "res://Game Assets/Stages/Building Blocks/interactibles.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if abs(Global.game.player.global_position.x - global_position.x) < 64 && Global.game.player_HP < Global.game.player_stat["max_HP"]:
		Global.game.player_HP = Global.game.player_stat["max_HP"]
		Global.play_SFX("heal")

func interact():
	$Label/AnimationPlayer.play("no_save")
