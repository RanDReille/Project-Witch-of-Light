extends ColorRect

@onready var default = $Default
@onready var map = $World_Map
@onready var goto_menu = $Goto_Menu_Confirm

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel") && Global.game.current_stage.left(1) == "w":
		pause_menu_toggle()

func pause_menu_toggle():
	if !get_tree().paused:
		get_tree().paused = true
		default.show()
		map.hide()
		goto_menu.hide()
		show()
	else:
		get_tree().paused = false
		hide()

func _on_pause_button_pressed():
	pause_menu_toggle()

func _on_button_resume_pressed():
	get_tree().paused = false
	hide()

func _on_button_map_pressed():
	default.hide()
	map.show()
	goto_menu.hide()
	
func _on_button_return_map_pressed():
	default.show()
	map.hide()
	goto_menu.hide()

func _on_button_menu_pressed():
	default.hide()
	map.hide()
	goto_menu.show()

func _on_button_menu_no_pressed():
	default.show()
	map.hide()
	goto_menu.hide()

func _on_button_menu_yes_pressed():
	get_tree().paused = false
	hide()
	Global.game.set_stage("main_menu")
