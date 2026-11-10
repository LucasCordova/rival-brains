extends Node2D

signal berry_eaten

const BERRY: PackedScene = preload("res://berry.tscn")

@export var berries_per_second: float = 160.0
@export var berry_life: float = 5.0
@export var drift_speed: float = 40.0
@export var burst_size: int = 400
@export var pool_size: int = 1200

var area: Rect2 = Rect2()
var owed: float = 0.0
var pool: Array[Area2D] = []   # berries that are resting, ready to launch

func _ready() -> void:
	for i in pool_size:
		var berry: Area2D = BERRY.instantiate()
		berry.eaten.connect(_on_berry_eaten)
		berry.retired.connect(_on_berry_retired)
		add_child(berry)

func _process(delta: float) -> void:
	owed += berries_per_second * delta
	while owed >= 1.0:
		owed -= 1.0
		_spawn()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_pressed() and not event.is_echo() and event.keycode == KEY_B:
		burst()

func burst() -> void:
	for i in burst_size:
		_spawn()

func clear() -> void:
	owed = 0.0
	for berry in get_children():
		berry.retire()

func _spawn() -> void:
	if pool.is_empty():
		return   # every berry is in the air: the pool is the budget
	var berry: Area2D = pool.pop_back()
	berry.launch(
			Vector2(randf_range(area.position.x, area.end.x),
					randf_range(area.position.y, area.end.y)),
			Vector2.from_angle(randf() * TAU) * drift_speed,
			berry_life)

func _on_berry_retired(berry: Area2D) -> void:
	pool.append(berry)

func _on_berry_eaten() -> void:
	berry_eaten.emit()
