extends Area2D

export var energy_gain = 50

onready var anim_player: AnimatedSprite = $AnimationPlayer

func _on_body_entered(body):
	anim_player.play("FadeOut")
