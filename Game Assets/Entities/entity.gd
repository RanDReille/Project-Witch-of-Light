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

@export var max_HP : int = 1
@onready var HP : int

@export var gravity_toggle : bool = true
@export var damage_knockback : Vector2 = Vector2(300.0, 300.0)
@export var damage_sound : String
@export var death_particle : String
@export var death_sound : String

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var submerged := false
var last_submerged := false
var head_submerged := false

@onready var flash_animation = $sprite/flash_animation

# Called when the node enters the scene tree for the first time.
func _ready():
	material = Global.ENEMY_FLASH_SHADER.duplicate()
	HP = max_HP

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	water_interaction()
	if not is_on_floor():
		if gravity_toggle: velocity.y += gravity * delta
		vertical_air_physics(delta)
	move_and_slide()

func splash_submerge(enter := false):
	Global.instant_particles("splash", global_position + Vector2(0.0, 24.0))
	if enter:
		Global.play_SFX("water_submerge")
	else:
		Global.play_SFX("water_splash")

func check_submerged():
	submerged = $water_check.has_overlapping_bodies()

func water_interaction():
	last_submerged = submerged
	check_submerged()
	
	if submerged && !last_submerged && velocity.y >= 0:
		splash_submerge(true)
	elif !submerged && last_submerged && velocity.y <= 0:
		splash_submerge(false)

func take_damage(damage, source_position : Vector2):
	if damage > 0:
		#flash_animation.stop()
		#flash_animation.play("Hit Flash")
		Global.summon_damage_indicator("default", global_position, damage)
		HP -= damage
		match sign(source_position.x - global_position.x):
				-1.0:
					velocity = -damage_knockback
					velocity.x *= -1
				0.0:
					velocity = -damage_knockback
					velocity.x = 0
				1.0:
					velocity = -damage_knockback
		if HP <= 0:
			destroy()
		elif damage_sound != "":
			Global.play_SFX(damage_sound)

func destroy():
	Global.instant_particles(death_particle, global_position)
	Global.play_SFX(death_sound)
	queue_free()

func ground_physics(delta):
	var friction: float
	match submerged:
		false:
			friction = ground_static_friction + ground_dynamic_friction*abs(velocity.x)
		true:
			friction = ground_submerged_static_friction + ground_submerged_dynamic_friction*abs(velocity.x)
	velocity.x = move_toward(
		velocity.x,
		0,
		delta*friction
	)

func air_physics(delta):
	var friction: float
	match submerged:
		false:
			friction = air_static_friction + air_dynamic_friction*abs(velocity.x)
		true:
			friction = submerged_static_friction + submerged_dynamic_friction*abs(velocity.x)
	velocity.x = move_toward(
		velocity.x,
		0,
		delta*friction
	)

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

func flying_air_physics(delta):
	var friction: float
	var speed = velocity.length()
	match submerged:
		false:
			friction = air_static_friction + air_dynamic_friction*speed
		true:
			friction = submerged_static_friction + submerged_dynamic_friction*speed
	
	if speed < delta*friction: velocity = Vector2(0.0, 0.0)
	else:
		velocity -= delta*friction*velocity.normalized()
