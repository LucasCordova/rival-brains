extends VBoxContainer

const PATH := "user://settings.cfg"

@onready var music_slider: HSlider = $MusicRow/MusicSlider
@onready var sfx_slider: HSlider = $SfxRow/SfxSlider
@onready var big_text: CheckButton = $BigText
@onready var slow_mode: CheckButton = $SlowMode

func _ready() -> void:
	var file := ConfigFile.new()
	file.load(PATH)   # no file yet is fine: every get below has a default
	music_slider.set_value_no_signal(file.get_value("audio", "music", 1.0))
	sfx_slider.set_value_no_signal(file.get_value("audio", "sfx", 1.0))
	big_text.set_pressed_no_signal(file.get_value("access", "big_text", false))
	slow_mode.set_pressed_no_signal(file.get_value("access", "slow_mode", false))
	_apply()

func _apply() -> void:
	_set_volume("Music", music_slider.value)
	_set_volume("SFX", sfx_slider.value)
	get_tree().call_group("hud", "set_big_text", big_text.button_pressed)
	Engine.time_scale = 0.7 if slow_mode.button_pressed else 1.0

func _set_volume(bus_name: String, amount: float) -> void:
	var bus := AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus, linear_to_db(amount))
	AudioServer.set_bus_mute(bus, amount <= 0.0)

func _on_changed(_value: Variant = null) -> void:
	_apply()
	var file := ConfigFile.new()
	file.set_value("audio", "music", music_slider.value)
	file.set_value("audio", "sfx", sfx_slider.value)
	file.set_value("access", "big_text", big_text.button_pressed)
	file.set_value("access", "slow_mode", slow_mode.button_pressed)
	file.save(PATH)

func _on_sfx_slider_changed(_value: float) -> void:
	_on_changed()
	$Preview.play()
