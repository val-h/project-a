extends Main

func _ready():
	new_game()

func _on_Player_killed():
	# Check the parent script for reference
	player_killed()
