extends CanvasLayer

onready var score = $ScoreBox/HBoxContainer/Score
onready var score_box = $ScoreBox
onready var message = $Message


func show_message(text):
	message.text = text
	$AnimationPlayer.play("show_message")
	

func hide():
	score_box.hide()
	
	
func show():
	score_box.show()
	

func update_score(value):
	if value < 0:
		score.text = str(0)
	else:
		score.text = str(value)
