extends Node

const AudioOn = preload("res://assets/images/buttons/audioOn.png")
const AudioOff = preload("res://assets/images/buttons/audioOff.png")
const MusicOn = preload("res://assets/images/buttons/musicOn.png")
const MusicOff = preload("res://assets/images/buttons/musicOff.png")

signal start_game

onready var click = $Click

var sound_buttons = {true: AudioOn, false: AudioOff}
var music_buttons = {true: MusicOn, false: MusicOff}
var current_screen = null


func _ready():
	register_buttons()
	change_screen($TitleScreen)


func register_buttons():
	var buttons = get_tree().get_nodes_in_group("buttons")
	for button in buttons:
		button.connect("pressed", self, "_on_button_pressed", [button])
		match button.name:
			"Sound":
				button.texture_normal = sound_buttons[settings.enable_sound]
			"Music":
				button.texture_normal = music_buttons[settings.enable_music]


func _on_button_pressed(button):
	if settings.enable_sound:
		click.play()
	match button.name:
		"Home":
			change_screen($TitleScreen)
		"Play":
			change_screen(null)
			yield(get_tree().create_timer(0.5), "timeout")
			emit_signal("start_game")
		"Settings":
			change_screen($SettingsScreen)
		"Sound":
			settings.enable_sound = not settings.enable_sound
			button.texture_normal = sound_buttons[settings.enable_sound]
			settings.save_settings()
		"Music":
			settings.enable_music = not settings.enable_music
			button.texture_normal = music_buttons[settings.enable_music]
			settings.save_settings()
		"About":
			change_screen($AboutScreen)


func change_screen(new_screen):
	if current_screen:
		current_screen.disappear()
		yield(current_screen.tween, "tween_completed")
	current_screen = new_screen
	if new_screen:
		current_screen.appear()
		yield(current_screen.tween, "tween_completed")


func game_over():
	change_screen($GameOverScreen)
