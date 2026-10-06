extends MarginContainer

@onready var time_label: Label = $Row/TimeLabel
@onready var best_label: Label = $Row/BestLabel

func _ready() -> void:
	show_best(Scoreboard.best_time)
	Scoreboard.best_changed.connect(show_best)

func show_time(seconds: float) -> void:
	time_label.text = "TIME %.1f" % seconds

func show_best(seconds: float) -> void:
	best_label.text = "BEST %.1f" % seconds
