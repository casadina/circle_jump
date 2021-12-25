extends Area2D


onready var orbit_position= $Pivot/OrbitPosition
onready var circle_collision = $CircleCollision
onready var sprite = $Sprite
onready var sprite_size = sprite.texture.get_size()
onready var collision_shape = circle_collision.shape
onready var animation_player = $AnimationPlayer

var radius = 50
var rotation_speed = PI


func init(_position, _radius=radius):
	position = _position
	radius = _radius
	collision_shape = collision_shape.duplicate()
	collision_shape.radius = radius
	var img_size = sprite_size.x / 2
	sprite.scale = Vector2(1, 1) * radius / img_size
	orbit_position.position.x = radius + 25
	rotation_speed *= pow(-1, randi() % 2)
	

func _process(delta):
	$Pivot.rotation += rotation_speed * delta
	
	
func capture():
	animation_player.play("capture")


func implode():
	animation_player.play("implode")
	yield(animation_player, "animation_finished")
	queue_free()
