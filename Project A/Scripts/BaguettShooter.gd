extends Humanoid

export var reload_time = 3
export(PackedScene) var Baguette

func _ready():
	# Shoot
	shot()
	
func shot():
	var baguette = Baguette.instance()
	get_parent().add_child(baguette)
	baguette.position = position
