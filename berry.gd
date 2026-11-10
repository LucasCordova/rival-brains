extends Area2D

signal eaten

var velocity: Vector2 = Vector2.ZERO
var time_left: float = 0.0

func _process(delta: float) -> void:
	position += velocity * delta
	time_left -= delta
	# Berries should not pile up: push away from any berry that is too close.
	for other in get_tree().get_nodes_in_group("berries"):
		if other != self and position.distance_to(other.position) < 16.0:
			position += (position - other.position).normalized() * 20.0 * delta
	if time_left <= 0.0:
		queue_free()

func _on_body_entered(_body: Node2D) -> void:
	eaten.emit()
	queue_free()
