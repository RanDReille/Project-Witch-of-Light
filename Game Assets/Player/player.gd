extends CharacterBody2D

@export var ground_acceleration := 2000.0
@export var ground_static_friction := 800.0
@export var ground_dynamic_friction := 4.0

@export var air_acceleration := 1000.0
@export var air_static_friction := 400.0
@export var air_dynamic_friction := 3.0
@export var air_vertical_static_friction := 200.0
@export var air_vertical_dynamic_friction := 1.0

@export var ground_submerged_acceleration := 1500.0
@export var ground_submerged_static_friction := 1200.0
@export var ground_submerged_dynamic_friction := 6.0

@export var submerged_acceleration := 1000.0
@export var submerged_static_friction := 600.0
@export var submerged_dynamic_friction := 4.0
@export var submerged_vertical_static_friction := 400.0
@export var submerged_vertical_dynamic_friction := 2.0

@export var knockback_horizontal_velocity = 400.0
@export var knockback_vertical_velocity = 400.0

@export var jump_speed := 350.0
@export var submerged_jump_speed_multiplier := 0.5
@export var max_jump_stamina := 0.25
@export var submerged_jump_stamina := 0.1
@export var coyote_time = 0.05
@export var input_jump_memory_time = 0.1

@export var splash_min_delay = 0.2
@export var splash_check_delay = 0.1
@export var platform_disable_delay = 0.2

@export var projectile_light_speed = 600.0
@export var hurt_time = 0.5
@export var invulnerability_time = 1.0
@export var accuracy = 1.0

@onready var anim_state_machine = $AnimationTree.get("parameters/playback")
@onready var anim_tree = $AnimationTree
@onready var flame = $Flame

var submerged := false
var last_submerged := false
var head_submerged := false
var invulnerability_timer := 0.0
var platform_disable_timer := 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var current_state = null

@onready var body = $body
@onready var fairy_pointer = $Fairy_Pointer
@onready var water_check = $Water_Check
@onready var head_water_check = $Head_Water_Check
@onready var interactible_check = $Interactible_Check

@onready var states_map = {
	'idle': $States/Idle,
	'run': $States/Run,
	'air': $States/Air,
	'swim': $States/Swim,
	'hurt': $States/Hurt,
	'event': $States/Event,
	'dead': $States/Dead
}

#inputs
var input_horizontal : int = 0
var input_up : bool = false
var input_just_up : bool = false
var input_jump : bool = false
var input_just_jump : bool = false
var input_jump_memory : float = 0.0
var input_down : bool = false
var jump_stamina = 0

var nearest_interactible = null

func _ready():
	Global.game.player = self
	anim_tree.active = true
	current_state = states_map['air']
	current_state.enter(self)

func _physics_process(delta):
	get_input()
	input_jump_memory = Global.timer_countdown(input_jump_memory, delta)
	
	last_submerged = submerged
	check_submerged()
	nearest_interactible = check_interactible()
	if nearest_interactible && input_just_up:
		nearest_interactible.interact()
	
	if submerged && !last_submerged && velocity.y >= 0:
		splash_submerge(true)
	elif !submerged && last_submerged && velocity.y <= 0:
		splash_submerge(false)
	
	fairy_pointer.position = Vector2(-16*body.scale.x, -24)
	
	if platform_disable_timer <= delta && platform_disable_timer > 0:
		set_collision_mask_value(3, true)
	platform_disable_timer = Global.timer_countdown(platform_disable_timer, delta)
	
	invulnerability_timer = Global.timer_countdown(invulnerability_timer, delta)
	if invulnerability_timer > 0 && current_state != states_map['dead']:
		body.modulate = Color(1.0, 1.0, 1.0, float(int((20*invulnerability_timer)+1)%2))
		
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		vertical_air_physics(delta)
	
	move_and_slide()
	
	var new_state_name = current_state.physics_update(self, delta)
	if new_state_name:
		change_state(new_state_name)

func get_input():
	input_horizontal = Input.get_axis("action_left", "action_right")
	input_up = Input.is_action_pressed("action_up")
	input_just_up = Input.is_action_just_pressed("action_up")
	input_jump = Input.is_action_pressed("action_jump")
	input_just_jump = Input.is_action_just_pressed("action_jump")
	input_down = Input.is_action_pressed("action_down")

func change_state(new_state_name):
	current_state.exit(self)
	current_state = states_map[new_state_name]
	current_state.enter(self)

func platform_disable():
	set_collision_mask_value(3, false)
	platform_disable_timer = platform_disable_delay

func splash_submerge(enter := false):
	Global.instant_particles("splash", global_position + Vector2(0.0, 24.0))
	if enter:
		Global.play_SFX("water_submerge")
	else:
		Global.play_SFX("water_splash")

func check_submerged():
	submerged = water_check.has_overlapping_bodies()
	head_submerged = head_water_check.has_overlapping_bodies()

func check_interactible():
	if !interactible_check.has_overlapping_areas():
		return null
	var interactibles = interactible_check.get_overlapping_areas()
	var nearest_interactible = null
	var nearest_interactible_distance := 64.0
	for interactible in interactibles:
		var interactible_distance = abs(interactible.global_position.x - global_position.x)
		if nearest_interactible_distance > interactible_distance:
			if nearest_interactible: nearest_interactible.hide_prompt()
			interactible.show_prompt()
			nearest_interactible = interactible
			nearest_interactible_distance = interactible_distance
		else:
			interactible.hide_prompt()
	return nearest_interactible

func _on_interactible_check_area_exited(area):
	area.hide_prompt()

func vertical_air_physics(delta):
	var static_friction
	var dynamic_friction
	if submerged:
		static_friction = submerged_vertical_static_friction
		dynamic_friction = submerged_vertical_dynamic_friction
	else:
		static_friction = air_vertical_static_friction
		dynamic_friction = air_vertical_dynamic_friction
	velocity.y = move_toward(velocity.y, 0, delta*(static_friction+abs(velocity.y)*dynamic_friction))

func take_damage(damage, source_position, ignore_knockback := false):
	var knockback_condition = ignore_knockback || current_state != states_map['hurt']
	if invulnerability_timer <= 0 && knockback_condition && current_state != states_map['dead']:
		if damage > 0:
			Global.game.player_HP -= min(damage, Global.game.player_HP)
			Global.summon_damage_indicator("player", global_position, damage)
			Global.play_SFX("player_hurt")
			change_state('hurt')
			match sign(source_position.x - global_position.x):
				-1.0:
					velocity = Vector2(knockback_horizontal_velocity, -knockback_vertical_velocity)
				0.0:
					velocity = Vector2(0.0, -knockback_vertical_velocity)
				1.0:
					velocity = Vector2(-knockback_horizontal_velocity, -knockback_vertical_velocity)

func show_flame():
	flame.show()

func hide_flame():
	flame.hide()
