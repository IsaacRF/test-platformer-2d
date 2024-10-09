extends Area2D

@export_file("*.tscn") var next_level

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _gpu_particles_2d = $GPUParticles2D
@onready var _goal_sfx = $GoalSFX

func _ready():
	_animated_sprite.play("idle")
	
func _on_body_entered(body):
	if body.is_in_group("Players"):
		# The player entered the goal zone
		_gpu_particles_2d.emitting = true
		_goal_sfx.play()
		_animated_sprite.play("captured")
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file(next_level)
