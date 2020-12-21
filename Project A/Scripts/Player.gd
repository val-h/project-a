extends Area2D

signal hit

export var speed = 500
var screen_size 
var sprite_size
var velocity = Vector2()

func _ready():
	screen_size = get_viewport_rect().size
	sprite_size = $Sprite.get_rect().size
	hide()
	
func _process(delta):
	# Create the vector var and control the direction of the movements
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		
	# Normalizing the diagonal movements
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	# Update the position of the player and set its limits
	position += velocity * delta
	position.x = clamp(position.x, 0 + sprite_size.x / 2, screen_size.x - sprite_size.x / 2)
	position.y = clamp(position.y, 0 + sprite_size.y / 2, screen_size.y - sprite_size.y / 2)
	
	# Change the sprite orientation when the user presses space
	if velocity.x != 0:
		$Sprite.flip_h = velocity.x < 0
	
#func change_sprite_orientation():
#	if $Sprite.flip_h == false:
#		$Sprite.flip_h = true
#	else:
#		$Sprite.flip_h = false		

func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
