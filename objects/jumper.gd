extends Area2D

var velocity = Vector2(100, 0)  # start value for testing
var jump_speed = 1000
var target = null  # if we're on a circle


func _unhandled_input(event):
	if target and event is InputEventScreenTouch and event.pressed:
		jump()
		

func jump():
	target = null
	velocity = transform.x * jump_speed
	
	
func _on_Jumper_area_entered(area):
	target = area
	velocity = Vector2()
	

func _physics_process(delta):
	if target:
		transform = target.orbit_position.global_transform
	else:
		position += velocity * delta
