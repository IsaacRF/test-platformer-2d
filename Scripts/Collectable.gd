extends Area2D

@export var score_value: int = 1
@export var life_value: int = 0
@export var texture: Texture
@export var sfx: AudioStream

func _ready():
	$Sprite2D.texture = texture
	$SFX.stream = sfx

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("Players"):
		$SFX.play()
		if score_value > 0:
			body.call("add_score", score_value)
		if life_value > 0:
			body.call("add_life", life_value)
