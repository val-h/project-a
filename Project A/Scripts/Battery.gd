extends Area2D

onready var anim_player: AnimatedSprite = $AnimationPlayer

func _ready():
	anim_player.play("bouncing")

func _on_Battery_body_entered(body):
	anim_player.play("FadeOut")
