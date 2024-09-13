extends Node

@export var player_index = 0
var input_velocity = Vector2.ZERO
var speed = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func lerpp(A, B, F):
	return B + (A - B) * F

func _physics_process(delta):
	input_velocity = Vector2.ZERO
	
	input_velocity.x = Input.get_joy_axis(player_index, JOY_AXIS_LEFT_X)
	input_velocity.y = Input.get_joy_axis(player_index, JOY_AXIS_LEFT_Y)
	
	input_velocity *= (speed / 10.0)
	
	$RigidBody3D.position += Vector3(input_velocity.x, 0, input_velocity.y)
