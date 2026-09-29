extends CharacterBody2D

enum State { PATROL, CHASE, FRIGHTENED }

@export var stats: RivalStats

var state: State = State.PATROL
var patrol_points: Array[Vector2] = [
	Vector2(200, 150), Vector2(950, 150), Vector2(950, 500), Vector2(200, 500),
]
var patrol_index: int = 0
var frightened_left: float = 0.0

@onready var player: Node2D = get_node("../Player")

func _ready() -> void:
	if stats == null:
		stats = RivalStats.new()
	_change_state(State.PATROL)

func _physics_process(delta: float) -> void:
	var to_player := player.global_position - global_position

	match state:
		State.PATROL:
			var target := patrol_points[patrol_index]
			if global_position.distance_to(target) < 12.0:
				patrol_index = (patrol_index + 1) % patrol_points.size()
				target = patrol_points[patrol_index]
			velocity = (target - global_position).normalized() * stats.patrol_speed
			if to_player.length() < stats.sight_range:
				_change_state(State.CHASE)
		State.CHASE:
			velocity = to_player.normalized() * stats.chase_speed
			if to_player.length() > stats.give_up_range:
				_change_state(State.PATROL)
		State.FRIGHTENED:
			frightened_left -= delta
			velocity = -to_player.normalized() * stats.flee_speed
			if frightened_left <= 0.0:
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
		State.FRIGHTENED:
			modulate = Color("478cbf")

func frighten() -> void:
	frightened_left = stats.frightened_time
	_change_state(State.FRIGHTENED)

func calm() -> void:
	frightened_left = 0.0
	patrol_index = 0
	_change_state(State.PATROL)
