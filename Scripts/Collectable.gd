extends Area2D

@export var score_value: int = 1
@export var life_value: int = 0
@export var texture: Texture
@export var sfx: AudioStream

var bob_height : float = 5.0
var bob_speed : float = 5.0

@onready var start_y : float = global_position.y
var t : float = 0.0

func _ready():
	$Sprite2D.texture = texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += delta
	
	var d = (sin(t * bob_speed) + 1) / 2
	global_position.y = start_y + (d * bob_height)


func _on_body_entered(body):
	if body.is_in_group("Players"):
		SoundManager.stream = sfx
		SoundManager.play()
		
		if score_value > 0:
			body.call("add_score", score_value)
		if life_value > 0:
			body.call("add_life", life_value)
			
		queue_free()
