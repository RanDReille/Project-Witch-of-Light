extends Node

@onready var stage = get_node("%Stage")

const INIT_PLAYER_STAT = {
	"fairy_light": false,
	"max_HP": 80,
	"max_mana": 100.0,
	"mana_regen": 40.0,
	"berserk_length": 5.0,
	"berserk_hit_gain": 5
}

const INIT_EVENT_DATA = {
	"Woken up in a cave": false
}

var current_stage : String = ""
var current_stage_node
var current_BGM : String = ""

var player = null
var player_stat = INIT_PLAYER_STAT.duplicate(true)
var player_HP : int = player_stat["max_HP"]
var player_mana := 0.0
var player_berserk := 0
var player_berserk_timer := 0.0
var projectile_light_fire_delay := 0.2
var projectile_light_fire_berserk_delay := 0.05
var projectile_light_fire_timer := 0.0
var projectile_light_fire_cost := 20.0

@onready var stage_transition = $Stage_Transition_Player
var transition_stage_name : String = ""
var transition_start_pos : int = 0
var transition_offset_pos : Vector2 = Vector2(0, 0)
var transition_velocity : Vector2 = Vector2(0, 0)
var transition_jump_stamina : float = 0.0

var event_data = INIT_EVENT_DATA.duplicate(true)

var savepoint_player_stat = INIT_PLAYER_STAT.duplicate(true)
var savepoint_event_data = INIT_EVENT_DATA.duplicate(true)
var savepoint_player_HP : int = player_HP
var savepoint_loc : String = "w0"

var berserk_flame := false

var tutorial_movement := false
var tutorial_movement_timer := 15.0
var tutorial_attack := false
var tutorial_drop_down := false

@onready var UI = {
	"Bar_Frame_Tint": $UI_Canvas/UI/Bar_Frame_HPMP/AnimationPlayer,
	"Bar_HP": $UI_Canvas/UI/Bar_Frame_HPMP/Bar_HP,
	"Text_HP": $UI_Canvas/UI/Bar_Frame_HPMP/Text_HP,
	"Bar_MP": $UI_Canvas/UI/Bar_Frame_HPMP/Bar_MP,
	"Bar_Berserk": $UI_Canvas/UI/Bar_Frame_HPMP/Bar_Berserk,
	"Prompt_Berserk": $UI_Canvas/UI/Bar_Frame_HPMP/Berserk_Prompt,
	"World_Map": $UI_Canvas/UI/Pause_Menu/World_Map,
	"Game_Over": $UI_Canvas/UI/Game_Over
}

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.game = self
	set_stage("main_menu")

func _physics_process(delta):
	update_UI()
	projectile_light_fire_timer = Global.timer_countdown(projectile_light_fire_timer, delta)
	if player_stat["fairy_light"]:
		player_mana = clamp(player_mana + player_stat["mana_regen"]*delta, 0.0, player_stat["max_mana"])
	
	if player_berserk >= 100 && player_berserk_timer <= 0 && Input.is_action_just_pressed("action_berserk"):
		UI["Prompt_Berserk"].hide()
		Global.play_SFX("berserk_activate")
		player_berserk_timer = player_stat["berserk_length"]
		player_berserk = 0
		player.show_flame()
	
	player_berserk_timer = Global.timer_countdown(player_berserk_timer, delta)

func set_stage(stage_name):
	var child_count = stage.get_child_count()
	if child_count > 0:
		var children = stage.get_children()
		for child in children:
			child.queue_free()
	var new_stage = Global.STAGES[stage_name].instantiate()
	stage.add_child(new_stage)
	current_stage_node = new_stage
	
	current_stage = stage_name
#	print_debug(stage_name.left(1))
	if stage_name.left(1) == "w":
		$UI_Canvas/UI.show()
		play_BGM(new_stage.BGM)
		if UI["World_Map"].map_exploration_data.has(stage_name): UI["World_Map"].map_exploration_data[stage_name] = true
	else:
		$UI_Canvas/UI.hide()
		$UI_Canvas/UI/Pause_Menu.hide()
		player = null
		if stage_name == "main_menu":
			play_BGM("Light at the End of the Tunnel")

func set_stage_transition():
	set_stage(transition_stage_name)

func play_BGM(BGM_name):
	if BGM_name != current_BGM && Global.BGM.has(BGM_name):
		current_BGM = BGM_name
		$BGM_Player.stream = Global.BGM[BGM_name]
		$BGM_Player.play()
	elif BGM_name == "stop":
		current_BGM = ""
		$BGM_Player.stop()

func update_UI():
	UI["Bar_HP"].value = 80*player_HP/player_stat["max_HP"]
	UI["Text_HP"].text = str(player_HP)
	UI["Bar_MP"].value = 80*int(floor(player_mana))/int(player_stat["max_mana"])
	if player_berserk_timer <= 0:
		UI["Bar_Berserk"].value = player_berserk
		if player_berserk >= 100 && !berserk_flame:
			UI["Bar_Berserk"].material.set("shader_parameter/flame_active", true)
			UI["Prompt_Berserk"].show()
			berserk_flame = true
			UI["Bar_Frame_Tint"].play("White_Tint")
			Global.play_SFX("berserk_full_charge")
		elif player_berserk < 100 && berserk_flame:
			UI["Bar_Berserk"].material.set("shader_parameter/flame_active", false)
			UI["Prompt_Berserk"].hide()
			berserk_flame = false
			player.hide_flame()
	else:
		UI["Bar_Berserk"].value = int(100*player_berserk_timer/player_stat["berserk_length"])

func reset_progress():
	player_stat = INIT_PLAYER_STAT.duplicate(true)
	event_data = INIT_EVENT_DATA.duplicate(true)
	UI["World_Map"].reset_exploration_data()
	
	transition_stage_name = ""
	transition_start_pos = 0
	transition_offset_pos = Vector2(0, 0)
	transition_velocity = Vector2(0, 0)
	transition_jump_stamina = 0.0

func load_from_savepoint():
	player_stat = savepoint_player_stat.duplicate(true)
	event_data = savepoint_event_data.duplicate(true)
	player_HP = savepoint_player_HP
	UI["World_Map"].load_exploration_data()
	
	transition_stage_name = savepoint_loc
	transition_start_pos = 0
	transition_offset_pos = Vector2(0, 0)
	transition_velocity = Vector2(0, 0)
	transition_jump_stamina = 0.0
	
	stage_transition.play("Transition")

func _on_return_menu_pressed():
	UI["Game_Over"].hide()
	set_stage("main_menu")

func _on_retry_pressed():
	UI["Game_Over"].hide()
	load_from_savepoint()
