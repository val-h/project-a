extends RigidBody2D

export var damage = 25
# just for testing
export var speed = Vector2(500, 500)
var direction = Vector2.ZERO

func _ready():
	pass

func _physics_process(delta):
#	direction = rand_range(-PI / 4, PI / 4)
#	rotation = direction
#	position = speed * delta
	pass

# rework, doesn't work properly when changed from area to rigid body
func _on_body_entered(body):
	if body.collision_layer == 1:
		body.emit_signal('projectile_hit', 5)
		# body takes damage through hit singla
	queue_free()
