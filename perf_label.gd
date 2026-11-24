extends Label

func _ready() -> void:
	visible = OS.is_debug_build()   # true in the editor and in debug exports
	set_process(visible)

func _process(_delta: float) -> void:
	text = "FPS %d   NODES %d" % [
			Engine.get_frames_per_second(),
			Performance.get_monitor(Performance.OBJECT_NODE_COUNT)]
