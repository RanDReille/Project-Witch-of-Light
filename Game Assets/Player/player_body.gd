@tool
extends CanvasGroup

#@export var sync_children_frames : bool = true
@export var sync_sprite_frames : Array[bool] = [true, true, true, true, true]
@export var hframes : int = 1
@export var vframes : int = 1
@export var frame : int = 0
@export var frame_coords : Vector2i = Vector2i(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var children = get_children()
	var counter = 0
	for child in children:
		if child is Sprite2D && sync_sprite_frames[counter]:
			sync_frames(child)
		counter += 1

func sync_frames(sprite_node: Sprite2D):
	if Engine.is_editor_hint():
		sprite_node.hframes = hframes
		sprite_node.vframes = vframes
		sprite_node.frame_coords = frame_coords
	sprite_node.frame = frame
	
