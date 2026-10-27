extends ColorRect

var allowed: bool = false

func _ready() -> void:
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and (allowed or get_tree().paused):
		_set_paused(not get_tree().paused)

func _set_paused(paused: bool) -> void:
	get_tree().paused = true
	visible = true
	if paused:
		$Center/Menu/ResumeButton.grab_focus()


func _on_resume_button_pressed() -> void:
	pass # Replace with function body.


func _on_restart_button_pressed() -> void:
	pass # Replace with function body.
