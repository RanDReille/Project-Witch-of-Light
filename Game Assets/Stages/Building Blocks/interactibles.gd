extends Area2D

@onready var prompt = $prompt

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_prompt()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass

func show_prompt():
	prompt.show()

func hide_prompt():
	prompt.hide()

func interact():
	pass
