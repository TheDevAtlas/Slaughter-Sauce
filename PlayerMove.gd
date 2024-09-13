extends Node

# Variables to control speed and movement
var speed = 10.0
var force_strength = 20.0
var max_speed = 15.0 # The maximum speed limit
var deceleration_rate = 10.0 # How quickly the body slows down when input is released
var snappiness = 0.5 # How quickly the velocity adjusts when changing direction

# References to player rigid bodies
@export var player1: RigidBody3D
@export var player2: RigidBody3D

func _physics_process(_delta):
	# Handle player 1 movement
	var direction_p1 = Vector3.ZERO

	direction_p1.x = Input.get_action_strength("move_right_p1") - Input.get_action_strength("move_left_p1")
	direction_p1.z = Input.get_action_strength("move_down_p1") - Input.get_action_strength("move_up_p1")

	move_player(player1, direction_p1)

	# Handle player 2 movement
	var direction_p2 = Vector3.ZERO

	#direction_p2.x = Input.get_action_strength("move_right_p2") - Input.get_action_strength("move_left_p2")
	#direction_p2.z = Input.get_action_strength("move_down_p2") - Input.get_action_strength("move_up_p2")

	move_player(player2, direction_p2)


func move_player(player: RigidBody3D, direction: Vector3):
	# Normalize direction to avoid faster diagonal movement
	if direction != Vector3.ZERO:
		direction = direction.normalized()

		# Calculate the current velocity and dot product with direction
		var current_velocity = player.linear_velocity
		var dot_product = direction.dot(current_velocity.normalized())

		# If moving in the opposite direction
		if dot_product < 0:
			# Smoothly reduce velocity towards zero for smoother direction change
			player.linear_velocity = player.linear_velocity.lerp(Vector3.ZERO, snappiness)
		elif current_velocity.length() < max_speed:
			# Apply force in the desired direction if under max speed
			player.apply_force(direction * force_strength, Vector3.ZERO)
	else:
		# Deceleration when no input is detected
		if player.linear_velocity.length() > 0.1:
			var deceleration = -player.linear_velocity.normalized() * deceleration_rate
			player.apply_force(deceleration, Vector3.ZERO)
		else:
			# Set velocity to zero to prevent jitter
			player.linear_velocity = Vector3.ZERO
