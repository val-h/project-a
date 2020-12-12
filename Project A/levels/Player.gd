extends Area2D

export var speed = 300
var screen_size 
var sprite_size

func _ready():
	screen_size = get_viewport_rect().size
	sprite_size = $Sprite.get_rect().size
	
func _process(delta):
	var velocity = Vector2()
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	position += velocity * delta
	position.x = clamp(position.x, 0 + sprite_size.x / 2, screen_size.x - sprite_size.x / 2)
	position.y = clamp(position.y, 0 + sprite_size.y / 2, screen_size.y - sprite_size.y / 2)
	
	
	