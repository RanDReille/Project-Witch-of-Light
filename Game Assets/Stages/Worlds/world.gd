@tool
extends Node2D

@export var world_length : int = 1
@export var world_height : int = 1

@export var BGM : String = ""

@onready var player_camera = $Player/Camera_Dragger/Player_Camera
@onready var player = $Player
@onready var fairy = $Fairy

func _ready():
	if !Engine.is_editor_hint():
		var current_start_pos = $Start_Pos.get_child(Global.game.transition_start_pos)
		player.global_position = current_start_pos.global_position + Global.game.transition_offset_pos
		player.body.scale.x = current_start_pos.scale.x
		player.fairy_pointer.position = Vector2(-16*player.body.scale.x, -24)
		player.velocity = Global.game.transition_velocity
		player.jump_stamina = Global.game.transition_jump_stamina
		
		fairy.global_position = player.fairy_pointer.global_position
		if !Global.game.player_stat["fairy_light"]:
			fairy.hide()

func _physics_process(delta):
	if Engine.is_editor_hint():
		player_camera.limit_right = world_length*Global.SCREEN_WIDTH
		player_camera.limit_bottom = world_height*Global.SCREEN_HEIGHT
	move_fairy(delta)
	
	if !Engine.is_editor_hint():
		if Global.game.player_stat["fairy_light"] && Input.is_action_pressed("action_shoot") && Global.game.projectile_light_fire_timer <= 0 && Global.game.player_HP > 0 && Global.game.player.current_state != Global.game.player.states_map['event'] && (Global.game.player_mana >= Global.game.projectile_light_fire_cost || Global.game.player_berserk_timer > 0):
			fairy_shoot_at_mouse()
			if Global.game.player_berserk_timer > 0:
				Global.game.projectile_light_fire_timer = Global.game.projectile_light_fire_berserk_delay
			else:
				Global.game.player_mana -= Global.game.projectile_light_fire_cost
				Global.game.projectile_light_fire_timer = Global.game.projectile_light_fire_delay

func move_fairy(delta):
	if !Engine.is_editor_hint():
		fairy.target = player.fairy_pointer.global_position

func fairy_shoot_at_mouse():
	if !Global.game.tutorial_attack:
		Global.game.tutorial_attack = true
	var mouse_pos : Vector2 = get_global_mouse_position()
	var relative_mouse_pos : Vector2 = mouse_pos - fairy.global_position
	Global.shoot("player_light", fairy.global_position, Global.game.player.projectile_light_speed, atan2(relative_mouse_pos.y, relative_mouse_pos.x) + randfn(0.0, 0.1/player.accuracy))
	Global.play_SFX("projectile_player_light_shoot")

func show_fairy():
	fairy.show()
