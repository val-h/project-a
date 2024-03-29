tool
extends Area2D

onready var anim_player = $AnimationPlayer

export var next_scene: PackedScene

func _on_body_entered(body):
	teleport()

func _get_configuration_warning():
	return "The next scene property can't be empty." if not next_scene else ""

func teleport():
	anim_player.play("FadeIn")
	# pretty usefull, waits for a node to finish a process
	# then it resumes with the code
	yield(anim_player, "animation_finished")
	get_tree().change_scene_to(next_scene)
