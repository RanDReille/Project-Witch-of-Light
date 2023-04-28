@tool
extends Marker2D

var circle_color = Color(1.0, 0.0, 1.0, 0.5)
var circle_radius = 8.0
var arrow_color = Color(1.0, 1.0, 0.0, 0.5)

func _ready():
	pass

func _physics_process(delta):
	queue_redraw()

func _draw():
	if Engine.is_editor_hint():
		draw_circle(Vector2.ZERO, circle_radius, circle_color)
		draw_line(Vector2.ZERO, Vector2(circle_radius, 0), arrow_color, 1.5)
		draw_line(Vector2(0.5*circle_radius, 0.5*circle_radius), Vector2(circle_radius, 0), arrow_color, 1.5)
		draw_line(Vector2(0.5*circle_radius, -0.5*circle_radius), Vector2(circle_radius, 0), arrow_color, 1.5)
