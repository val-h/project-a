extends KinematicBody2D
class_name Humanoid

# All of these variables are to be moved to the level processes, and the player 
# could use the variables specific to the level, having different properties on
# each level.
const FLOOR_NORMAL = Vector2.UP

export var speed: = Vector2(350.0, 1000.0)
# These could be based on the level, space - no gravity
# different planets, different gravity
export var gravity: = 2500.0
export var max_gravity = 7500.0

export var velocity: = Vector2()

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.y = min(velocity.y, max_gravity)
