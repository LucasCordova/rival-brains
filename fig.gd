extends Area2D

func _on_body_entered(_body: Node2D) -> void:
    get_tree().call_group("rivals", "frighten")
    get_tree().call_group("storms", "burst")
    queue_free()
