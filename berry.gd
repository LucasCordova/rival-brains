extends Area2D

signal eaten
signal retired(berry: Area2D)

var velocity: Vector2 = Vector2.ZERO
var time_left: float = 0.0

func _ready() -> void:
	retire()

func launch(at: Vector2, drift: Vector2, life: float) -> void:
	position = at
	velocity = drift
	time_left = life
	show()
	set_process(true)
	set_deferred("monitoring", true)

func retire() -> void:
	if not visible:
		return   # already resting in the pool
	hide()
	set_process(false)
	set_deferred("monitoring", false)
	retired.emit(self)

func _process(delta: float) -> void:
	position += velocity * delta
	time_left -= delta
	if time_left <= 0.0:
		retire()

func _on_body_entered(_body: Node2D) -> void:
	eaten.emit()
	retire()
