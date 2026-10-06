extends Node

signal best_changed(seconds: float)

var best_time: float = 0.0

func report(seconds: float) -> void:
	if seconds > best_time:
		best_time = seconds
		best_changed.emit(best_time)
