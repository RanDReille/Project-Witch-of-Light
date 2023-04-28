extends Node2D

var velocity : Vector2
@export var init_speed_mean : float = 6.0
@export var lifetime : float = 2.0;
var timer = lifetime

var gravity = 0.01*ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	var init_speed = randfn(init_speed_mean, 1.0)
	var init_angle = randfn(-PI/2, 0.4)
	velocity = Vector2(init_speed*cos(init_angle), init_speed*sin(init_angle))

func _physics_process(delta):
	velocity.y += delta*gravity
	global_position += velocity
	timer = Global.timer_countdown(timer, delta)
	if timer < 1:
		modulate.a = timer
	if timer < 0:
		queue_free()

func set_value(value : int):
	$Text.text = str(value)
