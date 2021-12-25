extends Node

var Circle = preload("res://objects/circle.tscn")
var Jumper = preload("res://objects/jumper.tscn")

onready var camera = $Camera2D
onready var start_position = $StartPosition.position

var player


func _ready():
	randomize()
	new_game()
	

func new_game():
	camera.position = start_position
	player = Jumper.instance()
	player.position = start_position
	add_child(player)
	player.connect("captured", self, "_on_Jumper_captured")
	spawn_circle(start_position)
	

func spawn_circle(_position=null):
	var circle = Circle.instance()
	if not _position:
		var x = rand_range(-150, 150)
		var y = rand_range(-500, -400)
		_position = player.target.position + Vector2(x, y)
	add_child(circle)
	circle.init(_position)


func _on_Jumper_captured(object):
	camera.position = object.position
	object.capture(player)
	call_deferred("spawn_circle")
	
