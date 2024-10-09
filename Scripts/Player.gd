extends CharacterBody2D
class_name Player

@onready var score_label : Label = get_tree().current_scene.get_node("UI/Score")
@onready var _animated_sprite = $AnimatedSprite2D
@onready var _death_sfx = $DeathSFX
@onready var _jump_sfx = $JumpSFX
@onready var _gpu_particles_2d = $GPUParticles2D

var move_speed : float = 300.0
var acceleration : float = 20.0
var deceleration : float = 20.0
var jump_force : float = 200.0
var gravity : float = 500.0

var is_dead : bool

var score : int
var life : int

func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if not is_dead:
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			_jump_sfx.play()
			_animated_sprite.play("jump")
			velocity.y = -jump_force
		
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = move_toward(velocity.x, direction * move_speed, acceleration)
			
			if velocity.x > 0:
				_animated_sprite.flip_h = true
			else:
				_animated_sprite.flip_h = false
				
			if is_on_floor():
				_animated_sprite.play("run")
			else:
				_animated_sprite.play("jump")
				
		else:
			velocity.x = move_toward(velocity.x, 0, deceleration)
			
			if velocity.x == 0 && velocity.y == 0:
				_animated_sprite.play("idle")
	
	move_and_slide()
	
func add_score(amount):
	score += amount
	score_label.text = str(score)
	
func get_score():
	score
	
func add_life(amount):
	life += amount

func game_over():
	is_dead = true
	_death_sfx.play()
	_animated_sprite.play("death")
	_gpu_particles_2d.emitting = true
	$CameraFollow.update_position = false
	$CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
