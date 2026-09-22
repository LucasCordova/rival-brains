extends CharacterBody2D

@export var speed: float = 180.0

@onready var player: Node2D = get_node("../Player")

func _physics_process(_delta: float) -> void:
    var to_player := player.global_position - global_position
    velocity = to_player.normalized() * speed
    move_and_slide()
