extends Node2D
class_name Main

# References
# Players will be set at the specific level.
export(PackedScene) var Player
# Music will be set at the specific level.
export(PackedScene) var Music
# For future refining, put all UI elements in the GUI node and attatch a script to it.
# With it control the states of each element with functions, rather than passing the 
# path and doing it directly.
onready var GUI = get_node("UI/GUI")
# To be added to the GUI
onready var game_over_label = get_node("UI/GameOver")
onready var revive_label = $UI/ReviveLabel

var playing
var paused = false
var player
var music_bg

func _ready():
	# Possibly set by the level
	#new_game()
	pass

func _process(delta):
	# All of these will be optimised with signals.
	# Excessive logical operations.
	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()
	if Input.is_action_just_pressed("start_game") and !playing:
		new_game()
	
	# Pausing the game, either move it to the label itself or figure another way
	if Input.is_action_just_pressed("pause_game") and !paused:
		paused = true
		get_tree().paused = true
		# Show paused label
	elif Input.is_action_just_pressed("pause_game") and paused:
		paused = false
		get_tree().paused = false
		# Hide paused label

func new_game():
	GUI.show()
	game_over_label.hide()
	revive_label.hide()
	
	# Instance and add the player to the scene
	player = Player.instance()
	add_child(player)
	# Connect the player's signal to the script
	player.connect("player_killed", self, "_on_Player_player_killed") 
	
	# Add the music
	_set_music()
	
	# Set the player's position on every new game to the start pos
	player.start($StartPosition.position)
	
	playing = true

func player_killed():
	GUI.hide()
	game_over_label.show()
	revive_label.show()
	
	playing = false

# Most general misc settings will be set in another file that
# will be controlled by the GUI settings tab. 
# TODO Settings bar :D

# Music settings.
func _set_music():
	music_bg = Music.instance()
	music_bg.autoplay = true
	player.add_child(music_bg)
