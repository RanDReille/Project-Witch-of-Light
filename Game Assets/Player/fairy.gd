extends CharacterBody2D

@export var target : Vector2
@export var acceleration : float = 1600.0
@export var static_friction : float = 800.0
@export var dynamic_friction : float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	accelerate_toward(delta, target, acceleration)
	friction(delta, static_friction + dynamic_friction*velocity.length())
	move_and_slide()

func accelerate(delta : float, vector : Vector2):
	velocity += delta*vector

func accelerate_toward(delta : float, destination : Vector2, strength : float):
	accelerate(delta, strength*(destination-global_position).normalized())

func friction(delta, strength):
	if velocity.length() > delta*strength:
		accelerate(delta, -strength*velocity.normalized())
	else:
		velocity = Vector2(0,0)
