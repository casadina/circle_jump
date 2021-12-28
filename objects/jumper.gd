extends Area2D

signal captured
signal died

onready var trail := $Trail/Points
onready var new_game: bool = true
onready var jump_sound = $Jump
onready var capture_sound = $Capture

# Kill player if exit screen.
# Cannot use is_on_screen as the first frame will return false.
onready var on_screen: bool = $JumperVisibility.connect(
														"screen_exited",
														self,
														"_on_JumperVisibility_screen_exited"
														)
onready var game = get_owner()
onready var sprite = $Sprite
onready var player_color = settings.theme["player_body"]
onready var player_trail = settings.theme["player_trail"]

var trail_length = 25

var velocity = Vector2(100, 0)  # start value for testing
var jump_speed = 1000
var target = null  # if we're on a circle


func _ready():
	sprite.material.set_shader_param("color", player_color)
	trail.default_color = player_trail


func _unhandled_input(event) -> void:
	if target and event is InputEventScreenTouch and event.pressed:
		jump()
		

func jump() -> void:
	target.implode()
	target = null
	velocity = transform.x * jump_speed
	if settings.enable_sound:
		jump_sound.play()
	
	
func _on_Jumper_area_entered(area) -> void:
	target = area
	velocity = Vector2.ZERO
	emit_signal("captured", area)
	if settings.enable_sound:
		capture_sound.play()
	

func _physics_process(delta) -> void:
	if target:
		transform = target.orbit_position.global_transform
	else:
		position += velocity * delta
	
	if trail.points.size() > trail_length:
		trail.remove_point(0)
	trail.add_point(position)


func die() -> void:
	target = null
	queue_free()


func _on_JumperVisibility_screen_exited() -> void:
		emit_signal("died")
		die()
