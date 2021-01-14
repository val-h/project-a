extends Humanoid

signal killed
signal hit(current_health)
signal energy_changed(energy)

onready var player_sprite = $Sprite

var max_health = PlayerVariables.max_health
var health = PlayerVariables.health
var max_energy = PlayerVariables.max_energy
var energy = PlayerVariables.energy


# Preferably a negative value
export var jump_cost = -5
# Stomp values
export var stomp_impulse = 1200
export var stomp_health_reward = 5
export var stomp_energy_reward = 15

# Dashing
#export var dash_velocity = 150000 # Check the slide part of move_and_slide, possibly the root of the problem
#export var dash_cooldown = 1.0
#export var dash_energy_cost = 0
#var dash_enabled = true

var disable_jump = false

# Stomping over enemy
func _on_EnemyDetector_area_entered(area):
	# in case the player colides with an enemy area
	# temporary solution
	if area.collision_layer == 2:
		velocity = calculate_stomp_velocity(velocity, stomp_impulse)
		_update_health(stomp_health_reward)
		_update_energy(stomp_energy_reward)
	if area.collision_layer == 8:
		_update_health(-area.damage)
	#When checking for collision_layer, it takes the value of it not its place.
	if area.collision_layer == 4:
		_update_energy(area.energy_gain)

# Player killed by enemy
func _on_EnemyDetector_body_entered(body):
	# Different enemies, obstacles and traps would have different damage
	# I'm still thinking of a no UI game where the playere isn't exposed
	# to any variables from the game and plays by feel.
	if body.name == "BreadEnemy":
		_update_health(-body.damage)
	
# Dash cooldown
#func _on_CooldownTimer_timeout():
#	dash_enabled = true

func _ready():
	# Just testing out
	pass
	#CooldownTimer removed as a node
#	$CooldownTimer.wait_time = dash_cooldown
#	$CooldownTimer.connect("timeout", self, "_on_CooldownTimer_timeout")

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
	# Dash, poor implementation
#	if dash_enabled:
#		velocity = check_dashing(velocity)
	# Perfect scenario, move_and_slide stays here and the rest goes to _physics. Ofcourse, bugfree.
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	
func get_direction():
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.get_action_strength("move_up") else 0.0)
		# After the input take, the is_on_floor method doesn't work for some reaseon
		# Update: The charecter can only jump while not moving.
		# Like this the charecter can jump infinetly and creates a fun mechanic :D
	
func calculate_move_velocity(velocity, direction, speed, _is_jump_interrupted):
	var new_velocity = velocity
	new_velocity.x = speed.x * direction.x
	# Gravity moved to the Humanoid base class
	#new_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0 and is_on_floor() and not disable_jump:
		new_velocity.y = speed.y * direction.y
		_update_energy(jump_cost)
	if _is_jump_interrupted:
		new_velocity.y = 0.0
	return new_velocity
	
func calculate_stomp_velocity(velocity, impulse):
	var _velocity = velocity
	_velocity.y = -impulse
	return _velocity

# Not in use
#func check_dashing(velocity):
#	var _velocity = velocity
#	if Input.is_action_pressed("dash_left"):
#		_velocity.x = -dash_velocity
#		dashed()
#	elif Input.is_action_pressed("dash_right"):
#		_velocity.x = dash_velocity
#		dashed()
#	return _velocity
#
#func dashed():
#	dash_enabled = false
#	_update_energy(dash_energy_cost)
#	$CooldownTimer.start()
	
func start(pos):
	position = pos

# It will be used in the future with positive values
func _update_health(health_amount):
	health += health_amount
	if health <= 0.0:
		health = max(health, 0.0)
	else:
		health = min(health, max_health)
	emit_signal("hit", health)
	if health <= 0.0:
		emit_signal("killed")
		queue_free()

func _update_energy(energy_amount):
	energy += energy_amount
	if energy <= 0.0:
		energy = max(energy, 0.0)
	else:
		energy = min(energy, max_energy)
	disable_jump = true if energy == 0.0 else false
	emit_signal("energy_changed", energy)
