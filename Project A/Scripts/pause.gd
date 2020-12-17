extends Label

var playing

func _ready():
	hide()
	
func _process(delta):
	if Input.is_action_just_pressed("pause_game") and get_tree().paused == false and playing == true:
		get_tree().paused = true
		show()
		playing = false
	elif Input.is_action_just_pressed("pause_game"):
		get_tree().paused = false
		hide()
		playing = true

func _on_Main_playing():
	playing = true
