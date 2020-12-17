extends KinematicBody2D

var GRAVITY = 50
var MAX_FALL_SPEED = 1000
var JUMP_FORCE = 1000

export var speed = 500
var screen_size 
var sprite_size
var y_velo = 0

func _ready():
	screen_size = get_viewport_rect().size
	sprite_size = $Sprite.get_rect().size
	
func _physics_process(delta):
	# Create the vector var and control the direction of the movements
	var velocity = Vector2()
#	if Input.is_action_pressed("move_up"):
#		velocity.y -= 1
#	if Input.is_action_pressed("move_down"):
#		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		
	# Normalizing the diagonal movements
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	# Update the position of the player and set its limits
	var grounded = is_on_floor()
	y_velo += GRAVITY
	position += velocity * delta
	position.x = clamp(position.x, 0 + sprite_size.x / 2, screen_size.x - sprite_size.x / 2)
#	position.y = clamp(position.y, 0 + sprite_size.y / 2, screen_size.y - sprite_size.y / 2)
	if grounded and Input.is_action_just_pressed("move_up"):
		y_velo -= JUMP_FORCE
	if grounded and y_velo >=5:
		y_velo = 5
	if y_velo > MAX_FALL_SPEED:
		y_velo = MAX_FALL_SPEED
		
	
	# Change the sprite orientation when the user presses space
	if velocity.x != 0:
		$Sprite.flip_h = velocity.x < 0