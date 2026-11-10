extends Label

func _process(_delta: float) -> void:
	text = "FPS %d   NODES %d" % [
			Engine.get_frames_per_second(),
			Performance.get_monitor(Performance.OBJECT_NODE_COUNT)]
