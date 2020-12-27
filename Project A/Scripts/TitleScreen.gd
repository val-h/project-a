extends MarginContainer

export var first_level: PackedScene

func _ready():
	pass


func _on_Start_Game_pressed():
	get_tree().change_scene_to(first_level)


func _on_Exit_pressed():
	get_tree().quit()
