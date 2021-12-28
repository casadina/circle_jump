extends Node

var Circle = preload("res://objects/circle.tscn")
var Jumper = preload("res://objects/jumper.tscn")

onready var camera = $Camera2D
onready var start_position = $StartPosition.position
onready var screens = $Screens
onready var hud = $HUD

var player
var score: int = 0


func _ready():
	randomize()
	hud.hide()
	screens.connect("start_game", self, "new_game")
	

func new_game():
	score = 0
	hud.update_score(score)
	camera.position = start_position
	player = Jumper.instance()
	player.position = start_position
	add_child(player)
	player.connect("captured", self, "_on_Jumper_captured")
	spawn_circle(start_position)
	player.connect("died", self, "_on_Jumper_died")
	hud.show()
	hud.show_message("Go!")
	

func spawn_circle(_position=null):
	var circle = Circle.instance()
	if not _position:
		var x = rand_range(-150, 150)
		var y = rand_range(-500, -400)
		_position = player.target.position + Vector2(x, y)
	add_child(circle)
	circle.init(_position)


func _on_Jumper_captured(object):
	if player.new_game:
		player.new_game = false
	else:
		camera.position = object.position
		object.capture(player)
		score += 1
		hud.update_score(score)
	call_deferred("spawn_circle")


func _on_Jumper_died():
	get_tree().call_group("circles", "implode")
	screens.game_over()
	hud.hide()

