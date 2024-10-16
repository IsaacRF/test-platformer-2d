extends Node2D

@export var emit: bool = true
@onready var _point_light_2d = $PointLight2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if emit:
		_point_light_2d.enabled = true
		
		var tween = get_tree().create_tween().set_loops()
		tween.tween_property(_point_light_2d, "scale", Vector2(1.05, 1.05), 1)
		tween.tween_property(_point_light_2d, "scale", Vector2(1, 1), 1)
		var tween2 = get_tree().create_tween().set_loops()
		tween2.tween_property(_point_light_2d, "color", Color("ffffae"), 1)	
		tween2.tween_property(_point_light_2d, "color", Color.WHITE, 1)	
	else:
		_point_light_2d.enabled = false
