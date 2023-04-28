extends "res://Game Assets/Entities/Enemies/enemy.gd"

var move_time_min = 1.5
var move_time_max = 3.0
var idle_time_min = 1.5
var idle_time_max = 3.0

@onready var anim_state_machine = $AnimationTree.get("parameters/playback")
@onready var wall_detectors = {
	'left': $Wall_Detector/Left_Detector,
	'right': $Wall_Detector/Right_Detector
}
@onready var floor_detectors = {
	'left': $Floor_Detector/Left_Detector,
	'right': $Floor_Detector/Right_Detector
}

@onready var states_map = {
	'idle': $States/Idle,
	'air': $States/Air,
	'move': $States/Move
}

var current_state = null

var move_dir = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	HP = max_HP
	$AnimationTree.active = true
	current_state = states_map['air']
	current_state.enter(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	water_interaction()
	if not is_on_floor():
		if gravity_toggle: velocity.y += gravity * delta
		vertical_air_physics(delta)
	move_and_slide()
	
	var new_state_name = current_state.physics_update(self, delta)
	if new_state_name:
		change_state(new_state_name)

func change_state(new_state_name):
	current_state.exit(self)
	current_state = states_map[new_state_name]
	current_state.enter(self)


