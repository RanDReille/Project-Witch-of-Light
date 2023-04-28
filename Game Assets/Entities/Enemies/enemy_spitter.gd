extends "res://Game Assets/Entities/Enemies/enemy.gd"

@export var idle_stop_timer_min = 2.0
@export var idle_stop_timer_max = 3.0
@export var idle_move_timer_min = 2.0
@export var idle_move_timer_max = 3.0
@export var detect_player_distance = 200.0
@export var lose_player_distance = 300.0
@export var chase_player_distance = 80.0
@export var flee_from_player_distance = 64.0
@export var idle_move_acceleration = 650.0
@export var alert_move_acceleration = 800.0
@export var spit_speed = 200.0
@export var spit_delay = 3.0

var to_player : Vector2
var distance_to_player_squared
var spit_timer = 0.0

@onready var anim_state_machine = $AnimationTree.get("parameters/playback")
@onready var sprite = $sprite
@onready var spit_origin = $sprite/spit_origin
@onready var emotion = $Emotion

@onready var states_map = {
	'idle_stop': $States/Idle_Stop,
	'idle_move': $States/Idle_Move,
	'alert': $States/Alert,
	'spit': $States/Spit
}

@onready var raycasts = {
	"down": $Raycasts/Down,
	"up": $Raycasts/Up,
	"left": $Raycasts/Left,
	"right": $Raycasts/Right
}

var current_state = null

func _ready():
	HP = max_HP
	$AnimationTree.active = true
	current_state = states_map['idle_stop']
	current_state.enter(self)
	
	to_player = Global.game.player.global_position - global_position
	distance_to_player_squared = to_player.x*to_player.x + to_player.y*to_player.y

func _physics_process(delta):
	water_interaction()
	#to_player = Global.game.player.global_position - global_position
	#distance_to_player_squared = to_player.x*to_player.x + to_player.y*to_player.y
	spit_timer = Global.timer_countdown(spit_timer, delta)
	
	move_and_slide()
	
	var new_state_name = current_state.physics_update(self, delta)
	if new_state_name:
		change_state(new_state_name)
	

func change_state(new_state_name):
	current_state.exit(self)
	current_state = states_map[new_state_name]
	current_state.enter(self)

func spit_to_player():
	var to_player_angle = atan2(to_player.y, to_player.x)
	Global.shoot("enemy_spit", spit_origin.global_position, spit_speed, to_player_angle + randfn(0, 0.15))
	Global.play_SFX("projectile_enemy_spit")
	spit_timer = spit_delay
