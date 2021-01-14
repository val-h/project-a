extends Area2D

export var damage = 25
export var speed = 500

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	position += transform.x * speed * delta
