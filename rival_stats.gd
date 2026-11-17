extends Resource
class_name RivalStats

@export var patrol_speed: float = 140.0
@export var chase_speed: float = 220.0
@export var sight_range: float = 260.0
@export var give_up_range: float = 360.0
@export var flee_speed: float = 260.0
@export var frightened_time: float = 3.0
@export var pressure: Curve          # multiplies chase_speed; x runs 0 to 1 across pressure_time
@export var pressure_time: float = 30.0
