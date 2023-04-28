extends Node

const SCREEN_WIDTH = 640
const SCREEN_HEIGHT = 360

const STAGES = {
	"main_menu": preload("res://Game Assets/Stages/main_menu.tscn"),
	"w0": preload("res://Game Assets/Stages/Worlds/world_0.tscn"),
	"w1": preload("res://Game Assets/Stages/Worlds/world_1.tscn"),
	"w2": preload("res://Game Assets/Stages/Worlds/world_2.tscn"),
	"w3": preload("res://Game Assets/Stages/Worlds/world_3.tscn"),
	"w4": preload("res://Game Assets/Stages/Worlds/world_4.tscn"),
	"w5": preload("res://Game Assets/Stages/Worlds/world_5.tscn"),
	"w6": preload("res://Game Assets/Stages/Worlds/world_6.tscn"),
	"w7": preload("res://Game Assets/Stages/Worlds/world_7.tscn")
}

const SFX = {
	"jump": preload("res://Game Assets/SFX/Jump.wav"),
	"player_hurt": preload("res://Game Assets/SFX/Player_Hurt.wav"),
	"berserk_full_charge": preload("res://Game Assets/SFX/Berserk_Full_Charge.wav"),
	"berserk_activate": preload("res://Game Assets/SFX/Berserk_Activate.wav"),
	"enemy_hurt": preload("res://Game Assets/SFX/Enemy_Hurt.wav"),
	"enemy_slime_hurt": preload("res://Game Assets/SFX/Enemy_Slime_Hurt.wav"),
	"enemy_death": preload("res://Game Assets/SFX/Enemy_Death.wav"),
	"enemy_slime_death": preload("res://Game Assets/SFX/Enemy_Slime_Death.wav"),
	"water_splash": preload("res://Game Assets/SFX/Water_Splash.wav"),
	"water_submerge": preload("res://Game Assets/SFX/Water_Submerge.wav"),
	"heal": preload("res://Game Assets/SFX/Heal.wav"),
	"fairy_get": preload("res://Game Assets/SFX/Fairy_Get.wav"),
	"projectile_player_light_hit": preload("res://Game Assets/SFX/Projectile_Player_Light_Hit.wav"),
	"projectile_player_light_shoot": preload("res://Game Assets/SFX/Projectile_Player_Light_Shoot.wav"),
	"projectile_enemy_spit": preload("res://Game Assets/SFX/Projectile_Enemy_Spit.wav"),
	"emotion_surprised": preload("res://Game Assets/SFX/Emotion_Surprised.wav"),
	"emotion_confused": preload("res://Game Assets/SFX/Emotion_Confused.wav"),
}

const BGM = {
	"Light at the End of the Tunnel": preload("res://Game Assets/BGM/Light at the End of the Tunnel.mp3"),
	"Hopeless Darkness": preload("res://Game Assets/BGM/Hopeless Darkness.mp3")
}

const INSTANT_PARTICLES = {
	"splash": preload("res://Game Assets/GPUParticles/splash.tscn"),
	"projectile_light_player_explosion": preload("res://Game Assets/GPUParticles/projectile_player_light_explosion.tscn"),
	"enemy_dark_slime_death": preload("res://Game Assets/GPUParticles/enemy_dark_slime_death.tscn")
}

const PROJECTILES = {
	"player_light": preload("res://Game Assets/Projectiles/projectile_player_light.tscn"),
	"enemy_spit": preload("res://Game Assets/Projectiles/projectile_enemy_spit.tscn")
}

const DAMAGE_INDICATOR = {
	"default": preload("res://Game Assets/UI/damage_indicator.tscn"),
	"player": preload("res://Game Assets/UI/damage_indicator_player.tscn")
}

@onready var SFX_Player = preload("res://Game Assets/SFX/sfx_player.tscn")

const ENEMY_FLASH_SHADER = preload("res://Game Assets/Entities/entity_flash_shader.tres")

var game = null

var start_pos = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass

func timer_countdown(value : float, delta):
	if value > delta:
		return value - delta
	else:
		return 0

func play_SFX(SFX_name : String):
	if SFX.has(SFX_name):
		var new_SFX_Player = SFX_Player.instantiate()
		game.add_child(new_SFX_Player)
		new_SFX_Player.stream = SFX[SFX_name]
		new_SFX_Player.play()

func instant_particles(particle_name : String, location : Vector2):
	if INSTANT_PARTICLES.has(particle_name):
		var new_particle = INSTANT_PARTICLES[particle_name].instantiate()
		game.current_stage_node.add_child(new_particle)
		new_particle.global_position = location

func summon_damage_indicator(type : String, location, value):
	if !DAMAGE_INDICATOR.has(type): type = "default"
	var new_damage_indicator = DAMAGE_INDICATOR[type].instantiate()
	game.current_stage_node.add_child(new_damage_indicator)
	new_damage_indicator.global_position = location
	new_damage_indicator.set_value(value)

func shoot(projectile_name, location, speed, angle, custom_damage = -1):
	if PROJECTILES.has(projectile_name):
		var new_projectile = PROJECTILES[projectile_name].instantiate()
		game.current_stage_node.add_child(new_projectile)
		new_projectile.global_position = location
		new_projectile.velocity = Vector2(speed*cos(angle), speed*sin(angle))
		if custom_damage != -1: new_projectile.damage = custom_damage
