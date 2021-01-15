extends Humanoid

export var reload_time = 3
export(PackedScene) var Baguette

func _ready():
	# Shoot
	fire_shot()
	
func fire_shot():
	var baguette = Baguette.instance()
	add_child(baguette)
	
