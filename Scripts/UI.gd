extends CanvasLayer

@export var player : Player
@onready var _score_label = $Score
@onready var _fuel_meter = $FuelMeter

func _ready():
	player.score_updated.connect(_on_score_updated)
	player.life_updated.connect(_on_life_updated)
	player.fuel_updated.connect(_on_fuel_updated)

func _on_score_updated(score):
	_score_label.text = str(score)
	
func _on_life_updated(life):
	pass
	
func _on_fuel_updated(fuel):
	var tween = get_tree().create_tween().set_loops(3)
	tween.tween_property(_fuel_meter, "value", fuel, 0.5)
	
	if (fuel < 40):
		var tween2 = get_tree().create_tween().set_loops()
		tween2.tween_property(_fuel_meter, "modulate", Color.RED, 0.5)
		tween2.tween_property(_fuel_meter, "modulate", Color.WHITE, 0.5)
