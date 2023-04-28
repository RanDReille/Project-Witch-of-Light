extends Area2D

@export_range(0, 100000) var damage : int
@export var process_margin : Vector2 = Vector2(64, 64)
@export var rotate_with_direction : bool = false
@export var collision_bit_mask : int = 2
@export var bounce : int = 0
@export var impact_particle : String
@export var impact_sound : String
var velocity : Vector2
var projectile_process_rect : Rect2
@onready var sprite = $sprite
@export var toggle_gravity = false

var custom_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.game.current_stage.left(1) != "w":
		queue_free()
	var stage = Global.game.current_stage_node
	var stage_size : Vector2 = Vector2(stage.world_length*Global.SCREEN_WIDTH, stage.world_height*Global.SCREEN_HEIGHT)
	projectile_process_rect = Rect2(-process_margin, stage_size + 2*process_margin)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if toggle_gravity: velocity.y += custom_gravity
	global_position += delta*velocity
	if rotate_with_direction:
		sprite.rotation = atan2(velocity.y, velocity.x)
	if !projectile_process_rect.has_point(global_position):
		queue_free()

func set_collision_bit_mask(bit):
	var counter = 1
	var current_bit_value = bit
	while current_bit_value > 0 && counter < 100:
		if current_bit_value % 2 == 1:
			current_bit_value -= 1
			set_collision_mask_value(counter, true)
		else:
			set_collision_mask_value(counter, false)
		counter += 1

func _on_body_entered(body):
	if impact_particle != "":
		Global.instant_particles(impact_particle, global_position)
	var interaction
	interaction = interact_with_body(body)
	if !interaction && impact_sound != "":
		Global.play_SFX(impact_sound)
	queue_free()

func interact_with_body(body):
	if body.is_in_group("Player"):
		body.take_damage(damage, global_position)
		return true
	return false
