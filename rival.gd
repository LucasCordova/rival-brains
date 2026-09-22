extends CharacterBody2D

enum State { PATROL, CHASE }

@export var patrol_speed: float = 140.0
@export var chase_speed: float = 220.0
@export var sight_range: float = 260.0
@export var give_up_range: float = 360.0

var state: State = State.PATROL
var patrol_points: Array[Vector2] = [
    Vector2(200, 150), Vector2(950, 150), Vector2(950, 500), Vector2(200, 500),
]
var patrol_index: int = 0

@onready var player: Node2D = get_node("../Player")

func _ready() -> void:
    _change_state(State.PATROL)

func _physics_process(_delta: float) -> void:
    var to_player := player.global_position - global_position

    match state:
        State.PATROL:
            var target := patrol_points[patrol_index]
            if global_position.distance_to(target) < 12.0:
                patrol_index = (patrol_index + 1) % patrol_points.size()
                target = patrol_points[patrol_index]
            velocity = (target - global_position).normalized() * patrol_speed
            if to_player.length() < sight_range:
                _change_state(State.CHASE)
        State.CHASE:
            velocity = to_player.normalized() * chase_speed
            if to_player.length() > give_up_range:
                _change_state(State.PATROL)

    move_and_slide()

func _change_state(new_state: State) -> void:
    state = new_state
    print("rival: ", State.keys()[new_state])
    match new_state:
        State.PATROL:
            modulate = Color.WHITE
        State.CHASE:
            modulate = Color("ff2e97")
