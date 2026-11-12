extends Node2D

enum State { TITLE, PLAYING, CAUGHT, ESCAPED }

@export var catch_distance: float = 36.0
@export var mazes: Array[PackedScene] = []

var state: State = State.TITLE
var maze_index: int = 0
var maze: Maze
var time_alive: float = 0.0
var berries: int = 0

@onready var player: CharacterBody2D = $Player
@onready var rival: CharacterBody2D = $Rival
@onready var storm: Node2D = $BerryStorm
@onready var camera: Camera2D = $Player/Camera2D
@onready var banner: Label = $UI/Banner
@onready var hud: MarginContainer = $UI/HUD
@onready var pause_menu: ColorRect = $UI/PauseMenu
@onready var berry_sound: AudioStreamPlayer = $Audio/BerrySound
@onready var caught_sound: AudioStreamPlayer = $Audio/CaughtSound
@onready var escaped_sound: AudioStreamPlayer = $Audio/EscapedSound

func _ready() -> void:
	storm.berry_eaten.connect(_on_berry_eaten)
	_change_state(State.TITLE)

func _physics_process(delta: float) -> void:
	match state:
		State.TITLE:
			if Input.is_action_just_pressed("ui_accept"):
				_change_state(State.PLAYING)
		State.PLAYING:
			time_alive += delta
			hud.show_time(time_alive)
			if player.global_position.distance_to(rival.global_position) < catch_distance:
				_change_state(State.CAUGHT)
		State.CAUGHT, State.ESCAPED:
			if Input.is_action_just_pressed("ui_accept"):
				_change_state(State.TITLE)

func _change_state(new_state: State) -> void:
	state = new_state
	var running := new_state == State.PLAYING
	player.set_physics_process(running)
	rival.set_physics_process(running)
	storm.set_process(running)
	pause_menu.allowed = running
	match new_state:
		State.TITLE:
			_load_maze(0)
			time_alive = 0.0
			berries = 0
			hud.show_time(time_alive)
			hud.show_berries(berries)
			banner.text = "RIVAL BRAINS\nPress Space to play"
			banner.visible = true
		State.PLAYING:
			banner.visible = false
		State.CAUGHT:
			caught_sound.play()
			Scoreboard.report(time_alive)
			banner.text = "CAUGHT!\nPress Space to try again"
			banner.visible = true
		State.ESCAPED:
			escaped_sound.play()
			Scoreboard.report(time_alive)
			banner.text = "YOU ESCAPED THE GAUNTLET!\nPress Space to run it again"
			banner.visible = true

func _load_maze(index: int) -> void:
	if maze != null:
		maze.queue_free()
	maze_index = index
	maze = mazes[index].instantiate()
	add_child(maze)
	move_child(maze, 0)
	maze.exited.connect(_on_maze_exited)
	player.position = maze.player_spawn.position
	rival.position = maze.rival_spawn.position
	rival.patrol_points = maze.patrol_points()
	rival.calm()
	var box := maze.bounds()
	camera.limit_left = box.position.x
	camera.limit_top = box.position.y
	camera.limit_right = box.end.x
	camera.limit_bottom = box.end.y
	camera.reset_smoothing()
	storm.clear()
	storm.area = Rect2(box)

func _on_maze_exited() -> void:
	if maze_index + 1 < mazes.size():
		_load_maze(maze_index + 1)
	else:
		_change_state(State.ESCAPED)

func _on_berry_eaten() -> void:
	berries += 1
	hud.show_berries(berries)
	berry_sound.pitch_scale = randf_range(0.9, 1.2)
	berry_sound.play()
