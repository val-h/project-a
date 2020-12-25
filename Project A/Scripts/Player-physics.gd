extends Humanoid

onready var player_sprite = $Sprite

export var stomp_impulse = 1200

func _on_EnemyDetector_area_entered(area):
	velocity = calculate_stomp_velocity(velocity, stomp_impulse)

func _on_EnemyDetector_body_entered(body):
	queue_free()

func _physics_process(delta):
	# This possibly causes the jump problem
	#var _is_jump_interrupted = Input.is_action_just_released("move_up") and velocity.y < 0.0
	# maybe not, still the sam result
	
	var direction = get_direction()
	velocity = calculate_move_velocity(velocity, direction, speed)
		
func _process(delta):
	# Flip sprite
	if velocity.x != 0:
		player_sprite.flip_h = velocity.x < 0
	
	# Found the origin of the bug, the project settings don't do much however i set them,
	# rather the _physics_process and _process methods have to be both used correctly.
	# When i move the player 'move_and_slide' it creates a stutter and pixel mish-mash for 
	# every sprite object that moves around it(based on the fixed prespective of the player)
	# UPDATE: absolutely no stutter on moving sprites with this method.
	
	# NOTE: Now the jump doesn't work properly for the player.
	
	# Moved from physics
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	
func get_direction():
	 return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.get_action_strength("move_up") and is_on_floor() else 0.0)
	
func calculate_move_velocity(velocity, direction, speed): # is_jump_interupted removed as an argument
	var new_velocity = velocity
	new_velocity.x = speed.x * direction.x
	new_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		new_velocity.y = speed.y * direction.y
#	if _is_jump_interrupted:
#		new_velocity.y = 0.0
	return new_velocity
	
func calculate_stomp_velocity(velocity, impulse):
	var _velocity = velocity
	_velocity.y = -impulse
	return _velocity
