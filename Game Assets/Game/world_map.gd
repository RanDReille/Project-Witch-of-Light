@tool
extends Control

@export var offset : Vector2 = Vector2(100.0, 280.0)
@export var room_size : Vector2 = Vector2(20.0, 15.0)
@export var door_size : Vector2 = Vector2(6.0, 5.0)
@export var margin : Vector2 = Vector2(1.0, 1.0)
@export var outline_color : Color = Color(1.0, 1.0, 1.0, 0.6)
@export var default_room_color : Color = Color(0.0, 0.5, 1.0, 0.6)
@export var save_room_color : Color = Color(1.0, 0.0, 0.0, 0.6)
@export var warp_room_color : Color = Color(0.0, 1.0, 0.0, 0.6)
@export var current_room_color : Color = Color (1.0, 1.0, 0.0, 0.6)

enum {
	default,
	save,
	teleporter
}

const MAP_DATA = {
	"w0": {
		"position": Vector2i(0, 0),
		"size": Vector2(1, 1),
		"type": default,
		"doors_top": [false],
		"doors_bottom": [false],
		"doors_left": [true],
		"doors_right": [true]
	},
	"w1": {
		"position": Vector2i(1, 0),
		"size": Vector2i(2, 1),
		"type": default,
		"doors_top": [false, false],
		"doors_bottom": [false, false],
		"doors_left": [true],
		"doors_right": [true]
	},
	"w2": {
		"position": Vector2i(3, -1),
		"size": Vector2i(2, 2),
		"type": default,
		"doors_top": [false, false],
		"doors_bottom": [false, false],
		"doors_left": [false, true],
		"doors_right": [true, true]
	},
	"w3": {
		"position": Vector2i(5, 0),
		"size": Vector2i(1, 1),
		"type": default,
		"doors_top": [false],
		"doors_bottom": [false],
		"doors_left": [true],
		"doors_right": [false]
	},
	"w4": {
		"position": Vector2i(5, -1),
		"size": Vector2i(2, 1),
		"type": default,
		"doors_top": [false, false],
		"doors_bottom": [false, false],
		"doors_left": [true],
		"doors_right": [true]
	},
	"w5": {
		"position": Vector2i(7, -1),
		"size": Vector2i(1, 2),
		"type": default,
		"doors_top": [false],
		"doors_bottom": [false],
		"doors_left": [true, true],
		"doors_right": [false, true]
	},
	"w6": {
		"position": Vector2i(6, 0),
		"size": Vector2i(1, 1),
		"type": save,
		"doors_top": [false],
		"doors_bottom": [false],
		"doors_left": [false],
		"doors_right": [true]
	},
}

const INIT_MAP_EXPLORATION_DATA = {
	"w0": true,
	"w1": false,
	"w2": false,
	"w3": false,
	"w4": false,
	"w5": false,
	"w6": false,
}

var map_exploration_data = INIT_MAP_EXPLORATION_DATA.duplicate(true)

var savepoint_exploration_data = INIT_MAP_EXPLORATION_DATA.duplicate(true)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	queue_redraw()

func _draw():
	for key in map_exploration_data:
		if map_exploration_data[key] || Engine.is_editor_hint():
			draw_room(key)

func draw_room(key):
	var room_data = MAP_DATA[key]
	var rect_out = Rect2(Vector2(room_data["position"])*room_size + offset, Vector2(room_data["size"])*room_size)
	var rect_in = Rect2(Vector2(room_data["position"])*room_size + offset + margin, Vector2(room_data["size"])*room_size - 2.0*margin)
	draw_rect(rect_out, outline_color)
	if !Engine.is_editor_hint() && Global.game.current_stage == key:
		draw_rect(rect_in, current_room_color)
	else:
		var room_color = [default_room_color, save_room_color, warp_room_color]
		draw_rect(rect_in, room_color[MAP_DATA[key]["type"]])
	
	var rect_door : Rect2
	var door_relative_pos : Vector2
	
	for i in range(room_data["size"].x):
		if room_data["doors_top"][i]:
			door_relative_pos = Vector2(0.5 + float(i), 0.0) * room_size - Vector2(0.5*door_size.x, 0.0)
			rect_door = Rect2(
				Vector2(room_data["position"])*room_size + offset + door_relative_pos,
				Vector2(door_size.x, 1.0))
			draw_rect(rect_door, default_room_color)
			
		if room_data["doors_bottom"][i]:
			door_relative_pos = Vector2(0.5 + float(i), float(room_data["size"].y)) * room_size - Vector2(0.5*door_size.x, 1.0)
			rect_door = Rect2(
				Vector2(room_data["position"])*room_size + offset + door_relative_pos,
				Vector2(door_size.x, 1.0))
			draw_rect(rect_door, default_room_color)
		
	
	for i in range(room_data["size"].y):
		if room_data["doors_left"][i]:
			door_relative_pos = Vector2(0.0, 0.5 + float(i)) * room_size - Vector2(0.0, 0.5*door_size.y)
			rect_door = Rect2(
				Vector2(room_data["position"])*room_size + offset + door_relative_pos,
				Vector2(1.0, door_size.y))
			draw_rect(rect_door, default_room_color)
		
		if room_data["doors_right"][i]:
			door_relative_pos = Vector2(float(room_data["size"].x), 0.5 + float(i)) * room_size - Vector2(1.0, 0.5*door_size.y)
			rect_door = Rect2(
				Vector2(room_data["position"])*room_size + offset + door_relative_pos,
				Vector2(1.0, door_size.y))
			draw_rect(rect_door, default_room_color)
		
func reset_exploration_data():
	map_exploration_data = INIT_MAP_EXPLORATION_DATA.duplicate()

func save_exploration_data():
	if !Engine.is_editor_hint():
		savepoint_exploration_data = map_exploration_data.duplicate()

func load_exploration_data():
	if !Engine.is_editor_hint():
		map_exploration_data = savepoint_exploration_data.duplicate()
