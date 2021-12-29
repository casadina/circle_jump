extends CanvasLayer

onready var buttons_disabled: bool
onready var tween = $Tween


func buttons_clickable(buttons_enabled):
	return get_tree().call_group("buttons", "set_disabled", buttons_enabled)
	
	
func appear():
	buttons_disabled = false
	buttons_clickable(buttons_disabled)
	tween.interpolate_property(self, "offset:x", 500, 0,
							   0.5, tween.TRANS_BACK, tween.EASE_IN_OUT)
	tween.start()
	

func disappear():
	buttons_disabled = true
	buttons_clickable(buttons_disabled)
	tween.interpolate_property(self, "offset:x", 0, 500,
							   0.4, tween.TRANS_BACK, tween.EASE_IN_OUT)
	tween.start()
