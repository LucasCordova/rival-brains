extends Node2D

signal berry_eaten

@export var berries_per_second: float = 160.0
@export var berry_life: float = 5.0
@export var drift_speed: float = 40.0
@export var burst_size: int = 400

var area: Rect2 = Rect2()
var owed: float = 0.0

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
		berry.queue_free()

func _spawn() -> void:
	var berry: Area2D = load("res://berry.tscn").instantiate()
	berry.position = Vector2(
			randf_range(area.position.x, area.end.x),
			randf_range(area.position.y, area.end.y))
	berry.velocity = Vector2.from_angle(randf() * TAU) * drift_speed
	berry.time_left = berry_life
	berry.eaten.connect(_on_berry_eaten)
	add_child(berry)

func _on_berry_eaten() -> void:
	berry_eaten.emit()
