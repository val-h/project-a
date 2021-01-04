extends Area2D

export var damage = 50

func _ready():
	pass

# When the player enteres it, emit some particles.
func _on_body_entered(body):
	$Particles2D.emitting = true
