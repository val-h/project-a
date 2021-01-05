extends MarginContainer


onready var hp_number_label = get_node("HBoxContainer/Bars/Health/Count/Background/Number")
onready var hp_bar = get_node("HBoxContainer/Bars/Health/Gauge")
onready var en_number_label = $HBoxContainer/Bars/Energy/Count/Background/Number
onready var en_bar = $HBoxContainer/Bars/Energy/Gauge
onready var tween = $Tween

#var player = get_parent().get_parent().get_node("Player")
# experiment if you will
var player

var animated_health = 0
var animated_energy = 0

func _process(delta):
	# Bar animation
	# I really don;t like it being processed constantly
	# To be put into a function called only when needed
	# set_process() could be used here.
	var rounded_animated_health = round(animated_health)
	hp_number_label.text = str(rounded_animated_health)
	hp_bar.value = rounded_animated_health
	
	var rounded_animated_energy = round(animated_energy)
	en_number_label.text = str(rounded_animated_energy)
	en_bar.value = rounded_animated_energy

# connected signal from the Level node
func _get_player(_player):
	hp_bar.max_value = _player.max_health
	hp_bar.value = _player.health
	
	#hp_number_label.text = str(_player.health)
	_update_health(_player.health)
	_update_energy(_player.energy)
	
	# Not in use but good to have in case
	# I don't know why i didn't move it to the start of the function.
	player = _player
	
	player.connect("hit", self, "_on_Player_health_changed")
	player.connect("energy_changed", self, "_on_Player_energy_changed")
	# Makes a wierd error
	player.connect("killed", self, "_on_Player_killed")

func _on_Player_killed():
	var start_color = Color(1.0, 1.0, 1.0, 1.0)
	var end_color = Color(1.0, 1.0, 1.0, 0.0)
	tween.interpolate_property(self, "modulate", start_color, end_color, 1.0, Tween.TRANS_BOUNCE, Tween.EASE_IN)

func _on_Player_health_changed(player_health):
	_update_health(player_health)

func _on_Player_energy_changed(player_energy):
	_update_energy(player_energy)

func _update_health(new_value):
	tween.interpolate_property(self, "animated_health", animated_health, new_value, 0.5, Tween.TRANS_QUINT, Tween.EASE_IN)
	hp_bar.value = new_value
	hp_number_label.text = str(new_value)

	if not tween.is_active():
		tween.start()

func _update_energy(new_value):
	tween.interpolate_property(self, "animated_energy", animated_energy, new_value, 0.5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	en_bar.value = new_value
	en_number_label.text = str(new_value)
	
	if not tween.is_active():
		tween.start()

func reset_gui():
	modulate = Color(1.0, 1.0, 1.0, 1.0)
