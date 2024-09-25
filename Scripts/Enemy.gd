extends CharacterBody2D


@export var move_speed : float = 30.0
@export var move_range : Vector2

var start_pos : Vector2
var target_pos : Vector2

func _ready():
	start_pos = global_position
	target_pos = start_pos + move_range

func _process(delta):
	global_position = global_position.move_toward(target_pos, move_speed * delta)
	
	if global_position == target_pos:
		if global_position == start_pos:
			target_pos = start_pos + move_range
		else:
			target_pos = start_pos

func _on_hurtbox_body_entered(body):
	if body.is_in_group("Players"):
		# The player entered the hazard zone.
		body.call("game_over")
