extends Humanoid

var reloaded = true
export var reload_time = 0.1

export(PackedScene) var Baguette

func _on_ShootTimer_timeout():
	reloaded = true

func _ready():
	$ShootTimer.wait_time = reload_time
	
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
	
