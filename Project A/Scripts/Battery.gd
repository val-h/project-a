extends Area2D

onready var anim_player: AnimatedSprite = $AnimationPlayer

func _on_body_entered(body):
	anim_player.play("FadeOut")
