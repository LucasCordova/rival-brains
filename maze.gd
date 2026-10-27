class_name Maze
extends Node2D

signal exited

@onready var tiles: TileMapLayer = $Tiles
@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var rival_spawn: Marker2D = $RivalSpawn

func patrol_points() -> Array[Vector2]:
	var points: Array[Vector2] = []
	for marker in $Patrol.get_children():
		points.append(marker.position)
	return points

func bounds() -> Rect2i:
	var cells := tiles.get_used_rect()
	var size := tiles.tile_set.tile_size
	return Rect2i(cells.position * size, cells.size * size)

func _on_exit_body_entered(_body: Node2D) -> void:
	exited.emit()
