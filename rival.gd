extends CharacterBody2D

enum State { PATROL, CHASE, RETURN, FRIGHTENED }

@export var stats: RivalStats

var state: State = State.PATROL
var patrol_points: Array[Vector2] = [
	Vector2(792, 72), Vector2(1464, 72),
]
var patrol_index: int = 0
var frightened_left: float = 0.0
var leash: Vector2   # where the rival left its lane; RETURN walks back to it

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
			if to_player.length() < stats.sight_range and _can_see_player():
				_change_state(State.CHASE)
		State.CHASE:
			velocity = to_player.normalized() * stats.chase_speed
			if to_player.length() > stats.give_up_range or not _can_see_player():
				_change_state(State.RETURN)
		State.RETURN:
			velocity = (leash - global_position).normalized() * stats.patrol_speed
			if global_position.distance_to(leash) < 12.0:
				_change_state(State.PATROL)
			elif to_player.length() < stats.sight_range and _can_see_player():
				_change_state(State.CHASE)
		State.FRIGHTENED:
			frightened_left -= delta
			velocity = -to_player.normalized() * stats.flee_speed
			if frightened_left <= 0.0:
				_change_state(State.RETURN)

	move_and_slide()

func _change_state(new_state: State) -> void:
	var old_state := state
	state = new_state
	print("rival: ", State.keys()[new_state])
	match new_state:
		State.PATROL:
			modulate = Color.WHITE
		State.CHASE:
			if old_state == State.PATROL:
				leash = global_position
			modulate = Color("ff2e97")
		State.RETURN:
			modulate = Color("8f8ab0")
		State.FRIGHTENED:
			modulate = Color("478cbf")

func frighten() -> void:
	frightened_left = stats.frightened_time
	_change_state(State.FRIGHTENED)

func calm() -> void:
	frightened_left = 0.0
	patrol_index = 0
	_change_state(State.PATROL)

func _can_see_player() -> bool:
	var space := get_world_2d().direct_space_state
	var ray := PhysicsRayQueryParameters2D.create(global_position, player.global_position, 1)
	return space.intersect_ray(ray).is_empty()
