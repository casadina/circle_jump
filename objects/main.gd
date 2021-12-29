extends Node

var Circle = preload("res://objects/circle.tscn")
var Jumper = preload("res://objects/jumper.tscn")

onready var camera = $Camera2D
onready var start_position = $StartPosition.position
onready var screens = $Screens
onready var hud = $HUD
onready var music = $Music

var player
var score: int = 0 setget set_score
var level = 0


func _ready():
	randomize()
	hud.hide()
	screens.connect("start_game", self, "new_game")
	

func new_game():
	if settings.enable_music:
		music.play()
		
	self.score = -1
	level = 1
	
	camera.position = start_position
	
	player = Jumper.instance()
	player.position = start_position
	add_child(player)
	player.connect("captured", self, "_on_Jumper_captured")
	
	spawn_circle(start_position)
	player.connect("died", self, "_on_Jumper_died")
	
	hud.update_score(score)
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
	camera.position = object.position
	object.capture(player)
	call_deferred("spawn_circle")
	self.score += 1
	

func set_score(value):
	score = value
	hud.update_score(score)
	if score > 0 and score % settings.circles_per_level == 0:
		level += 1
		hud.show_message("Level %s" % str(level))


func _on_Jumper_died():
	if settings.enable_music:
		music.stop()
	get_tree().call_group("circles", "implode")
	screens.game_over()
	hud.hide()

