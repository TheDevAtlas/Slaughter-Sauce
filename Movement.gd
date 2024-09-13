#extends RigidBody3D
#
## Variables to control speed and movement
#var force_strength = 55.0
#var max_speed = 5.0 # The maximum speed limit
#var deceleration_rate = 15.0 # How quickly the body slows down when input is released
#
#func _physics_process(delta):
	#var direction = Vector3.ZERO
#
	## Capture player input (assuming default controls)
	#if Input.is_action_pressed("ui_right"):
		#direction.x += 1
	#if Input.is_action_pressed("ui_left"):
		#direction.x -= 1
	#if Input.is_action_pressed("ui_up"):
		#direction.z -= 1
	#if Input.is_action_pressed("ui_down"):
		#direction.z += 1
#
	## Normalize direction to avoid faster diagonal movement
	#if direction != Vector3.ZERO:
		#direction = direction.normalized()
#
	## Apply force only if current speed is less than max speed
	#if linear_velocity.length() < max_speed:
		#apply_force(direction * force_strength, Vector3.ZERO)
#
	## Deceleration when no input is detected
	#if direction == Vector3.ZERO:
		## Apply a deceleration force opposite to the current velocity
		#var deceleration = -linear_velocity.normalized() * deceleration_rate
		#apply_force(deceleration, Vector3.ZERO)
#
		## Prevent small velocities from causing jitter
		#if linear_velocity.length() < 0.1:
			#linear_velocity = Vector3.ZERO
