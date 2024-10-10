extends CharacterBody2D
class_name Player

signal score_updated(score)
signal life_updated(life)
signal fuel_updated(fuel)

@onready var score_label : Label = get_tree().current_scene.get_node("UI/Score")
@onready var _animated_sprite = $AnimatedSprite2D
@onready var _death_sfx = $DeathSFX
@onready var _jump_sfx = $JumpSFX
@onready var _rocket_sfx = $RocketSFX
@onready var _hurt_sfx = $HurtSFX
@onready var _sweat_particles = $SweatParticles
@onready var _smoke_particles = $SmokeParticles

var move_speed : float = 300.0
var acceleration : float = 20.0
var deceleration : float = 20.0
var jump_force : float = 200.0
var gravity : float = 500.0

var is_dead : bool

var score : int
@export var max_life : int = 3
@export var life : int = max_life
@export var max_fuel : int = 100
@export var fuel : int = max_fuel

@onready var rng = RandomNumberGenerator.new()

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
		if Input.is_action_just_pressed("ui_accept"):
			if is_on_floor():
				#Jump
				_jump_sfx.play()
				_animated_sprite.play("jump")
				velocity.y = -jump_force
			elif (fuel > 0):
				#Fly
				_rocket_sfx.pitch_scale = rng.randf_range(0.5, 1.5)
				_rocket_sfx.play()
				fuel -= 30
				fuel_updated.emit(fuel)
				velocity.y = -jump_force
				_smoke_particles.emitting = true
		
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
	score_updated.emit(score)
	
func add_life(amount):
	life += amount
	life_updated.emit(life)

func damage(hit_points):
	life -= hit_points
	life_updated.emit(life)
	
	if life <= 0:
		game_over()
	else:
		_hurt_sfx.pitch_scale = rng.randf_range(0.8, 1.2)
		_hurt_sfx.play()
		#Hurt animation
		var tween = get_tree().create_tween().set_loops(3)
		tween.tween_property(_animated_sprite, "modulate", Color.RED, 0.1)
		tween.tween_property(_animated_sprite, "modulate", Color.WHITE, 0.1)
		#Add back force
		if _animated_sprite.flip_h:
			velocity.x = -300
		else:
			velocity.x = 300
		velocity.y = -200

func game_over():
	is_dead = true
	_death_sfx.play()
	_animated_sprite.play("death")
	_sweat_particles.emitting = true
	$CameraFollow.update_position = false
	$CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
