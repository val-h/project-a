extends "res://Scripts/game.gd"

func _ready():
	new_game()

func _on_Player_player_killed():
	# Check the parent script for reference
	player_killed()
