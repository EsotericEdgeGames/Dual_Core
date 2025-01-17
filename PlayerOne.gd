extends CharacterBody3D
@export var player_id = 1
var speed = 5.0
const JUMP_VELOCITY = 4.5
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var is_sprinting = false
var speedWalk = 5.0
var speedRun = 10.0
# variables that make the character run

@onready var sprint_timer = $"Sprint timer"
	
func _process(delta):
	speed = speedWalk
	
	if Input.is_action_just_pressed("Sprint")and not is_sprinting:
		is_sprinting = true
		sprint_timer.start()
	elif Input.is_action_just_pressed("Sprint") and is_sprinting:
		is_sprinting = false
	
	if is_sprinting:
		speed = speedRun

func _on_timer_timeout():
	is_sprinting = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left_1", "move_right_1", "move_up_1", "move_down_1")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()


