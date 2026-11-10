extends Area2D

signal eaten

var velocity: Vector2 = Vector2.ZERO
var time_left: float = 0.0

func _process(delta: float) -> void:
	position += velocity * delta
	time_left -= delta
	if time_left <= 0.0:
		queue_free()

func _on_body_entered(_body: Node2D) -> void:
	eaten.emit()
	queue_free()
