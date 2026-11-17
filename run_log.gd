extends Node

const PATH := "user://runs.csv"

var times: Array[float] = []
var escapes: int = 0

func record(outcome: String, maze_number: int, rival_name: String, seconds: float, berries: int) -> void:
	var file: FileAccess
	if FileAccess.file_exists(PATH):
		file = FileAccess.open(PATH, FileAccess.READ_WRITE)
		file.seek_end()
	else:
		file = FileAccess.open(PATH, FileAccess.WRITE)
		file.store_line("when,outcome,maze,rival,seconds,berries")
	file.store_line("%s,%s,%d,%s,%.1f,%d" % [
			Time.get_datetime_string_from_system(), outcome, maze_number,
			rival_name, seconds, berries])
	file.close()

	times.append(seconds)
	if outcome == "escaped":
		escapes += 1
	print("run %d: %s in maze %d (%s) at %.1f s | %d escaped, median %.1f s" % [
			times.size(), outcome, maze_number, rival_name, seconds, escapes, _median()])

func _median() -> float:
	var sorted := times.duplicate()
	sorted.sort()
	return sorted[sorted.size() / 2]
