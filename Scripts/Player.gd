extends CharacterBody2D


var move_speed : float = 300.0
var acceleration : float = 20.0
var deceleration : float = 20.0
var jump_force : float = 200.0
var gravity : float = 500.0

var death_sfx : AudioStreamPlayer2D
var camera : RemoteTransform2D

func _ready():
	death_sfx = $DeathSFX
	camera = $CameraFollow

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -jump_force

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * move_speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
		
	move_and_slide()

func game_over():
	death_sfx.play()
	camera.update_position = false
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
