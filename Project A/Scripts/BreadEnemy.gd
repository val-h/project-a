extends "res://Scripts/Humanoid.gd"

func _ready():
	# Change the speed for movement
	speed.x = 300
	
	# For VisibilityNotifier, doesn't work properly
	# nvm the problem is not from it ;d
	#set_physics_process(false)
	velocity.x = -speed.x

func _on_StompArea_body_entered(body):
#	if body.global_position.y > $StompArea.global_position.y:
#		return
	
	# Causes the enemy not to be killed, sometimes returns an error
	# no longer returns an error with set_deffered, but doesn't work properly
	$CollisionShape2D.set_deferred("disabled", true)
	queue_free()

func _physics_process(delta):
	#Gravity moved to the Humanoid base class
	#velocity.y += gravity * delta
	if is_on_wall():
		velocity.x *= -1.0
	
func _process(delta):
	# Moved from physics
	velocity.y = move_and_slide(velocity, FLOOR_NORMAL).y