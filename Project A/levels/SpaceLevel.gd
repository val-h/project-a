extends Node2D

export (PackedScene) var Mob
var score

func _ready():
	randomize()
	
	# Start the game
	if Input.is_action_pressed("ui_select"):
		new_game()
	
# New game
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$Player/GameOver.visible = false

func _game_over():
	$MobTimer.stop()
	$Player/GameOver.visible = true

func _on_MobTimer_timeout():
	# Chosing a random location on the path
	$MobSpawner/MobLocation.offset = randi()
	
	# Create a mob instance and add it as a child
	var mob = Mob.instance()
	add_child(mob)
	
	# Set the mob's location perpendicular to the path
	var direction = $MobSpawner/MobLocation.rotation + PI / 2
	
	# Set the mob's position to a random location
	mob.position = $MobSpawner/MobLocation.position
	
	# Add some randomness to the direction
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Set the velocity
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
