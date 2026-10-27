extends Node2D

enum State { TITLE, PLAYING, CAUGHT }

@export var catch_distance: float = 36.0

var state: State = State.TITLE
var player_start: Vector2
var rival_start: Vector2
var time_alive: float = 0.0
var best_time: float = 0.0

@onready var player: CharacterBody2D = $Player
@onready var rival: CharacterBody2D = $Rival
@onready var banner: Label = $UI/Banner
@onready var hud: MarginContainer = $UI/HUD
@onready var pause_menu: ColorRect = $UI/PauseMenu

	

func _ready() -> void:
	player_start = player.position
	rival_start = rival.position
	_change_state(State.TITLE)

func _physics_process(_delta: float) -> void:
	match state:
		State.TITLE:
			rival.calm()
			hud.show_time(time_alive)     # new
			time_alive = 0.0              # new
			hud.show_best(best_time) 
			if Input.is_action_just_pressed("ui_accept"):
				_change_state(State.PLAYING)
		State.PLAYING:
			time_alive += _delta           # new
			hud.show_time(time_alive)     # new
			if player.global_position.distance_to(rival.global_position) < catch_distance:
				_change_state(State.CAUGHT)
		State.CAUGHT:
			if time_alive > best_time:    # new
				best_time = time_alive    # new
				hud.show_best(best_time) 
			if Input.is_action_just_pressed("ui_accept"):
				_change_state(State.TITLE)

func _change_state(new_state: State) -> void:
	state = new_state
	var running := new_state == State.PLAYING
	player.set_physics_process(true)
	rival.set_physics_process(true)
	pause_menu.allowed = true
	match new_state:
		State.TITLE:
			player.position = player_start
			rival.position = rival_start
			rival.calm()
			banner.text = "RIVAL BRAINS\nPress Space to play"
			banner.visible = true
		State.PLAYING:
			banner.visible = false
		State.CAUGHT:
			banner.text = "CAUGHT!\nPress Space to try again"
			banner.visible = true
