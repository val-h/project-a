extends Humanoid

var reloaded = true
export var reload_time = 0.1

export(PackedScene) var Baguette

func _on_ShootTimer_timeout():
	reloaded = true

func _ready():
	$ShootTimer.wait_time = reload_time
	
# Used for the ray casts
func _physics_process(delta):
	var space_rid = get_world_2d().space
	var space_state = Physics2DServer.space_get_direct_state(space_rid)
	
	# the ray
	var result = space_state.intersect_ray(Vector2(0, 0), Vector2(50, 300))

func _process(delta):
	if reloaded:
		fire_shot()
		reloaded = false
		$ShootTimer.start()
	
func fire_shot():
	var baguette = Baguette.instance()
	get_owner().add_child(baguette)
	baguette.position = position
	# Set the direction of the shot/baguette :D
	var direction = rotation
	# Works for now and i really don't know what i did here
	direction += rand_range(-PI, PI / 12)
	baguette.rotation = direction
	baguette.linear_velocity = Vector2(500, 0)
	baguette.linear_velocity = baguette.linear_velocity.rotated(direction)
	
# Implement ray casting so that the shooter aims at the player
# and after a short delay and animation, shoots
# https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html


