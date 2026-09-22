extends Node2D

enum State { TITLE, PLAYING, CAUGHT }

@export var catch_distance: float = 36.0

var state: State = State.TITLE
var player_start: Vector2
var rival_start: Vector2

@onready var player: CharacterBody2D = $Player
@onready var rival: CharacterBody2D = $Rival
@onready var banner: Label = $UI/Banner

func _ready() -> void:
    player_start = player.position
    rival_start = rival.position
    _change_state(State.TITLE)

func _physics_process(_delta: float) -> void:
    match state:
        State.TITLE:
            if Input.is_action_just_pressed("ui_accept"):
                _change_state(State.PLAYING)
        State.PLAYING:
            if player.global_position.distance_to(rival.global_position) < catch_distance:
                _change_state(State.CAUGHT)
        State.CAUGHT:
            if Input.is_action_just_pressed("ui_accept"):
                _change_state(State.TITLE)

func _change_state(new_state: State) -> void:
    state = new_state
    var running := new_state == State.PLAYING
    player.set_physics_process(running)
    rival.set_physics_process(running)
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
