extends Node2D
class_name Main

#signal playing

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()
