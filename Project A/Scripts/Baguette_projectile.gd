extends Area2D

export var damage = 25
# just for testing
export var speed = 500

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	position.x -= speed * delta

# rework!
func _on_Baguette_body_entered(body):
	queue_free()
