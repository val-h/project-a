extends Humanoid

signal killed
signal hit(current_health)

onready var player_sprite = $Sprite

export var stomp_impulse = 1200

# Stomping over enemy
func _on_EnemyDetector_area_entered(area):
	# in case the player colides with an enemy area
	# temporary solution
	if area.collision_layer == 2:
		velocity = calculate_stomp_velocity(velocity, stomp_impulse)
	if area.name == "GreenSpikes":
		_update_health(area.damage)

# Player killed by enemy
func _on_EnemyDetector_body_entered(body):
	# Different enemies, obstacles and traps would have different damage
	# I'm still thinking of a no UI game where the playere isn't exposed
	# to any variables from the game and plays by feel.
	_update_health(body.damage)

func _ready():
	# Just testing out
	pass

func _physics_process(delta):
	pass
	
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
	# When the whole calculation was moved here it worked fine.
	# Future note, this could result in perforamnce loss
	
	# Moved from _physics_process
	var _is_jump_interrupted = Input.is_action_just_released("move_up") and velocity.y < 0.0
	var direction = get_direction()
	velocity = calculate_move_velocity(velocity, direction, speed, _is_jump_interrupted)
	# Perfect scenario, move_and_slide stays here and the rest goes to _physics. Ofcourse, bugfree.
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	
func get_direction():
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.get_action_strength("move_up") and is_on_floor() else 0.0)
		# After the input take, the is_on_floor method doesn't work for some reaseon
		# Update: The charecter can only jump while not moving.
		# Like this the charecter can jump infinetly and creates a fun mechanic :D
	
func calculate_move_velocity(velocity, direction, speed, _is_jump_interrupted):
	var new_velocity = velocity
	new_velocity.x = speed.x * direction.x
	# Gravity moved to the Humanoid base class
	#new_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		new_velocity.y = speed.y * direction.y
	if _is_jump_interrupted:
		new_velocity.y = 0.0
	return new_velocity
	
func calculate_stomp_velocity(velocity, impulse):
	var _velocity = velocity
	_velocity.y = -impulse
	return _velocity
	
func start(pos):
	position = pos

func _update_health(damage):
	health -= damage
	health = max(health, 0.0)
	emit_signal("hit", health)
	if health <= 0.0:
		emit_signal("killed")
		queue_free()
