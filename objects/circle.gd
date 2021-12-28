extends Area2D


const FULL_CIRCLE = 2 * PI

onready var orbit_position= $Pivot/OrbitPosition
onready var circle_collision = $CircleCollision
onready var sprite = $Sprite
onready var sprite_size = sprite.texture.get_size()
onready var sprite_effect = $SpriteEffect
onready var collision_shape = circle_collision.shape
onready var animation_player = $AnimationPlayer
onready var orbit_counter = $Label
onready var beep = $Beep

enum MODES {STATIC, LIMITED}

var static_color = settings.theme["circle_static"]
var limited_color = settings.theme["circle_limited"]
var circle_fill = settings.theme["circle_fill"]

var circle_radius = 100
var rotation_speed = PI
var mode = MODES.STATIC
var num_orbits = 3  # Orbits until circle disappears
var current_orbits = 0  # Orbits the jumper has completed
var orbit_start = null  # Where the orbits started
var jumper = null
var circled_amount: float
var radius_multiplier
var radius_divider


func init(_position, _radius=circle_radius, _mode=MODES.LIMITED):
	set_mode(_mode)
	position = _position
	circle_radius = _radius
	sprite.material = sprite.material.duplicate()
	sprite_effect.material = sprite.material
	collision_shape = collision_shape.duplicate()
	collision_shape.radius = circle_radius
	var img_size = sprite_size.x / 2
	sprite.scale = Vector2(1, 1) * circle_radius / img_size
	orbit_position.position.x = circle_radius + 25
	rotation_speed *= pow(-1, randi() % 2)
	

func set_mode(_mode):
	mode = _mode
	var color
	match mode:
		MODES.STATIC:
			orbit_counter.hide()
			color = static_color
		MODES.LIMITED:
			current_orbits = num_orbits
			orbit_counter.text = str(current_orbits)
			orbit_counter.show()
			color = limited_color
	sprite.material.set_shader_param("color", color)
	

func _process(delta):
	$Pivot.rotation += rotation_speed * delta
	if mode == MODES.LIMITED and jumper:
		check_orbits()
		update()
		

func check_orbits():
	# Check if the jumper completed a full circle
	circled_amount = abs($Pivot.rotation - orbit_start)
	if circled_amount > FULL_CIRCLE:
		current_orbits -= 1
		if settings.enable_sound:
			beep.play()
		orbit_counter.text = str(current_orbits)
		if current_orbits <= 0:
			jumper.die()
			jumper = null
			implode()
		orbit_start = $Pivot.rotation

	
func capture(target):
	jumper = target
	animation_player.play("capture")
	$Pivot.rotation = (jumper.position - position).angle()
	orbit_start = $Pivot.rotation


func implode():
	animation_player.play("implode")
	yield(animation_player, "animation_finished")
	queue_free()


func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = angle_from + i * (angle_to - angle_from) / nb_points - PI / 2
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)
		

func _draw():
	if jumper:
		radius_multiplier = 1 + num_orbits - current_orbits
		radius_divider = (circle_radius - 50) / num_orbits
		var r = radius_divider * radius_multiplier
		draw_circle_arc_poly(Vector2.ZERO, r + 10, orbit_start + PI / 2,
							 $Pivot.rotation + PI / 2, circle_fill)
