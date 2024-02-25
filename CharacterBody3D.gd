extends CharacterBody3D

var max_speed = 50
var acceleration = 0.6
var pitch_speed = 1.5
var roll_speed = 1.9
var yaw_speed = 1.25  # Set lower for linked roll/yaw
var input_response = 8.0

var Velocity = Vector3.ZERO
var forward_speed = 0
var pitch_input = 0
var roll_input = 0
var yaw_input = 0


func get_input(delta):
	if Input.is_action_pressed("throttle_up"):
		forward_speed = lerpf(forward_speed, max_speed, acceleration * delta)
	if Input.is_action_pressed("throttle_down"):
		forward_speed = lerpf(forward_speed, 0, acceleration * delta)

	pitch_input = lerpf(pitch_input,
			Input.get_action_strength("pitch_up") - Input.get_action_strength("pitch_down"),
			input_response * delta)
	roll_input = lerpf(roll_input,
			Input.get_action_strength("roll_left") - Input.get_action_strength("roll_right"),
			input_response * delta)
	yaw_input = lerpf(yaw_input,
			Input.get_action_strength("yaw_left") - Input.get_action_strength("yaw_right"),
			input_response * delta)
	# replace the line above with this for linked roll/yaw:
	# yaw_input = roll_input


func _physics_process(delta):

	get_input(delta)
	transform.basis = transform.basis.rotated(transform.basis.z, roll_input * roll_speed * delta)
	transform.basis = transform.basis.rotated(transform.basis.x, pitch_input * pitch_speed * delta)
	transform.basis = transform.basis.rotated(transform.basis.y, yaw_input * yaw_speed * delta)
	transform.basis = transform.basis.orthonormalized()
	Velocity = -transform.basis.z * forward_speed
	move_and_collide(Velocity * delta)
