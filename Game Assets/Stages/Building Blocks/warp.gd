@tool
extends Node2D

@export var extents : Vector2 = Vector2(16, 48)
@export var world_target : String = ""
@export var start_pos_target : int = -1

var player_height: float = 48
var warp_area: Rect2
var warp_area_color = Color(1.0, 0.0, 0.0, 0.5)
var warp_origin_radius: float = 2.0
var warp_origin_color = Color(1.0, 1.0, 0.0, 0.5)

var triggered = false


# Called when the node enters the scene tree for the first time.
func _ready():
	set_warp_area_rect()
	if !Engine.is_editor_hint():
		$Label.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !Engine.is_editor_hint():
		if Global.game.player != null:
			if warp_area.has_point(Global.game.player.global_position - global_position):
				#print_debug(str(warp_area))
				warp()
	else:
		queue_redraw()
		$Label.text = "To: " + world_target + "\nStart: " + str(start_pos_target)

func _draw():
	if Engine.is_editor_hint():
		set_warp_area_rect()
		draw_rect(warp_area, warp_area_color)
		draw_circle(Vector2.ZERO, warp_origin_radius, warp_origin_color)

func set_warp_area_rect():
	warp_area = Rect2(-extents.x, -max((2*extents.y-0.5*player_height), extents.y), 2*extents.x, 2*extents.y)	

func warp():
	if !Engine.is_editor_hint():
		Global.game.transition_stage_name = world_target
		Global.game.transition_start_pos = start_pos_target
		Global.game.stage_transition.play("Transition")
		adjust_warp_offset()

func warp_simple():
	if !triggered:
		Global.game.transition_stage_name = world_target
		Global.game.transition_start_pos = start_pos_target
		adjust_warp_offset()
		Global.game.set_stage(world_target)
		triggered = true

func adjust_warp_offset():
	var multipliery = float(extents.y > 0.5*player_height)
	Global.game.transition_offset_pos = Global.game.player.global_position - global_position
	Global.game.transition_offset_pos.x *= 1-multipliery
	Global.game.transition_offset_pos.y *= multipliery
	Global.game.transition_velocity = Global.game.player.velocity
	Global.game.transition_jump_stamina = Global.game.player.jump_stamina
