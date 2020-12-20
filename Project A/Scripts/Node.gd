extends Node

signal playing

export (PackedScene) var Mob
var score	# Not yet implemented as a UI element
var playing = false

# References
onready var mob_timer = $MobTimer
onready var over_label = $GameOver
onready var start_label = $Start
onready var music = $BackgroundMusic
onready var death_sound = $DeathSound
onready var pause_label = $Pause


func _ready():
	randomize()
	over_label.hide()
	pause_label.hide()
	
func _process(delta):
	# Start the game
	if Input.is_action_pressed("start_game") && playing != true:
		new_game()
	# Quit the game
	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()
	
# New game
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	mob_timer.start()
	
	# Music
	music.play()
	death_sound.stop()
	
	# Labels
	over_label.hide()
	start_label.hide()
	
	playing	= true
	emit_signal("playing")

func game_over():
	mob_timer.stop()
	
	# Music
	music.stop()
	death_sound.play()
	
	# GameOver label position
	over_label.rect_position = $Player.position
	over_label.rect_position.x -= 50
	over_label.rect_position.y -= 25
	
	# Labels
	over_label.show()
	start_label.show()
	
	playing = false

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

