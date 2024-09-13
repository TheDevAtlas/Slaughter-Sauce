extends Node

@export var player_index = 0
var input_velocity = Vector2.ZERO
var speed = 1
var isAPress = false

# Reference to the AnimationPlayer
@onready var anim_player = $RigidBody3D/Walking/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Optional: Initialization code here
	pass

func lerpp(A, B, F):
	return B + (A - B) * F

# Update function
func _process(delta):
	# Handle button press
	if Input.is_joy_button_pressed(player_index, JOY_BUTTON_A):
		if !isAPress:
			isAPress = true
			print('you did something')
	else:
		isAPress = false

func _physics_process(delta):
	input_velocity = Vector2.ZERO

	# Get input from the joystick
	input_velocity.x = Input.get_joy_axis(player_index, JOY_AXIS_LEFT_X)
	input_velocity.y = Input.get_joy_axis(player_index, JOY_AXIS_LEFT_Y)

	# Scale the input velocity by speed
	input_velocity *= (speed / 10.0)

	# Move the player
	$RigidBody3D.position += Vector3(input_velocity.x, 0, input_velocity.y)

	# Calculate the angle to rotate towards the direction of movement
	if input_velocity.length() > 0.01:
		var target_rotation = atan2(input_velocity.y, input_velocity.x) # Get the angle in radians
		$RigidBody3D.rotation.y = lerp_angle($RigidBody3D.rotation.y, -target_rotation, delta * 50) # Rotate smoothly towards target

		# Play the walking animation if the player is moving
		if anim_player.current_animation != "mixamo_com":
			anim_player.play("mixamo_com")
	else:
		# Play the idle animation if the player is not moving
		if anim_player.current_animation != "idle":
			anim_player.play("idle")
