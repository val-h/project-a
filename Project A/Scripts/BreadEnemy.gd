extends "res://Scripts/Humanoid.gd"

func _ready():
	set_physics_process(false)
	velocity.x = -speed.x

func _on_StompArea_body_entered(body):
	if body.global_position.y > $StompArea.global_position.y:
		return
	$CollisionShape2D.disabled = true
	queue_free()

func _physics_process(delta):
	velocity.y += gravity * delta
	if is_on_wall():
		velocity.x *= -1.0
	velocity.y = move_and_slide(velocity, FLOOR_NORMAL).y


