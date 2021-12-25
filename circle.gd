extends Area2D


onready var orbit_position = $Pivot/OrbitPosition
onready var circle_collision = $CircleCollision
onready var sprite = $Sprite
onready var sprite_size = sprite.texture.get_size()
onready var collision_shape = circle_collision.shape

var radius = 100
var rotation_speed = PI

func _ready():
	init()
	

func init(_radius=radius):
	radius = _radius
	collision_shape = collision_shape.duplicate()
	collision_shape.radius = radius
	var img_size = sprite_size.x / 2
	sprite.scale = Vector2(1, 1) * radius / img_size
	orbit_position.position.x = radius + 25
	

func _process(delta):
	$Pivot.rotation += rotation_speed * delta